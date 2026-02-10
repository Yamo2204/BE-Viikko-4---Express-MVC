// Merkinnän malli (Entry Model)
// Merkintöjen tietomalli ja tietokantavuorovaikutus
// Huomio: Tietokantafunktiot ovat asynkronisia ja kutsuttava await-komennolla ohjauksesta

import promisePool from '../utils/database.js';

// Hae kaikki merkinnät
const listAllEntries = async () => {
  try {
    const [rows] = await promisePool.query('SELECT * FROM DiaryEntries');
    console.log('rows', rows);
    return rows;
  } catch (e) {
    console.error('error', e.message);
    return { error: e.message };
  }
};

const findEntryById = async (id) => {
  try {
    // Hae merkintä ID:n perusteella (parametroitu kysely)
    const [rows] = await promisePool.execute('SELECT * FROM DiaryEntries WHERE entry_id = ?', [id]);
    console.log('rows', rows);
    return rows[0];
  } catch (e) {
    console.error('error', e.message);
    return { error: e.message };
  }
};

const addEntry = async (entry) => {
  const { user_id, entry_date, mood, weight, sleep_hours, notes } = entry;
  // Lisää uusi merkintä tietokantaan
  const sql = `INSERT INTO DiaryEntries (user_id, entry_date, mood, weight, sleep_hours, notes)
               VALUES (?, ?, ?, ?, ?, ?)`;
  const params = [user_id, entry_date, mood, weight, sleep_hours, notes];
  try {
    const rows = await promisePool.execute(sql, params);
    console.log('rows', rows);
    return { entry_id: rows[0].insertId };
  } catch (e) {
    console.error('error', e.message);
    return { error: e.message };
  }
};

const updateEntry = async (id, entry) => {
  const { user_id, entry_date, mood, weight, sleep_hours, notes } = entry;
  // Päivitä olemassa olevan merkinnän tiedot
  const sql = `UPDATE DiaryEntries 
               SET user_id = ?, entry_date = ?, mood = ?, weight = ?, sleep_hours = ?, notes = ?
               WHERE entry_id = ?`;
  const params = [user_id, entry_date, mood, weight, sleep_hours, notes, id];
  try {
    const result = await promisePool.execute(sql, params);
    console.log('update result', result);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('error', e.message);
    return { error: e.message };
  }
};

const deleteEntry = async (id) => {
  // Poista merkintä ID:n perusteella
  const sql = `DELETE FROM DiaryEntries WHERE entry_id = ?`;
  try {
    const result = await promisePool.execute(sql, [id]);
    console.log('delete result', result);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('error', e.message);
    return { error: e.message };
  }
};

export { listAllEntries, findEntryById, addEntry, updateEntry, deleteEntry };
