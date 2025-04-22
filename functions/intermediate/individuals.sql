--INDIVIDUALS DIARIES
CREATE OR REPLACE FUNCTION insert_individuals_diaries(
  _id_individual UUID,
  _id_diary UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO individuals_diaries (id_individual, id_diary)
  VALUES (_id_individual, _id_diary)
  RETURNING id_individual, id_diary INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_individual', new_id.id_individual,
    'id_diary', new_id.id_diary
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--INDIVIDUALS MONITORING
CREATE OR REPLACE FUNCTION insert_individuals_monitoring(
  _id_individual UUID,
  _id_monitoring UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO individuals_monitoring (id_individual, id_monitoring)
  VALUES (_id_individual, _id_monitoring)
  RETURNING id_individual, id_monitoring INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_individual', new_id.id_individual,
    'id_monitoring', new_id.id_monitoring
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--INDIVIDUALS ALERTS
CREATE OR REPLACE FUNCTION insert_individuals_alerts(
  _id_individual UUID,
  _id_alert UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO individuals_alerts (id_individual, id_alert)
  VALUES (_id_individual, _id_alert)
  RETURNING id_individual, id_alert INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_individual', new_id.id_individual,
    'id_alert', new_id.id_alert
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

-- INDIVIDUALS WEEKLY
CREATE OR REPLACE FUNCTION insert_individuals_weekly(
  _id_individual UUID,
  _id_weekly UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO individuals_weekly (id_individual, id_weekly)
  VALUES (_id_individual, _id_weekly)
  RETURNING id_individual, id_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_individual', new_id.id_individual,
    'id_weekly', new_id.id_weekly
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;


--INDIVIDUALS NGO WEEKLY
CREATE OR REPLACE FUNCTION insert_individuals_ngo_weekly(
  _id_individual UUID,
  _id_ngo_weekly UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO individuals_ngo_weekly (id_individual, id_ngo_weekly)
  VALUES (_id_individual, _id_ngo_weekly)
  RETURNING id_individual, id_ngo_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_individual', new_id.id_individual,
    'id_ngo_weekly', new_id.id_ngo_weekly
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--INDIVIDUALS SUNDAY
CREATE OR REPLACE FUNCTION insert_individuals_sundays(
  _id_individual UUID,
  _id_sunday UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO individuals_sundays (id_individual, id_sunday)
  VALUES (_id_individual, _id_sunday)
  RETURNING id_individual, id_sunday INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_individual', new_id.id_individual,
    'id_sunday', new_id.id_sunday
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--SUBJECT ASSOCIATIONS
CREATE OR REPLACE FUNCTION insert_subjects_associations(
  _id_subject UUID,
  _id_assocaition UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO subjects_associations (id_subject, id_association)
  VALUES (_id_subject, _id_assocaition)
  RETURNING id_subject, id_association INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_subject', new_id.id_subject,
    'id_association', new_id.id_association
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;
