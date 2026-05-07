from service.usuario_service import UsuarioService

class UsuarioController:

    def __init__(self, view):
        self.service = UsuarioService()
        self.view = view

    def criar_usuario(self):
        nome, email = self.view.obter_dados_usuario()
        self.service.criar_usuario(nome, email)
        self.view.mostrar_mensagem("Usuário criado com sucesso!")

    def listar_usuarios(self):
        usuarios = self.service.listar_usuarios()
        self.view.mostrar_usuarios(usuarios)