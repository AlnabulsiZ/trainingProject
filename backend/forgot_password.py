import random
import string
import smtplib
from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from werkzeug.security import generate_password_hash
from tables import get_db  

rou = APIRouter()

class ForgotPasswordRequest(BaseModel):
    email: str

class ResetPasswordRequest(BaseModel):
    email: str
    reset_code: str
    new_password: str

def generate_reset_code():
    s = ''
    return s.join(random.choices(string.digits, k=4)) 

def send_reset_email(email: str, reset_code: str):
    sender = "z87615339@gmail.com"  
    sender_password = "2025isBetter"  
    message = f"Your password reset code is: {reset_code}" 
    try:
        s = smtplib.SMTP("smtp.gmail.com", 587)
        s.starttls()
        s.login(sender, sender_password)
        s.sendmail(sender, email, message)
        s.quit()
        return True
    
    except Exception as e:
        print(f"Error: {e}")
        return False  

@rou.post("/forgot_password")
def forgot_password(data: ForgotPasswordRequest):
    db = get_db()
    cr = db.cursor()

    cr.execute("SELECT id FROM users WHERE email = ?", (data.email,))
    user = cr.fetchone()

    if not user:
        raise HTTPException(status_code=404, detail="Email not found in our records")
    
    reset_code = generate_reset_code()
    cr.execute("UPDATE users SET reset_code = ? WHERE email = ?", (reset_code, data.email))
    db.commit()

    if send_reset_email(data.email, reset_code):
        return {"message": "Reset code sent to your email", "status": "success"}
    else:
        raise HTTPException(status_code=500, detail="Failed to send email")
    

@rou.post("/reset_password")
def reset_password(data: ResetPasswordRequest):
    db = get_db()
    cr = db.cursor()    

    cr.execute("SELECT reset_code FROM users WHERE email = ?", (data.email,))
    user = cr.fetchone()

    if not user or user[0] != data.reset_code:
        raise HTTPException(status_code=400, detail="Invalid reset code")
    
    
    new = data.new_password
    hashed_password = generate_password_hash(new)
    
    
    cr.execute("UPDATE users SET password = ?, reset_code = NULL WHERE email = ?", (hashed_password, data.email))
    db.commit()
    db.close()

    return {"message": "Password reset successfully", "status": "success"}
