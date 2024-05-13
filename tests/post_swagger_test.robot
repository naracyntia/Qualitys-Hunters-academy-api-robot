*** Settings ***
Resource    ../resources/swagger_testes_recursos.resource.
Resource    ../resources/swagger_testes_recursos.resource





*** Test Cases ***
Cenário com POST: Cadastrar novo usuario
    Criar sessão
    Entrar com usuario sysadmin
    Validar o token e gravar no header de autorização
    Criar login de usuario
    Cadastrar usuario
    Conferir se este usuario foi cadastrado corretamente
    


Cenário com POST: Cadastrar nova Diretoria
    Criar sessão
    Criar Massa de dados para diretoria   
    Criar diretoria   
    Conferir se diretoria foi cadastrado corretamente
   








