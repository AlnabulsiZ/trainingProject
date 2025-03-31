from fastapi import FastAPI, Query, Depends
from helper import get_db
import sqlite3

app = FastAPI()

@app.get("/search/")
def search(
    name: str = Query(None, title="Place Name", description="Search by place name"),
    type: str = Query(None, title="Place Type", description="Search by place type"),
    guide: str = Query(None, title="Guide Name", description="Search by guide first or last name"),
    db: sqlite3.Connection = Depends(get_db)
):
    params = []
    typeOfSearch = ""
    query = ""

    name = name.strip() if name else None
    type = type.strip() if type else None
    guide = guide.strip() if guide else None

    if (name or type) and guide is None:
        query = "SELECT name, type FROM places WHERE 1=1"
        
        if name:
            query += " AND name LIKE ?"
            params.append(f"%{name}%")

        if type:
            query += " AND type LIKE ?"
            params.append(f"%{type}%")

        typeOfSearch = "places"

    elif guide:
        query = "SELECT Fname, Lname FROM guides WHERE 1=1"
        query += " AND (Fname LIKE ? OR Lname LIKE ?)"
        params.append(f"%{guide}%")
        params.append(f"%{guide}%")

        typeOfSearch = "guides"

    else:
        return {"error": "Invalid search parameters. Please provide at least one valid search criterion."}

    try:
        cr = db.cursor()
        cr.execute(query, params)
        results = cr.fetchall()
        return {typeOfSearch: [{"Fname": row[0], "Lname": row[1]} if typeOfSearch == "guides" else {"name": row[0], "type": row[1]} for row in results]}

    except sqlite3.Error as e:
        return {"error": f"Database error: {str(e)}"}

@app.get("/top_places/home/")
def get_top_10_places(db: sqlite3.Connection = Depends(get_db)):
    query = """
        SELECT places.name, places.rate, places.city, 
               (SELECT image_path FROM images WHERE images.place_id = places.id LIMIT 1) AS image_path
        FROM places
        ORDER BY places.rate DESC
        LIMIT 10
    """
    try:
        cr = db.cursor()
        cr.execute(query)
        results = cr.fetchall()
        return {"top_places": [{"name": row[0], "rate": row[1], "city": row[2], "image_path": row[3] or "default_image.jpg"} for row in results]}
    
    except Exception as e:
        return {"error": str(e)}

@app.get("/top_guides/home/")
def get_top_10_guides(db: sqlite3.Connection = Depends(get_db)):
    query = "SELECT Fname, personal_image FROM guides ORDER BY rate DESC LIMIT 10"
    try:
        cr = db.cursor()
        cr.execute(query)
        results = cr.fetchall()
        return {"top_guides": [{"Fname": row[0], "personal_image": row[1]} for row in results]}
    
    except Exception as e:
        return {"error": str(e)}
