from db.database import get_connection
from model.filme import Filme

class FilmeRepository:

    def salvarFilme(self, filme: Filme):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute(
            "INSERT INTO filmes (nome, duracao, classificacao) VALUES (?, ?, ?)",
            (filme.nome, filme.duracao, filme.classificacao)
        )
        conn.commit()
        conn.close()

    def listarFilme(self):
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT id, nome, duracao, classificacao FROM filmes")
        rows = cursor.fetchall()
        conn.close()
        return [Filme(r[1], r[2], r[0]) for r in rows]