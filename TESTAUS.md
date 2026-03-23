# TESTAUS

Tama tiedosto dokumentoi Robot Framework -testauksen tasta projektista.

## Testiymparisto

- OS: Windows
- Backend: Node.js + Express
- Testityokalu: Robot Framework
- Kirjastot: RequestsLibrary
- API base URL: `http://localhost:3000`

## Testikansiot

- Testit: `tests/api_homework.robot`
- Resurssit: `tests/resources/api_common.resource`
- Tulokset: `outputs/`

## Suoritusohje

1. Kaynnista backend:

```bash
npm start
```

2. Aja Robot-testit:

```bash
robot -d outputs tests
```

3. Avaa raportit:

- `outputs/report.html`
- `outputs/log.html`
- `outputs/output.xml`

## Testitapaukset

1. `Root Endpoint Returns Welcome Json`
- Tarkistaa etta `/` palauttaa statuskoodin 200 ja JSON-rakenteen.

2. `Unknown Route Returns 404 Json`
- Tarkistaa etta tuntematon reitti palauttaa 404 ja virhe-JSONin.

3. `Users Endpoint Is Reachable`
- Tarkistaa etta `/api/users` vastaa (200 tai 500 sallittu, jotta testi ei riipu tietokannan tilasta).

4. `Create User Without Required Fields Returns 400`
- Tarkistaa validoinnin puuttuvilla kentilla.

5. `Create Medication Without Required Fields Returns 400`
- Tarkistaa validoinnin puuttuvilla kentilla.

6. `Create Exercise Without Required Fields Returns 400`
- Tarkistaa validoinnin puuttuvilla kentilla.

7. `Create Entry Without Required Fields Returns 400`
- Tarkistaa validoinnin puuttuvilla kentilla.

## Viimeisin tulos

Ajo paivamaara: 2026-03-23

- Yhteensa: 7
- Lapi: 7
- Epaonnistui: 0

## Havainnot

- API vastasi oikein juurireitilla ja virhereitilla.
- Pakollisten kenttien validointi toimii testatuissa POST-reiteissa.
- Testit on suunniteltu niin, etteivat ne tarvitse tiettya seed-dataa onnistumiseen.
