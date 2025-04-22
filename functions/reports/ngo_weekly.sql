-- CREATE NGO WEEKLY
CREATE OR REPLACE FUNCTION create_ngo_weekly(
  _id_ngo_weekly UUID,
  _num_ngo_weekly VARCHAR,
  _date_ngo_weekly DATE,
  _link_ngo_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO ngo_weekly (id_ngo_weekly, num_ngo_weekly, date_ngo_weekly, link_ngo_weekly, id_user)
  VALUES (_id_ngo_weekly, _num_ngo_weekly, _date_ngo_weekly, _link_ngo_weekly, _id_user)
  RETURNING id_ngo_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'NGO Weekly created successfully',
    'id_ngo_weekly', new_id,
    'num_ngo_weekly', _num_ngo_weekly,
    'date_ngo_weekly', _date_ngo_weekly,
    'link_ngo_weekly', _link_ngo_weekly,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create NGO Weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE NGO WEEKLY
CREATE OR REPLACE FUNCTION update_ngo_weekly(
  _id_ngo_weekly UUID,
  _num_ngo_weekly VARCHAR,
  _date_ngo_weekly DATE,
  _link_ngo_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE ngo_weekly
  SET num_ngo_weekly = _num_ngo_weekly,
      date_ngo_weekly = _date_ngo_weekly,
      link_ngo_weekly = _link_ngo_weekly,
      id_user = _id_user
  WHERE id_ngo_weekly = _id_ngo_weekly
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'NGO Weekly updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'NGO Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update NGO Weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE NGO WEEKLY
CREATE OR REPLACE FUNCTION delete_ngo_weekly(
  _id_ngo_weekly UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM ngo_weekly WHERE id_ngo_weekly = _id_ngo_weekly;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'NGO Weekly deleted successfully',
      'id_ngo_weekly', _id_ngo_weekly
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'NGO Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete NGO Weekly'
    );
END;
$$ LANGUAGE plpgsql;
