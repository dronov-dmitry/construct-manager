-- ============================================================
-- ConstructManager — Supabase Storage Setup
-- Run after 002-rls.sql
-- 1. Create bucket manually in Supabase Dashboard OR via API
-- 2. Run this SQL for bucket policies
-- ============================================================

-- Ensure the bucket exists (run CREATE or use Dashboard)
INSERT INTO storage.buckets (id, name, public)
VALUES ('construction-photos', 'construction-photos', true)
ON CONFLICT (id) DO NOTHING;

-- Function to create bucket from the app (called via anon key + RPC)
CREATE OR REPLACE FUNCTION create_photo_bucket()
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  INSERT INTO storage.buckets (id, name, public)
  VALUES ('construction-photos', 'construction-photos', true)
  ON CONFLICT (id) DO NOTHING;
END;
$$;

-- Allow authenticated users to call this function
GRANT EXECUTE ON FUNCTION create_photo_bucket() TO authenticated;

-- ******************** STORAGE POLICIES ********************

-- Allow authenticated users to upload photos
DROP POLICY IF EXISTS "authenticated_upload_photos" ON storage.objects;
CREATE POLICY "authenticated_upload_photos"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'construction-photos'
);

-- Allow public access to view photos
DROP POLICY IF EXISTS "public_view_photos" ON storage.objects;
CREATE POLICY "public_view_photos"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'construction-photos');

-- Allow authenticated users to update photos
DROP POLICY IF EXISTS "authenticated_update_photos" ON storage.objects;
CREATE POLICY "authenticated_update_photos"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'construction-photos');

-- Allow authenticated users to delete their photos
DROP POLICY IF EXISTS "authenticated_delete_photos" ON storage.objects;
CREATE POLICY "authenticated_delete_photos"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'construction-photos');

-- ******************** VERIFICATION ********************
SELECT
    'Storage policies created' as status,
    COUNT(*) as policy_count
FROM pg_policies
WHERE tablename = 'objects'
AND schemaname = 'storage';
