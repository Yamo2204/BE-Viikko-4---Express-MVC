*** Settings ***
Documentation    Tehtävä 6 – Kirjautumistesti jossa sekä käyttäjätunnus että
...              salasana on kryptattu käyttäen CryptoLibrarya (NaCl/PyNaCl).
...              Kryptatut arvot alkavat etuliitteellä "crypt:" ja puretaan
...              automaattisesti testin ajon aikana yksityisavaimella.
Resource         resources/api_common.resource
Library          CryptoLibrary
...              password=robot123
...              key_path=${CURDIR}/resources/crypto/

Suite Setup      Create Backend Session

*** Variables ***
# Kryptattu käyttäjätunnus (CryptoLibrary purkaa crypt:-arvot automaattisesti)
${ENC_USERNAME}    crypt:96JlD/EAEqoHbmG8p3TVph2YmBCZeWzSiZP8LN7CSWK5pjo4n3MjBfgBNnoj2d5hsfBSDcMBPXD9AQ==
# Kryptattu salasana
${ENC_PASSWORD}    crypt:pp34kh4UY2lhDoxBA861HkiMJaeKdPuUV0h+aY4fTBygJbI25KrDoWb0Z2Opmh0RRvI6JO1ExyI+hmE7Z8o=
# Nämä muuttujat täytetään testin alussa puretuilla arvoilla
${PLAIN_USERNAME}    ${EMPTY}
${PLAIN_PASSWORD}    ${EMPTY}
${CRYPTO_USER_ID}    ${EMPTY}

*** Test Cases ***
Login With Encrypted Credentials Returns 200
    [Documentation]    Purkaa kryptatut tunnukset, luo testikäyttäjän,
    ...                kirjautuu sisään ja varmistaa onnistumisen. Siivoa lopuksi.
    [Setup]    Prepare Crypto Test User
    ${payload}=    Create Dictionary
    ...    username=${PLAIN_USERNAME}
    ...    password=${PLAIN_PASSWORD}
    ${response}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    user_id
    Dictionary Should Contain Key    ${response.json()}    username
    Should Be Equal    ${response.json()['username']}    ${PLAIN_USERNAME}
    [Teardown]    Delete Crypto Test User

*** Keywords ***
Prepare Crypto Test User
    [Documentation]    Purkaa kryptatut muuttujat ja luo testikäyttäjän.
    ${plain_user}=    Get Decrypted Text    ${ENC_USERNAME}
    ${plain_pass}=    Get Decrypted Text    ${ENC_PASSWORD}
    Set Suite Variable    ${PLAIN_USERNAME}    ${plain_user}
    Set Suite Variable    ${PLAIN_PASSWORD}    ${plain_pass}
    ${payload}=    Create Dictionary
    ...    username=${plain_user}
    ...    email=${plain_user}@cryptotest.com
    ...    password=${plain_pass}
    ${response}=    Post Endpoint With Json    /api/users    ${payload}
    Should Be Equal As Integers    ${response.status_code}    201
    Set Suite Variable    ${CRYPTO_USER_ID}    ${response.json()['user_id']}

Delete Crypto Test User
    [Documentation]    Poistaa testikäyttäjän testin jälkeen.
    ${response}=    Delete Endpoint    /api/users/${CRYPTO_USER_ID}
    Should Be Equal As Integers    ${response.status_code}    200
