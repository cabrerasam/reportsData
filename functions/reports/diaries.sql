-- CREATE DIARY
CREATE OR REPLACE FUNCTION create_diary(
  _id_diary UUID,
  _type_diary VARCHAR,
  _priority_diary VARCHAR,
  _confidentiality_diary VARCHAR,
  _num_diary VARCHAR,
  _date_diary DATE,
  _issue_diary VARCHAR,
  _link_diary VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO diaries (id_diary, type_diary, priority_diary, confidentiality_diary, num_diary, date_diary, issue_diary, link_diary, id_user)
  VALUES (_id_diary, _type_diary, _priority_diary, _confidentiality_diary, _num_diary, _date_diary, _issue_diary, _link_diary, _id_user)
  RETURNING id_diary INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Diary created successfully',
    'id_diary', new_id,
    'type_diary', _type_diary,
    'priority_diary', _priority_diary,
    'confidentiality_diary', _confidentiality_diary,
    'num_diary', _num_diary,
    'date_diary', _date_diary,
    'issue_diary', _issue_diary,
    'link_diary', _link_diary,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create diary',
      'error', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE DIARY
CREATE OR REPLACE FUNCTION update_diary(
  _id_diary UUID,
  _type_diary VARCHAR,
  _priority_diary VARCHAR,
  _confidentiality_diary VARCHAR,
  _num_diary VARCHAR,
  _date_diary DATE,
  _issue_diary VARCHAR,
  _link_diary VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE diaries
  SET type_diary = _type_diary,
      priority_diary = _priority_diary,
      confidentiality_diary = _confidentiality_diary,
      num_diary = _num_diary,
      date_diary = _date_diary,
      issue_diary = _issue_diary,
      link_diary = _link_diary,
      id_user = _id_user
  WHERE id_diary = _id_diary
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Diary updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Diary not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update diary'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE DIARY
CREATE OR REPLACE FUNCTION delete_diary(
  _id_diary UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM diaries WHERE id_diary = _id_diary;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Diary deleted successfully',
      'id_diary', _id_diary
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Diary not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete diary'
    );
END;
$$ LANGUAGE plpgsql;
