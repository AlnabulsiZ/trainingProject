import sqlite3

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
        CREATE TABLE IF NOT EXISTS favorites(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            user_id INTEGER NOT NULL,
            place_id INTEGER NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
            FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE,
            UNIQUE(user_id, place_id)
        );
    ''')
    db.commit()
    db.close()

    
if __name__ == "__main__":
    create_tables()
