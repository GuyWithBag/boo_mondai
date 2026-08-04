-- Survey definitions are app/code-defined for now.
-- This migration stores submitted responses only.

CREATE TABLE survey_submissions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  survey_id     text NOT NULL,
  profile_id    uuid NOT NULL CONSTRAINT survey_submissions_profile_id_fkey REFERENCES profiles(id) ON DELETE CASCADE,
  assignment_id text,
  answers       jsonb NOT NULL DEFAULT '{}'::jsonb,
  submitted_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (survey_id, profile_id)
);

ALTER TABLE survey_submissions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "survey_submissions: insert own" ON survey_submissions
  FOR INSERT TO authenticated
  WITH CHECK (profile_id = current_profile_id());

CREATE POLICY "survey_submissions: update own" ON survey_submissions
  FOR UPDATE TO authenticated
  USING (profile_id = current_profile_id())
  WITH CHECK (profile_id = current_profile_id());

CREATE POLICY "survey_submissions: read own or researcher" ON survey_submissions
  FOR SELECT TO authenticated
  USING (
    profile_id = current_profile_id()
    OR EXISTS (
      SELECT 1
      FROM profiles
      WHERE id = current_profile_id()
        AND role = 'researcher'
    )
  );
