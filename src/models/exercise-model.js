// Harjoitusten malli (Exercise Model)
// Harjoitusten tietomalli ja tietokantavuorovaikutus

import promisePool from '../utils/database.js';

// Sanitoi undefined-arvot null:iksi
const sanitize = (value) => value === undefined || value === '' ? null : value;

// Hae kaikki harjoitukset
const listAllExercises = async () => {
  try {
    const [rows] = await promisePool.query('SELECT * FROM Exercises');
    console.log('Harjoitukset haettu:', rows.length);
    return rows;
  } catch (e) {
    console.error('Virhe harjoitusten haussa:', e.message);
    return { error: e.message };
  }
};

// Hae harjoitus ID:n perusteella
const findExerciseById = async (id) => {
  try {
    const [rows] = await promisePool.execute('SELECT * FROM Exercises WHERE exercise_id = ?', [id]);
    console.log('Harjoitus haettu:', rows.length > 0);
    return rows[0] || null;
  } catch (e) {
    console.error('Virhe harjoituksen haussa:', e.message);
    return { error: e.message };
  }
};

// Hae käyttäjän harjoitukset
const findExercisesByUserId = async (userId) => {
  try {
    const [rows] = await promisePool.execute('SELECT * FROM Exercises WHERE user_id = ?', [userId]);
    console.log('Käyttäjän harjoitukset haettu:', rows.length);
    return rows;
  } catch (e) {
    console.error('Virhe käyttäjän harjoitusten haussa:', e.message);
    return { error: e.message };
  }
};

// Lisää uusi harjoitus
const addExercise = async (exercise) => {
  const { user_id, exercise_date, exercise_type, duration_minutes, intensity, calories_burned, notes } = exercise;
  const sql = `INSERT INTO Exercises (user_id, exercise_date, exercise_type, duration_minutes, intensity, calories_burned, notes, created_at)
               VALUES (?, ?, ?, ?, ?, ?, ?, NOW())`;
  const params = [sanitize(user_id), sanitize(exercise_date), sanitize(exercise_type), sanitize(duration_minutes), sanitize(intensity), sanitize(calories_burned), sanitize(notes)];
  try {
    const result = await promisePool.execute(sql, params);
    console.log('Harjoitus lisätty:', result[0].insertId);
    return { exercise_id: result[0].insertId };
  } catch (e) {
    console.error('Virhe harjoituksen lisäämisessä:', e.message);
    return { error: e.message };
  }
};

// Päivitä harjoitusta
const updateExercise = async (id, exercise) => {
  const { exercise_date, exercise_type, duration_minutes, intensity, calories_burned, notes } = exercise;
  const sql = `UPDATE Exercises 
               SET exercise_date = ?, exercise_type = ?, duration_minutes = ?, intensity = ?, calories_burned = ?, notes = ?, updated_at = NOW()
               WHERE exercise_id = ?`;
  const params = [sanitize(exercise_date), sanitize(exercise_type), sanitize(duration_minutes), sanitize(intensity), sanitize(calories_burned), sanitize(notes), id];
  try {
    const result = await promisePool.execute(sql, params);
    console.log('Harjoitus päivitetty:', result[0].affectedRows);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('Virhe harjoituksen päivittämisessä:', e.message);
    return { error: e.message };
  }
};

// Poista harjoitus
const deleteExercise = async (id) => {
  const sql = `DELETE FROM Exercises WHERE exercise_id = ?`;
  try {
    const result = await promisePool.execute(sql, [id]);
    console.log('Harjoitus poistettu:', result[0].affectedRows);
    return { affectedRows: result[0].affectedRows };
  } catch (e) {
    console.error('Virhe harjoituksen poistamisessa:', e.message);
    return { error: e.message };
  }
};

export { listAllExercises, findExerciseById, findExercisesByUserId, addExercise, updateExercise, deleteExercise };
