export type Json =
  | string
  | number
  | boolean
  | null
  | { [key: string]: Json | undefined }
  | Json[]

export interface Database {
  public: {
    Tables: {
      profiles: {
        Row: {
          id: string
          email: string
          full_name: string | null
          avatar_url: string | null
          super_admin: boolean
          created_at: string
          updated_at: string
        }
        Insert: {
          id: string
          email: string
          full_name?: string | null
          avatar_url?: string | null
          super_admin?: boolean
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          email?: string
          full_name?: string | null
          avatar_url?: string | null
          super_admin?: boolean
          created_at?: string
          updated_at?: string
        }
      }
      invitations: {
        Row: {
          id: string
          home_id: string
          email: string
          token: string
          invited_by: string
          status: 'pending' | 'accepted' | 'declined' | 'expired'
          created_at: string
          expires_at: string
        }
        Insert: {
          id?: string
          home_id: string
          email: string
          token: string
          invited_by: string
          status?: 'pending' | 'accepted' | 'declined' | 'expired'
          created_at?: string
          expires_at?: string
        }
        Update: {
          id?: string
          home_id?: string
          email?: string
          token?: string
          invited_by?: string
          status?: 'pending' | 'accepted' | 'declined' | 'expired'
          created_at?: string
          expires_at?: string
        }
      }
      homes: {
        Row: {
          id: string
          name: string
          description: string | null
          owner_id: string
          google_drive_folder_url: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          name: string
          description?: string | null
          owner_id: string
          google_drive_folder_url?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          name?: string
          description?: string | null
          owner_id?: string
          google_drive_folder_url?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      home_members: {
        Row: {
          id: string
          home_id: string
          user_id: string
          role: 'owner' | 'member'
          created_at: string
        }
        Insert: {
          id?: string
          home_id: string
          user_id: string
          role?: 'owner' | 'member'
          created_at?: string
        }
        Update: {
          id?: string
          home_id?: string
          user_id?: string
          role?: 'owner' | 'member'
          created_at?: string
        }
      }
      zones: {
        Row: {
          id: string
          home_id: string
          name: string
          description: string | null
          image_url: string | null
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          home_id: string
          name: string
          description?: string | null
          image_url?: string | null
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          home_id?: string
          name?: string
          description?: string | null
          image_url?: string | null
          created_at?: string
          updated_at?: string
        }
      }
      plants: {
        Row: {
          id: string
          zone_id: string
          name: string
          species: string | null
          description: string | null
          acquisition_date: string | null
          watering_frequency_days: number | null
          last_watered: string | null
          image_url: string | null
          status: 'active' | 'archived'
          created_at: string
          updated_at: string
        }
        Insert: {
          id?: string
          zone_id: string
          name: string
          species?: string | null
          description?: string | null
          acquisition_date?: string | null
          watering_frequency_days?: number | null
          last_watered?: string | null
          image_url?: string | null
          status?: 'active' | 'archived'
          created_at?: string
          updated_at?: string
        }
        Update: {
          id?: string
          zone_id?: string
          name?: string
          species?: string | null
          description?: string | null
          acquisition_date?: string | null
          watering_frequency_days?: number | null
          last_watered?: string | null
          image_url?: string | null
          status?: 'active' | 'archived'
          created_at?: string
          updated_at?: string
        }
      }
      plant_diary_entries: {
        Row: {
          id: string
          plant_id: string
          user_id: string
          entry_type: 'watering' | 'fertilizing' | 'pruning' | 'observation' | 'other'
          notes: string
          image_url: string | null
          created_at: string
        }
        Insert: {
          id?: string
          plant_id: string
          user_id: string
          entry_type: 'watering' | 'fertilizing' | 'pruning' | 'observation' | 'other'
          notes: string
          image_url?: string | null
          created_at?: string
        }
        Update: {
          id?: string
          plant_id?: string
          user_id?: string
          entry_type?: 'watering' | 'fertilizing' | 'pruning' | 'observation' | 'other'
          notes?: string
          image_url?: string | null
          created_at?: string
        }
      }
    }
    Views: {
      [_ in never]: never
    }
    Functions: {
      [_ in never]: never
    }
    Enums: {
      [_ in never]: never
    }
  }
}
