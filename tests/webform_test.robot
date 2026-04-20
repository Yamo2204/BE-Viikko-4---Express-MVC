*** Settings ***
Documentation    Tehtävä 3 – Browser Library web form -testit.
...              Testaa Selenium WebDriver -demolomakkeen kenttien toimintaa:
...              Dropdown (select), Dropdown (datalist), File input,
...              Checkboxit ja Radio-napit.
...              Testisivu: https://selenium.dev/selenium/web/web-form.html
Library          Browser

Suite Setup      Avaa Selain
Suite Teardown   Close Browser    ALL

Test Setup       New Page    ${FORM_URL}
Test Teardown    Close Page

*** Variables ***
${FORM_URL}    https://selenium.dev/selenium/web/web-form.html

*** Test Cases ***
Dropdown Select Kenttä Toimii
    [Documentation]    Tarkistaa, että select-pudotusvalikosta voidaan valita arvo
    ...                ja valittu arvo on oikein.
    Select Options By    select[name="my-select"]    value    1
    ${valitut}=    Get Selected Options    select[name="my-select"]    value
    Should Be Equal    ${valitut}[0]    1
    Select Options By    select[name="my-select"]    value    2
    ${valitut2}=    Get Selected Options    select[name="my-select"]    value
    Should Be Equal    ${valitut2}[0]    2

Datalist Dropdown Kenttä Hyväksyy Arvon
    [Documentation]    Tarkistaa, että datalist-kenttään voidaan kirjoittaa arvo
    ...                ja se tallennetaan oikein.
    Fill Text    input[list="my-options"]    New York
    ${arvo}=    Get Property    input[list="my-options"]    value
    Should Be Equal    ${arvo}    New York

Datalist Dropdown Hyväksyy Toisen Arvon
    [Documentation]    Tarkistaa, että datalist-kenttään voidaan kirjoittaa toinen arvo.
    Fill Text    input[list="my-options"]    San Francisco
    ${arvo}=    Get Property    input[list="my-options"]    value
    Should Be Equal    ${arvo}    San Francisco

File Input Hyväksyy Tiedoston
    [Documentation]    Tarkistaa, että file input -kenttään voidaan ladata tiedosto.
    Upload File By Selector    input[name="my-file"]    ${CURDIR}/resources/test_upload.txt
    ${arvo}=    Get Property    input[name="my-file"]    value
    Should Contain    ${arvo}    test_upload.txt

Checkbox Voidaan Valita
    [Documentation]    Tarkistaa, että checkbox voidaan valita (checked).
    Check Checkbox    id=my-check-2
    ${valittu}=    Get Property    id=my-check-2    checked
    Should Be True    ${valittu}

Checkbox Voidaan Poistaa Valinta
    [Documentation]    Tarkistaa, että valittu checkbox voidaan poistaa (unchecked).
    Check Checkbox    id=my-check-1
    Uncheck Checkbox    id=my-check-1
    ${ei_valittu}=    Get Property    id=my-check-1    checked
    Should Not Be True    ${ei_valittu}

Radio Button Voidaan Valita
    [Documentation]    Tarkistaa, että radio-nappi voidaan valita ja
    ...                sen valinta näkyy oikein.
    Check Checkbox    id=my-radio-1
    ${valittu}=    Get Property    id=my-radio-1    checked
    Should Be True    ${valittu}

Vain Yksi Radio Button Kerralla Voidaan Valita
    [Documentation]    Tarkistaa, että useammasta radio-napista vain yksi on kerralla valittu.
    Check Checkbox    id=my-radio-1
    Check Checkbox    id=my-radio-2
    ${radio1}=    Get Property    id=my-radio-1    checked
    ${radio2}=    Get Property    id=my-radio-2    checked
    Should Not Be True    ${radio1}
    Should Be True    ${radio2}

*** Keywords ***
Avaa Selain
    New Browser    browser=chromium    headless=True
