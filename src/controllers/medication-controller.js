// Lääkkeiden kontrollerisovellus (Medication Controller)
// Lääkkeiden kanssa liittyvien pyyntöjen käsittely ja validointi

import { listAllMedications, findMedicationById, findMedicationsByUserId, addMedication, updateMedication, deleteMedication } from "../models/medication-model.js";

// Hae kaikki lääkkeet
const getMedications = async (req, res) => {
  try {
    const result = await listAllMedications();
    if (!result.error) {
      res.json(result);
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe lääkkeiden hakemisessa' });
  }
};

// Hae lääke ID:n perusteella
const getMedicationById = async (req, res) => {
  try {
    const medication = await findMedicationById(req.params.id);
    if (medication && !medication.error) {
      res.json(medication);
    } else if (medication?.error) {
      res.status(500).json(medication);
    } else {
      res.status(404).json({ error: 'Lääkettä ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe lääkkeen hakemisessa' });
  }
};

// Hae käyttäjän lääkkeet
const getMedicationsByUser = async (req, res) => {
  try {
    const result = await findMedicationsByUserId(req.params.userId);
    if (!result.error) {
      res.json(result);
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe käyttäjän lääkkeiden hakemisessa' });
  }
};

// Lisää uusi lääke
const postMedication = async (req, res) => {
  const { user_id, name, dosage, frequency, start_date, end_date, notes } = req.body;
  
  // Validointi
  if (!user_id || !name || !dosage || !frequency) {
    return res.status(400).json({ error: 'Pakollisia kenttiä puuttuu: user_id, name, dosage, frequency' });
  }
  
  try {
    const result = await addMedication(req.body);
    if (result.medication_id) {
      res.status(201).json({ message: 'Uusi lääke lisätty.', ...result });
    } else {
      res.status(500).json(result);
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe lääkkeen lisäämisessä' });
  }
};

// Päivitä lääkettä
const putMedication = async (req, res) => {
  const { name, dosage, frequency, start_date, end_date, notes } = req.body;
  
  // Vähintään yksi kenttä pitää päivittää
  if (!name && !dosage && !frequency) {
    return res.status(400).json({ error: 'Päivitettävät kentät puuttuvat' });
  }
  
  try {
    const result = await updateMedication(req.params.id, req.body);
    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Lääke päivitetty onnistuneesti.', ...result });
    } else if (result.error) {
      res.status(500).json(result);
    } else {
      res.status(404).json({ error: 'Lääkettä ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe lääkkeen päivittämisessä' });
  }
};

// Poista lääke
const deleteMedicationFn = async (req, res) => {
  try {
    const result = await deleteMedication(req.params.id);
    if (result.affectedRows > 0) {
      res.status(200).json({ message: 'Lääke poistettu onnistuneesti.', ...result });
    } else if (result.error) {
      res.status(500).json(result);
    } else {
      res.status(404).json({ error: 'Lääkettä ei löydy' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Virhe lääkkeen poistamisessa' });
  }
};

export { getMedications, getMedicationById, getMedicationsByUser, postMedication, putMedication, deleteMedicationFn };
