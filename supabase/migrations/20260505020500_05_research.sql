-- ══════════════════════════════════════════════════════
-- 7. RESEARCH TABLES
-- ══════════════════════════════════════════════════════

CREATE TABLE research_profiles (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id    uuid NOT NULL UNIQUE REFERENCES profiles(id) ON DELETE CASCADE,
  first_name text NOT NULL DEFAULT '',
  last_name  text NOT NULL DEFAULT '',
  age        int  NOT NULL DEFAULT 0,
  role       text NOT NULL CHECK (role IN ('group_a_participant', 'group_b_participant')),
  goal       text NOT NULL,
  created_at timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_profiles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_profiles: select access" ON research_profiles FOR SELECT TO authenticated USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));
CREATE POLICY "research_profiles: researcher manage" ON research_profiles FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

CREATE TABLE research_codes (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  code        text NOT NULL UNIQUE,
  target_role text NOT NULL,
  unlocks     text NOT NULL,
  created_by  uuid NOT NULL CONSTRAINT research_codes_created_by_fkey REFERENCES profiles(id) ON DELETE CASCADE,
  used_by     uuid CONSTRAINT research_codes_used_by_fkey REFERENCES profiles(id),
  used_at     timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now()
);
ALTER TABLE research_codes ENABLE ROW LEVEL SECURITY;
CREATE POLICY "research_codes: select access" ON research_codes FOR SELECT TO authenticated USING (used_by = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));
CREATE POLICY "research_codes: researcher manage" ON research_codes FOR ALL TO authenticated USING (EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

CREATE TABLE survey_responses (
  id             uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id        uuid NOT NULL CONSTRAINT survey_responses_user_id_fkey REFERENCES profiles(id) ON DELETE CASCADE,
  survey_type    text NOT NULL,
  time_point     text,
  responses      jsonb NOT NULL DEFAULT '{}',
  computed_score double precision,
  submitted_at   timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT survey_responses_research_profile_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES research_profiles(user_id) ON DELETE CASCADE,
  UNIQUE (user_id, survey_type, time_point)
);
ALTER TABLE survey_responses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_responses: insert own" ON survey_responses FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "survey_responses: read own or researcher" ON survey_responses FOR SELECT USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

CREATE TABLE vocabulary_test_results (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id      uuid NOT NULL CONSTRAINT vocabulary_test_results_user_id_fkey REFERENCES profiles(id) ON DELETE CASCADE,
  test_set     text NOT NULL CHECK (test_set IN ('A', 'B')),
  score        int  NOT NULL CHECK (score BETWEEN 0 AND 30),
  answers      jsonb NOT NULL,
  submitted_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT vocabulary_test_results_research_profile_user_id_fkey
    FOREIGN KEY (user_id) REFERENCES research_profiles(user_id) ON DELETE CASCADE,
  UNIQUE (user_id, test_set)
);
ALTER TABLE vocabulary_test_results ENABLE ROW LEVEL SECURITY;
CREATE POLICY "vocabulary_test_results: insert own" ON vocabulary_test_results FOR INSERT WITH CHECK (user_id = current_profile_id());
CREATE POLICY "vocabulary_test_results: read own or researcher" ON vocabulary_test_results FOR SELECT USING (user_id = current_profile_id() OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

