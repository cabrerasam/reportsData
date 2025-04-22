-- CREATE DIARY
CREATE OR REPLACE FUNCTION create_special(
  _id_special UUID,
  _type_special VARCHAR,
  _priority_special VARCHAR,
  _confidentiality_special VARCHAR,
  _num_special VARCHAR,
  _date_special DATE,
  _issue_special VARCHAR,
  _link_special VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO specials (id_special, type_special, priority_special, confidentiality_special, num_special, date_special, link_special, id_user)
  VALUES (_id_special, _type_special, _priority_special, _confidentiality_special, _num_special, _date_special, _link_special, _id_user)
  RETURNING id_special INTO new_id;

  RETURN jsonb_build_object(
    'message', 'special created successfully',
    'id_special', new_id,
    'type_special', _type_special,
    'priority_special', _priority_special,
    'confidentiality_special', _confidentiality_special,
    'num_special', _num_special,
    'date_special', _date_special,
    'link_special', _link_special,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create special',
      'error', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE special
CREATE OR REPLACE FUNCTION update_special(
  _id_special UUID,
  _type_special VARCHAR,
  _priority_special VARCHAR,
  _confidentiality_special VARCHAR,
  _num_special VARCHAR,
  _date_special DATE,
  _link_special VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE specials
  SET type_special = _type_special,
      priority_special = _priority_special,
      confidentiality_special = _confidentiality_special,
      num_special = _num_special,
      date_special = _date_special,
      link_special = _link_special,
      id_user = _id_user
  WHERE id_special = _id_special
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'special updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'special not found'
    );
  END IF;00
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update special'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE special
CREATE OR REPLACE FUNCTION delete_special(
  _id_special UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM specials WHERE id_special = _id_special;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'special deleted successfully',
      'id_special', _id_special
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'special not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete special'
    );
END;
$$ LANGUAGE plpgsql;
