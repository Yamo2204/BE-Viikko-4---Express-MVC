# TESTAUS

Tässä dokumentissa kerron miten tein tämän projektin testauksen Robot Frameworkilla.

## Testiympäristö

- OS: Windows
- Backend: Node.js + Express
- Testityökalu: Robot Framework
- Kirjastot: RequestsLibrary, Browser (Playwright), CryptoLibrary
- API osoite: http://localhost:3000

## Miten testit ajetaan

Ensin käynnistä backend:

```bash
npm start
```

Sitten aja testit:

```bash
robot -d outputs tests
```

Raportit löytyy kansiosta [outputs/](outputs/).

---

## Tehtävä 1

Asenna omalle koneellesi seuraavat työkalut:

- Robot Framework
- Browser Library
- Requests library
- CryptoLibrary
- Robotidy

Asensin kaikki työkalut Python-virtuaaliympäristöön (`.venv`). Asennus onnistui ongelmitta. Käytin seuraavia komentoja:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install robotframework
pip install robotframework-requests
pip install robotframework-browser
rfbrowser init
pip install robotframework-crypto
pip install robotframework-tidy
```

Asennetut versiot:

| Työkalu | Versio |
|---------|--------|
| Robot Framework | 7.4.2 |
| RequestsLibrary | 0.9.7 |
| Browser Library | 19.12.7 |
| CryptoLibrary | 0.4.2 |
| Robotidy | 4.18.0 |

Kaikki asennukset onnistuivat. Testitiedosto: [tests/api_homework.robot](tests/api_homework.robot)

Testasin API:n perustoimintaa:

- `/` toimii ja palauttaa JSONin
- Väärä reitti antaa 404
- `/api/users` vastaa (sallin myös 500)
- POST-reiteissä puuttuvat kentät → 400

## Tehtävä 2

Tein kirjautumistestin omalle terveyspäiväkirja-sovellukselleni.

Testitiedosto: [tests/login_test.robot](tests/login_test.robot)

Testasin kirjautumista eri skenaarioilla:

- Tyhjä login → 400
- Ilman salasanaa → 400
- Ilman käyttäjätunnusta → 400
- Väärät tunnukset → 401
- Oikeat tunnukset → 200

Testi luo käyttäjän itse ennen testiä ja poistaa sen lopuksi.

## Tehtävä 3

Tutkin Browser Libraryn käyttöä ja tein testin web-lomakkeen kentille.(Dropdown (select), Dropdown (datalist), File input, Checkboxit, Radio buttonit, jne).

Testitiedosto: [tests/webform_test.robot](tests/webform_test.robot)

Testasin lomaketta selaimessa:

- Dropdown toimii
- Datalist hyväksyy arvot
- File upload toimii
- Checkbox toimii (voi valita ja poistaa valinnan)
- Radio button toimii oikein (vain yksi kerrallaan)

## Tehtävä 4

Tein testin uuden päiväkirjamerkinnän lisäämisestä omalle terveyspäiväkirja-sovellukselleni.

Testitiedosto: [tests/api_homework.robot](tests/api_homework.robot)

Testi luo ensin testikäyttäjän, lisää uuden päiväkirjamerkinnän (`POST /api/entries`) ja tarkistaa että vastaus on 201 ja sisältää `entry_id`. Lopuksi testi poistaa sekä merkinnän että käyttäjän automaattisesti.

## Tehtävä 5

Tein kirjautumistestin, joka lukee käyttäjätunnuksen ja salasanan `.env`-tiedostosta.

Testitiedosto: [tests/login_env_test.robot](tests/login_env_test.robot)

Käyttäjätunnus ja salasana on tallennettu `.env`-tiedostoon muuttujina `TEST_USERNAME` ja `TEST_PASSWORD`. Testi lukee ne automaattisesti tiedostosta ilman että ne näkyvät testikoodissa.

## Tehtävä 6

Tein kirjautumistestin jossa käyttäjätunnus ja salasana on kryptattu CryptoLibraryn avulla.

Testitiedosto: [tests/login_crypto_test.robot](tests/login_crypto_test.robot)

Generoin NaCl-avainparin CryptoLibraryn avulla. Käyttäjätunnus ja salasana on kryptattu ja tallennettu testiin `crypt:`-etuliitteellä. CryptoLibrary purkaa ne automaattisesti testin ajon aikana yksityisavaimella.

## Oma huomio

- API toimi ihan hyvin perus tapauksissa
- Validointi toimii kun kenttiä puuttuu
- Login-testit toimii itsenäisesti, ei tarvitse valmista dataa
- Selain testit meni nopeammin headless-tilassa
- `.env`-tiedosto piilottaa tunnukset versionhallinnasta
- CryptoLibrary suojaa tunnukset myös testitiedostoissa