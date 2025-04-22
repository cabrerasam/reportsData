--CREATE AREA
CREATE OR REPLACE FUNCTION create_area (
  _id_area UUID,
  _name_area character varying, 
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _id UUID;
BEGIN
  INSERT INTO areas (id_area, name_area, id_super_user)
  VALUES (_id_area, _name_area, _id_super_user)
  RETURNING id_area INTO _id;
  
  RETURN jsonb_build_object(
    'id_area', _id,
    'name_area', _name_area,
    'id_super_user', _id_super_user
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible crear el Área';
END;
$$ LANGUAGE plpgsql;

--UPDATE AREA
CREATE OR REPLACE FUNCTION update_area (
  _id_area UUID,
  _name_area character varying, 
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _updated_id UUID;
BEGIN
  UPDATE areas
  SET name_area = _name_area, id_super_user = _id_super_user
  WHERE id_area = _id_area
  RETURNING id_area INTO _updated_id;

  IF _updated_id IS NULL THEN
    RAISE EXCEPTION 'Área no encontrada';
  END IF;

  RETURN jsonb_build_object(
    'id_area', _updated_id,
    'name_area', _name_area,
    'id_super_user', _id_super_user
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible actualizar el Área';
END;
$$ LANGUAGE plpgsql;


--DELETE AREA
CREATE OR REPLACE FUNCTION delete_area (
  _id_area UUID
) RETURNS jsonb
AS $$
DECLARE
  _deleted_id UUID;
BEGIN

  DELETE FROM areas
  WHERE id_area = _id_area
  RETURNING id_area INTO _deleted_id;

  IF _deleted_id IS NULL THEN
    RAISE EXCEPTION 'Área no encontrada';
  END IF;

  RETURN jsonb_build_object(
    'id_area', _deleted_id,
    'message', 'Área eliminada correctamente'
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible eliminar el Área';
END;
$$ LANGUAGE plpgsql;
