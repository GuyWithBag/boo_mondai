-- Generic paginated survey definitions, assignments, and submissions.

CREATE TABLE surveys (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  profile_id  uuid NOT NULL CONSTRAINT surveys_profile_id_fkey REFERENCES profiles(id) ON DELETE CASCADE,
  title       text NOT NULL,
  description text NOT NULL DEFAULT '',
  status      text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE surveys ENABLE ROW LEVEL SECURITY;
CREATE POLICY "surveys: researcher manage" ON surveys FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'))
  WITH CHECK (profile_id = current_profile_id() AND EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));

CREATE TABLE survey_pages (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  survey_id  uuid NOT NULL CONSTRAINT survey_pages_survey_id_fkey REFERENCES surveys(id) ON DELETE CASCADE,
  position   int NOT NULL,
  title      text,
  UNIQUE (survey_id, position)
);

ALTER TABLE survey_pages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_pages: researcher manage" ON survey_pages FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM surveys s WHERE s.id = survey_pages.survey_id AND s.profile_id = current_profile_id() AND EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher')))
  WITH CHECK (EXISTS (SELECT 1 FROM surveys s WHERE s.id = survey_pages.survey_id AND s.profile_id = current_profile_id() AND EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher')));

CREATE TABLE survey_blocks (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  survey_id   uuid NOT NULL CONSTRAINT survey_blocks_survey_id_fkey REFERENCES surveys(id) ON DELETE CASCADE,
  page_id     uuid NOT NULL CONSTRAINT survey_blocks_page_id_fkey REFERENCES survey_pages(id) ON DELETE CASCADE,
  block_type  text NOT NULL CHECK (block_type IN ('content', 'text_input', 'number_input', 'multiple_choice_input', 'likert_input', 'boolean_input')),
  position    int NOT NULL,

  -- SurveyContentBlock
  markdown    text,

  -- Input block fields
  key         text,
  prompt      text,
  description text,
  is_required boolean NOT NULL DEFAULT true,

  -- SurveyTextInputBlock
  is_long_text boolean,
  placeholder  text,
  min_length   int,
  max_length   int,

  -- SurveyNumberInputBlock / SurveyLikertInputBlock
  min_value    numeric,
  max_value    numeric,
  step         numeric,
  min_label    text,
  max_label    text,

  -- SurveyMultipleChoiceInputBlock
  min_answers  int,
  max_answers  int,

  -- SurveyBooleanInputBlock
  true_label   text,
  false_label  text,

  created_at   timestamptz NOT NULL DEFAULT now(),
  updated_at   timestamptz NOT NULL DEFAULT now(),

  UNIQUE (page_id, position),
  UNIQUE (survey_id, key),
  CHECK (
    (block_type = 'content' AND markdown IS NOT NULL AND key IS NULL AND prompt IS NULL)
    OR
    (block_type <> 'content' AND key IS NOT NULL AND prompt IS NOT NULL)
  ),
  CHECK (min_length IS NULL OR min_length >= 0),
  CHECK (max_length IS NULL OR max_length >= 0),
  CHECK (min_length IS NULL OR max_length IS NULL OR max_length >= min_length),
  CHECK (min_value IS NULL OR max_value IS NULL OR max_value >= min_value),
  CHECK (min_answers IS NULL OR min_answers >= 0),
  CHECK (max_answers IS NULL OR max_answers >= 0),
  CHECK (min_answers IS NULL OR max_answers IS NULL OR max_answers >= min_answers)
);

ALTER TABLE survey_blocks ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_blocks: researcher manage" ON survey_blocks FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM surveys s WHERE s.id = survey_blocks.survey_id AND s.profile_id = current_profile_id() AND EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher')))
  WITH CHECK (EXISTS (SELECT 1 FROM surveys s WHERE s.id = survey_blocks.survey_id AND s.profile_id = current_profile_id() AND EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher')));

CREATE TABLE survey_block_options (
  id       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  block_id uuid NOT NULL CONSTRAINT survey_block_options_block_id_fkey REFERENCES survey_blocks(id) ON DELETE CASCADE,
  position int NOT NULL,
  value    text NOT NULL,
  label    text NOT NULL,
  UNIQUE (block_id, position),
  UNIQUE (block_id, value)
);

ALTER TABLE survey_block_options ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_block_options: researcher manage" ON survey_block_options FOR ALL TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM survey_blocks b
      JOIN surveys s ON s.id = b.survey_id
      WHERE b.id = survey_block_options.block_id
        AND s.profile_id = current_profile_id()
        AND EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher')
    )
  )
  WITH CHECK (
    EXISTS (
      SELECT 1
      FROM survey_blocks b
      JOIN surveys s ON s.id = b.survey_id
      WHERE b.id = survey_block_options.block_id
        AND s.profile_id = current_profile_id()
        AND EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher')
    )
  );

CREATE TABLE survey_assignments (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  survey_id    uuid NOT NULL CONSTRAINT survey_assignments_survey_id_fkey REFERENCES surveys(id) ON DELETE CASCADE,
  profile_id   uuid NOT NULL CONSTRAINT survey_assignments_profile_id_fkey REFERENCES profiles(id) ON DELETE CASCADE,
  status       text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'expired', 'cancelled')),
  assigned_at  timestamptz NOT NULL DEFAULT now(),
  due_at       timestamptz,
  completed_at timestamptz,
  UNIQUE (survey_id, profile_id)
);

ALTER TABLE survey_assignments ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_assignments: researcher manage" ON survey_assignments FOR ALL TO authenticated
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'))
  WITH CHECK (EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher'));
CREATE POLICY "survey_assignments: participant read own" ON survey_assignments FOR SELECT TO authenticated
  USING (profile_id = current_profile_id());
CREATE POLICY "survey_assignments: participant complete own" ON survey_assignments FOR UPDATE TO authenticated
  USING (profile_id = current_profile_id() AND status = 'pending')
  WITH CHECK (profile_id = current_profile_id() AND status = 'completed');

CREATE POLICY "surveys: assigned participant read published" ON surveys FOR SELECT TO authenticated
  USING (
    status = 'published'
    AND EXISTS (
      SELECT 1 FROM survey_assignments a
      WHERE a.survey_id = surveys.id AND a.profile_id = current_profile_id()
    )
  );

CREATE POLICY "survey_pages: assigned participant read" ON survey_pages FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM surveys s
      JOIN survey_assignments a ON a.survey_id = s.id
      WHERE s.id = survey_pages.survey_id
        AND s.status = 'published'
        AND a.profile_id = current_profile_id()
    )
  );

CREATE POLICY "survey_blocks: assigned participant read" ON survey_blocks FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM surveys s
      JOIN survey_assignments a ON a.survey_id = s.id
      WHERE s.id = survey_blocks.survey_id
        AND s.status = 'published'
        AND a.profile_id = current_profile_id()
    )
  );

CREATE POLICY "survey_block_options: assigned participant read" ON survey_block_options FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1
      FROM survey_blocks b
      JOIN surveys s ON s.id = b.survey_id
      JOIN survey_assignments a ON a.survey_id = s.id
      WHERE b.id = survey_block_options.block_id
        AND s.status = 'published'
        AND a.profile_id = current_profile_id()
    )
  );

CREATE TABLE survey_submissions (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  survey_id     uuid NOT NULL CONSTRAINT survey_submissions_survey_id_fkey REFERENCES surveys(id) ON DELETE CASCADE,
  profile_id    uuid NOT NULL CONSTRAINT survey_submissions_profile_id_fkey REFERENCES profiles(id) ON DELETE CASCADE,
  assignment_id uuid CONSTRAINT survey_submissions_assignment_id_fkey REFERENCES survey_assignments(id) ON DELETE SET NULL,
  answers       jsonb NOT NULL DEFAULT '{}'::jsonb,
  submitted_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE (survey_id, profile_id)
);

ALTER TABLE survey_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "survey_submissions: insert own assigned" ON survey_submissions FOR INSERT TO authenticated
  WITH CHECK (
    profile_id = current_profile_id()
    AND EXISTS (
      SELECT 1 FROM survey_assignments a
      WHERE a.id = assignment_id
        AND a.survey_id = survey_submissions.survey_id
        AND a.profile_id = current_profile_id()
        AND a.status = 'pending'
    )
  );
CREATE POLICY "survey_submissions: read own or researcher" ON survey_submissions FOR SELECT TO authenticated
  USING (
    profile_id = current_profile_id()
    OR EXISTS (SELECT 1 FROM profiles WHERE id = current_profile_id() AND role = 'researcher')
  );
