*** Settings ***
Resource    ../resources/swagger_testes_recursos.resource


*** Variables ***



*** Test Cases ***
Cenário com PUT: Editar dados da Diretoria
    Criar Massa de dados para diretoria
    Criar diretoria
    Conferir os dados retornados da Diretoria
    Consultar os dados da Diretoria
    Criar sessão
    Alterar status da Diretoria



