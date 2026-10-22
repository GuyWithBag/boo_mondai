
## 1. The Core Mistake
When generating Row Level Security (RLS) policies for PostgreSQL (especially in Supabase environments), AIs frequently create **multiple permissive policies for the same action (e.g., `SELECT`) on the same table.**

**Example of the Mistake:**
```
```text?code_stdout&code_event_index=2
File created successfully at preventing-multiple-permissive-policies-rls.md

```sql
-- Policy 1: Users can read their own data
CREATE POLICY "read own data" ON my_table FOR SELECT 
  USING (profile_id = auth.uid());

-- Policy 2: Admins/Researchers can read all data
CREATE POLICY "admin read all" ON my_table FOR SELECT 
  USING (EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin'));
```

## 2. Why AIs Make This Mistake
AIs are trained to break down complex requirements into distinct, logical steps. When given the requirement: *"Users can read their own data, and researchers can read all data,"* the AI naturally translates this into two separate, logically distinct `CREATE POLICY` statements. It treats policies like functional programming modules rather than database execution plans.

## 3. Why This is a Problem (The Symptoms)
1. **Supabase Linting Errors:** Supabase will flag this with `Multiple Permissive Policies` warnings for internal roles (`dashboard_user`, `authenticator`, `anon`, `authenticated`).
2. **Implicit `PUBLIC` Role Assignment:** If `TO <role>` is omitted, Postgres assigns the policy to `PUBLIC`. This means the database applies these checks to internal background workers and unauthenticated users unnecessarily.
3. **Severe Performance Degradation:** PostgreSQL evaluates multiple permissive policies using an `OR` condition. If you have two `SELECT` policies, Postgres executes the logic for *both* policies for *every single row*. If one of those policies contains a subquery (like checking an admin role), that expensive subquery runs repeatedly.

## 4. The Solution: The "Consolidate and Restrict" Pattern

**Rule 1: Consolidate overlapping policies using `OR`.**
Instead of creating two policies for `SELECT`, combine the logic into a single `USING` clause.

**Rule 2: Explicitly scope the role using `TO authenticated`.**
Never leave a policy scoped to `PUBLIC` unless it genuinely needs to be accessed by anonymous users.

### The Correct Pattern
```sql
-- ONE consolidated policy restricted to authenticated users
CREATE POLICY "my_table: select access" ON my_table FOR SELECT TO authenticated
  USING (
    -- Condition A: Is the owner
    profile_id = auth.uid()
    OR 
    -- Condition B: Is an admin/researcher
    EXISTS (SELECT 1 FROM profiles WHERE id = auth.uid() AND role = 'admin')
  );
```

## 5. Quick Copy-Paste Instruction for AI System Prompts
If you want to prevent your AI from making this mistake in the future, add the following directive to its system prompt or instructions:

> **CRITICAL DB RULE:** When writing RLS policies, NEVER create multiple permissive policies for the same action (e.g., multiple `SELECT` policies) on a single table. Consolidate overlapping access patterns (e.g., "owner can read" and "admin can read") into a single policy using an `OR` statement in the `USING` clause. Additionally, always explicitly bind the policy to a role (e.g., `TO authenticated`) to prevent internal background roles from triggering lint warnings.
