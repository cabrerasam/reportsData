-- CREATE ISSUES REPORT
CREATE OR REPLACE FUNCTION create_issues_report(
  _id_issues_report UUID,
  _issue_report VARCHAR,
  _intensity_issues_report VARCHAR,
  _id_report UUID

) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO issues_report (id_issues_report, issue_report, intensity_issues_report, id_report)
  VALUES (_id_issues_report, _issue_report, _intensity_issues_report, _id_report)
  RETURNING id_issues_report INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Issues report created successfully',
    'id_issues_report', new_id,
    'issue_report', _issue_report,
    'intensity_issues_report', _intensity_issues_report,
    'id_report', _id_report
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create Issues report'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE ISSUES REPORT
CREATE OR REPLACE FUNCTION update_issues_report(
  _id_issues_report UUID,
  _issue_report VARCHAR,
  _intensity_issues_report VARCHAR,
  _id_report UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE issues_report
  SET issue_report = _issue_report,
      intensity_issues_report = _intensity_issues_report,
      id_report = _id_report
  WHERE id_issues_report = _id_issues_report
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Issues report updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Issues report not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update Issues report'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE ISSUES REPORT
CREATE OR REPLACE FUNCTION delete_issues_report(
  _id_issues_report UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM issues_report WHERE id_issues_report = _id_issues_report;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Issues report deleted successfully',
      'id_issues_report', _id_issues_report
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Issues report not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete Issues report'
    );
END;
$$ LANGUAGE plpgsql;
