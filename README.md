# Express MVC - Terveyspaivakirja API

Node.js + Express + MySQL -projekti terveystietojen hallintaan.

## 1. Asennus

```bash
npm install
```

Luo `.env` tiedosto ja maarita tietokantamuuttujat:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=your_database
DB_PORT=3306
PORT=3000
```

## 2. Sovelluksen kaynnistys

```bash
npm start
```

Tai kehitystilassa:

```bash
npm run dev
```

Palvelin kaynnistyy: `http://localhost:3000`

## 3. API endpointit

### Kayttajat

```text
GET    /api/users                - Hae kaikki kayttajat
GET    /api/users/:id            - Hae kayttaja ID:n perusteella
POST   /api/users                - Luo uusi kayttaja
PUT    /api/users/:id            - Paivita kayttajan tiedot
DELETE /api/users/:id            - Poista kayttaja
```

### Paivakirjamerkinnat

```text
GET    /api/entries              - Hae kaikki merkinnat
GET    /api/entries/:id          - Hae merkinta ID:n perusteella
POST   /api/entries              - Lisaa uusi merkinta
PUT    /api/entries/:id          - Paivita merkintaa
DELETE /api/entries/:id          - Poista merkinta
```

### Laakkeet

```text
GET    /api/medications          - Hae kaikki laakkeet
GET    /api/medications/:id      - Hae laake ID:n perusteella
GET    /api/medications/user/:id - Hae kayttajan laakkeet
POST   /api/medications          - Lisaa uusi laake
PUT    /api/medications/:id      - Paivita laaketta
DELETE /api/medications/:id      - Poista laake
```

### Harjoitukset

```text
GET    /api/exercises            - Hae kaikki harjoitukset
GET    /api/exercises/:id        - Hae harjoitus ID:n perusteella
GET    /api/exercises/user/:id   - Hae kayttajan harjoitukset
POST   /api/exercises            - Lisaa uusi harjoitus
PUT    /api/exercises/:id        - Paivita harjoitusta
DELETE /api/exercises/:id        - Poista harjoitus
```

## 4. Robot Framework - tehtävä (tests + outputs)

Projektissa on Robot Framework -testit kansiossa `tests/` ja raportit kansiossa `outputs/`.

Katso tarkempi dokumentaatio: [TESTAUS.md](TESTAUS.md)

### Tehtävä 1

Asensin Robot Framework -testiympäristön Python-virtuaaliympäristöön:

```bash
python -m venv .venv
.venv\Scripts\activate
pip install robotframework robotframework-requests robotframework-browser robotframework-crypto robotframework-tidy
rfbrowser init
```

Testitiedosto: [tests/api_homework.robot](tests/api_homework.robot)

### Tehtävä 2

Tein kirjautumistestin omalle terveyspäiväkirja-sovellukselleni eri skenaarioilla (tyhjä login, väärät tunnukset, oikeat tunnukset).

Testitiedosto: [tests/login_test.robot](tests/login_test.robot)

### Tehtävä 3

Tein Browser Library -testin web-lomakkeen kentille: dropdown, datalist, file upload, checkbox ja radio button.

Testitiedosto: [tests/webform_test.robot](tests/webform_test.robot)

### Tehtävä 4

Tein testin uuden päiväkirjamerkinnän lisäämisestä (`POST /api/entries`). Testi luo testikäyttäjän, lisää merkinnän ja siivoo datan lopuksi.

Testitiedosto: [tests/api_homework.robot](tests/api_homework.robot)

### Tehtävä 5

Tein kirjautumistestin joka lukee käyttäjätunnuksen ja salasanan `.env`-tiedostosta muuttujina `TEST_USERNAME` ja `TEST_PASSWORD`.

Testitiedosto: [tests/login_env_test.robot](tests/login_env_test.robot)

### Tehtävä 6

Tein kirjautumistestin jossa käyttäjätunnus ja salasana on kryptattu CryptoLibraryn NaCl-avainparilla (`crypt:`-etuliite).

Testitiedosto: [tests/login_crypto_test.robot](tests/login_crypto_test.robot)

### Tehtävä 7

KAIKKI testit (Tehtävät 1–6 ja 9) ohjataan **yhteiseen** loki- ja raporttitiedostoon ajamalla koko `tests/`-kansio kerralla `-d outputs` -lipulla:

```bash
robot -d outputs tests
```

Tämä ajaa kaikki `.robot`-tiedostot ja kokoaa **kaikkien** testien tulokset **yhteen** raporttiin:

| Testitiedosto | Tehtävä |
|---------------|---------|
| `api_homework.robot` | Tehtävät 1 & 4 |
| `login_test.robot` | Tehtävä 2 |
| `webform_test.robot` | Tehtävä 3 |
| `login_env_test.robot` | Tehtävä 5 |
| `login_crypto_test.robot` | Tehtävä 6 |
| `backend_full_test.robot` | Tehtävä 9 |

Yhteinen tulostiedostot:

| Tiedosto | Kuvaus |
|----------|--------|
| `outputs/report.html` | Kaikkien testien yhteinen HTML-raportti |
| `outputs/log.html` | Kaikkien testien yksityiskohtainen loki |
| `outputs/output.xml` | Koneluettava XML |

### Tehtävä 8

Projektin GitHub Pages -sivusto näyttää **kaikkien testien** yhteisen raportin selaimessa.

## 🌐 [https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/](https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/)

| Raportti | Linkki |
|----------|--------|
| Etusivu | [GitHub Pages](https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/) |
| Report (kaikki testit 1–6 + 9) | [outputs/report.html](https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/outputs/report.html) |
| Log (kaikki testit 1–6 + 9) | [outputs/log.html](https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/outputs/log.html) |

## 5. Testien ajaminen

Käynnistä ensin backend:

```bash
npm start
```

Sitten aja testit:

```bash
robot -d outputs tests
```

Raportit löytyvät kansiosta `outputs/`.


