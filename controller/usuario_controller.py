from service.usuario_service import UsuarioService

class UsuarioController:

    def __init__(self, view):
        self.service = UsuarioService()
        self.view = view

    def tela_criar(self):
        return self.view.mostrar_formulario()

    def criar_usuario(self):
        nome, email = self.view.obter_dados_usuario()
        self.service.criar_usuario(nome, email)
        return self.view.redirecionar_home()