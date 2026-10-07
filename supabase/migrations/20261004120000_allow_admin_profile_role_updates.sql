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
    and coalesce(auth.role(), '') is distinct from 'service_role'
    and session_user not in ('postgres', 'supabase_admin')
  then
    raise exception 'profiles.role cannot be changed by this user';
  end if;

  return new;
end;
$$;
