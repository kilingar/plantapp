-- Add Google Drive folder link to homes table
ALTER TABLE public.homes
ADD COLUMN google_drive_folder_url TEXT;

COMMENT ON COLUMN public.homes.google_drive_folder_url IS 'Link to Google Drive folder for high-res photo backup';
