--CREATE WORKS
CREATE OR REPLACE FUNCTION create_work(
  _id_work UUID,
  _work VARCHAR,
  _id_individual UUID,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
    new_id UUID;
BEGIN
  INSERT INTO works (id_work, work, id_individual, id_user)
  VALUES (_id_work, _work, _id_individual, _id_user)
  RETURNING id_work INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Work created successfully',
    'id_work', new_id,
    'work', _work,
    'id_individual', _id_individual,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create work'
    );
END;
$$ LANGUAGE plpgsql;

--UPDATE WORKS
CREATE OR REPLACE FUNCTION update_work(
  _id_work UUID,
  _work VARCHAR,
  _id_individual UUID,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE works
  SET work = _work,
    id_individual = _id_individual,
    id_user = _id_user
  WHERE id_work = _id_work
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Work updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Work not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update work'
    );
END;
$$ LANGUAGE plpgsql;

--DELETE WORKS
CREATE OR REPLACE FUNCTION delete_work(
    _id_work UUID
) RETURNS jsonb AS $$
BEGIN
    DELETE FROM works WHERE id_work = _id_work;

    IF FOUND THEN
        RETURN jsonb_build_object(
            'message', 'Work deleted successfully',
            'id_work', _id_work
        );
    ELSE
        RETURN jsonb_build_object(
            'message', 'Work not found'
        );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN jsonb_build_object(
            'message', 'Failed to delete work'
        );
END;
$$ LANGUAGE plpgsql;

