/*
  # Learn2Teach Platform Schema

  ## Overview
  This migration creates the complete database schema for the Learn2Teach platform - a peer-to-peer skill exchange marketplace where students can teach and learn skills from each other.

  ## New Tables

  ### 1. `profiles`
  User profiles with extended information beyond authentication
  - `id` (uuid, primary key) - Links to auth.users
  - `full_name` (text) - User's full name
  - `bio` (text) - User description
  - `location` (text) - City/area for local connections
  - `profile_image` (text) - Profile picture URL
  - `created_at` (timestamptz) - Account creation timestamp

  ### 2. `skills`
  Skills that users can teach or want to learn
  - `id` (uuid, primary key)
  - `user_id` (uuid, foreign key) - Skill owner
  - `skill_name` (text) - Name of the skill
  - `category` (text) - Skill category (e.g., Programming, Languages, Arts)
  - `description` (text) - Detailed skill description
  - `skill_type` (text) - Either 'teaching' or 'learning'
  - `hourly_rate` (decimal) - Price per hour (0 for skill exchange)
  - `accepts_exchange` (boolean) - Whether user accepts skill exchange
  - `created_at` (timestamptz)

  ### 3. `sessions`
  Booking sessions between students
  - `id` (uuid, primary key)
  - `teacher_id` (uuid, foreign key) - User teaching the skill
  - `learner_id` (uuid, foreign key) - User learning the skill
  - `skill_id` (uuid, foreign key) - Skill being taught
  - `session_date` (timestamptz) - Scheduled date/time
  - `duration_hours` (decimal) - Session duration
  - `total_amount` (decimal) - Total payment amount
  - `payment_type` (text) - 'paid' or 'exchange'
  - `exchange_skill_id` (uuid, foreign key) - Skill offered in exchange (nullable)
  - `status` (text) - 'pending', 'confirmed', 'completed', 'cancelled'
  - `location` (text) - Meeting location or 'online'
  - `notes` (text) - Additional notes
  - `created_at` (timestamptz)

  ### 4. `reviews`
  Reviews and ratings after sessions
  - `id` (uuid, primary key)
  - `session_id` (uuid, foreign key)
  - `reviewer_id` (uuid, foreign key) - User giving the review
  - `reviewed_id` (uuid, foreign key) - User being reviewed
  - `rating` (integer) - 1-5 star rating
  - `comment` (text) - Review text
  - `created_at` (timestamptz)

  ### 5. `transactions`
  Payment transaction records
  - `id` (uuid, primary key)
  - `session_id` (uuid, foreign key)
  - `payer_id` (uuid, foreign key)
  - `receiver_id` (uuid, foreign key)
  - `amount` (decimal)
  - `status` (text) - 'pending', 'completed', 'failed'
  - `created_at` (timestamptz)

  ## Security
  - Enable Row Level Security (RLS) on all tables
  - Profiles: Users can view all profiles, but only edit their own
  - Skills: Public read access, users can only modify their own skills
  - Sessions: Users can only view sessions where they are teacher or learner
  - Reviews: Public read, users can only create reviews for their completed sessions
  - Transactions: Users can only view their own transactions

  ## Notes
  1. All tables use UUID primary keys with automatic generation
  2. Timestamps default to current time
  3. Foreign keys ensure referential integrity
  4. RLS policies ensure data security and privacy
  5. Decimal types for monetary values ensure precision
*/

-- Create profiles table
CREATE TABLE IF NOT EXISTS profiles (
  id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  full_name text NOT NULL,
  bio text DEFAULT '',
  location text DEFAULT '',
  profile_image text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view profiles"
  ON profiles FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert own profile"
  ON profiles FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile"
  ON profiles FOR UPDATE
  TO authenticated
  USING (auth.uid() = id)
  WITH CHECK (auth.uid() = id);

-- Create skills table
CREATE TABLE IF NOT EXISTS skills (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  skill_name text NOT NULL,
  category text NOT NULL,
  description text DEFAULT '',
  skill_type text NOT NULL CHECK (skill_type IN ('teaching', 'learning')),
  hourly_rate decimal(10,2) DEFAULT 0,
  accepts_exchange boolean DEFAULT false,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE skills ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view skills"
  ON skills FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can insert own skills"
  ON skills FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own skills"
  ON skills FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own skills"
  ON skills FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create sessions table
CREATE TABLE IF NOT EXISTS sessions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  teacher_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  learner_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  skill_id uuid NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  session_date timestamptz NOT NULL,
  duration_hours decimal(4,2) NOT NULL,
  total_amount decimal(10,2) DEFAULT 0,
  payment_type text NOT NULL CHECK (payment_type IN ('paid', 'exchange')),
  exchange_skill_id uuid REFERENCES skills(id) ON DELETE SET NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
  location text DEFAULT 'online',
  notes text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own sessions"
  ON sessions FOR SELECT
  TO authenticated
  USING (auth.uid() = teacher_id OR auth.uid() = learner_id);

CREATE POLICY "Users can create sessions as learner"
  ON sessions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = learner_id);

CREATE POLICY "Users can update sessions if involved"
  ON sessions FOR UPDATE
  TO authenticated
  USING (auth.uid() = teacher_id OR auth.uid() = learner_id)
  WITH CHECK (auth.uid() = teacher_id OR auth.uid() = learner_id);

-- Create reviews table
CREATE TABLE IF NOT EXISTS reviews (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  reviewer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  reviewed_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  rating integer NOT NULL CHECK (rating >= 1 AND rating <= 5),
  comment text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Anyone can view reviews"
  ON reviews FOR SELECT
  TO authenticated
  USING (true);

CREATE POLICY "Users can create reviews for their sessions"
  ON reviews FOR INSERT
  TO authenticated
  WITH CHECK (
    auth.uid() = reviewer_id AND
    EXISTS (
      SELECT 1 FROM sessions 
      WHERE sessions.id = session_id 
      AND (sessions.teacher_id = auth.uid() OR sessions.learner_id = auth.uid())
      AND sessions.status = 'completed'
    )
  );

-- Create transactions table
CREATE TABLE IF NOT EXISTS transactions (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id uuid NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  payer_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  receiver_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  amount decimal(10,2) NOT NULL,
  status text DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
  created_at timestamptz DEFAULT now()
);

ALTER TABLE transactions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own transactions"
  ON transactions FOR SELECT
  TO authenticated
  USING (auth.uid() = payer_id OR auth.uid() = receiver_id);

CREATE POLICY "Users can create transactions as payer"
  ON transactions FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = payer_id);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_skills_user_id ON skills(user_id);
CREATE INDEX IF NOT EXISTS idx_skills_category ON skills(category);
CREATE INDEX IF NOT EXISTS idx_skills_type ON skills(skill_type);
CREATE INDEX IF NOT EXISTS idx_sessions_teacher ON sessions(teacher_id);
CREATE INDEX IF NOT EXISTS idx_sessions_learner ON sessions(learner_id);
CREATE INDEX IF NOT EXISTS idx_sessions_status ON sessions(status);
CREATE INDEX IF NOT EXISTS idx_reviews_reviewed ON reviews(reviewed_id);
CREATE INDEX IF NOT EXISTS idx_transactions_payer ON transactions(payer_id);
CREATE INDEX IF NOT EXISTS idx_transactions_receiver ON transactions(receiver_id);