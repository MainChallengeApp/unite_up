-- Migration: Create challenges, goals, and events tables
-- Version: 20251208
-- Description: Sets up challenge management with members, goals, and events
-- NOTE: Run after 20251208_create_users_table.sql

-- =============================================================================
-- STEP 1: CREATE ALL TABLES FIRST (without policies)
-- =============================================================================

-- CHALLENGES TABLE
CREATE TABLE IF NOT EXISTS public.challenges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT NOT NULL DEFAULT 'custom',
  emoji TEXT NOT NULL DEFAULT '🎯',
  creator_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  is_personal BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_challenges_creator_id ON public.challenges(creator_id);
CREATE INDEX IF NOT EXISTS idx_challenges_created_at ON public.challenges(created_at DESC);
ALTER TABLE public.challenges ENABLE ROW LEVEL SECURITY;

-- CHALLENGE MEMBERS TABLE (Many-to-Many)
CREATE TABLE IF NOT EXISTS public.challenge_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  role TEXT NOT NULL DEFAULT 'member', -- 'creator', 'admin', 'member'
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT unique_challenge_member UNIQUE (challenge_id, user_id)
);

CREATE INDEX IF NOT EXISTS idx_challenge_members_challenge_id ON public.challenge_members(challenge_id);
CREATE INDEX IF NOT EXISTS idx_challenge_members_user_id ON public.challenge_members(user_id);
ALTER TABLE public.challenge_members ENABLE ROW LEVEL SECURITY;

-- GOALS TABLE
CREATE TABLE IF NOT EXISTS public.goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  start_value DOUBLE PRECISION NOT NULL DEFAULT 0,
  end_value DOUBLE PRECISION NOT NULL,
  current_value DOUBLE PRECISION NOT NULL DEFAULT 0,
  unit TEXT,
  start_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  end_date TIMESTAMPTZ NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_goals_challenge_id ON public.goals(challenge_id);
CREATE INDEX IF NOT EXISTS idx_goals_user_id ON public.goals(user_id);
ALTER TABLE public.goals ENABLE ROW LEVEL SECURITY;

-- CHALLENGE EVENTS TABLE (Chat/Activity Feed)
CREATE TABLE IF NOT EXISTS public.challenge_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  challenge_id UUID NOT NULL REFERENCES public.challenges(id) ON DELETE CASCADE,
  user_id UUID REFERENCES public.users(id) ON DELETE SET NULL, -- NULL for AI messages
  event_type TEXT NOT NULL, -- 'userMessage', 'aiMessage', 'progressSubmitted', 'goalCreated', etc.
  message TEXT,
  goal_id UUID REFERENCES public.goals(id) ON DELETE SET NULL,
  goal_data JSONB, -- Stores goal snapshot for history
  old_goal_data JSONB, -- For goal updates
  goal_completed_by_update BOOLEAN,
  progress_data JSONB, -- For progress entries
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_challenge_events_challenge_id ON public.challenge_events(challenge_id);
CREATE INDEX IF NOT EXISTS idx_challenge_events_user_id ON public.challenge_events(user_id);
CREATE INDEX IF NOT EXISTS idx_challenge_events_created_at ON public.challenge_events(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_challenge_events_type ON public.challenge_events(event_type);
ALTER TABLE public.challenge_events ENABLE ROW LEVEL SECURITY;

-- =============================================================================
-- STEP 2: HELPER FUNCTIONS FOR RLS (to avoid circular recursion)
-- =============================================================================

-- Function to check if user is a member (bypasses RLS)
CREATE OR REPLACE FUNCTION public.is_challenge_member(p_challenge_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.challenge_members
    WHERE challenge_id = p_challenge_id AND user_id = p_user_id
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- Function to check if user is creator (bypasses RLS)
CREATE OR REPLACE FUNCTION public.is_challenge_creator(p_challenge_id UUID, p_user_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.challenges
    WHERE id = p_challenge_id AND creator_id = p_user_id
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- =============================================================================
-- STEP 3: ADD ALL POLICIES (using helper functions to avoid circular refs)
-- =============================================================================

-- Challenges policies
DROP POLICY IF EXISTS "Users can view challenges they are members of" ON public.challenges;
CREATE POLICY "Users can view challenges they are members of"
  ON public.challenges FOR SELECT
  USING (creator_id = auth.uid() OR public.is_challenge_member(id, auth.uid()));

DROP POLICY IF EXISTS "Users can create challenges" ON public.challenges;
CREATE POLICY "Users can create challenges"
  ON public.challenges FOR INSERT WITH CHECK (auth.uid() = creator_id);

DROP POLICY IF EXISTS "Creators can update their challenges" ON public.challenges;
CREATE POLICY "Creators can update their challenges"
  ON public.challenges FOR UPDATE USING (auth.uid() = creator_id) WITH CHECK (auth.uid() = creator_id);

DROP POLICY IF EXISTS "Creators can delete their challenges" ON public.challenges;
CREATE POLICY "Creators can delete their challenges"
  ON public.challenges FOR DELETE USING (auth.uid() = creator_id);

-- Challenge members policies (using helper functions to avoid circular recursion)
DROP POLICY IF EXISTS "Users can view members of challenges they belong to" ON public.challenge_members;
CREATE POLICY "Users can view members of challenges they belong to"
  ON public.challenge_members FOR SELECT
  USING (
    user_id = auth.uid()
    OR public.is_challenge_creator(challenge_id, auth.uid())
    OR public.is_challenge_member(challenge_id, auth.uid())
  );

DROP POLICY IF EXISTS "Challenge creators can add members" ON public.challenge_members;
CREATE POLICY "Challenge creators can add members"
  ON public.challenge_members FOR INSERT
  WITH CHECK (
    -- Creator can add any member
    public.is_challenge_creator(challenge_id, auth.uid())
    OR
    -- Users can add themselves (e.g., accepting an invite)
    user_id = auth.uid()
  );

DROP POLICY IF EXISTS "Users can leave challenges" ON public.challenge_members;
CREATE POLICY "Users can leave challenges"
  ON public.challenge_members FOR DELETE
  USING (
    -- Users can remove themselves
    user_id = auth.uid()
    OR
    -- Creator can remove any member
    public.is_challenge_creator(challenge_id, auth.uid())
  );

-- Goals policies
DROP POLICY IF EXISTS "Users can view goals in their challenges" ON public.goals;
CREATE POLICY "Users can view goals in their challenges"
  ON public.goals FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.challenge_members cm WHERE cm.challenge_id = challenge_id AND cm.user_id = auth.uid()));

DROP POLICY IF EXISTS "Users can create goals in their challenges" ON public.goals;
CREATE POLICY "Users can create goals in their challenges"
  ON public.goals FOR INSERT
  WITH CHECK (user_id = auth.uid() AND EXISTS (SELECT 1 FROM public.challenge_members cm WHERE cm.challenge_id = challenge_id AND cm.user_id = auth.uid()));

DROP POLICY IF EXISTS "Users can update their own goals" ON public.goals;
CREATE POLICY "Users can update their own goals"
  ON public.goals FOR UPDATE USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "Users can delete their own goals" ON public.goals;
CREATE POLICY "Users can delete their own goals"
  ON public.goals FOR DELETE USING (user_id = auth.uid());

-- Challenge events policies
DROP POLICY IF EXISTS "Users can view events in their challenges" ON public.challenge_events;
CREATE POLICY "Users can view events in their challenges"
  ON public.challenge_events FOR SELECT
  USING (EXISTS (SELECT 1 FROM public.challenge_members cm WHERE cm.challenge_id = challenge_id AND cm.user_id = auth.uid()));

DROP POLICY IF EXISTS "Users can create events in their challenges" ON public.challenge_events;
CREATE POLICY "Users can create events in their challenges"
  ON public.challenge_events FOR INSERT
  WITH CHECK (EXISTS (SELECT 1 FROM public.challenge_members cm WHERE cm.challenge_id = challenge_id AND cm.user_id = auth.uid()));

DROP POLICY IF EXISTS "Users can update their own events" ON public.challenge_events;
CREATE POLICY "Users can update their own events"
  ON public.challenge_events FOR UPDATE USING (user_id = auth.uid()) WITH CHECK (user_id = auth.uid());

DROP POLICY IF EXISTS "Users can delete their own events" ON public.challenge_events;
CREATE POLICY "Users can delete their own events"
  ON public.challenge_events FOR DELETE USING (user_id = auth.uid());

-- =============================================================================
-- STEP 4: ADD TRIGGERS
-- =============================================================================

DROP TRIGGER IF EXISTS on_challenges_updated ON public.challenges;
CREATE TRIGGER on_challenges_updated
  BEFORE UPDATE ON public.challenges FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

DROP TRIGGER IF EXISTS on_goals_updated ON public.goals;
CREATE TRIGGER on_goals_updated
  BEFORE UPDATE ON public.goals FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- Auto-add creator as member when challenge is created
CREATE OR REPLACE FUNCTION public.handle_new_challenge()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.challenge_members (challenge_id, user_id, role)
  VALUES (NEW.id, NEW.creator_id, 'creator');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

DROP TRIGGER IF EXISTS on_challenge_created ON public.challenges;
CREATE TRIGGER on_challenge_created
  AFTER INSERT ON public.challenges FOR EACH ROW EXECUTE FUNCTION public.handle_new_challenge();

-- Track goal completion for user stats
CREATE OR REPLACE FUNCTION public.handle_goal_completion()
RETURNS TRIGGER AS $$
DECLARE
  is_completed BOOLEAN;
  was_completed BOOLEAN;
BEGIN
  IF NEW.end_value > NEW.start_value THEN
    is_completed := NEW.current_value >= NEW.end_value;
    was_completed := OLD.current_value >= OLD.end_value;
  ELSE
    is_completed := NEW.current_value <= NEW.end_value;
    was_completed := OLD.current_value <= OLD.end_value;
  END IF;

  IF is_completed AND NOT was_completed THEN
    UPDATE public.users SET completed_challenges_count = completed_challenges_count + 1 WHERE id = NEW.user_id;
  ELSIF NOT is_completed AND was_completed THEN
    UPDATE public.users SET completed_challenges_count = GREATEST(0, completed_challenges_count - 1) WHERE id = NEW.user_id;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

DROP TRIGGER IF EXISTS on_goal_progress_updated ON public.goals;
CREATE TRIGGER on_goal_progress_updated
  AFTER UPDATE OF current_value ON public.goals FOR EACH ROW EXECUTE FUNCTION public.handle_goal_completion();

-- =============================================================================
-- STEP 5: GRANTS
-- =============================================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON public.challenges TO authenticated;
GRANT SELECT, INSERT, DELETE ON public.challenge_members TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.goals TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.challenge_events TO authenticated;
