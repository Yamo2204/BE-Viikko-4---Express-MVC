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

## Tehtävä 7

KAIKKI testit (Tehtävät 1–6 ja 9) ohjataan yhteiseen loki- ja raporttitiedostoon käyttämällä `-d outputs`-lippua ja ajamalla koko `tests/`-kansio kerralla.

Lisäsin `package.json`-tiedostoon `test:robot`-skriptin:

```bash
robot -d outputs tests
```

Tämä ajaa **kaikki** `.robot`-tiedostot kansiosta `tests/` ja kokoaa niiden tulokset **yhteen** raporttiin:

| Tiedosto | Sisältö |
|----------|--------|
| `outputs/report.html` | Kaikkien testien yhteinen HTML-raportti |
| `outputs/log.html` | Kaikkien testien yksityiskohtainen loki |
| `outputs/output.xml` | Koneluettava XML-tulostiedosto |

Testit sisältävät:

| Testitiedosto | Tehtävä |
|---------------|---------|
| `api_homework.robot` | Tehtävät 1 & 4 |
| `login_test.robot` | Tehtävä 2 |
| `webform_test.robot` | Tehtävä 3 |
| `login_env_test.robot` | Tehtävä 5 |
| `login_crypto_test.robot` | Tehtävä 6 |
| `backend_full_test.robot` | Tehtävä 9 |

Kaikki tulokset näkyvät samassa `report.html`- ja `log.html`-tiedostossa.

## Tehtävä 8

Muokataan projektia niin, että testien HTML-raportit ovat luettavissa GitHub Pages -sivuston kautta.

Loin repositorion juureen `index.html`-tiedoston, joka toimii GitHub Pages -sivuston etusivuna ja sisältää linkit Robot Frameworkin tuottamiin HTML-raportteihin.

**GitHub Pages -asetukset:**

1. Mene repositoriosi GitHub-sivulle → **Settings** → **Pages**
2. Valitse **Source**: `Deploy from a branch`
3. Valitse **Branch**: `main`, kansio `/` (root)
4. Tallenna → GitHub luo sivuston osoitteeseen `https://<käyttäjänimi>.github.io/<repositorion-nimi>/`

**Sivuston rakenne:**

```
index.html              ← GitHub Pages etusivu (linkit raportteihin)
outputs/
  report.html           ← Saatavilla: /outputs/report.html
  log.html              ← Saatavilla: /outputs/log.html
  output.xml
```

Raportit löytyvät GitHub Pages -sivustolta:

| Raportti | Linkki |
|----------|--------|
| Etusivu | [https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/](https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/) |
| Report | [outputs/report.html](https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/outputs/report.html) |
| Log | [outputs/log.html](https://Yamo2204.github.io/BE-Viikko-4---Express-MVC/outputs/log.html) |

## Tehtävä 9

Tein kattavat backend-testit omalle terveyspäiväkirja-sovellukselleni.

Testitiedosto: [tests/backend_full_test.robot](tests/backend_full_test.robot)

Testasin kaikkien API-reittien täydellisen CRUD-syklin:

### Käyttäjät (`/api/users`)
- `POST` uusi käyttäjä → 201 + `user_id`
- `POST` ilman `username` → 400
- `POST` ilman `email` → 400
- `POST` ilman `password` → 400
- `GET` kaikki käyttäjät → 200
- `GET` käyttäjä ID:llä → 200
- `GET` olematon ID → 404
- `PUT` päivitys → 200
- `PUT` olematon ID → 404
- `DELETE` poisto → 200
- `DELETE` olematon ID → 404

### Kirjautuminen (`/api/auth/login`)
- Oikeat tunnukset → 200
- Väärä salasana → 401
- Tyhjä body → 400
- Olematon käyttäjä → 401

### Merkinnät (`/api/entries`)
- `POST` uusi merkintä → 201 + `entry_id`
- `POST` ilman `entry_date` → 400
- `POST` ilman `user_id` → 400
- `GET` kaikki → 200
- `GET` ID:llä → 200
- `GET` olematon → 404
- `PUT` päivitys → 200
- `DELETE` poisto → 200
- `DELETE` olematon → 404

### Harjoitukset (`/api/exercises`)
- `POST` uusi harjoitus → 201 + `exercise_id`
- `POST` puuttuvat kentät → 400
- `GET` kaikki → 200
- `GET` ID:llä → 200
- `GET` olematon → 404
- `GET` käyttäjän harjoitukset → 200
- `PUT` päivitys → 200
- `DELETE` poisto → 200

### Lääkkeet (`/api/medications`)
- `POST` uusi lääke → 201 + `medication_id`
- `POST` puuttuvat kentät → 400
- `GET` kaikki → 200
- `GET` ID:llä → 200
- `GET` olematon → 404
- `GET` käyttäjän lääkkeet → 200
- `PUT` päivitys → 200
- `DELETE` poisto → 200
- `DELETE` olematon → 404

Jokainen testi luo oman testidatan ja siivoa sen testin lopuksi. Testit eivät vaadi valmista dataa tietokannassa.

Yhteensä **35 testiä** kattaa kaikki pääreitit ja virhetilanteet.

## Oma huomio

- API toimi ihan hyvin perus tapauksissa
- Validointi toimii kun kenttiä puuttuu
- Login-testit toimii itsenäisesti, ei tarvitse valmista dataa
- Selain testit meni nopeammin headless-tilassa
- `.env`-tiedosto piilottaa tunnukset versionhallinnasta
- CryptoLibrary suojaa tunnukset myös testitiedostoissa
- `-d outputs` ohjaa kaikki Robot Framework -tulostiedostot yhteen kansioon
- GitHub Pages tarjoaa helpon tavan jakaa HTML-raportit julkisesti