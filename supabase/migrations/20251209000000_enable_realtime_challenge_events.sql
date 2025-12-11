-- Enable Realtime for challenge_events table
-- This allows clients to subscribe to changes on this table

-- Add the table to the supabase_realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.challenge_events;

-- Optionally, also enable realtime for goals table for future use
ALTER PUBLICATION supabase_realtime ADD TABLE public.goals;
