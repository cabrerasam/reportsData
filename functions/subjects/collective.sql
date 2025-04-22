--CREATE COLLECTIVE
DROP FUNCTION IF EXISTS create_collective;
CREATE OR REPLACE FUNCTION create_collective(
    _id_collective UUID,
    _name_collective VARCHAR,
    _logo_collective VARCHAR,
    _origin_collective VARCHAR,
    _type_collective VARCHAR,
    _headquarters_collective VARCHAR,
    _description_collective TEXT,
    _mission_collective TEXT,
    _vision_collective TEXT,
    _network_collective JSON,
    _inf_area_collective VARCHAR,
    _financing_collective VARCHAR,
    _personal_collective JSON,
    _id_user UUID
) RETURNS jsonb AS $$
DECLARE
    new_id UUID;
BEGIN
  INSERT INTO collectives (
    id_collective,
    name_collective,
    logo_collective,
    origin_collective,
    type_collective,
    headquarters_collective,
    description_collective,
    mission_collective,
    vision_collective,
    network_collective,
    inf_area_collective,
    financing_collective,
    personal_collective,
    id_user
  )
  VALUES (
    _id_collective,
    _name_collective,
    _logo_collective,
    _origin_collective,
    _type_collective,
    _headquarters_collective,
    _description_collective,
    _mission_collective,
    _vision_collective,
    _network_collective,
    _inf_area_collective,
    _financing_collective,
    _personal_collective,
    _id_user
  )
  RETURNING id_collective INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Collective created successfully',
    'id_collective', new_id,
    'name_collective', _name_collective,
    'logo_collective', _logo_collective,
    'origin_collective', _origin_collective,
    'type_collective', _type_collective,
    'headquarters_collective', _headquarters_collective,
    'description_collective', _description_collective,
    'mission_collective', _mission_collective,
    'vision_collective', _vision_collective,
    'network_collective', _network_collective,
    'inf_area_collective', _inf_area_collective,
    'financing_collective', _financing_collective,
    'personal_collective', _personal_collective,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create collective'
    );
END;
$$ LANGUAGE plpgsql;

--UPDATE COLLECTIVE
DROP FUNCTION IF EXISTS update_collective;
CREATE OR REPLACE FUNCTION update_collective(
  _id_collective UUID,
  _name_collective VARCHAR,
  _logo_collective VARCHAR,
  _origin_collective VARCHAR,
  _type_collective VARCHAR,
  _headquarters_collective VARCHAR,
  _description_collective TEXT,
  _mission_collective TEXT,
  _vision_collective TEXT,
  _network_collective JSON,
  _inf_area_collective VARCHAR,
  _financing_collective VARCHAR,
  _personal_collective JSON,
  _id_user UUID
) RETURNS jsonb AS $$
BEGIN
  UPDATE collectives
  SET
    name_collective = _name_collective,
    logo_collective = _logo_collective,
    origin_collective = _origin_collective,
    type_collective = _type_collective,
    headquarters_collective = _headquarters_collective,
    description_collective = _description_collective,
    mission_collective = _mission_collective,
    vision_collective = _vision_collective,
    network_collective = _network_collective,
    inf_area_collective = _inf_area_collective,
    financing_collective = _financing_collective,
    personal_collective = _personal_collective,
    id_user = _id_user
  WHERE id_collective = _id_collective
  RETURNING id_collective, name_collective, logo_collective, origin_collective, type_collective,
            headquarters_collective, description_collective, mission_collective, vision_collective,
            network_collective, inf_area_collective, financing_collective, personal_collective, id_user
  INTO _id_collective, _name_collective, _logo_collective, _origin_collective, _type_collective,
        _headquarters_collective, _description_collective, _mission_collective, _vision_collective,
        _network_collective, _inf_area_collective, _financing_collective, _personal_collective, _id_user;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Collective updated successfully',
      'id_collective', _id_collective,
      'name_collective', _name_collective,
      'logo_collective', _logo_collective,
      'origin_collective', _origin_collective,
      'type_collective', _type_collective,
      'headquarters_collective', _headquarters_collective,
      'description_collective', _description_collective,
      'mission_collective', _mission_collective,
      'vision_collective', _vision_collective,
      'network_collective', _network_collective,
      'inf_area_collective', _inf_area_collective,
      'financing_collective', _financing_collective,
      'personal_collective', _personal_collective
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Collective not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update collective'
    );
END;
$$ LANGUAGE plpgsql;

--DELETE COLLECTIVES
CREATE OR REPLACE FUNCTION delete_collective(
  _id_collective UUID
) RETURNS jsonb AS $$
DECLARE
  deleted_id UUID;
BEGIN
  DELETE FROM collectives
  WHERE id_collective = _id_collective
  RETURNING id_collective INTO deleted_id;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Collective deleted successfully',
      'id_collective', deleted_id
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Collective not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete collective'
    );
END;
$$ LANGUAGE plpgsql;
