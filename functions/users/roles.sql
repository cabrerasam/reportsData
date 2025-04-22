--CREATE ROLE
CREATE OR REPLACE FUNCTION create_role (
  _id_role UUID,
  _name_role character varying, 
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _id UUID;
BEGIN
  INSERT INTO roles (id_role, name_role, id_super_user)
  VALUES (_id_role, _name_role, _id_super_user)
  RETURNING id_role INTO _id;

  RETURN jsonb_build_object(
    'id_role', _id,
    'name_role', _name_role,
    'id_super_user', _id_super_user
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible crear el Rol';
END;
$$ LANGUAGE plpgsql;

--UPDATE ROLE
CREATE OR REPLACE FUNCTION update_role (
  _id_role UUID,
  _name_role character varying, 
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _updated_id UUID;
BEGIN
  UPDATE roles
  SET name_role = _name_role, id_super_user = _id_super_user
  WHERE id_role = _id_role
  RETURNING id_role INTO _updated_id;

  IF _updated_id IS NULL THEN
    RAISE EXCEPTION 'Rol no encontrado';
  END IF;

  RETURN jsonb_build_object(
    'id_role', _updated_id,
    'name_role', _name_role,
    'id_super_user', _id_super_user
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible actualizar el Rol';
END;
$$ LANGUAGE plpgsql;

--DELETE ROLE
CREATE OR REPLACE FUNCTION delete_role (
  _id_role UUID
) RETURNS jsonb
AS $$
DECLARE
  _deleted_id UUID;
BEGIN
  DELETE FROM roles
  WHERE id_role = _id_role
  RETURNING id_role INTO _deleted_id;

  IF _deleted_id IS NULL THEN
    RAISE EXCEPTION 'Rol no encontrado';
  END IF;

  RETURN jsonb_build_object(
    'id_role', _deleted_id,
    'message', 'Rol eliminado correctamente'
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible eliminar el Rol';
END;
$$ LANGUAGE plpgsql;

