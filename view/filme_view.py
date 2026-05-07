from flask import render_template, request, redirect, url_for

class FilmeView:

    def mostrar_home(self, filmes):
        return render_template("index.html", filmes=filmes)

    def mostrar_formulario(self):
        return render_template("criarFilme.html")

    def obter_dados_filme(self):
        nome = request.form.get("nome")
        duracao = request.form.get("duracao")
        classificacao = request.form.get("classificacao")
        return nome, duracao, classificacao

    def redirecionar_home(self):
        return redirect(url_for("home"))