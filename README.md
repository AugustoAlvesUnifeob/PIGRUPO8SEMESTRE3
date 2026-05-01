# PI-GRUPO8-SEMESTRE3
Projeto Integrado - Terceiro semestre - Modulo Desenvolvimento de Sistemas Móveis

## Equipe

- Augusto Barreto Gomes Alves RA: 2500011
- Mateus Graçadio Coelho RA: 25000217
- Pedro Henrique Breda Domingues RA: 25000578
- Felipe Grossi Pereira RA: 25000473
- João Vitor Zamai Martins RA: 25000783
- Augusto De Pauli Duarte RA: 25000087


# Sistema Mobile de Monitoramento de Produção – PackBag
## Sobre o Projeto Desenvolvido

Neste 3º semestre, o projeto evoluiu para o desenvolvimento de um sistema mobile de monitoramento de produção, com o objetivo de acompanhar em tempo real os dados gerados pelo contador de peças da máquina de corte de alças da PackBag.
O aplicativo possui uma tela inicial de login, garantindo controle de acesso ao sistema.
Após a autenticação, o usuário é direcionado para um dashboard com gráficos e métricas, onde é possível visualizar informações detalhadas sobre a produção.
O sistema permite acompanhar os dados coletados pelo contador desenvolvido nos semestres anteriores, transformando informações técnicas em análises visuais e estratégicas.

## Empresa Beneficiada

A PackBag é uma empresa especializada na fabricação de bags para diferentes finalidades.
Com a expansão do projeto, além da automação da contagem, surgiu a necessidade de:

- Monitoramento remoto
- Visualização estratégica da produção
- Acompanhamento de desempenho
- Tomada de decisão baseada em dados

## Problema

Apesar da automação da contagem no sistema físico, ainda havia limitações como:

- Falta de visualização gráfica da produção
- Ausência de análise histórica estruturada
- Dificuldade no acompanhamento remoto
- Falta de controle de acesso aos dados

Isso dificultava uma análise mais estratégica do desempenho da produção.

# 📖 História do Projeto
## 1º Semestre – Módulo de Internet das Coisas (IoT)

O projeto teve início no 1º semestre, durante o módulo de Internet das Coisas (IoT).
Nesta fase, foi desenvolvido um sistema físico de contagem automatizada, com o objetivo de auxiliar a empresa PackBag no controle da produção de alças para bags.
O sistema utilizava um sensor infravermelho E18-D80NK conectado a um ESP32 (DOIT ESP32 DevKit V1), responsável por detectar automaticamente os cortes realizados na máquina de produção. A contagem era exibida em tempo real em um display LCD 16x2.

## Componentes utilizados na primeira versão:

- LCD 16x2
- Sensor infravermelho E18-D80NK
- Potenciômetro B10K
- DOIT ESP32 DevKit V1
- Resistor 1K
- Placa de ensaio

## Resultados do 1º Semestre

- Automatização da contagem de cortes
- Redução de erros humanos
- Visualização em tempo real da produção
- Primeira etapa da automação do processo produtivo

# 2º Semestre – Modelagem e Desenvolvimento de Sistemas

No 2º semestre, o projeto evoluiu significativamente, deixando de ser apenas um contador local para se tornar um sistema integrado de monitoramento e análise de produção.
A solução passou a integrar múltiplas tecnologias:

## Firebase – Banco de Dados em Nuvem

O Firebase passou a funcionar como o banco de dados em nuvem do projeto.
Cada peça detectada pelo ESP32 é automaticamente enviada e registrada online.
Isso permite:

- Armazenamento em tempo real
- Acompanhamento remoto da produção
- Centralização das informações

A comunicação com o Firebase foi organizada utilizando Programação Orientada a Objetos, criando classes específicas para gerenciar o envio e organização dos dados, deixando o sistema mais limpo, estruturado e preparado para futuras expansões.

## Dart – Conexão e Lógica do Sistema

A linguagem Dart foi utilizada como base da lógica do sistema, funcionando como a principal conexão entre todas as ferramentas.
É o Dart que:

- Recebe as leituras do ESP32
- Organiza as informações
- Envia os dados para o Firebase
- Garante a integridade das informações

Dessa forma, o Dart se torna o núcleo do projeto, garantindo que cada corte detectado seja corretamente registrado e posteriormente analisado.

## MySQL – Modelagem de Dados

A modelagem de dados foi desenvolvida no MySQL Workbench, utilizando diagrama ER para estruturar o banco de dados.
Foram definidas tabelas como:

- LogDia
- Sensor
-LogsPHR

Essa organização permite:

-Registro estruturado de cada leitura
-Consultas eficientes
-Controle confiável da produção

A modelagem garante que o sistema não apenas conte peças, mas armazene dados de forma estratégica.

## Power BI – Análise e Visualização

Com o Power BI, os dados coletados pelo contador passaram a ser transformados em informações visuais e estratégicas.
O Power BI:

- Recebe os registros do banco
- Gera dashboards interativos
- Exibe gráficos de produção em tempo real
- Permite análise de desempenho das máquinas

Com gráficos dinâmicos e filtros interativos, a PackBag pode:

- Identificar falhas
- Analisar picos de produção
- Avaliar eficiência
- Tomar decisões mais rápidas e seguras

# 3º Semestre - Desenvolvimento de Sistemas Móveis
No Terceiro Semestre, o projeto passa de uma UI baseada no PowerBi para visualizar os dados em Tempo Real, adquirindo informações de um banco MySQL, para um App Mobile, feito com o Framework da Google: O Flutter.
Com esta ferramenta, conseguimos criar uma interface mais avançada para o nosso projeto, um aplicativo completo com login, registro, usuários de diferentes privilégios, visualiação de máquina em tempo real, sobre seu estado e progresso, e a integração de IA para a criação de resumos sobre as informações de produção.

## Firestore e firebase_auth
Tecnologias providenciadas pelo Firebase, que, respectivamente:

### Firestore: 
Substituindo o banco de dados do MySQL, o firestore armazena informações de usuários, da máquina e seus respectivos registros;

### firebase_auth
O firebase_auth é um pacote para o Flutter que implementa o recurso ´Authentication´ do Firebase, que permite o registros de usuários a partir de Email e Senha, além de outros recursos de gerenciamento de contas.
É com ele que conseguimos manter o registro de nossos usuários, e suas informações.
Com isso, conseguimos designar máquinas e equipamentos a usuários específicos, dentre outros.

## 💠 Flutter:
Flutter é um framework feito pela Google, que usa a liguagem de programação Dart como sua base, ele permite criar aplicativos para Android, IOS, Web, Windows e Linux baseados no mesmo código Dart, o que é excelente para portabilidade.
No nosso projeto, focamos em usar o Flutter para o desenvolvimento de um aplicativo Android.

### Estrutura do Aplicativo:
O app possui tela de login, registro, home, configurações e telas de visualização para as respectivas máquinas. Usando a arquitura MVVM, que permite a separação dos visuais da lógica, isso permite a reutilização do cófigo, e a fácil expansão do projeto caso necessário.
