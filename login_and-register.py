import sqlite3
from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
from werkzeug.security import generate_password_hash, check_password_hash
import smtplib
import random
import string
from typing import List, Optional

app = FastAPI()

# Database Functions
def get_db():
    db = sqlite3.connect("Tasheh.db")
    return db

def create_tables():
    db = get_db()
    cr = db.cursor()
    cr.executescript('''
        CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            Fname TEXT NOT NULL,
            Lname TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL,
            reset_code TEXT DEFAULT NULL
        );
        CREATE TABLE IF NOT EXISTS owners(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            Fname TEXT NOT NULL,
            Lname TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            phone TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        );
        CREATE TABLE IF NOT EXISTS places(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            city TEXT NOT NULL,
            type TEXT NOT NULL,
            description TEXT,
            rate REAL DEFAULT 0.0
        );
        CREATE TABLE IF NOT EXISTS images(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            place_id INTEGER NOT NULL,
            image_path TEXT NOT NULL,
            FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE
        );
        CREATE TABLE IF NOT EXISTS guides(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            Fname TEXT NOT NULL,
            Lname TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            phone TEXT UNIQUE NOT NULL,
            national_id INTEGER NOT NULL,
            personal_image TEXT NOT NULL,
            password TEXT NOT NULL,
            gender TEXT NOT NULL,
            age INTEGER NOT NULL    
        );
    ''')
    db.commit()
    db.close()

# Models
class UserRegister(BaseModel):
    Fname: str
    Lname: str
    email: str
    password: str

class OwnerRegister(UserRegister):
    phone: str
    name: str
    city: str
    type: str
    description: str
    images: Optional[List[str]] = []

class GuideRegister(UserRegister):
    phone: str
    national_id: int
    personal_image: str
    gender: str
    age: int

class LoginRequest(BaseModel):
    email: str
    password: str

class RatingRequest(BaseModel):
    id_place: int
    rate: float

class ResetPasswordRequest(BaseModel):
    email: str
    reset_code: str
    new_password: str

# Helper Functions
def generate_reset_code():
    return ''.join(random.choices(string.ascii_letters + string.digits, k=4))

def send_reset_email(email: str, reset_code: str):
    sender = "z87615339@gmail.com"
    sender_password = "2025isBetter"
    message = f"Subject: Password Reset Code\n\nYour password reset code is: {reset_code}"
    
    try:
        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.starttls()
        server.login(sender, sender_password)
        server.sendmail(sender, email, message)
        server.quit()
        return True
    except Exception as e:
        print(f"Error sending email: {e}")
        return False

# API Endpoints
@app.post("/user_register")
def user_register(data: UserRegister):
    db = get_db()
    cr = db.cursor()
    hashed_password = generate_password_hash(data.password)
    try:
        cr.execute("INSERT INTO users (Fname, Lname, email, password) VALUES (?, ?, ?, ?)",
                   (data.Fname, data.Lname, data.email, hashed_password))
        db.commit()
        return {"message": "User added successfully", "status": "success"}
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=400, detail="An account already exists for this email")
    finally:
        db.close()

@app.post("/login")
def login(data: LoginRequest):
    db = get_db()
    cr = db.cursor()
    cr.execute("SELECT password FROM users WHERE email = ?", (data.email,))
    user = cr.fetchone()
    db.close()
    
    if user and check_password_hash(user[0], data.password):
        return {"message": "Login successful", "status": "success"}
    raise HTTPException(status_code=400, detail="Invalid email or password")

@app.post("/rating")
def rating(data: RatingRequest):
    db = get_db()
    cr = db.cursor()
    cr.execute("SELECT rate FROM places WHERE id = ?", (data.id_place,))
    rating = cr.fetchone()
    
    if rating:
        new_rate = (rating[0] + data.rate) / 2
        cr.execute("UPDATE places SET rate = ? WHERE id = ?", (new_rate, data.id_place))
        db.commit()
        return {"message": "Rating updated successfully", "status": "success"}
    raise HTTPException(status_code=404, detail="Place ID not found")

@app.post("/reset_password")
def reset_password(data: ResetPasswordRequest):
    db = get_db()
    cr = db.cursor()
    cr.execute("SELECT reset_code FROM users WHERE email = ?", (data.email,))
    user = cr.fetchone()
    
    if not user or user[0] != data.reset_code:
        raise HTTPException(status_code=400, detail="Invalid reset code")
    
    hashed_password = generate_password_hash(data.new_password)
    cr.execute("UPDATE users SET password = ?, reset_code = NULL WHERE email = ?", (hashed_password, data.email))
    db.commit()
    return {"message": "Password reset successfully", "status": "success"}

if __name__ == "__main__":
    create_tables()