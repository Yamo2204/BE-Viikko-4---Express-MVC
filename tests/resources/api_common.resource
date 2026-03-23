*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn

*** Variables ***
${BASE_URL}    http://localhost:3000

*** Keywords ***
Create Backend Session
    Create Session    backend    ${BASE_URL}

Get Endpoint
    [Arguments]    ${endpoint}
    ${response}=    GET On Session    backend    ${endpoint}    expected_status=any
    RETURN    ${response}

Post Endpoint With Json
    [Arguments]    ${endpoint}    ${payload}
    ${headers}=    Create Dictionary    Content-Type=application/json
    ${response}=    POST On Session    backend    ${endpoint}    json=${payload}    headers=${headers}    expected_status=any
    RETURN    ${response}

Response Should Be Json
    [Arguments]    ${response}
    ${content_type}=    Get From Dictionary    ${response.headers}    Content-Type
    Should Contain    ${content_type}    application/json

Status Should Be One Of
    [Arguments]    ${response}    @{allowed_statuses}
    ${actual}=    Convert To Integer    ${response.status_code}
    FOR    ${status}    IN    @{allowed_statuses}
        ${expected}=    Convert To Integer    ${status}
        IF    ${actual} == ${expected}
            RETURN
        END
    END
    Fail    ${allowed_statuses} does not contain value ${actual}.
