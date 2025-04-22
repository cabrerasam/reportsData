--CREATE SPEACH
CREATE OR REPLACE FUNCTION create_speach(
  _id_speach UUID,
  _title_speach VARCHAR,
  _speach VARCHAR,
  _date_speach DATE,
  _id_individual UUID,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO speachs (id_speach, title_speach, speach, date_speach, id_individual, id_user)
  VALUES (_id_speach, _title_speach, _speach, _date_speach, _id_individual, _id_user)
  RETURNING id_speach INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Speach created successfully',
    'id_speach', new_id,
    'title_speach', _title_speach,
    'speach', _speach,
    'date_speach', _date_speach,
    'id_individual', _id_individual,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create speach'
    );
END;
$$ LANGUAGE plpgsql;

--UPDATE SPEACH
CREATE OR REPLACE FUNCTION update_speach(
    _id_speach UUID,
    _title_speach VARCHAR,
    _speach VARCHAR,
    _date_speach DATE,
    _id_individual UUID,
    _id_user UUID
) RETURNS jsonb AS $$
DECLARE
    updated_row RECORD;
BEGIN
  UPDATE speachs
  SET title_speach = _title_speach,
    speach = _speach,
    date_speach = _date_speach,
    id_individual = _id_individual,
    id_user = _id_user
  WHERE id_speach = _id_speach
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
        'message', 'Speach updated successfully',
        'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
        'message', 'Speach not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to update speach'
    );
END;
$$ LANGUAGE plpgsql;

--DELETE SPEACH
CREATE OR REPLACE FUNCTION delete_speach(
    _id_speach UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM speachs WHERE id_speach = _id_speach;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Speach deleted successfully',
      'id_speach', _id_speach
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Speach not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete speach'
    );
END;
$$ LANGUAGE plpgsql;
