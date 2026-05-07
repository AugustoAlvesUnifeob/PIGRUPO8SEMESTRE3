from flask import Flask
from controller.usuario_controller import UsuarioController
from controller.filme_controller import FilmeController
from controller.home_controller import HomeController
from view.usuario_view import UsuarioView
from view.filme_view import FilmeView

app = Flask(__name__)

view = UsuarioView()
controller = UsuarioController(view)
viewfilme = FilmeView()
controllerfilme = FilmeController(viewfilme)

home_controller = HomeController()

@app.route("/")
def home():
    return home_controller.home()

@app.route("/criar")
def criar():
    return controller.tela_criar()

@app.route("/criarFilme")
def criarFilme():
    return controllerfilme.tela_criar()

@app.route("/salvar", methods=["POST"])
def salvar():
    return controller.criar_usuario()

@app.route("/salvarFilme", methods=["POST"])
def salvarFilme():
    return controllerfilme.criar_filme()

if __name__ == "__main__":
    app.run(debug=True)