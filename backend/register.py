from fastapi import FastAPI, HTTPException, File, UploadFile
from pydantic import BaseModel, EmailStr, constr
from helper import get_db 
import sqlite3
import os
from werkzeug.security import generate_password_hash, check_password_hash
from typing import List

app = FastAPI()

## TODO you defined this function twice , define it once in a helper file and call it wherever you need ==> Done
get_db()

## TODO: Don't over enginer the code, you dont need such function ==> Done
## TODO: same here, don't over enginer ==> Done


class UserRegister(BaseModel):
    Fname: str
    Lname: str
    email: EmailStr
    password: constr(min_length=6)

class PlaceRegister(BaseModel):
    name: str
    city: str
    type: str
    description: str = ""

class OwnerRegister(UserRegister):
    phone: constr(min_length=10, max_length=10)
    place: PlaceRegister

class GuideRegister(OwnerRegister):
    national_id: int
    gender: str
    age: int
    personal_image: str  

@app.post("/register/user/")
def register_user(user: UserRegister):
    db = get_db()
    cr = db.cursor()
    try:
        cr.execute("INSERT INTO users (Fname, Lname, email, password) VALUES (?, ?, ?, ?)",
                   (user.Fname, user.Lname, user.email, generate_password_hash(user.password)))
        db.commit()
        return {"message": "User registered successfully"}
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=400, detail="Email already exists")
    finally:
        db.close()

@app.post("/register/owner/")
async def register_owner(owner: OwnerRegister, images: List[UploadFile] = File(...)): # = File(...) => images file will be in body
    db = get_db()
    cr = db.cursor()

    
    if len(images) < 5:
        raise HTTPException(status_code=400, detail="You must upload at least 5 images")

    try:
       
        cr.execute("INSERT INTO owners (Fname, Lname, email, phone, password) VALUES (?, ?, ?, ?, ?)",
                   (owner.Fname, owner.Lname, owner.email, owner.phone, generate_password_hash(owner.password)))
        owner_id = cr.lastrowid
        
        cr.execute("INSERT INTO places (name, city, type, description) VALUES (?, ?, ?, ?)",
                   (owner.place.name, owner.place.city, owner.place.type, owner.place.description))
        #images table
        place_id = cr.lastrowid 
        if not os.path.exists('uploads'):
         os.makedirs('uploads')

        for image in images:
            image_path = f"uploads/{image.filename}"
            with open(image_path, "wb") as f:
                f.write(await image.read())  

            
            cr.execute("INSERT INTO images (place_id, image_path) VALUES (?, ?)", (place_id, image_path))

        db.commit()
        return {"message": "Owner and place registered successfully", "owner_id": owner_id, "place_id": place_id}
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=400, detail="Email or Phone already exists")
    finally:
        db.close()

@app.post("/register/guide/")
async def register_guide(guide: GuideRegister, image: UploadFile = File(...)):
    db = get_db()
    cr = db.cursor()
    
    if not os.path.exists("uploads/guides"):
        os.makedirs("uploads/guides")

    image_path = f"uploads/guides/{image.filename}"

    with open(image_path, "wb") as f:
        f.write(await image.read())  

    try:
        cr.execute("""
            INSERT INTO guides (Fname, Lname, email, phone, national_id, personal_image, password, gender, age, image_path)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (guide.Fname, guide.Lname, guide.email, guide.phone, guide.national_id,
              guide.personal_image, generate_password_hash(guide.password), guide.gender, guide.age, image_path))
        db.commit()
        return {"message": "Guide registered successfully"}
    except sqlite3.IntegrityError:
        raise HTTPException(status_code=400, detail="Email or Phone already exists")
    finally:
        db.close()
        db.close()
