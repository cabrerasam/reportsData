--CREATE ASSOCIATIONS
CREATE OR REPLACE FUNCTION create_association(
  _id_association UUID,
  _association VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO associations (id_association, association, id_user)
  VALUES (_id_association, _association, _id_user)
  RETURNING id_association INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Association created successfully',
    'id_association', new_id,
    'association', _association,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create association'
    );
END;
$$ LANGUAGE plpgsql;

--UPDATE ASSOCIATION
CREATE OR REPLACE FUNCTION update_association(
  _id_association UUID,
  _association VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE associations
  SET association = _association,
    id_user = _id_user
  WHERE id_association = _id_association
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Association updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Association not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update association'
    );
END;
$$ LANGUAGE plpgsql;

--DELETE ASSOCIATION
CREATE OR REPLACE FUNCTION delete_association(
    _id_association UUID
) RETURNS JSON AS $$
BEGIN
    DELETE FROM associations WHERE id_association = _id_association;

    IF FOUND THEN
        RETURN json_build_object(
            'message', 'Association deleted successfully',
            'id_association', _id_association
        );
    ELSE
        RETURN json_build_object(
            'message', 'Association not found'
        );
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RETURN json_build_object(
            'message', 'Failed to delete association'
        );
END;
$$ LANGUAGE plpgsql;

