*** Settings ***
Documentation
Library    RequestsLibrary
Library    String
Library    Collections
Library    OperatingSystem
Library    XML



*** Variables ***
${TOKEN}    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTMzMDk5YWZhNzBkNTMwNzVjODFlZjQiLCJmdWxsTmFtZSI6IlFhLUNvZGVycy1TWVNBRE1JTiIsIm1haWwiOiJzeXNhZG1pbkBxYWNvZGVycy5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRBVEd0US5ZMVB4a1VxNHJDS00zS2x1djl4TVJIUHU4Mkg4Ylo3ZFNFSVNxTHVQSlIuTEFuNiIsImFjY2Vzc1Byb2ZpbGUiOiJTWVNBRE1JTiIsImNwZiI6IjExMTExMTExMTExIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjExMTExMTExMTExMTExMTExMSIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoic2V4dGEtZmVpcmEsIDIwLzEwLzIwMjMsIDIwOjEzOjI5IEJSVCIsInJlZ2lzdHJhdGlvbk51bWJlciI6IjAxIiwiY29tcGFueUlkIjoiUWEuQ29kZXJzIiwiX2lkIjoiNjUzMzA5OWFmYTcwZDUzMDc1YzgxZWY1In1dLCJfX3YiOjAsImlhdCI6MTcxNTM1NTE5MSwiZXhwIjoxNzE1NDQxNTkxfQ.2rhztXX9aOixlwguvEsgCMFnIA5hicYKcivPzDO2apo



*** Keywords ***
Criar sessão
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json     Authorization=${TOKEN} 
    Create Session    alias=APISwagger    url=https://qualitys-hunters.qacoders-academy.com.br      headers=${headers}
   
Entrar com usuario sysadmin
    ${body}    Create Dictionary    mail=sysadmin@qacoders.com    password=1234@Test
    Log    ${body}
    Criar sessão
    ${resposta}    POST On Session    alias=APISwagger    url=/api/login    json=${body}
    Log    ${resposta.json()}
    Set Test Variable    ${TOKEN}    ${resposta.json()["token"]}


Validar o token e gravar no header de autorização
    ${headers}    Create Dictionary    Authorization=Bearer ${TOKEN}
    ${resposta}    GET On Session    alias=APISwagger    url=/api/validateToken    headers=${headers}
    Log    Resposta da solicitação: ${resposta.content}
    Log    ${TOKEN}



Criar login de usuario    
    ${palavra_randomica_1}      Generate Random String      length=8    chars=[LETTERS]
    ${palavra_randomica_cpf}    generate random string      length=11    chars=[NUMBERS]
    ${palavra_randomica_1}      Convert To Lower Case       ${palavra_randomica_1}
    ${palavra_randomica_cpf}    convert to lower case       ${palavra_randomica_cpf}
   
    set test variable           ${FULLNAME}                 ${palavra_randomica_1}
    Set Test Variable           ${EMAIL_TEST}               ${palavra_randomica_1}@qacoders.com.br        
    Log                         ${EMAIL_TEST}     
    set test variable           ${CPF}                      ${palavra_randomica_cpf}
    log                         ${CPF}
       
   
Cadastrar usuario
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    fullName=${FULLNAME}     mail=${EMAIL_TEST}    password=1234@Test      accessProfile=ADMIN     cpf=${CPF}     confirmPassword=1234@Test    
    Log    ${body}
    Criar sessão
    ${resposta}        post on session       alias=APISwagger        url=/api/user   json=${body}        
    Log    ${resposta.json()}
    Set Suite Variable    ${ID_USUARIO}     ${resposta.json()["user"]["_id"]}
    Set Test Variable     ${RESPOSTA}       ${resposta.json()}


Conferir se este usuario foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg    Olá ${FULLNAME}, cadastro realizado com sucesso.
    Dictionary Should Contain Key     ${RESPOSTA}    user    _id



Criar Massa de dados para diretoria   
    ${palavra_randomica}    Generate Random String    length=8    chars=[LETTERS]
    ${palavra_randomica}    Convert To Lower Case     ${palavra_randomica}
    Set Test Variable                 ${BOARD_NAME}             ${palavra_randomica}        
    Log                               ${BOARD_NAME}


Criar diretoria
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    boardName=${BOARD_NAME}     
    Log    ${body}
    Criar sessão
    ${resposta}    POST On Session   alias=APISwagger    url=/api/board   json=${body}               
    Log    ${resposta.json()}
    Set Test Variable     ${BOARD_NAME}        ${resposta.json()['newBoard']['_id']}
    Set Test Variable     ${RESPOSTA}        ${resposta.json()}
   


Conferir se diretoria foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg        Cadastro realizado com sucesso!
    Dictionary Should Contain Key     ${RESPOSTA}    newBoard   _id    


Consultar os dados da Diretoria
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_consulta}    GET On Session        alias=APISwagger    url=/api/board/${BOARD_NAME}    expected_status=200    headers=${headers}
    Set Test Variable        ${RESPOSTA_CONSULTA}                        ${resposta_consulta.json()}


Conferir os dados retornados da Diretoria
    Log    ${RESPOSTA}
    Should Be Equal As Strings    ${resposta['newBoard']['_id']}    ${BOARD_NAME}


Alterar status da Diretoria
    ${alterar_status_diretoria}     PUT On Session        alias=APISwagger        url=/api/board/660b1e40cebf1f9a4d5cf89f       expected_status=200        data={"_id":"660b1e40cebf1f9a4d5cf89f", "boardName":"tesourariA", "status":"false"}
   

Listar diretoria
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${resposta_consulta}    GET On Session        alias=APISwagger    url=/api/board/    expected_status=200    headers=${headers}
    Set Test Variable        ${RESPOSTA_CONSULTA}                        ${resposta_consulta.json()}


Contagem de cadastro
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${count_Lista}    GET On Session     alias=APISwagger    url=/api/board/count
       
    














