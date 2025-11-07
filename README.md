# Learn2Teach - Connect, Learn, and Teach Skills

A modern web platform where students can connect with each other to learn and teach skills. Students can offer skills they want to teach, find skills they want to learn, and optionally charge money or exchange skills with others.

## Features

✨ **Skill Sharing**
- List skills you want to teach or learn
- Set hourly rates or offer skill exchanges
- Flexible payment options: paid lessons or skill exchanges

🌍 **Location-Based Discovery**
- Find students and teachers near you
- Filter skills by location, category, and type
- Connect with local community

💰 **Flexible Pricing**
- Charge for teaching your skills
- Exchange skills with other students
- Free lessons option available

📅 **Session Management**
- Book lessons at convenient times
- Track session status (pending, confirmed, completed)
- Accept or decline lesson requests

⭐ **Review System**
- Rate and review sessions
- Build trust in the community
- Showcase your expertise

## Tech Stack

- **Backend**: Flask (Python)
- **Frontend**: HTML, CSS, JavaScript
- **Database**: Supabase (PostgreSQL)
- **Authentication**: Supabase Auth

## Prerequisites

- Python 3.8+
- Supabase account (free tier available at https://supabase.com)

## Setup Instructions (Windows PowerShell)

### 1. Clone or navigate to the project
```powershell
cd "c:\Users\ibrah\Desktop\kr project\learn2tech-main"
```

### 2. Create Virtual Environment
```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

### 3. Install Dependencies
```powershell
pip install -r requirements.txt
```

### 4. Configure Environment Variables

Copy `.env` template and add your Supabase credentials:

```powershell
Copy-Item ".env" ".env.local" -Force
```

Edit the `.env` file with your Supabase project details:
- Go to https://supabase.com/dashboard
- Create a new project
- Copy your project URL and anon key
- Update `.env` with:
  ```
  VITE_SUPABASE_URL=https://your-project.supabase.co
  VITE_SUPABASE_ANON_KEY=your-anon-key
  FLASK_SECRET_KEY=your-random-secret-key
  ```

### 5. Create Supabase Tables

Run these SQL commands in your Supabase SQL editor:

```sql
-- Create profiles table
CREATE TABLE profiles (
    id UUID PRIMARY KEY,
    full_name TEXT NOT NULL,
    bio TEXT,
    location TEXT,
    profile_image TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create skills table
CREATE TABLE skills (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    skill_name TEXT NOT NULL,
    category TEXT NOT NULL,
    description TEXT,
    skill_type TEXT NOT NULL CHECK (skill_type IN ('teaching', 'learning')),
    hourly_rate DECIMAL(10, 2) DEFAULT 0,
    accepts_exchange BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create sessions table
CREATE TABLE sessions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    teacher_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    learner_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    skill_id UUID NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    session_date TIMESTAMP NOT NULL,
    duration_hours DECIMAL(5, 2) NOT NULL,
    total_amount DECIMAL(10, 2) DEFAULT 0,
    payment_type TEXT CHECK (payment_type IN ('paid', 'exchange')),
    exchange_skill_id UUID REFERENCES skills(id),
    location TEXT DEFAULT 'online',
    notes TEXT,
    status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'confirmed', 'completed', 'cancelled')),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create transactions table
CREATE TABLE transactions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    payer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    receiver_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create reviews table
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
    reviewer_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    reviewed_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    rating INTEGER CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_skills_user_id ON skills(user_id);
CREATE INDEX idx_sessions_teacher_id ON sessions(teacher_id);
CREATE INDEX idx_sessions_learner_id ON sessions(learner_id);
CREATE INDEX idx_skills_category ON skills(category);
CREATE INDEX idx_skills_skill_type ON skills(skill_type);
```

### 6. Run the Application

```powershell
python app.py
```

The app will start on `http://127.0.0.1:5000`

### 7. Access the App

Open your browser and navigate to:
```
http://127.0.0.1:5000
```

## Usage

1. **Register** - Create a new account with email and password
2. **Set Up Profile** - Add your bio, location, and profile picture
3. **Add Skills** - List skills you can teach or want to learn
4. **Browse** - Search for skills by category, location, or type
5. **Book Sessions** - Schedule lessons or skill exchanges
6. **Manage** - Track your sessions and update their status
7. **Review** - Rate and review sessions after completion

## Folder Structure

```
learn2tech-main/
├── app.py                 # Main Flask application
├── requirements.txt       # Python dependencies
├── .env                   # Environment variables (git-ignored)
├── templates/
│   ├── index.html        # Homepage
│   ├── login.html        # Login page
│   ├── register.html     # Registration page
│   ├── dashboard.html    # User dashboard
│   ├── profile.html      # User profile
│   └── skills.html       # Skills browsing and booking
├── static/
│   └── css/
│       └── style.css     # Global styles
└── README.md            # This file
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login user
- `POST /api/auth/logout` - Logout user

### Profile
- `GET /api/profile` - Get current user profile
- `PUT /api/profile` - Update user profile

### Skills
- `GET /api/skills` - List skills (with filters)
- `POST /api/skills` - Create new skill
- `DELETE /api/skills/<skill_id>` - Delete skill

### Sessions
- `GET /api/sessions` - Get user's sessions
- `POST /api/sessions` - Create new session
- `PUT /api/sessions/<session_id>/status` - Update session status

### Reviews
- `POST /api/reviews` - Submit review
- `GET /api/users/<user_id>/reviews` - Get user reviews

## Troubleshooting

### "ModuleNotFoundError: No module named 'flask'"
Make sure your virtual environment is activated and dependencies are installed:
```powershell
pip install -r requirements.txt
```

### "Connection refused" to Supabase
- Verify your Supabase URL and keys in `.env`
- Ensure Supabase project is active
- Check internet connection

### Port 5000 already in use
Change the port in `app.py`:
```python
app.run(debug=True, host='0.0.0.0', port=5001)  # Use 5001 instead
```

## Deployment

For production deployment:

1. Set `DEBUG=False` in `.env`
2. Use a production WSGI server like Gunicorn:
   ```powershell
   pip install gunicorn
   gunicorn -w 4 -b 0.0.0.0:5000 app:app
   ```
3. Deploy to Heroku, Railway, or your preferred platform

## Contributing

Contributions are welcome! Please submit pull requests or open issues for bugs and feature requests.

## License

MIT License - feel free to use this project for personal or commercial purposes.

## Support

For issues or questions:
1. Check existing GitHub issues
2. Create a new issue with detailed description
3. Include error messages and steps to reproduce

---

**Happy Learning and Teaching!** 🚀
