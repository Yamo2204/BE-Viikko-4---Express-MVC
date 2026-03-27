# TESTAUS

Tässä dokumentissa kerron vähän siitä, miten tein tämän projektin testauksen Robot Frameworkilla.

Testiympäristö

# Testasin tätä omalla koneella seuraavilla:

OS: Windows
Backend: Node.js + Express
Testityökalu: Robot Framework
Kirjastot: RequestsLibrary ja Browser (Playwright)
API osoite: http://localhost:3000
Testikansiot

# Testit löytyy näistä:

tests/api_homework.robot
tests/login_test.robot
tests/webform_test.robot

Resurssit on kansiossa tests/resources/ ja testien tulokset menee kansioon outputs/.

Miten testit ajetaan
Ensin pitää käynnistää backend:
npm start
Sitten voi ajaa kaikki testit:
robot -d outputs tests
Tai jos haluaa ajaa vain yhden:
robot -d outputs tests/login_test.robot
robot -d outputs tests/webform_test.robot
Lopuksi raportit löytyy outputs-kansiosta.
Testit
api_homework.robot

# Tässä testasin API:n perusjuttuja:

/ toimii ja palauttaa JSONin
väärä reitti antaa 404
/api/users vastaa (sallin myös 500 ettei testi kaadu turhaan)
POST-reiteissä tarkistin, että jos pakolliset kentät puuttuu → tulee 400
login_test.robot

# Tässä testasin kirjautumista:

tyhjä login → 400
ilman salasanaa → 400
ilman usernamea → 400
väärät tunnukset → 401
oikeat tunnukset → 200

Tein myös niin, että testi luo käyttäjän itse ja poistaa sen lopuksi.

webform_test.robot

# Tässä testasin lomaketta selaimessa:

dropdown toimii
datalist hyväksyy arvot
file upload toimii
checkbox toimii (voi valita ja poistaa valinnan)
radio button toimii oikein (vain yksi kerrallaan)
Viimeisin tulos

# Päivämäärä: 27.03.2026

Testejä: 20
Läpi: -
Fail: -
Oma huomio
API toimi ihan hyvin perus tapauksissa
validointi toimii kun kenttiä puuttuu
login-testit toimii itsenäisesti
ei tarvitse valmista dataa
selain testit meni nopeammin headless-tilassa