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
