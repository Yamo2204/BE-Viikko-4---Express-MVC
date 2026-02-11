// Lääkkeiden malli (Medication Model)
// Lääkkeiden tietomalli ja tietokantavuorovaikutus

import promisePool from '../utils/database.js';

// Sanitoi undefined-arvot null:iksi
const sanitize = (value) => value === undefined || value === '' ? null : value;

// Hae kaikki lääkkeet
const listAllMedications = async () => {
  try {
    const [rows] = await promisePool.query('SELECT * FROM Medications');
    console.log('Lääkkeet haettu:', rows.length);
    return rows;
  } catch (e) {
    console.error('Virhe lääkkeiden haussa:', e.message);
    return { error: e.message };
  }
};

// Hae lääke ID:n perusteella
const findMedicationById = async (id) => {
  try {
    const [rows] = await promisePool.execute('SELECT * FROM Medications WHERE medication_id = ?', [id]);
    console.log('Lääke haettu:', rows.length > 0);
    return rows[0] || null;
  } catch (e) {
    console.error('Virhe lääkkeen haussa:', e.message);
    return { error: e.message };
  }
};

// Hae käyttäjän lääkkeet
const findMedicationsByUserId = async (userId) => {
  try {
    const [rows] = await promisePool.execute('SELECT * FROM Medications WHERE user_id = ?', [userId]);
    console.log('Käyttäjän lääkkeet haettu:', rows.length);
    return rows;
  } catch (e) {
    console.error('Virhe käyttäjän lääkkeiden haussa:', e.message);
    return { error: e.message };
  }
};

// Lisää uusi lääke
const addMedication = async (medication) => {
  const { user_id, name, dosage, frequency, start_date, end_date, notes } = medication;
  const sql = `INSERT INTO Medications (user_id, name, dosage, frequency, start_date, end_date, notes, created_at)
               VALUES (?, ?, ?, ?, ?, ?, ?, NOW())`;
  const params = [sanitize(user_id), sanitize(name), sanitize(dosage), sanitize(frequency), sanitize(start_date), sanitize(end_date), sanitize(notes)];
  try {
    const result = await promisePool.execute(sql, params);
    console.log('Lääke lisätty:', result[0].insertId);
    return { medication_id: result[0].insertId };
  } catch (e) {
    console.error('Virhe lääkkeen lisäämisessä:', e.message);
    return { error: e.message };
  }
};

// Päivitä lääkettä
const updateMedication = async (id, medication) => {
  const { name, dosage, frequency, start_date, end_date, notes } = medication;
  const sql = `UPDATE Medications 
               SET name = ?, dosage = ?, frequency = ?, start_date = ?, end_date = ?, notes = ?, updated_at = NOW()
               WHERE medication_id = ?`;
  const params = [sanitize(name), sanitize(dosage), sanitize(frequency), sanitize(start_date), sanitize(end_date), sanitize(notes), id];
  try {
    const result = await promisePool.execute(sql, params);
    console.log('Lääke päivitetty:', result[0].affectedRows);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('Virhe lääkkeen päivittämisessä:', e.message);
    return { error: e.message };
  }
};

// Poista lääke
const deleteMedication = async (id) => {
  const sql = `DELETE FROM Medications WHERE medication_id = ?`;
  try {
    const result = await promisePool.execute(sql, [id]);
    console.log('Lääke poistettu:', result[0].affectedRows);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('Virhe lääkkeen poistamisessa:', e.message);
    return { error: e.message };
  }
};

export { listAllMedications, findMedicationById, findMedicationsByUserId, addMedication, updateMedication, deleteMedication };
