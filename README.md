# SUPPLY - Controle de Abastecimento em Flutter com Firebase

## Descrição do Projeto

O aplicativo de **Controle de Abastecimento em Flutter** foi desenvolvido para gerenciar o controle de abastecimentos de veículos de forma simples e eficiente. Ele utiliza o Firebase para autenticação de usuários e armazenamento dos dados dos veículos e abastecimentos. O app possui um menu de navegação utilizando o **Drawer**, que organiza as funcionalidades principais para o usuário.

## Funcionalidades

### **Autenticação e Gerenciamento de Usuários 🔑**
- **Cadastro e Login de Usuário**: Permite que o usuário se cadastre e faça login utilizando seu e-mail e senha através do Firebase Authentication.
- **Recuperação de Senha**: O app oferece a funcionalidade de recuperação de senha por e-mail.
- **Logout**: O usuário pode sair de sua conta a qualquer momento.

### **Menu de Navegação (Drawer) 🍔**
O menu de navegação é implementado através do **Drawer**, que organiza as funcionalidades principais. As opções incluem:
- **Home**: Tela inicial com a listagem dos veículos cadastrados.
- **Meus Veículos**: Exibe todos os veículos cadastrados pelo usuário.
- **Adicionar Veículo**: Acesso ao formulário para cadastro de novos veículos.
- **Histórico de Abastecimentos**: Exibe o histórico de abastecimentos realizados pelo usuário.
- **Perfil**: Tela com as informações básicas do usuário e opção de edição de dados.
- **Logout**: Realiza o logout do usuário.

### **Gerenciamento de Veículos 🚗**
- **Cadastro de Veículo**: O usuário pode cadastrar novos veículos informando dados como nome, modelo, ano e placa.
- **Listagem de Veículos**: Exibe todos os veículos cadastrados, com a opção de visualizar detalhes, editar ou excluir um veículo.
- **Edição e Exclusão de Veículo**: Permite ao usuário editar ou excluir um veículo, com confirmação antes da exclusão.

### **Registro e Histórico de Abastecimento ⛽**
- **Novo Abastecimento**: O usuário pode registrar um abastecimento, fornecendo dados como quantidade de litros, quilometragem atual e data do abastecimento.
- **Histórico de Abastecimentos**: Exibe todos os abastecimentos registrados, com detalhes como data, quantidade de litros e quilometragem.

### **Cálculo da Média de Consumo 🔢**
- **Média de Consumo**: A média de consumo é calculada para cada veículo com a fórmula:
  \[
  \text{Média de Consumo} = \frac{\text{Quilometragem Atual} - \text{Quilometragem Anterior}}{\text{Quantidade de Litros Abastecidos}}
  \]
- A média é exibida na tela de detalhes de cada veículo.

## Interface do Usuário

- **Tela de Login e Cadastro**: Tela inicial para login ou cadastro de usuários com campos de e-mail e senha.
- **Tela de Listagem de Veículos (Home)**: Tela principal mostrando todos os veículos cadastrados e permitindo navegação pelo Drawer.
- **Menu Drawer**: Um menu deslizante que exibe opções como Home, Meus Veículos, Adicionar Veículo, Histórico de Abastecimentos, Perfil e Logout.
- **Tela de Cadastro e Edição de Veículo**: Formulário para cadastrar e editar os dados dos veículos.
- **Tela de Histórico de Abastecimentos**: Exibe o histórico de abastecimentos, organizado por data.
- **Tela de Detalhes do Veículo**: Exibe as informações detalhadas do veículo, incluindo a média de consumo calculada.
- **Tela de Perfil**: Tela de perfil do usuário com a possibilidade de atualização de dados.

## Fluxo Básico do Usuário
1. O usuário realiza login ou se cadastra no aplicativo.
2. Após o login, ele é direcionado à tela principal, onde pode visualizar a lista de veículos.
3. O usuário pode acessar o Drawer e navegar para as telas de "Meus Veículos", "Adicionar Veículo", "Histórico de Abastecimentos", "Perfil" ou "Logout".
4. Ao registrar um novo abastecimento, a média de consumo do veículo é recalculada e exibida na tela de detalhes.

## Observações Técnicas

- **Armazenamento no Firebase**: Os dados dos veículos e abastecimentos são armazenados no **Firebase Firestore** ou **Realtime Database**, vinculados ao ID do usuário. Cada usuário tem acesso apenas aos seus próprios dados.
- **Segurança**: O acesso aos dados é restrito a cada usuário, garantindo que apenas o proprietário de um veículo possa visualizar, editar ou excluir seus dados.
- **Drawer Personalizado**: O Drawer é personalizado para exibir o nome e e-mail do usuário na parte superior, junto com ícones e títulos para cada opção de navegação.

## Estrutura do Projeto

- **Firebase**: Utilizado para autenticação de usuários (Firebase Authentication) e armazenamento de dados (Firestore ou Realtime Database).
- **Flutter**: Framework utilizado para o desenvolvimento do aplicativo.
- **Drawer**: Implementado para organizar a navegação do aplicativo.
