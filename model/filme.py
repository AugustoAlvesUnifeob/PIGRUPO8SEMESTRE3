class Filme:
    def __init__(self, nome: str, duracao: str, classificacao: str, id: int = None):
        self.id = id
        self.nome = nome
        self.duracao = duracao
        self.classificacao = classificacao