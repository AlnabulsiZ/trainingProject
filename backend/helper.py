import sqlite3

def get_db():
    db = sqlite3.connect("Tasheh.db")
    db.row_factory = sqlite3.Row #(convert row to dictionary)
    return db
