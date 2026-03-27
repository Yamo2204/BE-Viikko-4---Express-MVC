// Autentikointikontrolleri (Auth Controller)
// Käyttäjän kirjautumisen käsittely

import { findUserByCredentials } from '../models/user-model.js';

// Kirjaudu sisään
const login = async (req, res) => {
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ error: 'username ja password vaaditaan' });
  }

  try {
    const user = await findUserByCredentials(username, password);
    if (user && !user.error) {
      res.json({
        message: 'Kirjautuminen onnistui',
        user_id: user.user_id,
        username: user.username,
      });
    } else if (user?.error) {
      res.status(500).json({ error: user.error });
    } else {
      res.status(401).json({ error: 'Virheelliset käyttäjätunnus tai salasana' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Kirjautumisessa tapahtui virhe' });
  }
};

export { login };
