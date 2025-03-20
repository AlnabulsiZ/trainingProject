from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from werkzeug.security import check_password_hash
from tables import get_db

rou = APIRouter()

class LoginRequest(BaseModel):
    email: str
    password: str

@rou.post("/login")
def login(data: LoginRequest):
    db = get_db()
    cr = db.cursor()
    cr.execute("SELECT password FROM users WHERE email = ?", (data.email,))
    user = cr.fetchone()
    db.close()
    
    if user and check_password_hash(user[0], data.password):
        return {"message": "Login successful", "status": "success"}
    
    raise HTTPException(status_code=400, detail="Invalid email or password")
