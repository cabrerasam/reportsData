-- CREATE SUNDAY
CREATE OR REPLACE FUNCTION create_sunday(
  _id_sunday UUID,
  _type_sunday VARCHAR,
  _priority_sunday VARCHAR,
  _confidentiality_sunday VARCHAR,
  _num_sunday VARCHAR,
  _date_sunday DATE,
  _issue_sunday VARCHAR,
  _link_sunday VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO sundays (id_sunday, type_sunday, priority_sunday, confidentiality_sunday, num_sunday, date_sunday, link_sunday, id_user)
  VALUES (_id_sunday, _type_sunday, _priority_sunday, _confidentiality_sunday, _num_sunday, _date_sunday, _link_sunday, _id_user)
  RETURNING id_sunday INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Sunday created successfully',
    'id_sunday', new_id,
    'type_sunday', _type_sunday,
    'priority_sunday', _priority_sunday,
    'confidentiality_sunday', _confidentiality_sunday,
    'num_sunday', _num_sunday,
    'date_sunday', _date_sunday,
    'link_sunday', _link_sunday,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create Sunday'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE SUNDAY
CREATE OR REPLACE FUNCTION update_sunday(
  _id_sunday UUID,
  _type_sunday VARCHAR,
  _priority_sunday VARCHAR,
  _confidentiality_sunday VARCHAR,
  _num_sunday VARCHAR,
  _date_sunday DATE,
  _link_sunday VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE sundays
  SET type_sunday = _type_sunday,
      priority_sunday = _priority_sunday,
      confidentiality_sunday = _confidentiality_sunday,
      num_sunday = _num_sunday,
      date_sunday = _date_sunday,
      link_sunday = _link_sunday,
      id_user = _id_user
  WHERE id_sunday = _id_sunday
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Sunday updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Sunday not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update Sunday'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE SUNDAY
CREATE OR REPLACE FUNCTION delete_sunday(
  _id_sunday UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM sundays WHERE id_sunday = _id_sunday;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Sunday deleted successfully',
      'id_sunday', _id_sunday
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Sunday not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete Sunday'
    );
END;
$$ LANGUAGE plpgsql;
