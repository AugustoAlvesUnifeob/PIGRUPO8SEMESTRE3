from model.usuario import Usuario
from repository.usuario_repository import UsuarioRepository

class UsuarioService:

    def __init__(self):
        self.repository = UsuarioRepository()

    def criar_usuario(self, nome, email):
        if "@" not in email:
            raise ValueError("Email inválido")
        usuario = Usuario(nome, email)
        self.repository.salvar(usuario)

    def listar_usuarios(self):
        return self.repository.listar()