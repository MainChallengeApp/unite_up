-- Migration: Make username required and display_name nullable
-- Description: Changes username to NOT NULL and display_name to nullable, updates trigger

-- ============================================================================
-- ALTER USERS TABLE
-- ============================================================================

-- Make display_name nullable
ALTER TABLE public.users ALTER COLUMN display_name DROP NOT NULL;

-- Make username required (first set a default for existing rows without username)
UPDATE public.users 
SET username = LOWER(REPLACE(display_name, ' ', '_')) || '_' || SUBSTRING(id::text, 1, 8)
WHERE username IS NULL;

-- Now make username NOT NULL
ALTER TABLE public.users ALTER COLUMN username SET NOT NULL;

-- ============================================================================
-- UPDATE TRIGGER FUNCTION
-- ============================================================================

-- Function to create user profile on signup (updated to handle username)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, username, display_name, auth_provider)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(
      NEW.raw_user_meta_data->>'username',
      LOWER(REPLACE(COALESCE(NEW.raw_user_meta_data->>'name', SPLIT_PART(NEW.email, '@', 1)), ' ', '_'))
    ),
    NEW.raw_user_meta_data->>'display_name',
    COALESCE(NEW.raw_app_meta_data->>'provider', 'email')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER
SET search_path = '';

