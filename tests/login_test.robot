*** Settings ***
Documentation    Tehtävä 2 – Kirjautumistestit terveyspäiväkirja-sovellukselle.
...              Testaa POST /api/auth/login -päätepistettä eri skenaarioilla:
...              puuttuvat kentät, väärät tunnukset ja onnistunut kirjautuminen.
Resource         resources/api_common.resource

Suite Setup      Create Backend Session

*** Test Cases ***
Login Without Any Credentials Returns 400
    [Documentation]    Kirjautuminen ilman body-tietoja palauttaa 400 Bad Request.
    ${payload}=    Create Dictionary
    ${response}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    error

Login With Missing Password Returns 400
    [Documentation]    Kirjautuminen ilman salasanaa palauttaa 400 Bad Request.
    ${payload}=    Create Dictionary    username=testuser
    ${response}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    error

Login With Missing Username Returns 400
    [Documentation]    Kirjautuminen ilman käyttäjätunnusta palauttaa 400 Bad Request.
    ${payload}=    Create Dictionary    password=salasana123
    ${response}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    error

Login With Wrong Credentials Returns 401
    [Documentation]    Väärillä tunnuksilla kirjautuminen palauttaa 401 Unauthorized.
    ${payload}=    Create Dictionary    username=kayttaja_ei_ole    password=vaara_salasana
    ${response}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    401
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    error

Successful Login Returns 200 And User Data
    [Documentation]    Luo testikäyttäjä, kirjaudu sisään oikeilla tunnuksilla,
    ...                tarkista vastaus ja siivoa luotu käyttäjä pois.
    # Luo väliaikainen testikäyttäjä
    ${timestamp}=    Get Time    epoch
    ${unique_user}=    Set Variable    logintest_${timestamp}
    ${reg_payload}=    Create Dictionary
    ...    username=${unique_user}
    ...    email=${unique_user}@test.com
    ...    password=Salasana123
    ${reg_response}=    Post Endpoint With Json    /api/users    ${reg_payload}
    Should Be Equal As Integers    ${reg_response.status_code}    201
    ${user_id}=    Set Variable    ${reg_response.json()['user_id']}

    # Kirjaudu sisään oikeilla tunnuksilla
    ${login_payload}=    Create Dictionary    username=${unique_user}    password=Salasana123
    ${login_response}=    Post Endpoint With Json    /api/auth/login    ${login_payload}
    Should Be Equal As Integers    ${login_response.status_code}    200
    Response Should Be Json    ${login_response}
    Dictionary Should Contain Key    ${login_response.json()}    message
    Dictionary Should Contain Key    ${login_response.json()}    user_id
    Dictionary Should Contain Key    ${login_response.json()}    username
    Should Be Equal    ${login_response.json()['username']}    ${unique_user}

    # Siivoa – poista testikäyttäjä
    ${del_response}=    Delete Endpoint    /api/users/${user_id}
    Should Be Equal As Integers    ${del_response.status_code}    200
