from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from werkzeug.security import check_password_hash
from tables import get_db
import jwt
import os 
import secrets

from dotenv import load_dotenv
from datetime import datetime, timedelta # => Validity time
from fastapi.security import OAuth2PasswordBearer

load_dotenv()
secret_key=os.getenv("SECRET_KEY",secrets.token_hex(32))
algo = "HS256"
access_token_expire_time_minutes=60

auth_token = OAuth2PasswordBearer(tokenUrl="login")
rou = APIRouter()

class LoginRequest(BaseModel):
    email: str
    password: str


def create_access_token(data:dict,expire_delta:timedelta=timedelta(minutes=access_token_expire_time_minutes)):
    to_encode=data.copy()
    expire=datetime.utcnow() + expire_delta
    to_encode.update({"exp":expire})
    return jwt.encode(to_encode,secret_key,algorithm=algo)
 

@rou.post("/login")
def login(data: LoginRequest):
    db = get_db()
    cr = db.cursor()
    cr.execute("SELECT password FROM users WHERE email = ?", (data.email,))
    user = cr.fetchone()
    db.close()
    
    if user and check_password_hash(user[0], data.password):
        token=create_access_token({"sub":data.email})
        return {"access token": token, "type": "bearer"}
    
    raise HTTPException(status_code=400, detail="Invalid email or password")


@rou.post("/users/self")
def get_current_user(token:str=Depends(auth_token)):
    try:
        payload= jwt.decode(token,secret_key,algorithms=[algo]) # [algo] => must be list, if not > TypeError
        username : str = payload.get("sub")
        if username is None:
            raise HTTPException(status_code=401,detail="Invalid token")
        return {"username":username}
    
    except jwt.ExpiredSignatureError: 
        raise HTTPException(status_code=401,detail="Token expired")
    except jwt.InvalidTokenError:
        raise HTTPException(status_code=401, detail="Invalid token")
