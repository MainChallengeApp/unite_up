-- Migration: Remove email from public.users table
-- Description: Email should only be stored in auth.users (single source of truth)
-- The app will get the current user's email from the auth session instead.

-- ============================================================================
-- UPDATE TRIGGER FUNCTION
-- ============================================================================

-- Update the handle_new_user function to not insert email
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
DECLARE
  new_username TEXT;
BEGIN
  -- Generate username from metadata or email prefix
  new_username := COALESCE(
    NEW.raw_user_meta_data->>'username',
    LOWER(REGEXP_REPLACE(SPLIT_PART(NEW.email, '@', 1), '[^a-z0-9_]', '', 'g'))
  );
  
  -- Ensure username is unique by appending random suffix if needed
  WHILE EXISTS (SELECT 1 FROM public.users WHERE username = new_username) LOOP
    new_username := new_username || '_' || SUBSTRING(gen_random_uuid()::text, 1, 4);
  END LOOP;

  INSERT INTO public.users (id, username, auth_provider)
  VALUES (
    NEW.id,
    new_username,
    COALESCE(NEW.raw_app_meta_data->>'provider', 'email')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = '';

-- ============================================================================
-- REMOVE EMAIL COLUMN
-- ============================================================================

-- Drop the email column from users table
ALTER TABLE public.users DROP COLUMN IF EXISTS email;

