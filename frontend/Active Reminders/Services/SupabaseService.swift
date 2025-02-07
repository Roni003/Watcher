//
//  SupabaseService.swift
//  Active Reminders
//
//  Created by Ronik on 23/01/2025.
//

import Foundation
import Supabase

let api_url = "https://wjvgjlzvnmteylvrqlcc.supabase.co"
let public_key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndqdmdqbHp2bm10ZXlsdnJxbGNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2Mzc5OTIsImV4cCI6MjA1MzIxMzk5Mn0.YwiX-YOXpTuz0J_YyXCyMa9-y9v6tJ9EFvlB8cVk2sU"

let supabase = SupabaseClient(
    supabaseURL: URL(string: api_url)!,
  supabaseKey: public_key
)
