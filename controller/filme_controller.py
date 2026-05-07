from service.filme_service import FilmeService

class FilmeController:

    def __init__(self, view):
        self.service = FilmeService()
        self.view = view

    def tela_criar(self):
        return self.view.mostrar_formulario()

    def criar_filme(self):
        nome, duracao, classificacao = self.view.obter_dados_filme()
        self.service.criar_filme(nome, duracao, classificacao)
        return self.view.redirecionar_home()