
-- Käyttäjät-taulu
-- Tallentaa sovelluksen käyttäjiä
CREATE TABLE IF NOT EXISTS Users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  email VARCHAR(100) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  age INT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Päiväkirjamerkinnät-taulu
-- Tallentaa päivittäiset terveystietoja
CREATE TABLE IF NOT EXISTS DiaryEntries (
  entry_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  entry_date DATE NOT NULL,
  mood VARCHAR(50),           -- Mieliala (Happy, Sad, Neutral, etc.)
  weight DECIMAL(5, 2),       -- Keho paino kilogrammoissa
  sleep_hours DECIMAL(4, 2),  -- Unen tuntimäärä
  notes TEXT,                 -- Lisämuistiinpanot
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Lääkkeet-taulu
-- Käyttäjät ottamien lääkkeiden seuranta
CREATE TABLE IF NOT EXISTS Medications (
  medication_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  name VARCHAR(100) NOT NULL,     -- Lääkkeen nimi
  dosage VARCHAR(50) NOT NULL,    -- Annos (esim. 500mg)
  frequency VARCHAR(50) NOT NULL, -- Ottotiheys (päivittäin, kerran viikossa, etc.)
  start_date DATE NOT NULL,       -- Aloituspäivä
  end_date DATE,                  -- Loppupäivä (voi olla NULL)
  notes TEXT,                     -- Muistiinpanot
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Harjoitukset-taulu
-- Fyysisen aktiivisuuden seuranta
CREATE TABLE IF NOT EXISTS Exercises (
  exercise_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  exercise_date DATE NOT NULL,           -- Harjoituspäivä
  exercise_type VARCHAR(50) NOT NULL,    -- Laji (Juoksu, Kävely, Uinti, etc.)
  duration_minutes INT NOT NULL,         -- Kesto minuuteissa
  intensity VARCHAR(25),                 -- Intensiteetti (Matala, Keskitaso, Korkea)
  calories_burned INT,                   -- Poltetut kalorit
  notes TEXT,                            -- Muistiinpanot
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- ===========================================================
-- INDEKSIT - Haun nopeuttamiseksi
-- ===========================================================
CREATE INDEX idx_user_id_diary ON DiaryEntries(user_id);
CREATE INDEX idx_entry_date ON DiaryEntries(entry_date);
CREATE INDEX idx_user_id_medications ON Medications(user_id);
CREATE INDEX idx_user_id_exercises ON Exercises(user_id);
CREATE INDEX idx_exercise_date ON Exercises(exercise_date);

-- ===========================================================
-- TESTIDATA - Näytetiedot
-- ===========================================================

-- Näyttöjä käyttäjät
INSERT INTO Users (username, email, password, age) VALUES
('john_doe', 'john@example.com', 'password123', 28),
('jane_smith', 'jane@example.com', 'password456', 32),
('mike_wilson', 'mike@example.com', 'password789', 25);

-- Näyttö päiväkirjamerkinnät
INSERT INTO DiaryEntries (user_id, entry_date, mood, weight, sleep_hours, notes) VALUES
(1, '2024-01-15', 'Happy', 75.5, 8.0, 'Hyvä päivä, paljon energiaa'),
(1, '2024-01-14', 'Tired', 75.3, 6.5, 'Väsynyt päivä'),
(2, '2024-01-15', 'Neutral', 68.0, 7.5, 'Normaali päivä'),
(3, '2024-01-15', 'Happy', 82.1, 8.5, 'Loistava treeni');

-- Näyttö lääkkeet
INSERT INTO Medications (user_id, name, dosage, frequency, start_date, end_date, notes) VALUES
(1, 'Aspirin', '500mg', 'Kerran päivässä', '2024-01-01', NULL, 'Päänsärkyyn'),
(2, 'Vitamiini D', '1000IU', 'Kerran päivässä', '2023-11-01', NULL, 'Immuunijärjestelmälle'),
(3, 'Ibuprofeeni', '200mg', 'Tarpeen mukaan', '2024-01-10', '2024-02-10', 'Lihasmerkkeihin');

-- Näyttö harjoitukset
INSERT INTO Exercises (user_id, exercise_date, exercise_type, duration_minutes, intensity, calories_burned, notes) VALUES
(1, '2024-01-15', 'Juoksu', 30, 'Korkea', 400, 'Hyvä harjoitus'),
(2, '2024-01-15', 'Kävely', 45, 'Matala', 180, 'Rauhallinen kävelylenkki'),
(1, '2024-01-14', 'Uinti', 60, 'Keskitaso', 500, 'Rentouttava'),
(3, '2024-01-15', 'Voima', 50, 'Korkea', 350, 'Painonnostoa');
