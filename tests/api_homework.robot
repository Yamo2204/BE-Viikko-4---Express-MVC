*** Settings ***
Documentation    API smoke and validation tests for Express MVC health app.
Resource         resources/api_common.resource

Suite Setup      Create Backend Session

*** Test Cases ***
Root Endpoint Returns Welcome Json
    ${response}=    Get Endpoint    /
    Should Be Equal As Integers    ${response.status_code}    200
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    message
    Dictionary Should Contain Key    ${response.json()}    version

Unknown Route Returns 404 Json
    ${response}=    Get Endpoint    /does-not-exist
    Should Be Equal As Integers    ${response.status_code}    404
    Response Should Be Json    ${response}
    Dictionary Should Contain Key    ${response.json()}    error
    Dictionary Should Contain Key    ${response.json()}    path

Users Endpoint Is Reachable
    ${response}=    Get Endpoint    /api/users
    Status Should Be One Of    ${response}    200    500
    Response Should Be Json    ${response}

Create User Without Required Fields Returns 400
    ${payload}=    Create Dictionary    username=test_only
    ${response}=    Post Endpoint With Json    /api/users    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Response Should Be Json    ${response}

Create Medication Without Required Fields Returns 400
    ${payload}=    Create Dictionary    user_id=1    name=Aspirin
    ${response}=    Post Endpoint With Json    /api/medications    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Response Should Be Json    ${response}

Create Exercise Without Required Fields Returns 400
    ${payload}=    Create Dictionary    user_id=1    exercise_type=Running
    ${response}=    Post Endpoint With Json    /api/exercises    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400
    Response Should Be Json    ${response}

Create Entry Without Required Fields Returns 400
    ${payload}=    Create Dictionary    user_id=1
    ${response}=    Post Endpoint With Json    /api/entries    ${payload}
    Should Be Equal As Integers    ${response.status_code}    400

Create New Diary Entry Successfully Returns 201
    [Documentation]    Tehtävä 4 – Luo testikäyttäjä, lisää uusi päiväkirjamerkintä,
    ...                varmista 201-vastaus ja siivoa molemmat pois.
    # 1. Luo testikäyttäjä
    ${timestamp}=    Get Time    epoch
    ${unique_user}=    Set Variable    entrytest_${timestamp}
    ${reg_payload}=    Create Dictionary
    ...    username=${unique_user}
    ...    email=${unique_user}@test.com
    ...    password=Salasana123
    ${reg_response}=    Post Endpoint With Json    /api/users    ${reg_payload}
    Should Be Equal As Integers    ${reg_response.status_code}    201
    ${user_id}=    Set Variable    ${reg_response.json()['user_id']}

    # 2. Lisää uusi päiväkirjamerkintä
    ${entry_payload}=    Create Dictionary
    ...    user_id=${user_id}
    ...    entry_date=2026-04-03
    ...    mood=Hyvä
    ...    weight=75.5
    ...    sleep_hours=8
    ...    notes=Testimerkintä Robot Frameworkilla
    ${entry_response}=    Post Endpoint With Json    /api/entries    ${entry_payload}
    Should Be Equal As Integers    ${entry_response.status_code}    201
    Response Should Be Json    ${entry_response}
    Dictionary Should Contain Key    ${entry_response.json()}    message
    Dictionary Should Contain Key    ${entry_response.json()}    entry_id
    ${entry_id}=    Set Variable    ${entry_response.json()['entry_id']}

    # 3. Siivoa – poista merkintä ja käyttäjä
    ${del_entry}=    Delete Endpoint    /api/entries/${entry_id}
    Should Be Equal As Integers    ${del_entry.status_code}    200
    ${del_user}=    Delete Endpoint    /api/users/${user_id}
    Should Be Equal As Integers    ${del_user.status_code}    200
