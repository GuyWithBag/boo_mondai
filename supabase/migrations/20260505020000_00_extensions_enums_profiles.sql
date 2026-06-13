-- ══════════════════════════════════════════════════════
-- BooMondai — Schema V2 (Ultimate Edition)
-- Includes: Core Schema, FSRS, Research Tables,
-- Design Tokens, and the "Storefront" (Deck Listings)
-- ══════════════════════════════════════════════════════

-- ── Extensions ────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS moddatetime SCHEMA extensions;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ══════════════════════════════════════════════════════
-- 1. ENUMS
-- ══════════════════════════════════════════════════════

CREATE TYPE study_rating AS ENUM ('incorrect', 'again', 'hard', 'good', 'easy');
CREATE TYPE card_type AS ENUM ('normal', 'reversed', 'both');
CREATE TYPE visibility_state AS ENUM ('public', 'private', 'unlisted');

-- ══════════════════════════════════════════════════════
-- 2. CORE TABLES & PROFILES
-- ══════════════════════════════════════════════════════

CREATE TABLE profiles (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL UNIQUE REFERENCES auth.users(id) ON DELETE CASCADE,
  username      text NOT NULL,
  display_name  text NOT NULL,
  role          text,
  avatar_url    text,
  is_anonymous  bool NOT NULL DEFAULT true,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),

  CONSTRAINT profiles_role_check
    CHECK (role IN ('group_a_participant', 'group_b_participant', 'researcher') OR role IS NULL)
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "profiles: insert own" ON profiles FOR INSERT TO authenticated WITH CHECK ((select auth.uid()) = user_id);
CREATE POLICY "profiles: read all" ON profiles FOR SELECT USING (true);
CREATE POLICY "profiles: update own" ON profiles FOR UPDATE USING ((select auth.uid()) = user_id) WITH CHECK ((select auth.uid()) = user_id);

-- Helper: resolve auth.uid() → profiles.id
CREATE OR REPLACE FUNCTION current_profile_id() RETURNS uuid LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public AS $$
  SELECT id FROM profiles WHERE user_id = (select auth.uid()) LIMIT 1
$$;
