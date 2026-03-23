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

## 4. Robot Framework - tehtava (tests + outputs)

Projektissa on valmiiksi Robot Framework API -testit:

- `tests/api_homework.robot`
- `tests/resources/api_common.resource`

### Asenna Python testityokalut

```bash
pip install -r requirements.txt
```

`requirements.txt` sisaltaa:

- `robotframework`
- `robotframework-requests`
- `robotframework-browser`
- `robotframework-crypto`
- `robotframework-tidy`

### Suorita testit

Varmista ensin, etta Node-palvelin on kaynnissa (`npm start`).

```bash
robot -d outputs tests
```

### Muotoile Robot tiedostot (valinnainen)

```bash
robotidy tests
```

### Tulokset

Robot luo raportit kansioon `outputs/`:

- `outputs/report.html`
- `outputs/log.html`
- `outputs/output.xml`

Naita voi kayttaa tehtavan dokumentointiin (README + GitHub).

## 5. Tehtavan dokumentointi

- Testauksen raportti: `TESTAUS.md`
- Robot tulostiedostot: `outputs/report.html`, `outputs/log.html`, `outputs/output.xml`

Nopea tarkistus ennen palautusta:

1. `tests/` kansio loytyy projektista.
2. `outputs/` kansio loytyy projektista ja sisaltaa raportit testiajon jalkeen.
3. `README.md` ja `TESTAUS.md` on paivitetty.


