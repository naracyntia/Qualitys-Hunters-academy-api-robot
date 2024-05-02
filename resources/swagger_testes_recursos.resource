*** Settings ***
Documentation
Library    RequestsLibrary
Library    String
Library    Collections
Library    OperatingSystem
Library    XML
Library    Faker


*** Variables ***
${TOKEN}    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NTMzMDk5YWZhNzBkNTMwNzVjODFlZjQiLCJmdWxsTmFtZSI6IlFhLUNvZGVycy1TWVNBRE1JTiIsIm1haWwiOiJzeXNhZG1pbkBxYWNvZGVycy5jb20iLCJwYXNzd29yZCI6IiQyYiQxMCRBVEd0US5ZMVB4a1VxNHJDS00zS2x1djl4TVJIUHU4Mkg4Ylo3ZFNFSVNxTHVQSlIuTEFuNiIsImFjY2Vzc1Byb2ZpbGUiOiJTWVNBRE1JTiIsImNwZiI6IjExMTExMTExMTExIiwic3RhdHVzIjp0cnVlLCJhdWRpdCI6W3sicmVnaXN0ZXJlZEJ5Ijp7InVzZXJJZCI6IjExMTExMTExMTExMTExMTExMSIsInVzZXJMb2dpbiI6InN5c2FkbWluQHFhY29kZXJzLmNvbSJ9LCJyZWdpc3RyYXRpb25EYXRlIjoic2V4dGEtZmVpcmEsIDIwLzEwLzIwMjMsIDIwOjEzOjI5IEJSVCIsInJlZ2lzdHJhdGlvbk51bWJlciI6IjAxIiwiY29tcGFueUlkIjoiUWEuQ29kZXJzIiwiX2lkIjoiNjUzMzA5OWFmYTcwZDUzMDc1YzgxZWY1In1dLCJfX3YiOjAsImlhdCI6MTcxMjI1MjY3NiwiZXhwIjoxNzEyMzM5MDc2fQ.s80hLFQ-InuCDIjnv2odxuDIq9t03A3bZ33SWMnL2m0



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
    ${palavra_randomica_1}    Generate Random String    length=8    chars=[LETTERS]
    ${palavra_randomica_1}    Convert To Lower Case     ${palavra_randomica_1}
    Set Test Variable      ${EMAIL_TEST}              ${palavra_randomica_1}@qacoders.com.br        
    Log                    ${EMAIL_TEST} 
       
   
Cadastrar usuario
    ${body}    Create Dictionary    fullName=naRa MArquez     mail=${EMAIL_TEST}    password=1234@Test      accessProfile=ADMIN    cpf=23415477919    confirmPassword=1234@Test    
    Log    ${body}
    Criar sessão
    ${resposta}    POST On Session   alias=APISwagger    url=/api/user   json=${body}        
    Log    ${resposta.json()}
    Set Suite Variable    ${ID_USUARIO}     ${resposta.json()["user"]["_id"]}
    Set Test Variable     ${RESPOSTA}       ${resposta.json()}


Conferir se este usuario foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg    Olá naRa MArquez, cadastro realizado com sucesso.
    Dictionary Should Contain Key     ${RESPOSTA}    user    _id



Criar Massa de dados para diretoria   
    ${palavra_randomica}    Generate Random String    length=8    chars=[LETTERS]
    ${palavra_randomica}    Convert To Lower Case     ${palavra_randomica}
    Set Test Variable                 ${BOARD_NAME}             ${palavra_randomica}        
    Log                               ${BOARD_NAME}


Criar diretoria
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}    Create Dictionary    boardName=     
    Log    ${body}
    Criar sessão
    ${resposta}    POST On Session   alias=APISwagger    url=/api/board   json=${body}               
    Log    ${resposta.json()}
    Set Test Variable     ${BOARD_NAME}        ${resposta.json()['newBoard']['_id']}
    Set Test Variable     ${RESPOSTA}        ${resposta.json()}
    ${resposta}           ${resposta['expected_status']['400']}


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
       
    






















Criar Centro de Custo
    ${headers}    Create Dictionary    accept=application/json    Authorization=${TOKEN}
    ${body}       Create Dictionary    costCentername=aDminiStrAcAo       boardId=74e51673d94be9062773f6dc           
    Log    ${body}
    Criar sessão
    ${resposta}    POST On Session   alias=APISwagger    url=/api/costCenter/   json=${body}            
    Log    ${resposta.json()}
    Set Test Variable    ${ID_BOARD}        ${resposta.json()['newCostCenter']['_id']}
    Set Test Variable     ${RESPOSTA}        ${resposta.json()}



Conferir se o centro de custo foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg    erro
    Dictionary Should Contain Key     ${RESPOSTA}    newCostCenter    _id    


















Cadastrar o novo departamento criado
    ${headers}    Create Dictionary    Authorization=${TOKEN}
    ${body}        Create Dictionary    departmentName=Novo Departamento       costCenterId=64e51573d94be9062773f6da     
    Log    ${body}
    Criar sessão
    ${resposta}    POST On Session    alias=APISwagger    url=api/department    json=${body}        
    Log    ${resposta.json()}
    Set Test Variable    ${ID_USUARIO}    ${resposta.json()['newDepartment']['_id']}
    Set Test Variable    ${RESPOSTA}         ${resposta.json()}

Conferir se novo departamento foi cadastrado corretamente
    Log    ${RESPOSTA}
    Dictionary Should Contain Item    ${RESPOSTA}    msg    Cadastro realizado com sucesso!
    Dictionary Should Contain Key     ${RESPOSTA}    newBoard    _id     










Gerar Números Inteiros Aleatórios
    Criar sessão
    ${numero_randomica}    Generate Random String    length=11    chars=[NUMBER]
    Log    Número Inteiro Gerado: ${numero_randomica}
    Log    ${resposta.json()}
    Set Suite Variable     ${NUMERO_RANDOMICO}       ${resposta.json()["number"]}


