*** Settings ***
Resource    ../resources/swagger_testes_recursos.resource.
Resource    ../resources/swagger_testes_delete_recursos.resource



*** Variables ***




*** Test Cases ***
Cenário com DELETE: 
    Criar diretoria
    Conferir se diretoria foi cadastrado corretamente
    Excluir Diretoria
    Conferir se Diretoria foi excluida