--COLLECTIVE DIARIES
CREATE OR REPLACE FUNCTION insert_collectives_diaries(
  _id_collective UUID,
  _id_diary UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO collectives_diaries (id_collective, id_diary)
  VALUES (_id_collective, _id_diary)
  RETURNING id_collective, id_diary INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_collective', new_id.id_collective,
    'id_diary', new_id.id_diary
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--COLLECTIVE MONITORNG
CREATE OR REPLACE FUNCTION insert_collectives_monitoring(
  _id_collective UUID,
  _id_monitoring UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO collectives_monitoring (id_collective, id_monitoring)
  VALUES (_id_collective, _id_monitoring)
  RETURNING id_collective, id_monitoring INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_collective', new_id.id_collective,
    'id_monitoring', new_id.id_monitoring
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--COLLECTIVES ALERTS
CREATE OR REPLACE FUNCTION insert_collectives_alerts(
  _id_collective UUID,
  _id_alert UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO collectives_alerts (id_collective, id_alert)
  VALUES (_id_collective, _id_alert)
  RETURNING id_collective, id_alert INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_collective', new_id.id_collective,
    'id_alert', new_id.id_alert
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--COLLECTIVES WEEKLY
CREATE OR REPLACE FUNCTION insert_collectives_weekly(
  _id_collective UUID,
  _id_weekly UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO collectives_weekly (id_collective, id_weekly)
  VALUES (_id_collective, _id_weekly)
  RETURNING id_collective, id_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_collective', new_id.id_collective,
    'id_weekly', new_id.id_weekly
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--COLLECTIVES NGO WEEKLY
CREATE OR REPLACE FUNCTION insert_collectives_ngo_weekly(
  _id_collective UUID,
  _id_ngo_weekly UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO collectives_ngo_weekly (id_collective, id_ngo_weekly)
  VALUES (_id_collective, _id_ngo_weekly)
  RETURNING id_collective, id_ngo_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_collective', new_id.id_collective,
    'id_ngo_weekly', new_id.id_ngo_weekly
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;

--COLLECTIVES SUNDAY
CREATE OR REPLACE FUNCTION insert_collectives_sundays(
  _id_collective UUID,
  _id_sunday UUID
) RETURNS jsonb AS $$
DECLARE
  new_id RECORD;
BEGIN
  INSERT INTO collectives_sundays (id_collective, id_sunday)
  VALUES (_id_collective, _id_sunday)
  RETURNING id_collective, id_sunday INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Record created successfully',
    'id_collective', new_id.id_collective,
    'id_sunday', new_id.id_sunday
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
        'message', 'Failed to create record'
    );
END;
$$ LANGUAGE plpgsql;
