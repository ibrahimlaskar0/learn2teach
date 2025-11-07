# Deployment Guide - Learn2Teach

This guide explains how to deploy Learn2Teach to various platforms.

## Quick Deploy Options

### Option 1: Railway (Recommended - Easiest)
Railway is the easiest option for full-stack Flask apps. Free tier available.

**Steps:**
1. Push your code to GitHub (already done ✓)
2. Go to https://railway.app
3. Click "New Project" → "Deploy from GitHub"
4. Select `ibrahimlaskar0/learn2teach` repository
5. Set environment variables:
   - `FLASK_ENV=production`
   - `FLASK_SECRET_KEY=your-random-secret-key-here`
6. Deploy! Railway will automatically detect the Procfile

**Cost:** Free tier with limitations, paid plans start at $5/month

---

### Option 2: Heroku (Classic but Paid)
Heroku was the standard but discontinued free tier.

**Steps:**
1. Install Heroku CLI: `npm install -g heroku`
2. Login: `heroku login`
3. Create app: `heroku create learn2teach`
4. Set config vars:
   ```powershell
   heroku config:set FLASK_ENV=production
   heroku config:set FLASK_SECRET_KEY=your-random-secret-key
   ```
5. Deploy: `git push heroku main`

**Cost:** Starting at $7/month

---

### Option 3: Render
Modern alternative to Heroku with good free tier.

**Steps:**
1. Go to https://render.com
2. Click "New +" → "Web Service"
3. Connect your GitHub repository
4. Configure:
   - Build command: `pip install -r requirements.txt`
   - Start command: `gunicorn app:app`
   - Environment: Set FLASK_ENV=production
5. Deploy!

**Cost:** Free tier available with limitations

---

### Option 4: PythonAnywhere
Good for Python-specific hosting.

**Steps:**
1. Go to https://www.pythonanywhere.com
2. Create account and upload your code
3. Configure WSGI application
4. Set environment variables in web app settings

**Cost:** Free tier with limitations (~100MB storage)

---

## Environment Variables

Make sure to set these on your hosting platform:

```
FLASK_ENV=production
FLASK_SECRET_KEY=generate-a-random-string-here
DEBUG=False
```

Generate a secure secret key:
```powershell
python -c "import secrets; print(secrets.token_hex(32))"
```

---

## Netlify + Backend Separation

**If you want to use Netlify for the frontend only:**

1. Build a static export of your frontend
2. Deploy to Netlify
3. Configure API calls to point to your backend (Railway, Heroku, etc.)
4. Set environment variable in Netlify:
   ```
   REACT_APP_API_URL=https://your-railway-app.railway.app
   ```

However, since our frontend is server-rendered by Flask, **we recommend deploying the entire app to Railway/Render/Heroku instead**.

---

## Deployment Checklist

- [ ] Push latest code to GitHub
- [ ] Set FLASK_ENV=production on hosting platform
- [ ] Generate and set FLASK_SECRET_KEY
- [ ] Configure custom domain (optional)
- [ ] Test all features on live site
- [ ] Set up error monitoring (Sentry)
- [ ] Enable HTTPS (automatic on most platforms)

---

## Post-Deployment

Once deployed, your app will be available at:
- Railway: `https://your-project-name.railway.app`
- Heroku: `https://learn2teach.herokuapp.com`
- Render: `https://learn2teach.onrender.com`
- PythonAnywhere: `https://username.pythonanywhere.com`

---

## Monitoring & Logs

### Railway
- View logs: Dashboard → View Logs

### Heroku
```powershell
heroku logs --tail
```

### Render
- View logs: Dashboard → Service Logs

---

## Database (Future Enhancement)

Currently using in-memory database. For production with persistent data:

1. Add MySQL/PostgreSQL database to your hosting plan
2. Update `requirements.txt` to use Flask-SQLAlchemy
3. Update `app.py` to connect to the database
4. Set DATABASE_URL environment variable
5. Run migrations on deployment

---

## Troubleshooting

**App not starting:**
- Check logs on hosting platform
- Verify Procfile exists and is correct
- Ensure all dependencies in requirements.txt

**Port errors:**
- App automatically uses PORT environment variable
- No need to hardcode port

**Session/Cookie errors:**
- Set FLASK_SECRET_KEY environment variable
- Enable secure cookies for HTTPS

**CORS errors:**
- Flask-CORS is already configured
- Check frontend URL matches allowed origins

---

## Recommended: Deploy to Railway Now

1. Go to https://railway.app
2. Sign up with GitHub
3. Click "New Project"
4. Select "Deploy from GitHub repo"
5. Choose `learn2teach` repository
6. Add environment variables
7. Done! ✓

Your app will be live in minutes!

---

**Need help?**
- Railway Support: https://railway.app/support
- Flask Deployment: https://flask.palletsprojects.com/deployment/
- GitHub Issues: https://github.com/ibrahimlaskar0/learn2teach/issues
