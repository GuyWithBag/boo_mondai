create extension if not exists pgcrypto with schema extensions;

create table public.profiles (
  id uuid primary key default extensions.gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  username text not null,
  display_name text not null,
  role text not null default 'user',
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz,
  purge_after timestamptz,
  is_anonymous boolean not null default true,
  constraint profiles_role_valid check (
    role in (
      'user',
      'researcher',
      'appAdmin',
      'participant_chinese_a',
      'participant_chinese_b',
      'participant_japanese_a',
      'participant_japanese_b'
    )
  ),
  constraint profiles_username_not_blank check (length(btrim(username)) > 0),
  constraint profiles_display_name_not_blank check (length(btrim(display_name)) > 0),
  constraint profiles_purge_after_requires_deleted_at check (
    purge_after is null or deleted_at is not null
  )
);

create unique index profiles_user_id_key
  on public.profiles (user_id);

create unique index profiles_username_active_key
  on public.profiles (lower(username))
  where deleted_at is null;

create index profiles_updated_at_idx
  on public.profiles (updated_at);

create index profiles_deleted_at_purge_after_idx
  on public.profiles (deleted_at, purge_after)
  where deleted_at is not null;

create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

create or replace function public.current_profile_role()
returns text
language sql
stable
security definer
set search_path = public
as $$
  select role
  from public.profiles
  where user_id = auth.uid()
    and deleted_at is null
  limit 1
$$;

create or replace function public.prevent_profile_privilege_escalation()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.user_id is distinct from old.user_id then
    raise exception 'profiles.user_id cannot be changed';
  end if;

  if new.role is distinct from old.role
    and public.current_profile_role() is distinct from 'appAdmin'
  then
    raise exception 'profiles.role cannot be changed by this user';
  end if;

  return new;
end;
$$;

create trigger profiles_prevent_privilege_escalation
before update on public.profiles
for each row
execute function public.prevent_profile_privilege_escalation();

create or replace function public.handle_new_auth_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  base_username text;
  candidate_username text;
  display_name text;
  retry_count integer = 0;
begin
  base_username = nullif(btrim(new.raw_user_meta_data->>'username'), '');
  base_username = coalesce(
    base_username,
    nullif(split_part(coalesce(new.email, ''), '@', 1), ''),
    'User'
  );
  display_name = coalesce(
    nullif(btrim(new.raw_user_meta_data->>'display_name'), ''),
    base_username
  );
  candidate_username = base_username;

  loop
    begin
      insert into public.profiles (
        user_id,
        username,
        display_name,
        role,
        is_anonymous
      ) values (
        new.id,
        candidate_username,
        display_name,
        'user',
        false
      );

      return new;
    exception
      when unique_violation then
        if exists (
          select 1
          from public.profiles
          where user_id = new.id
        ) then
          return new;
        end if;

        retry_count = retry_count + 1;
        candidate_username =
          base_username || '_' || replace(left(new.id::text, 8), '-', '');

        if retry_count > 1 then
          candidate_username = candidate_username || '_' || retry_count;
        end if;
    end;
  end loop;
end;
$$;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_auth_user();

alter table public.profiles enable row level security;

create policy "profiles: select access"
on public.profiles
for select
to authenticated
using (
  user_id = auth.uid()
  or public.current_profile_role() in ('researcher', 'appAdmin')
);

create policy "profiles: insert own"
on public.profiles
for insert
to authenticated
with check (
  user_id = auth.uid()
  and role = 'user'
);

create policy "profiles: update own"
on public.profiles
for update
to authenticated
using (user_id = auth.uid())
with check (user_id = auth.uid());
