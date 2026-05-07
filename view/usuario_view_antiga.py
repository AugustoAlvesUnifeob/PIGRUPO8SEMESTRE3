class UsuarioView:

    def mostrar_menu(self):
        print("1 - Criar usuário")
        print("2 - Listar usuários")
        print("0 - Sair")

    def obter_dados_usuario(self):
        nome = input("Nome: ")
        email = input("Email: ")
        return nome, email

    def mostrar_usuarios(self, usuarios):
        print("\n=== Usuários ===")
        for u in usuarios:
            print(f"{u.id} - {u.nome} ({u.email})")
        print("================")

    def mostrar_mensagem(self, mensagem):
        print(mensagem)