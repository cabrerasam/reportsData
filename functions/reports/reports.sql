-- CREATE MONITORING
CREATE OR REPLACE FUNCTION create_report(
  _id_report UUID,
  _area_report VARCHAR,
  _type_report VARCHAR,
  _priority_report VARCHAR,
  _confidentiality_report VARCHAR,
  _num_report VARCHAR,
  _date_report DATE,
  _link_report VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO reports (id_report, area_report, type_report, priority_report, confidentiality_report, num_report, date_report, link_report, id_user)
  VALUES (_id_report, _area_report, _type_report, _priority_report, _confidentiality_report, _num_report, _date_report, _link_report, _id_user)
  RETURNING id_report INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Report created successfully',
    'id_report', new_id,
    'area_report', _area_report,
    'type_report', _type_report,
    'priority_report', _priority_report,
    'confidentiality_report', _confidentiality_report,
    'num_report', _num_report,
    'date_report', _date_report,
    'link_report', _link_report,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create report'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE REPORT
CREATE OR REPLACE FUNCTION update_report(
  _id_report UUID,
  _area_report VARCHAR,
  _type_report VARCHAR,
  _priority_report VARCHAR,
  _confidentiality_report VARCHAR,
  _num_report VARCHAR,
  _date_report DATE,
  _link_report VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE reports
  SET area_report = _area_report,
      type_report = _type_report,
      priority_report = _priority_report,
      confidentiality_report = _confidentiality_report,
      num_report = _num_report,
      date_report = _date_report,
      link_report = _link_report,
      id_user = _id_user
  WHERE id_report = _id_report
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Report updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Report not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update report'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE REPORT
CREATE OR REPLACE FUNCTION delete_report(
  _id_report UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM reports WHERE id_report = _id_report;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Report deleted successfully',
      'id_report', _id_report
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Report not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete report'
    );
END;
$$ LANGUAGE plpgsql;
