import { supabase } from "@/lib/supabase/client";

const MAX_WIDTH = 1280;
const MAX_HEIGHT = 1280;
const DEFAULT_MAX_FILE_SIZE = 100 * 1024; // 100KB default
const HIGH_QUALITY_MAX_FILE_SIZE = 500 * 1024; // 500KB with Google Drive

/**
 * Resize and compress image to fit within max dimensions and file size
 */
export async function resizeImage(file: File, maxFileSize: number = DEFAULT_MAX_FILE_SIZE): Promise<Blob> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = (event) => {
      const img = new Image();
      img.src = event.target?.result as string;
      img.onload = async () => {
        const canvas = document.createElement("canvas");
        let width = img.width;
        let height = img.height;

        // Calculate new dimensions while maintaining aspect ratio
        if (width > height) {
          if (width > MAX_WIDTH) {
            height = (height * MAX_WIDTH) / width;
            width = MAX_WIDTH;
          }
        } else {
          if (height > MAX_HEIGHT) {
            width = (width * MAX_HEIGHT) / height;
            height = MAX_HEIGHT;
          }
        }

        canvas.width = width;
        canvas.height = height;

        const ctx = canvas.getContext("2d");
        if (!ctx) {
          reject(new Error("Could not get canvas context"));
          return;
        }

        ctx.drawImage(img, 0, 0, width, height);

        // Try different quality levels to hit target file size
        let quality = 0.7;
        let blob: Blob | null = null;
        
        // Start with WebP at 70% quality
        blob = await new Promise<Blob | null>((res) => {
          canvas.toBlob((b) => res(b), "image/webp", quality);
        });

        // If still too large, reduce quality further
        while (blob && blob.size > maxFileSize && quality > 0.1) {
          quality -= 0.1;
          blob = await new Promise<Blob | null>((res) => {
            canvas.toBlob((b) => res(b), "image/webp", quality);
          });
        }

        // If still too large, reduce dimensions
        if (blob && blob.size > maxFileSize) {
          const scale = Math.sqrt(maxFileSize / blob.size);
          canvas.width = Math.floor(width * scale);
          canvas.height = Math.floor(height * scale);
          ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
          
          blob = await new Promise<Blob | null>((res) => {
            canvas.toBlob((b) => res(b), "image/webp", 0.7);
          });
        }

        if (blob) {
          console.log(`Image compressed to ${(blob.size / 1024).toFixed(1)}KB`);
          resolve(blob);
        } else {
          reject(new Error("Could not create blob"));
        }
      };
      img.onerror = reject;
    };
    reader.onerror = reject;
  });
}

/**
 * Upload image to Supabase Storage
 * Checks if Google Drive is configured to determine image quality
 */
export async function uploadPlantImage(
  file: File,
  plantId: string,
  homeId?: string
): Promise<string | null> {
  try {
    // Check if Google Drive is configured for this home
    let maxFileSize = DEFAULT_MAX_FILE_SIZE;
    
    if (homeId) {
      const { data: home } = await supabase
        .from("homes")
        .select("google_drive_folder_url")
        .eq("id", homeId)
        .single();
      
      if (home?.google_drive_folder_url) {
        maxFileSize = HIGH_QUALITY_MAX_FILE_SIZE;
        console.log("Google Drive configured - using high quality (500KB max)");
      } else {
        console.log("No Google Drive - using standard quality (100KB max)");
      }
    }

    // Resize image with appropriate quality
    const resizedBlob = await resizeImage(file, maxFileSize);
    
    // Generate unique filename with webp extension
    const fileName = `${plantId}/${Date.now()}.webp`;

    // Upload to Supabase Storage
    const { data, error } = await supabase.storage
      .from("plant-images")
      .upload(fileName, resizedBlob, {
        contentType: "image/webp",
        upsert: false,
      });

    if (error) {
      console.error("Error uploading image:", error);
      return null;
    }

    // Get public URL
    const {
      data: { publicUrl },
    } = supabase.storage.from("plant-images").getPublicUrl(data.path);

    return publicUrl;
  } catch (error) {
    console.error("Error processing image:", error);
    return null;
  }
}

/**
 * Delete image from Supabase Storage
 */
export async function deletePlantImage(imageUrl: string): Promise<boolean> {
  try {
    // Extract path from URL
    const path = imageUrl.split("/plant-images/")[1];
    if (!path) return false;

    const { error } = await supabase.storage
      .from("plant-images")
      .remove([path]);

    if (error) {
      console.error("Error deleting image:", error);
      return false;
    }

    return true;
  } catch (error) {
    console.error("Error deleting image:", error);
    return false;
  }
}
