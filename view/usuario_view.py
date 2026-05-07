from flask import render_template, request, redirect, url_for

class UsuarioView:

    def mostrar_home(self, usuarios):
        return render_template("index.html", usuarios=usuarios)

    def mostrar_formulario(self):
        return render_template("criar.html")

    def obter_dados_usuario(self):
        nome = request.form.get("nome")
        email = request.form.get("email")
        return nome, email

    def redirecionar_home(self):
        return redirect(url_for("home"))