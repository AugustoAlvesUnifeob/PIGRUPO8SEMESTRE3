class Usuario:
    def __init__(self, nome: str, email: str, id: int = None):
        self.id = id
        self.nome = nome
        self.email = email