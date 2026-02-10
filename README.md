# 💪 Health & Wellness Diary - Express MVC Application

![Express.js](https://img.shields.io/badge/Express.js-4.18.2-green)
![MySQL](https://img.shields.io/badge/MySQL-8.0-blue)
![Node.js](https://img.shields.io/badge/Node.js-14+-yellow)
![License](https://img.shields.io/badge/License-MIT-red)

## 📋 Projektikuvaus

**Health & Wellness Diary** on kattava REST API-sovellus, joka mahdollistaa:
- 👤 **Käyttäjien hallinta** (rekisteröinti, päivitys, poistaminen)
- 📝 **Päiväkirjamerkintöjen seuranta** (mieli, paino, uni, muistinpanot)
- 💊 **Lääkkeiden hallinta** (ottotaulu, annosten seuranta)
- 🏃 **Harjoitusten seuranta** (liikunta, kalorit, intensiteetti)

Sovellus on rakennettu **Express.js** frameworkilla ja noudattaa **MVC-arkkitehtuuria** (Model-View-Controller). Tietokanta on **MySQL**, johon tiedot tallentuvat pysyvästi.

---

## ✨ Ominaisuudet

### 🟦 Käyttäjät
```
GET    /api/users          - Hae kaikki käyttäjät
GET    /api/users/:id      - Hae käyttäjä ID:n perusteella
POST   /api/users          - Luo uusi käyttäjä
PUT    /api/users/:id      - Päivitä käyttäjän tiedot
DELETE /api/users/:id      - Poista käyttäjä
```

### 📝 Päiväkirjamerkinnät
```
GET    /api/entries        - Hae kaikki merkinnät
GET    /api/entries/:id    - Hae merkintä ID:n perusteella
POST   /api/entries        - Lisää uusi merkintä
PUT    /api/entries/:id    - Päivitä merkintää
DELETE /api/entries/:id    - Poista merkintä
```

### 💊 Lääkkeet
```
GET    /api/medications           - Hae kaikki lääkkeet
GET    /api/medications/:id       - Hae lääke ID:n perusteella
GET    /api/medications/user/:id  - Hae käyttäjän lääkkeet
POST   /api/medications           - Lisää uusi lääke
PUT    /api/medications/:id       - Päivitä lääkettä
DELETE /api/medications/:id       - Poista lääke
```

### 🏃 Harjoitukset
```
GET    /api/exercises           - Hae kaikki harjoitukset
GET    /api/exercises/:id       - Hae harjoitus ID:n perusteella
GET    /api/exercises/user/:id  - Hae käyttäjän harjoitukset
POST   /api/exercises           - Lisää uusi harjoitus
PUT    /api/exercises/:id       - Päivitä harjoitusta
DELETE /api/exercises/:id       - Poista harjoitus
```

---

## 🛠️ Teknologia Stack

| Teknologia | Versio | Käyttö |
|-----------|--------|--------|
| **Express.js** | 4.18.2 | Web framework |
| **MySQL2** | 3.6.5 | Tietokanta-ajuri |
| **Node.js** | 14+ | Runtime |
| **Dotenv** | 16.3.1 | Ympäristömuuttujat |

---

## 📁 Projektirakenteen

```
express-mvc-diary/
├── src/
│   ├── models/                 # Datan lähde (tietokantakyselyt)
│   │   ├── user-model.js
│   │   ├── entry-model.js
│   │   ├── medication-model.js
│   │   └── exercise-model.js
│   │
│   ├── controllers/            # Liiketoimintalogiikka
│   │   ├── user-controller.js
│   │   ├── entry-controller.js
│   │   ├── medication-controller.js
│   │   └── exercise-controller.js
│   │
│   ├── routes/                 # HTTP-reititys
│   │   ├── user-router.js
│   │   ├── entry-router.js
│   │   ├── medication-router.js
│   │   └── exercise-router.js
│   │
│   ├── utils/
│   │   └── database.js         # MySQL-connection pool
│   │
│   └── index.js                # Sovelluksen pääpiste
├── .env                        # Ympäristömuuttujat
├── package.json                # npm-konfiguraatio
├── database-schema.sql         # Tietokantakaavio
├── API-DOCUMENTATION.md        # API-dokumentaatio
├── IMPLEMENTATION-DETAILS.md   # Toteutuksen selitys
├── QUICK-START.md              # Nopea käynnistysohje
└── README.md                   # Tämä tiedosto
```

---

## 🚀 Pian aluksi

### 1. Kloonaa projektin
```bash
git clone https://github.com/yourusername/express-mvc-diary.git
cd express-mvc-diary
```

### 2. Asenna riippuvuudet
```bash
npm install
```

### 3. Konfiguroi .env
```env
PORT=3000
DB_HOST=localhost
DB_PORT=3306
DB_NAME=diary_db
DB_USER=root
DB_PASSWORD=
NODE_ENV=development
```

### 4. Luo tietokanta
```bash
# MySQL-komentokehote:
mysql -u root -p
source database-schema.sql;
```

### 5. Käynnistä palvelin
```bash
npm start              # Production
npm run dev           # Kehitys
```

Palvelin käynnistyy: `http://localhost:3000`

---

## 📚 Dokumentaatio

- **[Nopea alkuun -ohje](./QUICK-START.md)** - 5 minuutin asennusohje
- **[API Dokumentaatio](./API-DOCUMENTATION.md)** - Yksityiskohtainen API-viite
- **[Toteutuksen yksityiskohdat](./IMPLEMENTATION-DETAILS.md)** - Arkkitehtuurin selitys

---

## 🔒 Turvallisuus

✅ **SQL Injection -suoja**: Parametroidut kyselyt
✅ **Input Validation**: Kaikki syötteet validoidaan
✅ **CORS**: Cross-Origin Resource Sharing -tuki
✅ **Error Handling**: Kattava virheenhallinta

---

## 📊 Tietokannan kaavio

```sql
Users (1) ──────< (N) DiaryEntries
  ├── user_id        ├── entry_id
  ├── username       ├── user_id (FK)
  ├── email          ├── entry_date
  ├── password       ├── mood
  ├── age            ├── weight
  └── timestamps     ├── sleep_hours
                     └── notes

Users (1) ──────< (N) Medications
  └── lääkenaika       ├── medication_id
     ja annostus       ├── user_id (FK)
                       ├── name
                       ├── dosage
                       ├── frequency
                       └── dates

Users (1) ──────< (N) Exercises
  └── harjoitus        ├── exercise_id
     tiedot           ├── user_id (FK)
                       ├── exercise_date
                       ├── exercise_type
                       ├── duration_minutes
                       ├── intensity
                       └── calories_burned
```

---

## 🧪 API-testaus

### cURL-esimerkkejä

**Luo käyttäjä:**
```bash
curl -X POST http://localhost:3000/api/users \
  -H "Content-Type: application/json" \
  -d '{
    "username": "john",
    "email": "john@example.com",
    "password": "pass123",
    "age": 30
  }'
```

**Hae käyttäjät:**
```bash
curl http://localhost:3000/api/users
```

**Lisää merkintä:**
```bash
curl -X POST http://localhost:3000/api/entries \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": 1,
    "entry_date": "2024-01-16",
    "mood": "Happy",
    "weight": 75.5,
    "sleep_hours": 8,
    "notes": "Hyvä päivä"
  }'
```

---

## 📊 Käyttää

### Terveystietojen seuranta
- Käyttäjät voivat kirjata päivittäisiä terveystietoja
- Mielialan, painon ja unen seuranta
- Henkilökohtaiset muistiinpanot

### Lääkkeiden hallinta
- Kerää käyttäjiä ottamia lääkkeitä
- Seurata ottamisen tiheyttä
- Hallitse aloitus- ja loppupäiviä

### Harjoituksen rakentaminen
- Kirjaa erilaisia harjoitustyyppejä
- Seurata kestoa ja intensiteettiä
- Kaloripolttamisen seurainta

---

## 🔄 Status Koodit

| Koodi | Merkitys |
|-------|----------|
| 200 | OK - Pyyntö onnistui |
| 201 | Created - Resurssi luotiin |
| 400 | Bad Request - Virheellinen pyyntö |
| 404 | Not Found - Resurssia ei löydy |
| 500 | Server Error - Palvelinvirhe |

---

## 🚀 Tulevaisuuden ominaisuudet

- [ ] Autentikointi (JWT-tokenit)
- [ ] Käyttäjän roolit (admin, user)
- [ ] Raportointi ja tilastot
- [ ] Email-notifikaatiot
- [ ] Graafinen käyttöliittymä (React)
- [ ] Mobiilisovellus
- [ ] Datavieinti (CSV, PDF)
- [ ] Machine Learning-ennusteet

---

## 💬 Yhteensähköposti

Kysymyksiä tai ehdotuksia?
- 📧 Email: developer@example.com
- 🐛 Issues: GitHub Issues
- 💡 Ideat: GitHub Discussions

---

## 📄 Lisenssi

MIT License - Vapaasti käytettävissä. Katso [LICENSE](./LICENSE) tiedostosta.

---

## 👥 Kirjoitus

Kehitystiimi
- **Node.js/Express.js kehittäjä**
- **Full Stack Developer**

---

## 🎉 Kiitos käyttämisestä!

Jos hyödynnit tätä sovellusta, näytä tuki lisäämällä tähden ⭐️

---

**Viimeksi päivitetty**: 2024-01-16
**Versio**: 1.0.0
