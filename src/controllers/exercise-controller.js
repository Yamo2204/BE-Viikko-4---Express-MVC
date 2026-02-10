// Harjoitusten kontrollerisovellus (Exercise Controller)
// Harjoitusten kanssa liittyvien pyyntöjen käsittely ja validointi

import { listAllExercises, findExerciseById, findExercisesByUserId, addExercise, updateExercise, deleteExercise } from "../models/exercise-model.js";

// Hae kaikki harjoitukset
const getExercises = async (req, res) => {
  try {
    const result = await listAllExercises();
    if (!result.error) {
      res.json(result);
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe harjoitusten hakemisessa' });
  }
};

// Hae harjoitus ID:n perusteella
const getExerciseById = async (req, res) => {
  try {
    const exercise = await findExerciseById(req.params.id);
    if (exercise && !exercise.error) {
      res.json(exercise);
    } else if (exercise?.error) {
      res.status(500).json(exercise);
    } else {
      res.status(404).json({ error: 'Harjoitusta ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe harjoituksen hakemisessa' });
  }
};

// Hae käyttäjän harjoitukset
const getExercisesByUser = async (req, res) => {
  try {
    const result = await findExercisesByUserId(req.params.userId);
    if (!result.error) {
      res.json(result);
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe käyttäjän harjoitusten hakemisessa' });
  }
};

// Lisää uusi harjoitus
const postExercise = async (req, res) => {
  const { user_id, exercise_date, exercise_type, duration_minutes, intensity, calories_burned, notes } = req.body;
  
  // Validointi
  if (!user_id || !exercise_date || !exercise_type || !duration_minutes) {
    return res.status(400).json({ error: 'Pakollisia kenttiä puuttuu: user_id, exercise_date, exercise_type, duration_minutes' });
  }
  
  try {
    const result = await addExercise(req.body);
    if (result.exercise_id) {
      res.status(201).json({ message: 'Uusi harjoitus lisätty.', ...result });
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe harjoituksen lisäämisessä' });
  }
};

// Päivitä harjoitusta
const putExercise = async (req, res) => {
  const { exercise_date, exercise_type, duration_minutes, intensity, calories_burned, notes } = req.body;
  
  // Vähintään yksi kenttä pitää päivittää
  if (!exercise_date && !exercise_type && !duration_minutes) {
    return res.status(400).json({ error: 'Päivitettävät kentät puuttuvat' });
  }
  
  try {
    const result = await updateExercise(req.params.id, req.body);
    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Harjoitus päivitetty onnistuneesti.', ...result });
    } else if (result.error) {
      res.status(500).json(result);
    } else {
      res.status(404).json({ error: 'Harjoitusta ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe harjoituksen päivittämisessä' });
  }
};

// Poista harjoitus
const deleteExerciseFn = async (req, res) => {
  try {
    const result = await deleteExercise(req.params.id);
    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Harjoitus poistettu onnistuneesti.', ...result });
    } else if (result.error) {
      res.status(500).json(result);
    } else {
      res.status(404).json({ error: 'Harjoitusta ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe harjoituksen poistamisessa' });
  }
};

export { getExercises, getExerciseById, getExercisesByUser, postExercise, putExercise, deleteExerciseFn };
