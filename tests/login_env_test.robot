*** Settings ***
Documentation    Tehtävä 5 – Kirjautumistesti joka lukee käyttäjätunnuksen ja
...              salasanan '.env'-tiedostosta ympäristömuuttujina.
...              Tunnukset pysyvät piilossa testikoodeista.
Resource         resources/api_common.resource
Library          OperatingSystem
Library          String

Suite Setup      Run Keywords
...              Load Env Credentials    AND
...              Create Backend Session

*** Variables ***
${ENV_FILE}      ${CURDIR}/../.env
${TEST_USERNAME}    ${EMPTY}
${TEST_PASSWORD}    ${EMPTY}

*** Test Cases ***
Login With Env File Credentials Returns 200
    [Documentation]    Luo testikäyttäjä, kirjaudu sisään .env-tiedostosta
    ...                luetuilla tunnuksilla ja varmista onnistuminen.
    [Setup]    Create Env Test User
    ${payload}=    Create Dictionary    username=${TEST_USERNAME}    password=${TEST_PASSWORD}
    ${response}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    user_id
    Dictionary Should Contain Key    ${response.json()}    username
    Should Be Equal    ${response.json()['username']}    ${TEST_USERNAME}
    [Teardown]    Delete Env Test User

*** Keywords ***
Load Env Credentials
    [Documentation]    Lukee .env-tiedoston ja asettaa TEST_USERNAME ja TEST_PASSWORD
    ...                suite-muuttujiksi. Ohittaa tyhjät rivit ja kommentit (#).
    ${content}=    Get File    ${ENV_FILE}
    @{lines}=      Split To Lines    ${content}
    FOR    ${line}    IN    @{lines}
        ${line}=    Strip String    ${line}
        Continue For Loop If    '${line}' == '' or '${line}'.startswith('#')
        ${parts}=    Split String    ${line}    =    1
        ${key}=     Strip String    ${parts}[0]
        ${val}=     Strip String    ${parts}[1]
        IF    '${key}' == 'TEST_USERNAME'
            Set Suite Variable    ${TEST_USERNAME}    ${val}
        END
        IF    '${key}' == 'TEST_PASSWORD'
            Set Suite Variable    ${TEST_PASSWORD}    ${val}
        END
    END
    Should Not Be Empty    ${TEST_USERNAME}    msg=TEST_USERNAME puuttuu .env-tiedostosta
    Should Not Be Empty    ${TEST_PASSWORD}    msg=TEST_PASSWORD puuttuu .env-tiedostosta

Create Env Test User
    [Documentation]    Luo testikäyttäjä .env-tunnuksilla ennen testiä.
    ${payload}=    Create Dictionary
    ...    username=${TEST_USERNAME}
    ...    email=${TEST_USERNAME}@envtest.com
    ...    password=${TEST_PASSWORD}
    ${response}=    Post Endpoint With Json    /api/users    ${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    Set Suite Variable    ${ENV_USER_ID}    ${response.json()['user_id']}

Delete Env Test User
    [Documentation]    Poistaa testikäyttäjän testin jälkeen.
    ${response}=    Delete Endpoint    /api/users/${ENV_USER_ID}
    Should Be Equal As Integers    ${response.status_code}    200
