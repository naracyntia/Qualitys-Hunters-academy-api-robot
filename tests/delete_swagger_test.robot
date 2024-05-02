*** Settings ***
Resource    ../resources/swagger_testes_recursos.resource.
Resource    ../resources/swagger_testes_recursos.resource


*** Variables ***




*** Test Cases ***
Cenário com DELETE: 
    Criar diretoria
    Conferir os dados retornados da Diretoria
    Excluir Diretoria
    Conferir se Diretoria foi excluida