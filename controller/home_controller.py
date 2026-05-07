from flask import render_template
from service.usuario_service import UsuarioService
from service.filme_service import FilmeService

class HomeController:

    def __init__(self):
        self.usuario_service = UsuarioService()
        self.filme_service = FilmeService()

    def home(self):
        usuarios = self.usuario_service.listar_usuarios()
        filmes = self.filme_service.listar_filmes()

        return render_template(
            "index.html",
            usuarios=usuarios,
            filmes=filmes
        )