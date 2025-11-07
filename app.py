from flask import Flask, render_template, request, jsonify, session, redirect
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, timedelta
import os
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)
app.config["SECRET_KEY"] = "learn2teach-dev-secret"
app.config["SESSION_COOKIE_HTTPONLY"] = True
app.config["PERMANENT_SESSION_LIFETIME"] = timedelta(days=7)

users_db = {}
skills_db = {}
sessions_db = {}
reviews_db = {}
next_user_id = 1
next_skill_id = 1
next_session_id = 1
next_review_id = 1

@app.route("/")
def index():
    return render_template("index.html")

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/register")
def register():
    return render_template("register.html")

@app.route("/dashboard")
def dashboard():
    if "user_id" not in session:
        return redirect("/login")
    return render_template("dashboard.html")

@app.route("/profile")
def profile():
    if "user_id" not in session:
        return redirect("/login")
    return render_template("profile.html")

@app.route("/skills")
def skills():
    return render_template("skills.html")

@app.route("/api/auth/register", methods=["POST"])
def api_register():
    global next_user_id
    data = request.get_json()
    for user in users_db.values():
        if user["email"] == data.get("email"):
            return jsonify({"error": "Email already registered"}), 400
    user = {"id": next_user_id, "email": data.get("email"), "full_name": data.get("full_name"), "location": data.get("location", ""), "password_hash": generate_password_hash(data.get("password")), "bio": "", "profile_image": "", "created_at": datetime.utcnow().isoformat()}
    users_db[next_user_id] = user
    next_user_id += 1
    session["user_id"] = user["id"]
    session.permanent = True
    return jsonify({"success": True, "user_id": user["id"]})

@app.route("/api/auth/login", methods=["POST"])
def api_login():
    data = request.get_json()
    for user in users_db.values():
        if user["email"] == data.get("email"):
            if check_password_hash(user["password_hash"], data.get("password")):
                session["user_id"] = user["id"]
                session.permanent = True
                return jsonify({"success": True, "user_id": user["id"]})
    return jsonify({"error": "Invalid email or password"}), 401

@app.route("/api/auth/logout", methods=["POST"])
def api_logout():
    session.clear()
    return jsonify({"success": True})

@app.route("/api/auth/me", methods=["GET"])
def api_get_me():
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    user = users_db.get(session["user_id"])
    if not user:
        return jsonify({"error": "User not found"}), 404
    return jsonify({"id": user["id"], "email": user["email"], "full_name": user["full_name"], "location": user["location"], "bio": user["bio"], "profile_image": user["profile_image"]})

@app.route("/api/profile", methods=["GET"])
def api_get_profile():
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    user = users_db.get(session["user_id"])
    if not user:
        return jsonify({"error": "User not found"}), 404
    return jsonify({"id": user["id"], "email": user["email"], "full_name": user["full_name"], "location": user["location"], "bio": user["bio"], "profile_image": user["profile_image"]})

@app.route("/api/profile", methods=["PUT"])
def api_update_profile():
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    user = users_db.get(session["user_id"])
    if not user:
        return jsonify({"error": "User not found"}), 404
    data = request.get_json()
    user["full_name"] = data.get("full_name", user["full_name"])
    user["bio"] = data.get("bio", user["bio"])
    user["location"] = data.get("location", user["location"])
    user["profile_image"] = data.get("profile_image", user["profile_image"])
    return jsonify({"success": True})

@app.route("/api/skills", methods=["GET"])
def api_get_skills():
    result = []
    for skill in skills_db.values():
        teacher = users_db.get(skill["user_id"], {})
        result.append({"id": skill["id"], "skill_name": skill["skill_name"], "category": skill["category"], "description": skill["description"], "hourly_rate": skill["hourly_rate"], "accepts_exchange": skill["accepts_exchange"], "teacher": {"id": teacher.get("id"), "full_name": teacher.get("full_name"), "location": teacher.get("location")}})
    return jsonify(result)

@app.route("/api/skills", methods=["POST"])
def api_create_skill():
    global next_skill_id
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    data = request.get_json()
    skill = {"id": next_skill_id, "user_id": session["user_id"], "skill_name": data.get("skill_name"), "category": data.get("category"), "description": data.get("description"), "skill_type": data.get("skill_type", "teaching"), "hourly_rate": data.get("hourly_rate"), "accepts_exchange": data.get("accepts_exchange", False), "created_at": datetime.utcnow().isoformat()}
    skills_db[next_skill_id] = skill
    next_skill_id += 1
    return jsonify({"success": True, "skill_id": skill["id"]})

@app.route("/api/skills/<int:skill_id>", methods=["DELETE"])
def api_delete_skill(skill_id):
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    skill = skills_db.get(skill_id)
    if not skill:
        return jsonify({"error": "Skill not found"}), 404
    if skill["user_id"] != session["user_id"]:
        return jsonify({"error": "Unauthorized"}), 403
    del skills_db[skill_id]
    return jsonify({"success": True})

@app.route("/api/skills/user/<int:user_id>", methods=["GET"])
def api_get_user_skills(user_id):
    result = []
    for skill in skills_db.values():
        if skill["user_id"] == user_id:
            result.append(skill)
    return jsonify(result)

@app.route("/api/sessions", methods=["GET"])
def api_get_sessions():
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    result = []
    for sess in sessions_db.values():
        if sess["teacher_id"] == session["user_id"] or sess["learner_id"] == session["user_id"]:
            skill = skills_db.get(sess["skill_id"], {})
            result.append({"id": sess["id"], "skill_name": skill.get("skill_name"), "teacher_id": sess["teacher_id"], "learner_id": sess["learner_id"], "session_date": sess["session_date"], "duration_hours": sess["duration_hours"], "status": sess["status"]})
    return jsonify(result)

@app.route("/api/sessions", methods=["POST"])
def api_create_session():
    global next_session_id
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    data = request.get_json()
    sess = {"id": next_session_id, "skill_id": data.get("skill_id"), "teacher_id": data.get("teacher_id"), "learner_id": session["user_id"], "session_date": data.get("session_date"), "duration_hours": data.get("duration_hours", 1.0), "payment_method": data.get("payment_method"), "status": "pending", "created_at": datetime.utcnow().isoformat()}
    sessions_db[next_session_id] = sess
    next_session_id += 1
    return jsonify({"success": True, "session_id": sess["id"]})

@app.route("/api/sessions/<int:session_id>/status", methods=["PUT"])
def api_update_session_status(session_id):
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    sess = sessions_db.get(session_id)
    if not sess:
        return jsonify({"error": "Session not found"}), 404
    if sess["teacher_id"] != session["user_id"] and sess["learner_id"] != session["user_id"]:
        return jsonify({"error": "Unauthorized"}), 403
    data = request.get_json()
    sess["status"] = data.get("status")
    return jsonify({"success": True})

@app.route("/api/reviews", methods=["POST"])
def api_create_review():
    global next_review_id
    if "user_id" not in session:
        return jsonify({"error": "Not logged in"}), 401
    data = request.get_json()
    review = {"id": next_review_id, "session_id": data.get("session_id"), "reviewer_id": session["user_id"], "reviewed_user_id": data.get("reviewed_user_id"), "rating": data.get("rating"), "comment": data.get("comment"), "created_at": datetime.utcnow().isoformat()}
    reviews_db[next_review_id] = review
    next_review_id += 1
    return jsonify({"success": True, "review_id": review["id"]})

@app.route("/api/reviews/<int:user_id>", methods=["GET"])
def api_get_user_reviews(user_id):
    result = []
    for review in reviews_db.values():
        if review["reviewed_user_id"] == user_id:
            reviewer = users_db.get(review["reviewer_id"], {})
            result.append({"id": review["id"], "reviewer": reviewer.get("full_name"), "rating": review["rating"], "comment": review["comment"], "created_at": review["created_at"]})
    return jsonify(result)

@app.errorhandler(404)
def not_found(error):
    return render_template("index.html"), 404

if __name__ == "__main__":
    print(" Learn2Teach running on http://127.0.0.1:5000")
    app.run(debug=True, host="0.0.0.0", port=5000)
