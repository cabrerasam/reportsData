-- CREATE WEEKLY
CREATE OR REPLACE FUNCTION create_weekly(
  _id_weekly UUID,
  _num_weekly VARCHAR,
  _date_weekly DATE,
  _link_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO weekly (id_weekly, num_weekly, date_weekly, link_weekly, id_user)
  VALUES (_id_weekly, _num_weekly, _date_weekly, _link_weekly, _id_user)
  RETURNING id_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Weekly created successfully',
    'id_weekly', new_id,
    'num_weekly', _num_weekly,
    'date_weekly', _date_weekly,
    'link_weekly', _link_weekly,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE WEEKLY
CREATE OR REPLACE FUNCTION update_weekly(
  _id_weekly UUID,
  _num_weekly VARCHAR,
  _date_weekly DATE,
  _link_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE weekly
  SET num_weekly = _num_weekly,
      date_weekly = _date_weekly,
      link_weekly = _link_weekly,
      id_user = _id_user
  WHERE id_weekly = _id_weekly
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Weekly updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE WEEKLY
CREATE OR REPLACE FUNCTION delete_weekly(
  _id_weekly UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM weekly WHERE id_weekly = _id_weekly;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Weekly deleted successfully',
      'id_weekly', _id_weekly
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete weekly'
    );
END;
$$ LANGUAGE plpgsql;
