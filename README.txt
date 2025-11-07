Learn2Teach - Peer-to-Peer Skill Exchange Platform
===================================================

INSTALLATION AND SETUP
----------------------

1. Install Python dependencies:
   pip install -r requirements.txt

2. The database is already configured using Supabase. Check your .env file for connection details.

3. Run the Flask application:
   python app.py

4. Open your browser and visit:
   http://localhost:5000


FEATURES
--------

- User Registration and Authentication
- Profile Management
- Skill Listing (Teaching & Learning)
- Location-based Skill Discovery
- Session Booking System
- Payment Options:
  * Pay with money (hourly rates)
  * Skill exchange (trade skills)
  * Free teaching
- Session Management (pending, confirmed, completed, cancelled)
- Review and Rating System
- Transaction Tracking


HOW TO USE
----------

1. REGISTER
   - Visit http://localhost:5000/register
   - Create your account with name, email, password, and location

2. ADD SKILLS
   - Go to Dashboard
   - Click "Add New Skill"
   - Choose whether you want to teach or learn
   - Set your hourly rate or offer it for free
   - Enable skill exchange if you want to trade skills

3. BROWSE SKILLS
   - Visit "Browse Skills" page
   - Filter by category, location, or skill type
   - View available teachers and learners

4. BOOK SESSIONS
   - Click "Book" on any teaching skill
   - Choose date, time, and duration
   - Select payment method (paid or exchange)
   - Add location (online or physical)

5. MANAGE SESSIONS
   - View all your sessions in Dashboard
   - Confirm or cancel pending sessions
   - Mark sessions as complete

6. UPDATE PROFILE
   - Visit Profile page
   - Add bio, location, and profile image
   - Save your changes


DATABASE STRUCTURE
------------------

Tables:
- profiles: User profiles with name, bio, location
- skills: Skills users can teach or want to learn
- sessions: Booked learning sessions
- reviews: Ratings and reviews after sessions
- transactions: Payment records


PAYMENT OPTIONS
---------------

1. Paid Sessions:
   - Set hourly rate
   - System calculates total based on duration
   - Tracks payments in transactions table

2. Skill Exchange:
   - Offer your teaching skill
   - Exchange for another person's skill
   - No money involved

3. Free Teaching:
   - Set hourly rate to 0
   - Help others learn for free


SECURITY
--------

- Row Level Security (RLS) enabled on all tables
- Users can only view and modify their own data
- Session authentication required for all actions
- Secure password storage via Supabase Auth


SUPPORT
-------

For issues or questions, please check the code comments or review the API endpoints in app.py.
