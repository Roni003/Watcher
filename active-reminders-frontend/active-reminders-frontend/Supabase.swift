//
//  Supabase.swift
//  active-reminders-frontend
//
//  Created by Ronik on 11/02/2025.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://wjvgjlzvnmteylvrqlcc.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndqdmdqbHp2bm10ZXlsdnJxbGNjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2Mzc5OTIsImV4cCI6MjA1MzIxMzk5Mn0.YwiX-YOXpTuz0J_YyXCyMa9-y9v6tJ9EFvlB8cVk2sU"
)
