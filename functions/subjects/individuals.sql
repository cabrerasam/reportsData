--CREATE INDIVIDUAL
CREATE OR REPLACE FUNCTION create_individual(
  _id_individual UUID,
  _name_individual VARCHAR,
  _nationality_individual VARCHAR,
  _birthdate_individual DATE,
  _place_birth_individual VARCHAR,
  _gender_individual VARCHAR,
  _marital_status_individual VARCHAR,
  _photo_individual VARCHAR,
  _party_individual VARCHAR,
  _work_individual VARCHAR,
  _education_individual VARCHAR,
  _email_individual VARCHAR,
  _phone_individual VARCHAR,
  _networks_individual JSON,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO individuals (
    id_individual,
    name_individual,
    nationality_individual,
    birthdate_individual,
    place_birth_individual,
    gender_individual,
    marital_status_individual,
    photo_individual,
    party_individual,
    work_individual,
    education_individual,
    email_individual,
    phone_individual,
    networks_individual,
    id_user
  )
  VALUES (
    _id_individual,
    _name_individual,
    _nationality_individual,
    _birthdate_individual,
    _place_birth_individual,
    _gender_individual,
    _marital_status_individual,
    _photo_individual,
    _party_individual,
    _work_individual,
    _education_individual,
    _email_individual,
    _phone_individual,
    _networks_individual,
    _id_user
  )
  RETURNING id_individual INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Individual created successfully',
    'id_individual', new_id,
    'name_individual', _name_individual,
    'nationality_individual', _nationality_individual,
    'birthdate_individual', _birthdate_individual,
    'place_birth_individual', _place_birth_individual,
    'gender_individual', _gender_individual,
    'marital_status_individual', _marital_status_individual,
    'photo_individual', _photo_individual,
    'party_individual', _party_individual,
    'work_individual', _work_individual,
    'education_individual', _education_individual,
    'email_individual', _email_individual,
    'phone_individual', _phone_individual,
    'networks_individual', _networks_individual,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create individual'
    );
END;
$$ LANGUAGE plpgsql;

--UPDATE INDIVIDUAL
CREATE OR REPLACE FUNCTION update_individual(
  _id_individual UUID,
  _name_individual VARCHAR,
  _nationality_individual VARCHAR,
  _birthdate_individual DATE,
  _place_birth_individual VARCHAR,
  _gender_individual VARCHAR,
  _marital_status_individual VARCHAR,
  _photo_individual VARCHAR,
  _party_individual VARCHAR,
  _work_individual VARCHAR,
  _education_individual VARCHAR,
  _email_individual VARCHAR,
  _phone_individual VARCHAR,
  _networks_individual JSON,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE individuals SET 
    name_individual = _name_individual,
    nationality_individual = _nationality_individual,
    birthdate_individual = _birthdate_individual,
    place_birth_individual = _place_birth_individual,
    gender_individual = _gender_individual,
    marital_status_individual = _marital_status_individual,
    photo_individual = _photo_individual,
    party_individual = _party_individual,
    work_individual = _work_individual,
    education_individual = _education_individual,
    email_individual = _email_individual,
    phone_individual = _phone_individual,
    networks_individual = _networks_individual,
    id_user = _id_user
  WHERE id_individual = _id_individual
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Individual updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Individual not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update individual'
    );
END;
$$ LANGUAGE plpgsql;

--DELETE INDIVIDUALS
CREATE OR REPLACE FUNCTION delete_individual(
  _id_individual UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM individuals WHERE id_individual = _id_individual;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Individual deleted successfully',
      'id_individual', _id_individual
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Individual not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete individual'
    );
END;
$$ LANGUAGE plpgsql;
