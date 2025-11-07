# Learn2Teach 

A modern skill-sharing platform that connects teachers and learners. Share your expertise, learn new skills, and earn money or exchange knowledge locally.

![Python](https://img.shields.io/badge/Python-3.9+-blue)
![Flask](https://img.shields.io/badge/Flask-3.0.0-green)
![License](https://img.shields.io/badge/License-MIT-yellow)

## Features

 **Skill Sharing**
- List skills you want to teach or learn
- Set hourly rates or offer skill exchanges
- Flexible payment options: paid lessons or skill exchanges

 **Location-Based Discovery**
- Find students and teachers near you
- Filter skills by location, category, and type
- Connect with local community

 **Flexible Pricing**
- Charge for teaching your skills
- Exchange skills with other students
- Free lessons option available

 **Session Management**
- Book lessons at convenient times
- Track session status (pending, confirmed, completed)
- Accept or decline lesson requests

 **Review System**
- Rate and review sessions
- Build trust in the community
- Showcase your expertise

## Tech Stack

- **Backend**: Flask 3.0.0 (Python)
- **Frontend**: HTML5, CSS3, Vanilla JavaScript
- **Database**: In-memory (demo mode) or MySQL (production)
- **Authentication**: Session-based with password hashing
- **Styling**: Professional dark theme with responsive design

## Prerequisites

- Python 3.9 or higher
- pip package manager

## Quick Start (Windows PowerShell)

### 1. Clone the Repository

```powershell
git clone https://github.com/ibrahimlaskar0/learn2teach.git
cd learn2teach
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

### 4. Run the Application

```powershell
python app.py
```

The app will be available at `http://127.0.0.1:5000`

## Usage

1. **Register** - Create a new account
2. **Add Skills** - Go to dashboard and list skills you want to teach
3. **Browse Skills** - Visit skills page to find available lessons
4. **Book Sessions** - Click on skills to book sessions with teachers
5. **Track Sessions** - Manage sessions from your dashboard
6. **Leave Reviews** - Rate teachers and sessions

## Project Structure

```
learn2teach/
 app.py                    # Main Flask application
 requirements.txt          # Python dependencies
 .env                      # Environment variables (create from template)
 templates/                # HTML templates
    index.html           # Homepage with features
    login.html           # User login
    register.html        # User registration
    dashboard.html       # User dashboard
    profile.html         # User profile editor
    skills.html          # Skills marketplace
 static/
    css/
        style.css        # Responsive styling
 README.md               # This file
```

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - User login
- `POST /api/auth/logout` - User logout
- `GET /api/auth/me` - Get current user

### Profile
- `GET /api/profile` - Get user profile
- `PUT /api/profile` - Update profile

### Skills
- `GET /api/skills` - Get all available skills
- `POST /api/skills` - Create new skill
- `DELETE /api/skills/<id>` - Delete skill
- `GET /api/skills/user/<id>` - Get user's skills

### Sessions
- `GET /api/sessions` - Get user sessions
- `POST /api/sessions` - Book new session
- `PUT /api/sessions/<id>/status` - Update session status

### Reviews
- `POST /api/reviews` - Submit review
- `GET /api/reviews/<id>` - Get user reviews

## Environment Variables

Create a `.env` file in the root directory:

```
FLASK_SECRET_KEY=your-secret-key-here
FLASK_ENV=development
DEBUG=True
```

## Troubleshooting

### "Port 5000 already in use"
```powershell
# Change port in app.py or use:
python -c "from app import app; app.run(port=5001)"
```

### Virtual environment not activating
```powershell
# Try using the full path:
& ".\venv\Scripts\Activate.ps1"
```

### Missing dependencies
```powershell
# Reinstall all requirements:
pip install -r requirements.txt --force-reinstall
```

## Production Deployment

For production, use a WSGI server:

```powershell
pip install gunicorn
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

Or deploy to platforms like:
- Heroku
- PythonAnywhere
- Railway
- Render

## Future Enhancements

- [ ] MySQL database integration
- [ ] Payment gateway integration (Stripe)
- [ ] Real-time notifications
- [ ] Video call integration
- [ ] Mobile app (React Native/Flutter)
- [ ] Advanced search and filtering
- [ ] User ratings and rankings
- [ ] Email notifications

## Contributing

Contributions are welcome! Feel free to:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## License

MIT License - See LICENSE file for details

## Support

For questions or issues:
1. Open a GitHub issue
2. Include error messages and steps to reproduce
3. Describe your environment (OS, Python version, etc.)

---

**Happy Learning and Teaching!** 

Made with  by Ibrahim Laskar
