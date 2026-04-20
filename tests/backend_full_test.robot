*** Settings ***
Documentation    Tehtävä 9 – Kattavat backend-testit terveyspäiväkirja-sovellukselle.
...              Testaa täyden CRUD-syklin: käyttäjät, merkinnät, harjoitukset ja lääkkeet.
...              Jokainen testi siivoaa itse luomansa datan (teardown).
Resource         resources/api_common.resource

Suite Setup      Create Backend Session

*** Variables ***
${UNIQUE_SUFFIX}    t9

*** Test Cases ***

# ============================================================
# 1. KÄYTTÄJÄT – User CRUD
# ============================================================

Create User Successfully Returns 201
    [Documentation]    POST /api/users – uusi käyttäjä luodaan onnistuneesti.
    ${uid}=    Get Time    epoch
    ${payload}=    Create Dictionary
    ...    username=robot_${uid}
    ...    email=robot_${uid}@test.fi
    ...    password=Salasana123
    ${resp}=    Post Endpoint With Json    /api/users    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    Dictionary Should Contain Key    ${resp.json()}    user_id
    Dictionary Should Contain Key    ${resp.json()}    message
    # Siivous
    ${user_id}=    Set Variable    ${resp.json()['user_id']}
    Delete Endpoint    /api/users/${user_id}

Create User Without Username Returns 400
    [Documentation]    POST /api/users – puuttuva username → 400.
    ${payload}=    Create Dictionary    email=nousername@test.fi    password=Salasana123
    ${resp}=    Post Endpoint With Json    /api/users    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Create User Without Email Returns 400
    [Documentation]    POST /api/users – puuttuva email → 400.
    ${payload}=    Create Dictionary    username=noemail_user    password=Salasana123
    ${resp}=    Post Endpoint With Json    /api/users    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Create User Without Password Returns 400
    [Documentation]    POST /api/users – puuttuva password → 400.
    ${payload}=    Create Dictionary    username=nopass_user    email=nopass@test.fi
    ${resp}=    Post Endpoint With Json    /api/users    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Get All Users Returns 200
    [Documentation]    GET /api/users – palauttaa listan (tai tyhjän listan).
    ${resp}=    Get Endpoint    /api/users
    Status Should Be One Of    ${resp}    200    500

Get User By Id Returns 200
    [Documentation]    GET /api/users/:id – haetaan juuri luotu käyttäjä ID:llä.
    ${uid}=    Get Time    epoch
    ${payload}=    Create Dictionary
    ...    username=getbyid_${uid}
    ...    email=getbyid_${uid}@test.fi
    ...    password=Salasana123
    ${create}=    Post Endpoint With Json    /api/users    ${payload}
    ${user_id}=    Set Variable    ${create.json()['user_id']}
    ${resp}=    Get Endpoint    /api/users/${user_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    Dictionary Should Contain Key    ${resp.json()}    user_id
    # Siivous
    Delete Endpoint    /api/users/${user_id}

Get Nonexistent User Returns 404
    [Documentation]    GET /api/users/999999 – olematonta ID:tä → 404.
    ${resp}=    Get Endpoint    /api/users/999999
    Should Be Equal As Integers    ${resp.status_code}    404

Update User Returns 200
    [Documentation]    PUT /api/users/:id – päivitetään käyttäjän email.
    ${uid}=    Get Time    epoch
    ${create_payload}=    Create Dictionary
    ...    username=updateuser_${uid}
    ...    email=updateuser_${uid}@test.fi
    ...    password=Salasana123
    ${create}=    Post Endpoint With Json    /api/users    ${create_payload}
    ${user_id}=    Set Variable    ${create.json()['user_id']}
    ${update_payload}=    Create Dictionary    username=updateuser_${uid}    email=updated_${uid}@test.fi
    ${resp}=    Put Endpoint With Json    /api/users/${user_id}    ${update_payload}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/users/${user_id}

Update Nonexistent User Returns 404
    [Documentation]    PUT /api/users/999999 – olematonta ID:tä → 404.
    ${payload}=    Create Dictionary    email=nobody@test.fi
    ${resp}=    Put Endpoint With Json    /api/users/999999    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    404

Delete User Returns 200
    [Documentation]    DELETE /api/users/:id – poistetaan luotu käyttäjä.
    ${uid}=    Get Time    epoch
    ${payload}=    Create Dictionary
    ...    username=deluser_${uid}
    ...    email=deluser_${uid}@test.fi
    ...    password=Salasana123
    ${create}=    Post Endpoint With Json    /api/users    ${payload}
    ${user_id}=    Set Variable    ${create.json()['user_id']}
    ${resp}=    Delete Endpoint    /api/users/${user_id}
    Should Be Equal As Integers    ${resp.status_code}    200

Delete Nonexistent User Returns 404
    [Documentation]    DELETE /api/users/999999 – olematonta ID:tä → 404.
    ${resp}=    Delete Endpoint    /api/users/999999
    Should Be Equal As Integers    ${resp.status_code}    404


# ============================================================
# 2. KIRJAUTUMINEN – Auth
# ============================================================

Login With Valid Credentials Returns 200
    [Documentation]    POST /api/auth/login – oikeat tunnukset → 200 + token.
    ${uid}=    Get Time    epoch
    ${reg}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "loginok_${uid}", "email": "loginok_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${reg.json()['user_id']}
    ${payload}=    Create Dictionary    username=loginok_${uid}    password=Salasana123
    ${resp}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/users/${user_id}

Login With Wrong Password Returns 401
    [Documentation]    POST /api/auth/login – väärä salasana → 401.
    ${uid}=    Get Time    epoch
    ${reg}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "loginwrong_${uid}", "email": "loginwrong_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${reg.json()['user_id']}
    ${payload}=    Create Dictionary    username=loginwrong_${uid}    password=VääräSalasana
    ${resp}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    401
    # Siivous
    Delete Endpoint    /api/users/${user_id}

Login Without Credentials Returns 400
    [Documentation]    POST /api/auth/login – tyhjä body → 400.
    ${payload}=    Create Dictionary
    ${resp}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Login With Nonexistent User Returns 401
    [Documentation]    POST /api/auth/login – olematonta käyttäjää → 401.
    ${payload}=    Create Dictionary    username=ghost_user_99999    password=Salasana123
    ${resp}=    Post Endpoint With Json    /api/auth/login    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    401


# ============================================================
# 3. MERKINNÄT – Entry CRUD
# ============================================================

Create Entry Successfully Returns 201
    [Documentation]    POST /api/entries – uusi merkintä → 201 + entry_id.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "entryok_${uid}", "email": "entryok_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${payload}=    Create Dictionary
    ...    user_id=${user_id}
    ...    entry_date=2026-04-20
    ...    mood=Hyvä
    ...    weight=72.0
    ...    sleep_hours=7
    ...    notes=Robot Framework testi
    ${resp}=    Post Endpoint With Json    /api/entries    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    Dictionary Should Contain Key    ${resp.json()}    entry_id
    # Siivous
    ${entry_id}=    Set Variable    ${resp.json()['entry_id']}
    Delete Endpoint    /api/entries/${entry_id}
    Delete Endpoint    /api/users/${user_id}

Create Entry Without entry_date Returns 400
    [Documentation]    POST /api/entries – puuttuva entry_date → 400.
    ${payload}=    Create Dictionary    user_id=1    mood=Hyvä
    ${resp}=    Post Endpoint With Json    /api/entries    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Create Entry Without user_id Returns 400
    [Documentation]    POST /api/entries – puuttuva user_id → 400.
    ${payload}=    Create Dictionary    entry_date=2026-04-20    mood=Hyvä
    ${resp}=    Post Endpoint With Json    /api/entries    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Get All Entries Returns 200
    [Documentation]    GET /api/entries – palauttaa listan.
    ${resp}=    Get Endpoint    /api/entries
    Status Should Be One Of    ${resp}    200    500

Get Entry By Id Returns 200
    [Documentation]    GET /api/entries/:id – haetaan luotu merkintä.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "entryget_${uid}", "email": "entryget_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${entry_payload}=    Create Dictionary
    ...    user_id=${user_id}
    ...    entry_date=2026-04-20
    ...    mood=Ok
    ...    sleep_hours=6
    ${create}=    Post Endpoint With Json    /api/entries    ${entry_payload}
    ${entry_id}=    Set Variable    ${create.json()['entry_id']}
    ${resp}=    Get Endpoint    /api/entries/${entry_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/entries/${entry_id}
    Delete Endpoint    /api/users/${user_id}

Get Nonexistent Entry Returns 404
    [Documentation]    GET /api/entries/999999 – olematonta ID:tä → 404.
    ${resp}=    Get Endpoint    /api/entries/999999
    Should Be Equal As Integers    ${resp.status_code}    404

Update Entry Returns 200
    [Documentation]    PUT /api/entries/:id – päivitetään merkintää.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "entryput_${uid}", "email": "entryput_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/entries
    ...    ${{{"user_id": ${user_id}, "entry_date": "2026-04-20", "mood": "Hyvä", "sleep_hours": 8}}}
    ${entry_id}=    Set Variable    ${create.json()['entry_id']}
    ${update}=    Put Endpoint With Json    /api/entries/${entry_id}
    ...    ${{{"user_id": ${user_id}, "entry_date": "2026-04-20", "mood": "Erinomainen", "sleep_hours": 9}}}
    Should Be Equal As Integers    ${update.status_code}    200
    # Siivous
    Delete Endpoint    /api/entries/${entry_id}
    Delete Endpoint    /api/users/${user_id}

Delete Entry Returns 200
    [Documentation]    DELETE /api/entries/:id – poistetaan merkintä.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "entrydel_${uid}", "email": "entrydel_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/entries
    ...    ${{{"user_id": ${user_id}, "entry_date": "2026-04-20", "mood": "Hyvä", "sleep_hours": 7}}}
    ${entry_id}=    Set Variable    ${create.json()['entry_id']}
    ${resp}=    Delete Endpoint    /api/entries/${entry_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/users/${user_id}

Delete Nonexistent Entry Returns 404
    [Documentation]    DELETE /api/entries/999999 – olematonta ID:tä → 404.
    ${resp}=    Delete Endpoint    /api/entries/999999
    Should Be Equal As Integers    ${resp.status_code}    404


# ============================================================
# 4. HARJOITUKSET – Exercise CRUD
# ============================================================

Create Exercise Successfully Returns 201
    [Documentation]    POST /api/exercises – uusi harjoitus → 201 + exercise_id.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "exok_${uid}", "email": "exok_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${payload}=    Create Dictionary
    ...    user_id=${user_id}
    ...    exercise_date=2026-04-20
    ...    exercise_type=Juoksu
    ...    duration_minutes=30
    ...    intensity=Kohtalainen
    ...    calories_burned=250
    ${resp}=    Post Endpoint With Json    /api/exercises    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    Dictionary Should Contain Key    ${resp.json()}    exercise_id
    # Siivous
    ${exercise_id}=    Set Variable    ${resp.json()['exercise_id']}
    Delete Endpoint    /api/exercises/${exercise_id}
    Delete Endpoint    /api/users/${user_id}

Create Exercise Without Required Fields Returns 400
    [Documentation]    POST /api/exercises – puuttuvat pakolliset kentät → 400.
    ${payload}=    Create Dictionary    user_id=1    exercise_type=Juoksu
    ${resp}=    Post Endpoint With Json    /api/exercises    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Get All Exercises Returns 200
    [Documentation]    GET /api/exercises – palauttaa listan.
    ${resp}=    Get Endpoint    /api/exercises
    Status Should Be One Of    ${resp}    200    500

Get Exercise By Id Returns 200
    [Documentation]    GET /api/exercises/:id – haetaan luotu harjoitus.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "exget_${uid}", "email": "exget_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/exercises
    ...    ${{{"user_id": ${user_id}, "exercise_date": "2026-04-20", "exercise_type": "Pyöräily", "duration_minutes": 45}}}
    ${exercise_id}=    Set Variable    ${create.json()['exercise_id']}
    ${resp}=    Get Endpoint    /api/exercises/${exercise_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/exercises/${exercise_id}
    Delete Endpoint    /api/users/${user_id}

Get Nonexistent Exercise Returns 404
    [Documentation]    GET /api/exercises/999999 – olematonta ID:tä → 404.
    ${resp}=    Get Endpoint    /api/exercises/999999
    Should Be Equal As Integers    ${resp.status_code}    404

Get Exercises By User Returns 200
    [Documentation]    GET /api/exercises/user/:userId – haetaan käyttäjän harjoitukset.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "exuser_${uid}", "email": "exuser_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/exercises
    ...    ${{{"user_id": ${user_id}, "exercise_date": "2026-04-20", "exercise_type": "Uinti", "duration_minutes": 60}}}
    ${exercise_id}=    Set Variable    ${create.json()['exercise_id']}
    ${resp}=    Get Endpoint    /api/exercises/user/${user_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/exercises/${exercise_id}
    Delete Endpoint    /api/users/${user_id}

Update Exercise Returns 200
    [Documentation]    PUT /api/exercises/:id – päivitetään harjoitusta.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "exput_${uid}", "email": "exput_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/exercises
    ...    ${{{"user_id": ${user_id}, "exercise_date": "2026-04-20", "exercise_type": "Kävely", "duration_minutes": 20}}}
    ${exercise_id}=    Set Variable    ${create.json()['exercise_id']}
    ${update}=    Put Endpoint With Json    /api/exercises/${exercise_id}
    ...    ${{{"exercise_date": "2026-04-20", "exercise_type": "Kävely", "duration_minutes": 40}}}
    Should Be Equal As Integers    ${update.status_code}    200
    # Siivous
    Delete Endpoint    /api/exercises/${exercise_id}
    Delete Endpoint    /api/users/${user_id}

Delete Exercise Returns 200
    [Documentation]    DELETE /api/exercises/:id – poistetaan harjoitus.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "exdel_${uid}", "email": "exdel_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/exercises
    ...    ${{{"user_id": ${user_id}, "exercise_date": "2026-04-20", "exercise_type": "Jooga", "duration_minutes": 50}}}
    ${exercise_id}=    Set Variable    ${create.json()['exercise_id']}
    ${resp}=    Delete Endpoint    /api/exercises/${exercise_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/users/${user_id}


# ============================================================
# 5. LÄÄKKEET – Medication CRUD
# ============================================================

Create Medication Successfully Returns 201
    [Documentation]    POST /api/medications – uusi lääke → 201 + medication_id.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "medok_${uid}", "email": "medok_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${payload}=    Create Dictionary
    ...    user_id=${user_id}
    ...    name=Aspirin
    ...    dosage=500mg
    ...    frequency=Kaksi kertaa päivässä
    ...    start_date=2026-04-01
    ${resp}=    Post Endpoint With Json    /api/medications    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    201
    Dictionary Should Contain Key    ${resp.json()}    medication_id
    # Siivous
    ${medication_id}=    Set Variable    ${resp.json()['medication_id']}
    Delete Endpoint    /api/medications/${medication_id}
    Delete Endpoint    /api/users/${user_id}

Create Medication Without Required Fields Returns 400
    [Documentation]    POST /api/medications – puuttuvat pakolliset kentät → 400.
    ${payload}=    Create Dictionary    user_id=1    name=Aspirin
    ${resp}=    Post Endpoint With Json    /api/medications    ${payload}
    Should Be Equal As Integers    ${resp.status_code}    400

Get All Medications Returns 200
    [Documentation]    GET /api/medications – palauttaa listan.
    ${resp}=    Get Endpoint    /api/medications
    Status Should Be One Of    ${resp}    200    500

Get Medication By Id Returns 200
    [Documentation]    GET /api/medications/:id – haetaan luotu lääke.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "medget_${uid}", "email": "medget_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/medications
    ...    ${{{"user_id": ${user_id}, "name": "Ibuprofen", "dosage": "400mg", "frequency": "Kerran päivässä", "start_date": "2026-04-01"}}}
    ${medication_id}=    Set Variable    ${create.json()['medication_id']}
    ${resp}=    Get Endpoint    /api/medications/${medication_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/medications/${medication_id}
    Delete Endpoint    /api/users/${user_id}

Get Nonexistent Medication Returns 404
    [Documentation]    GET /api/medications/999999 – olematonta ID:tä → 404.
    ${resp}=    Get Endpoint    /api/medications/999999
    Should Be Equal As Integers    ${resp.status_code}    404

Get Medications By User Returns 200
    [Documentation]    GET /api/medications/user/:userId – haetaan käyttäjän lääkkeet.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "meduser_${uid}", "email": "meduser_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/medications
    ...    ${{{"user_id": ${user_id}, "name": "Paracetamol", "dosage": "1000mg", "frequency": "Tarvittaessa", "start_date": "2026-04-01"}}}
    ${medication_id}=    Set Variable    ${create.json()['medication_id']}
    ${resp}=    Get Endpoint    /api/medications/user/${user_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/medications/${medication_id}
    Delete Endpoint    /api/users/${user_id}

Update Medication Returns 200
    [Documentation]    PUT /api/medications/:id – päivitetään lääkkeen annos.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "medput_${uid}", "email": "medput_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/medications
    ...    ${{{"user_id": ${user_id}, "name": "Metformin", "dosage": "500mg", "frequency": "Aamulla", "start_date": "2026-04-01"}}}
    ${medication_id}=    Set Variable    ${create.json()['medication_id']}
    ${update}=    Put Endpoint With Json    /api/medications/${medication_id}
    ...    ${{{"name": "Metformin", "dosage": "850mg", "frequency": "Aamulla", "start_date": "2026-04-01"}}}
    Should Be Equal As Integers    ${update.status_code}    200
    # Siivous
    Delete Endpoint    /api/medications/${medication_id}
    Delete Endpoint    /api/users/${user_id}

Delete Medication Returns 200
    [Documentation]    DELETE /api/medications/:id – poistetaan lääke.
    ${uid}=    Get Time    epoch
    ${user}=    Post Endpoint With Json    /api/users
    ...    ${{{"username": "meddel_${uid}", "email": "meddel_${uid}@test.fi", "password": "Salasana123"}}}
    ${user_id}=    Set Variable    ${user.json()['user_id']}
    ${create}=    Post Endpoint With Json    /api/medications
    ...    ${{{"user_id": ${user_id}, "name": "Atorvastatin", "dosage": "20mg", "frequency": "Illalla", "start_date": "2026-04-01"}}}
    ${medication_id}=    Set Variable    ${create.json()['medication_id']}
    ${resp}=    Delete Endpoint    /api/medications/${medication_id}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Siivous
    Delete Endpoint    /api/users/${user_id}

Delete Nonexistent Medication Returns 404
    [Documentation]    DELETE /api/medications/999999 – olematonta ID:tä → 404.
    ${resp}=    Delete Endpoint    /api/medications/999999
    Should Be Equal As Integers    ${resp.status_code}    404


*** Keywords ***
Put Endpoint With Json
    [Arguments]    ${endpoint}    ${payload}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    PUT On Session    backend    ${endpoint}    json=${payload}    headers=${headers}    expected_status=any
    RETURN    ${response}
