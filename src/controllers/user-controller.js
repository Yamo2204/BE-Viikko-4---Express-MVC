// Käyttäjän kontrollerisovellus (User Controller)
// Käyttäjien kanssa liittyvien pyyntöjen käsittely ja validointi

import { listAllUsers, findUserById, addUser, updateUser, deleteUser } from "../models/user-model.js";

// Hae kaikki käyttäjät
const getUsers = async (req, res) => {
  try {
    const result = await listAllUsers();
    if (!result.error) {
      res.json(result);
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe käyttäjien hakemisessa' });
  }
};

// Hae käyttäjä ID:n perusteella
const getUserById = async (req, res) => {
  try {
    const user = await findUserById(req.params.id);
    if (user && !user.error) {
      res.json(user);
    } else if (user?.error) {
      res.status(500).json(user);
    } else {
      res.status(404).json({ error: 'Käyttäjää ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe käyttäjän hakemisessa' });
  }
};

// Lisää uusi käyttäjä
const postUser = async (req, res) => {
  const { username, email, password, age } = req.body;
  
  // Validointi
  if (!username || !email || !password) {
    return res.status(400).json({ error: 'Pakollisia kenttiä puuttuu: username, email, password' });
  }
  
  try {
    const result = await addUser(req.body);
    if (result.user_id) {
      res.status(201).json({ message: 'Uusi käyttäjä lisätty.', ...result });
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe käyttäjän lisäämisessä' });
  }
};

// Päivitä käyttäjä
const putUser = async (req, res) => {
  const { username, email, age } = req.body;
  
  // Vähintään yksi kenttä pitää päivittää
  if (!username && !email && age === undefined) {
    return res.status(400).json({ error: 'Päivitettävät kentät puuttuvat' });
  }
  
  try {
    const result = await updateUser(req.params.id, req.body);
    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Käyttäjä päivitetty onnistuneesti.', ...result });
    } else if (result.error) {
      res.status(500).json(result);
    } else {
      res.status(404).json({ error: 'Käyttäjää ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe käyttäjän päivittämisessä' });
  }
};

// Poista käyttäjä
const deleteUserFn = async (req, res) => {
  try {
    const result = await deleteUser(req.params.id);
    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Käyttäjä poistettu onnistuneesti.', ...result });
    } else if (result.error) {
      res.status(500).json(result);
    } else {
      res.status(404).json({ error: 'Käyttäjää ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe käyttäjän poistamisessa' });
  }
};

export { getUsers, getUserById, postUser, putUser, deleteUserFn };
