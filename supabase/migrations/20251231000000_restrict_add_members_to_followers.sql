-- Migration: Restrict adding members to followers only
-- Version: 20251231
-- Description: Challenge creators can only add users who follow them as members

-- =============================================================================
-- STEP 1: CREATE HELPER FUNCTION
-- =============================================================================

-- Helper function to check if a user follows another user
-- Returns true if p_follower_id follows p_following_id
CREATE OR REPLACE FUNCTION public.is_follower(p_follower_id UUID, p_following_id UUID)
RETURNS BOOLEAN AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM public.user_follows
    WHERE follower_id = p_follower_id AND following_id = p_following_id
  );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = '';

-- =============================================================================
-- STEP 2: UPDATE CHALLENGE MEMBERS INSERT POLICY
-- =============================================================================

-- Drop the existing policy
DROP POLICY IF EXISTS "Challenge creators can add members" ON public.challenge_members;

-- Create updated policy: creators can only add followers
CREATE POLICY "Challenge creators can add members"
  ON public.challenge_members FOR INSERT
  WITH CHECK (
    -- Creator can add members who follow them
    (
      public.is_challenge_creator(challenge_id, auth.uid())
      AND public.is_follower(user_id, auth.uid())
    )
    OR
    -- Users can add themselves (e.g., accepting an invite)
    user_id = auth.uid()
  );

