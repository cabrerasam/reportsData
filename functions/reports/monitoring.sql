-- CREATE MONITORING
CREATE OR REPLACE FUNCTION create_monitoring(
  _id_monitoring UUID,
  _type_monitoring VARCHAR,
  _priority_monitoring VARCHAR,
  _confidentiality_monitoring VARCHAR,
  _num_monitoring VARCHAR,
  _date_monitoring DATE,
  _link_monitoring VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO monitoring (id_monitoring, type_monitoring, priority_monitoring, confidentiality_monitoring, num_monitoring, date_monitoring, link_monitoring, id_user)
  VALUES (_id_monitoring, _type_monitoring, _priority_monitoring, _confidentiality_monitoring, _num_monitoring, _date_monitoring, _link_monitoring, _id_user)
  RETURNING id_monitoring INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Monitoring created successfully',
    'id_monitoring', new_id,
    'type_monitoring', _type_monitoring,
    'priority_monitoring', _priority_monitoring,
    'confidentiality_monitoring', _confidentiality_monitoring,
    'num_monitoring', _num_monitoring,
    'date_monitoring', _date_monitoring,
    'link_monitoring', _link_monitoring,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create monitoring'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE MONITORING
CREATE OR REPLACE FUNCTION update_monitoring(
  _id_monitoring UUID,
  _type_monitoring VARCHAR,
  _priority_monitoring VARCHAR,
  _confidentiality_monitoring VARCHAR,
  _num_monitoring VARCHAR,
  _date_monitoring DATE,
  _link_monitoring VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE monitoring
  SET type_monitoring = _type_monitoring,
      priority_monitoring = _priority_monitoring,
      confidentiality_monitoring = _confidentiality_monitoring,
      num_monitoring = _num_monitoring,
      date_monitoring = _date_monitoring,
      link_monitoring = _link_monitoring,
      id_user = _id_user
  WHERE id_monitoring = _id_monitoring
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Monitoring updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Monitoring not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update monitoring'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE MONITORING
CREATE OR REPLACE FUNCTION delete_monitoring(
  _id_monitoring UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM monitoring WHERE id_monitoring = _id_monitoring;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Monitoring deleted successfully',
      'id_monitoring', _id_monitoring
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Monitoring not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete monitoring'
    );
END;
$$ LANGUAGE plpgsql;
