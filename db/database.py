import sqlite3

def get_connection():
    conn = sqlite3.connect("usuarios.db")
    conn.executescript("""
        CREATE TABLE IF NOT EXISTS usuarios (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            email TEXT NOT NULL
        );
                 
        CREATE TABLE IF NOT EXISTS filmes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            duracao TEXT NOT NULL,
            classificacao TEXT NOT NULL
        );
    """)
    return conn