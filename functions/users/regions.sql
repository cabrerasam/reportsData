--CREATE REGION
CREATE OR REPLACE FUNCTION create_region (
  _id_region UUID,
  _name_region character varying, 
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _id UUID;
BEGIN
  INSERT INTO regions (id_region, name_region, id_super_user)
  VALUES (_id_region, _name_region, _id_super_user)
  RETURNING id_region INTO _id;

  RETURN jsonb_build_object(
    'id_region', _id,
    'name_region', _name_region,
    'id_super_user', _id_super_user
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible crear la Región';
END;
$$ LANGUAGE plpgsql;

--UPDATE REGION
CREATE OR REPLACE FUNCTION update_region (
  _id_region UUID,
  _name_region character varying, 
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _updated_id UUID;
BEGIN
  UPDATE regions
  SET name_region = _name_region, id_super_user = _id_super_user
  WHERE id_region = _id_region
  RETURNING id_region INTO _updated_id;

  IF _updated_id IS NULL THEN
    RAISE EXCEPTION 'Región no encontrada';
  END IF;

  RETURN jsonb_build_object(
    'id_region', _updated_id,
    'name_region', _name_region,
    'id_super_user', _id_super_user
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible actualizar la Región';
END;
$$ LANGUAGE plpgsql;

--DELETE REGION
CREATE OR REPLACE FUNCTION delete_region (
  _id_region UUID
) RETURNS jsonb
AS $$
DECLARE
  _deleted_id UUID;
BEGIN
  DELETE FROM regions
  WHERE id_region = _id_region
  RETURNING id_region INTO _deleted_id;

  IF _deleted_id IS NULL THEN
    RAISE EXCEPTION 'Región no encontrada';
  END IF;

  RETURN jsonb_build_object(
    'id_region', _deleted_id,
    'message', 'Región eliminada correctamente'
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible eliminar la Región';
END;
$$ LANGUAGE plpgsql;
