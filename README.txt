Learn2Teach - Peer-to-Peer Skill Exchange Platform
===================================================

QUICK START
-----------

1. Install Python dependencies:
   pip install -r requirements.txt

2. Run the Flask application:
   python app.py

3. Open your browser and visit:
   http://localhost:5000


FEATURES
--------

- User Registration and Authentication
- Profile Management
- Skill Listing (Teaching & Learning)
- Location-based Skill Discovery
- Session Booking System
- Flexible Payment Options:
  * Paid lessons (hourly rates)
  * Skill exchange (trade skills)
  * Free teaching options
- Session Management (pending, confirmed, completed)
- Review and Rating System
- Real-time skill marketplace


HOW TO USE
----------

1. REGISTER
   - Visit http://localhost:5000/register
   - Create your account with name, email, password, and location
   - Your profile is ready to use immediately

2. ADD SKILLS
   - Go to Dashboard after login
   - Click "Add New Skill"
   - Enter skill name, category, and description
   - Set your hourly rate or offer for free
   - Enable skill exchange if you want to trade skills

3. BROWSE SKILLS
   - Visit "Browse Skills" page
   - See all available skills from teachers
   - Filter by category, location, or skill type
   - View teacher profiles

4. BOOK SESSIONS
   - Click "Book" on any skill
   - Choose date, time, and duration
   - Select payment method (paid or exchange)
   - Confirm your session

5. MANAGE SESSIONS
   - View all your sessions in Dashboard
   - Accept or decline session requests
   - Track session status (pending, confirmed, completed)
   - Leave reviews after completion

6. UPDATE PROFILE
   - Visit Profile page
   - Add bio, location, and profile picture URL
   - Save your changes


TECHNOLOGY STACK
----------------

Backend:
- Flask 3.0.0 (Python web framework)
- Session-based authentication with password hashing
- In-memory database for demo/development

Frontend:
- HTML5 with semantic markup
- CSS3 with responsive design
- Vanilla JavaScript for interactivity

API:
- RESTful endpoints for all operations
- JSON request/response format


PAYMENT OPTIONS
---------------

1. Paid Sessions:
   - Set hourly rate for your skill
   - System calculates total based on duration
   - Book sessions at your specified rate

2. Skill Exchange:
   - Offer your teaching skill
   - Exchange for another person's skill
   - No money involved in the transaction

3. Free Teaching:
   - Set hourly rate to 0
   - Help others learn for free


HOW IT WORKS
------------

1. Users register and create a profile
2. Users list skills they can teach or want to learn
3. Other users browse available skills
4. Learners book sessions with teachers
5. Both parties confirm the session details
6. After completion, users leave reviews
7. System tracks all transactions and ratings


DATA STRUCTURE
--------------

Users:
- ID, email, password hash, full name, location, bio, profile image

Skills:
- ID, user ID, skill name, category, description, hourly rate, exchange flag

Sessions:
- ID, teacher ID, learner ID, skill ID, date, duration, status, payment method

Reviews:
- ID, session ID, reviewer ID, reviewed user ID, rating, comment

SECURITY
--------

- User passwords are hashed using industry-standard algorithms
- Session-based authentication for protected routes
- User data isolation (users can only see their own information)
- HTTPS recommended for production deployment


DEPLOYMENT
----------

For production use, deploy to platforms like:
- Heroku
- PythonAnywhere
- Railway
- Render
- AWS


SUPPORT
-------

For issues or questions, please:
1. Check the README.md for detailed documentation
2. Review API endpoints in app.py
3. Check GitHub issues: https://github.com/ibrahimlaskar0/learn2teach.git
