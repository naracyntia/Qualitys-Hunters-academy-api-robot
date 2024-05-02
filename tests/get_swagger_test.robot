*** Settings ***
Resource    ../resources/swagger_testes_recursos.resource.
Resource    ../resources/swagger_testes_recursos.resource


*** Variables ***




*** Test Cases ***
Cenário com GET: Consultar dados da Diretoria
    Criar sessão
    Entrar com usuario sysadmin
    Criar Massa de dados para diretoria 
    Criar diretoria
    Consultar os dados da Diretoria
    Conferir os dados retornados da Diretoria
    Listar diretoria
    Contagem de cadastro



