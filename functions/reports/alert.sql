-- CREATE ALERT
CREATE OR REPLACE FUNCTION create_alert(
  _id_alert UUID,
  _type_alert VARCHAR,
  _priority_alert VARCHAR,
  _confidentiality_alert VARCHAR,
  _num_alert VARCHAR,
  _date_alert DATE,
  _issue_alert VARCHAR,
  _link_alert VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO alerts (id_alert, type_alert, priority_alert, confidentiality_alert, num_alert, date_alert, issue_alert, link_alert, id_user)
  VALUES (_id_alert, _type_alert, _priority_alert, _confidentiality_alert, _num_alert, _date_alert, _issue_alert, _link_alert, _id_user)
  RETURNING id_alert INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Alert created successfully',
    'id_alert', new_id,
    'type_alert', _type_alert,
    'priority_alert', _priority_alert,
    'confidentiality_alert', _confidentiality_alert,
    'num_alert', _num_alert,
    'date_alert', _date_alert,
    'issue_alert', _issue_alert,
    'link_alert', _link_alert,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create alert'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE ALERT
CREATE OR REPLACE FUNCTION update_alert(
  _id_alert UUID,
  _type_alert VARCHAR,
  _priority_alert VARCHAR,
  _confidentiality_alert VARCHAR,
  _num_alert VARCHAR,
  _date_alert DATE,
  _issue_alert VARCHAR,
  _link_alert VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE alerts
  SET type_alert = _type_alert,
      priority_alert = _priority_alert,
      confidentiality_alert = _confidentiality_alert,
      num_alert = _num_alert,
      date_alert = _date_alert,
      issue_alert = _issue_alert,
      link_alert = _link_alert,
      id_user = _id_user
  WHERE id_alert = _id_alert
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Alert updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Alert not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update alert'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE ALERT
CREATE OR REPLACE FUNCTION delete_alert(
  _id_alert UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM alerts WHERE id_alert = _id_alert;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Alert deleted successfully',
      'id_alert', _id_alert
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Alert not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete alert'
    );
END;
$$ LANGUAGE plpgsql;
