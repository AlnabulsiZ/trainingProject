from helper import get_db

get_db()
def create_tables():
    db = get_db()
    cr = db.cursor()
    cr.executescript('''
        CREATE TABLE IF NOT EXISTS users(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            Fname TEXT NOT NULL,
            Lname TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL,
            phone TEXT UNIQUE,
            password TEXT NOT NULL,
            role TEXT NOT NULL CHECK(role IN ('user', 'owner', 'guide')),
            reset_code TEXT DEFAULT NULL,
            national_id TEXT UNIQUE,  -- guides
            personal_image TEXT,  -- guides
            gender TEXT CHECK(gender IN ('male', 'female')),  -- guides
            age INTEGER CHECK(age > 0),  -- guides
            rate REAL DEFAULT 0.0 CHECK(rate >= 0.0 AND rate <= 5.0), -- guide
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        );

        CREATE TABLE IF NOT EXISTS places(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            city TEXT NOT NULL,
            type TEXT NOT NULL,
            description TEXT,
            rate REAL DEFAULT NULL CHECK(rate >= 0.0 AND rate <= 5.0), -- for guides
            owner_id INTEGER NOT NULL,
            FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE
        );

        CREATE TABLE IF NOT EXISTS images(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            place_id INTEGER NOT NULL,
            image_path TEXT NOT NULL UNIQUE,
            is_main BOOLEAN DEFAULT FALSE,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (place_id) REFERENCES places(id) ON DELETE CASCADE
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
