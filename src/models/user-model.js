// Käyttäjän malli (User Model)
// Käyttäjien tietomalli ja tietokantavuorovaikutus
// Huomio: Tietokantafunktiot ovat asynkronisia ja kutsuttava await-komennolla ohjauksesta

import promisePool from '../utils/database.js';

// Hae kaikki käyttäjät
const listAllUsers = async () => {
  try {
    const [rows] = await promisePool.query('SELECT * FROM Users');
    console.log('Käyttäjät haettu:', rows.length);
    return rows;
  } catch (e) {
    console.error('Virhe käyttäjien haussa:', e.message);
    return { error: e.message };
  }
};

// Hae käyttäjä ID:n perusteella
const findUserById = async (id) => {
  try {
    const [rows] = await promisePool.execute('SELECT * FROM Users WHERE user_id = ?', [id]);
    console.log('Käyttäjä haettu:', rows.length > 0);
    return rows[0] || null;
  } catch (e) {
    console.error('Virhe käyttäjän haussa:', e.message);
    return { error: e.message };
  }
};

// Lisää uusi käyttäjä
const addUser = async (user) => {
  const { username, email, password, age } = user;
  const sql = `INSERT INTO Users (username, email, password, age, created_at)
               VALUES (?, ?, ?, ?, NOW())`;
  const params = [username, email, password, age];
  try {
    const result = await promisePool.execute(sql, params);
    console.log('Käyttäjä lisätty:', result[0].insertId);
    return { user_id: result[0].insertId };
  } catch (e) {
    console.error('Virhe käyttäjän lisäämisessä:', e.message);
    return { error: e.message };
  }
};

// Päivitä käyttäjän tiedot
const updateUser = async (id, user) => {
  const { username, email, age } = user;
  const sql = `UPDATE Users 
               SET username = ?, email = ?, age = ?, updated_at = NOW()
               WHERE user_id = ?`;
  const params = [username, email, age, id];
  try {
    const result = await promisePool.execute(sql, params);
    console.log('Käyttäjä päivitetty:', result[0].affectedRows);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('Virhe käyttäjän päivittämisessä:', e.message);
    return { error: e.message };
  }
};

// Poista käyttäjä
const deleteUser = async (id) => {
  const sql = `DELETE FROM Users WHERE user_id = ?`;
  try {
    const result = await promisePool.execute(sql, [id]);
    console.log('Käyttäjä poistettu:', result[0].affectedRows);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('Virhe käyttäjän poistamisessa:', e.message);
    return { error: e.message };
  }
};

export { listAllUsers, findUserById, addUser, updateUser, deleteUser };
