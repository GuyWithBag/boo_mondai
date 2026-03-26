-- ══════════════════════════════════════════════════════
-- BooMondai — Mock/Seed Data
-- Run this AFTER schema.sql in the Supabase SQL Editor
-- NOTE: auth.users rows must be created via Supabase Auth
--       or the Supabase dashboard. The UUIDs below assume
--       you've created these test users first.
-- ══════════════════════════════════════════════════════

-- ── Profiles ──────────────────────────────────────────
-- Create these users in Supabase Auth first with the passwords below:
--   researcher@test.com  / password123
--   alice@test.com       / password123
--   bob@test.com         / password123
--   carol@test.com       / password123
--
-- Then update the UUIDs below to match the auth.users IDs
-- Supabase generates, or use the SQL function override below.

-- Helper: insert into auth.users directly (works in local dev / self-hosted)
-- On hosted Supabase, create users via Dashboard > Authentication instead.
INSERT INTO auth.users (id, email, encrypted_password, email_confirmed_at, raw_app_meta_data, raw_user_meta_data, created_at, updated_at, instance_id, aud, role)
VALUES
  ('00000000-0000-0000-0000-000000000001', 'researcher@test.com', crypt('password123', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated'),
  ('00000000-0000-0000-0000-000000000002', 'alice@test.com',      crypt('password123', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated'),
  ('00000000-0000-0000-0000-000000000003', 'bob@test.com',        crypt('password123', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated'),
  ('00000000-0000-0000-0000-000000000004', 'carol@test.com',      crypt('password123', gen_salt('bf')), now(), '{"provider":"email","providers":["email"]}', '{}', now(), now(), '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated')
ON CONFLICT (id) DO NOTHING;

-- Also need identities for Supabase Auth to work
INSERT INTO auth.identities (id, user_id, provider_id, identity_data, provider, last_sign_in_at, created_at, updated_at)
VALUES
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-000000000001', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000001', 'email', 'researcher@test.com'), 'email', now(), now(), now()),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000002', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000002', 'email', 'alice@test.com'), 'email', now(), now(), now()),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-000000000003', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000003', 'email', 'bob@test.com'), 'email', now(), now(), now()),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-000000000004', jsonb_build_object('sub', '00000000-0000-0000-0000-000000000004', 'email', 'carol@test.com'), 'email', now(), now(), now())
ON CONFLICT DO NOTHING;

-- ── Profiles ──────────────────────────────────────────
INSERT INTO profiles (id, email, display_name, role, target_language) VALUES
  ('00000000-0000-0000-0000-000000000001', 'researcher@test.com', 'Dr. Test',  'researcher',           NULL),
  ('00000000-0000-0000-0000-000000000002', 'alice@test.com',      'Alice',     'group_a_participant',  'japanese'),
  ('00000000-0000-0000-0000-000000000003', 'bob@test.com',        'Bob',       'group_a_participant',  'japanese'),
  ('00000000-0000-0000-0000-000000000004', 'carol@test.com',      'Carol',     'group_b_participant',  'japanese')
ON CONFLICT (id) DO NOTHING;

-- ── Decks ──────────────────────────────────────────
INSERT INTO decks (id, creator_id, title, description, target_language, is_premade, card_count) VALUES
  ('00000000-0000-0000-0000-000000000010', '00000000-0000-0000-0000-000000000001', 'JLPT N5 Vocabulary',  'Premade deck for the study — basic Japanese vocabulary', 'japanese', true,  5),
  ('00000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-000000000002', 'My Extra Vocab',       'Alice''s user-generated deck',                           'japanese', false, 2)
ON CONFLICT (id) DO NOTHING;

-- ── Deck Cards ──────────────────────────────────────────
INSERT INTO deck_cards (id, deck_id, question, answer, sort_order) VALUES
  -- JLPT N5 premade deck
  ('00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000010', '犬',  'dog, いぬ, inu',       0),
  ('00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000010', '猫',  'cat, ねこ, neko',      1),
  ('00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000010', '鳥',  'bird, とり, tori',     2),
  ('00000000-0000-0000-0000-000000000023', '00000000-0000-0000-0000-000000000010', '魚',  'fish, さかな, sakana', 3),
  ('00000000-0000-0000-0000-000000000024', '00000000-0000-0000-0000-000000000010', '花',  'flower, はな, hana',   4),
  -- Alice's UGC deck
  ('00000000-0000-0000-0000-000000000025', '00000000-0000-0000-0000-000000000011', '空',  'sky, そら, sora',      0),
  ('00000000-0000-0000-0000-000000000026', '00000000-0000-0000-0000-000000000011', '海',  'sea, うみ, umi',       1)
ON CONFLICT (id) DO NOTHING;

-- ── Streaks ──────────────────────────────────────────
INSERT INTO streaks (id, user_id, current_streak, longest_streak, last_activity_date) VALUES
  ('00000000-0000-0000-0000-000000000030', '00000000-0000-0000-0000-000000000002', 5, 12, '2026-03-25'),
  ('00000000-0000-0000-0000-000000000031', '00000000-0000-0000-0000-000000000003', 0, 3,  '2026-03-20')
ON CONFLICT (id) DO NOTHING;

-- ── Research Users ──────────────────────────────────────
INSERT INTO research_users (id, user_id, role, target_language) VALUES
  ('00000000-0000-0000-0000-000000000050', '00000000-0000-0000-0000-000000000002', 'group_a_participant', 'japanese'),
  ('00000000-0000-0000-0000-000000000051', '00000000-0000-0000-0000-000000000003', 'group_a_participant', 'japanese'),
  ('00000000-0000-0000-0000-000000000052', '00000000-0000-0000-0000-000000000004', 'group_b_participant', 'japanese')
ON CONFLICT (id) DO NOTHING;

-- ── Research Codes ──────────────────────────────────────
INSERT INTO research_codes (id, code, target_role, unlocks, created_by) VALUES
  ('00000000-0000-0000-0000-000000000060', 'VOCAB-A-001',    'group_a_participant', 'vocabulary_test_a',              '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000061', 'VOCAB-B-001',    'group_b_participant', 'vocabulary_test_a',              '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000062', 'EXP-SHORT-001',  'group_a_participant', 'experience_survey_short_term',   '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000063', 'EXP-LONG-001',   'group_a_participant', 'experience_survey_long_term',    '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000064', 'PROF-001',       'group_a_participant', 'proficiency_screener',           '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000065', 'LANG-INT-001',   'group_a_participant', 'language_interest',              '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000066', 'PREVIEW-001',    'group_a_participant', 'preview_usefulness',             '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000067', 'FSRS-001',       'group_a_participant', 'fsrs_usefulness',                '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000068', 'UGC-A-001',      'group_a_participant', 'ugc_perception',                 '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-000000000069', 'UGC-B-001',      'group_b_participant', 'ugc_perception',                 '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-00000000006a', 'SUS-001',        'group_a_participant', 'sus',                            '00000000-0000-0000-0000-000000000001'),
  ('00000000-0000-0000-0000-00000000006b', 'VOCAB-B-002',    'group_b_participant', 'vocabulary_test_b',              '00000000-0000-0000-0000-000000000001')
ON CONFLICT (id) DO NOTHING;

-- ── Sample Quiz Session (Alice completed one quiz) ──────
INSERT INTO quiz_sessions (id, user_id, deck_id, previewed, total_questions, correct_count, started_at, completed_at) VALUES
  ('00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000010', true, 5, 4, '2026-03-25 10:00:00+00', '2026-03-25 10:15:00+00')
ON CONFLICT (id) DO NOTHING;

INSERT INTO quiz_answers (id, session_id, card_id, user_answer, is_correct, self_rating, answered_at) VALUES
  ('00000000-0000-0000-0000-000000000070', '00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000020', 'dog',    true,  3, '2026-03-25 10:02:00+00'),
  ('00000000-0000-0000-0000-000000000071', '00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000021', 'cat',    true,  4, '2026-03-25 10:04:00+00'),
  ('00000000-0000-0000-0000-000000000072', '00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000022', 'bird',   true,  3, '2026-03-25 10:06:00+00'),
  ('00000000-0000-0000-0000-000000000073', '00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000023', 'whale',  false, NULL, '2026-03-25 10:08:00+00'),
  ('00000000-0000-0000-0000-000000000074', '00000000-0000-0000-0000-000000000040', '00000000-0000-0000-0000-000000000024', 'flower', true,  2, '2026-03-25 10:10:00+00')
ON CONFLICT (id) DO NOTHING;

-- ── Sample FSRS Cards (Alice's review schedule) ──────
INSERT INTO fsrs_cards (id, user_id, card_id, due, stability, difficulty, elapsed_days, scheduled_days, reps, lapses, state, last_review) VALUES
  ('00000000-0000-0000-0000-000000000002_00000000-0000-0000-0000-000000000020', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000020', '2026-03-26 10:00:00+00', 4.5, 5.0, 1, 3, 1, 0, 2, '2026-03-25 10:02:00+00'),
  ('00000000-0000-0000-0000-000000000002_00000000-0000-0000-0000-000000000021', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000021', '2026-03-28 10:00:00+00', 8.0, 4.0, 1, 5, 1, 0, 2, '2026-03-25 10:04:00+00'),
  ('00000000-0000-0000-0000-000000000002_00000000-0000-0000-0000-000000000022', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000022', '2026-03-26 10:00:00+00', 4.5, 5.0, 1, 3, 1, 0, 2, '2026-03-25 10:06:00+00'),
  ('00000000-0000-0000-0000-000000000002_00000000-0000-0000-0000-000000000024', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000024', '2026-03-26 10:00:00+00', 2.0, 7.0, 1, 1, 1, 0, 1, '2026-03-25 10:10:00+00')
ON CONFLICT (id) DO NOTHING;

-- ── Sample Review Logs ──────────────────────────────────
INSERT INTO review_logs (id, user_id, card_id, rating, scheduled_days, elapsed_days, review, state) VALUES
  ('00000000-0000-0000-0000-000000000080', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000020', 3, 3, 0, '2026-03-25 10:02:00+00', 0),
  ('00000000-0000-0000-0000-000000000081', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000021', 4, 5, 0, '2026-03-25 10:04:00+00', 0),
  ('00000000-0000-0000-0000-000000000082', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000022', 3, 3, 0, '2026-03-25 10:06:00+00', 0),
  ('00000000-0000-0000-0000-000000000083', '00000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-000000000024', 2, 1, 0, '2026-03-25 10:10:00+00', 0)
ON CONFLICT (id) DO NOTHING;
