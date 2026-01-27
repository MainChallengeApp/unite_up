-- Migration: Create notifications table
-- Description: Creates notifications table for user notifications with RLS policies

-- ============================================================================
-- NOTIFICATIONS TABLE
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.notifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  type TEXT NOT NULL CHECK (type IN ('follow', 'challenge_invite', 'goal_completed', 'progress_update', 'system')),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  is_read BOOLEAN NOT NULL DEFAULT FALSE,
  -- Optional references
  action_user_id UUID REFERENCES public.users(id) ON DELETE SET NULL,
  challenge_id UUID REFERENCES public.challenges(id) ON DELETE SET NULL,
  -- Timestamps
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes for efficient lookups
CREATE INDEX IF NOT EXISTS idx_notifications_user_id ON public.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user_unread ON public.notifications(user_id, is_read) WHERE is_read = FALSE;
CREATE INDEX IF NOT EXISTS idx_notifications_created_at ON public.notifications(created_at DESC);

-- ============================================================================
-- ROW LEVEL SECURITY (RLS)
-- ============================================================================

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

-- Users can only view their own notifications
CREATE POLICY "Users can view their own notifications"
  ON public.notifications FOR SELECT
  USING (auth.uid() = user_id);

-- System/triggers can insert notifications (using SECURITY DEFINER functions)
CREATE POLICY "System can insert notifications"
  ON public.notifications FOR INSERT
  WITH CHECK (true);

-- Users can update (mark as read) their own notifications
CREATE POLICY "Users can update their own notifications"
  ON public.notifications FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

-- Users can delete their own notifications
CREATE POLICY "Users can delete their own notifications"
  ON public.notifications FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- TRIGGER FUNCTIONS FOR AUTO-CREATING NOTIFICATIONS
-- ============================================================================

-- Function to create notification on new follow
CREATE OR REPLACE FUNCTION public.handle_new_follow_notification()
RETURNS TRIGGER AS $$
DECLARE
  follower_name TEXT;
BEGIN
  -- Get the follower's display name or username as fallback
  SELECT COALESCE(display_name, username, 'Someone') INTO follower_name
  FROM public.users
  WHERE id = NEW.follower_id;

  -- Create notification for the followed user
  INSERT INTO public.notifications (user_id, type, title, body, action_user_id)
  VALUES (
    NEW.following_id,
    'follow',
    'New Follower',
    follower_name || ' started following you',
    NEW.follower_id
  );

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = '';

-- Trigger for follow notifications
DROP TRIGGER IF EXISTS on_follow_notification ON public.user_follows;
CREATE TRIGGER on_follow_notification
  AFTER INSERT ON public.user_follows
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_follow_notification();

-- Function to create notification on challenge invite (member added)
CREATE OR REPLACE FUNCTION public.handle_challenge_member_notification()
RETURNS TRIGGER AS $$
DECLARE
  challenge_name TEXT;
  inviter_name TEXT;
  inviter_id UUID;
BEGIN
  -- Get the challenge name and creator
  SELECT c.name, c.creator_id INTO challenge_name, inviter_id
  FROM public.challenges c
  WHERE c.id = NEW.challenge_id;

  -- Get the inviter's display name or username as fallback
  SELECT COALESCE(display_name, username, 'Someone') INTO inviter_name
  FROM public.users
  WHERE id = inviter_id;

  -- Only create notification if this is not the creator being added
  IF NEW.user_id != inviter_id THEN
    INSERT INTO public.notifications (user_id, type, title, body, action_user_id, challenge_id)
    VALUES (
      NEW.user_id,
      'challenge_invite',
      'Challenge Invitation',
      inviter_name || ' invited you to join ''' || COALESCE(challenge_name, 'a challenge') || '''',
      inviter_id,
      NEW.challenge_id
    );
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = '';

-- Trigger for challenge member notifications
DROP TRIGGER IF EXISTS on_challenge_member_notification ON public.challenge_members;
CREATE TRIGGER on_challenge_member_notification
  AFTER INSERT ON public.challenge_members
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_challenge_member_notification();

-- ============================================================================
-- GRANTS
-- ============================================================================

GRANT SELECT, INSERT, UPDATE, DELETE ON public.notifications TO authenticated;

-- ============================================================================
-- ENABLE REALTIME
-- ============================================================================

ALTER PUBLICATION supabase_realtime ADD TABLE public.notifications;

