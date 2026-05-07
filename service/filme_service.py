from model.filme import Filme
from repository.filme_repository import FilmeRepository

class FilmeService:

    def __init__(self):
        self.repository = FilmeRepository()

    def criar_filme(self, nome, duracao, classificacao):
        if ":" not in duracao:
            raise ValueError("duração inválido")
        filme = Filme(nome, duracao, classificacao)
        self.repository.salvarFilme(filme)

    def listar_filmes(self):
        return self.repository.listarFilme()