// Pääsovellus (Main Application File)
// Sovelluksen aloituspiste Middleware-ohjelmistovälineillä

import express from 'express';
import 'dotenv/config';
import entryRouter from './routes/entry-router.js';
import userRouter from './routes/user-router.js';
import medicationRouter from './routes/medication-router.js';
import exerciseRouter from './routes/exercise-router.js';
import authRouter from './routes/auth-router.js';

const app = express();

// ============================================
// 1️⃣ Middleware (Ohjelmistovälineet)
// ============================================

// JSON-jäsentäminen pyynnön rungossa
app.use(express.json());

// Kirjautumisen middleware
app.use((req, res, next) => {
  const timestamp = new Date().toISOString();
  console.log(`[${timestamp}] ${req.method} ${req.path}`);
  next();
});

// CORS - Salli pyynnöt eri verkkotunnuksilta
// Resurssien jakaminen verkkotunnusten välillä (Cross-Origin Resource Sharing)
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');  // Salli pyynnöt mistä tahansa verkkotunnukselta
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  
  // OPTIONS-pyyntöjen käsittely (preflight requests)
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// ============================================
// 2️⃣ Reitit (Routes)
// ============================================

// API reitit
app.use('/api/entries', entryRouter);
app.use('/api/users', userRouter);
app.use('/api/medications', medicationRouter);
app.use('/api/exercises', exerciseRouter);
app.use('/api/auth', authRouter);

// Testitie
app.get('/', (req, res) => {
  res.json({ 
    message: 'Tervetuloa päiväkirjasovellukseen!',
    version: '1.0.0',
    endpoints: {
      entries: 'GET /api/entries - Hae kaikki merkinnät',
      user: 'GET /api/users - Hae kaikki käyttäjät',
      medications: 'GET /api/medications - Hae kaikki lääkkeet',
      exercises: 'GET /api/exercises - Hae kaikki harjoitukset'
    }
  });
});

// ============================================
// 3️⃣ Virheenkäsittely (Error Handling Middleware)
// ============================================

// 404-käsittelijä - Reitti ei ole olemassa
app.use((req, res) => {
  res.status(404).json({ error: 'Reitti ei ole olemassa', path: req.path });
});

// Yleinen virheenkäsittelijä
// Täytyy olla viimeinen middleware
app.use((err, req, res, next) => {
  console.error('❌ Virhe:', err.stack);
  res.status(err.status || 500).json({
    error: err.message || 'Palvelimessa tapahtui virhe',
    timestamp: new Date().toISOString()
  });
});

// ============================================
// 4️⃣ Palvelimen käynnistäminen (Server)
// ============================================

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`✅ Palvelin käynnissä portissa ${PORT}`);
  console.log(`📍 Testaa: http://localhost:${PORT}/`);
});

export default app;
