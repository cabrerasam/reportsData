--CREATE USER
CREATE OR REPLACE FUNCTION create_user(
  _id_user UUID,
  _user_name varchar,
  _user_nick varchar,
  _password_user varchar,
  _id_area UUID,
  _id_role UUID,
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _id UUID;
BEGIN
  INSERT INTO users (id_user, user_name, user_nick, password_user, id_area, id_role, id_super_user)
  VALUES (_id_user, _user_name, _user_nick, PGP_SYM_ENCRYPT(_password_user, 'AES_KEY'), _id_area, _id_role, _id_super_user)
  RETURNING id_user INTO _id;

  RETURN jsonb_build_object(
    'id_user', _id,
    'user_name', _user_name,
    'user_nick', _user_nick,
    'message', 'Usuario creado exitosamente'
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible crear el usuario';
END;
$$ LANGUAGE plpgsql;

--UPDATE USER
CREATE OR REPLACE FUNCTION update_user(
  _id_user UUID,
  _user_name varchar,
  _user_nick varchar,
  _password_user varchar,
  _id_area UUID,
  _id_role UUID,
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _updated_id UUID;
BEGIN
  UPDATE users
  SET user_name = _user_name,
    user_nick = _user_nick,
    password_user = PGP_SYM_ENCRYPT(_password_user, 'AES_KEY'),
    id_area = _id_area,
    id_role = _id_role,
    id_super_user = _id_super_user
  WHERE id_user = _id_user
  RETURNING id_user INTO _updated_id;

  IF _updated_id IS NULL THEN
    RAISE EXCEPTION 'Usuario no encontrado';
  END IF;

  RETURN jsonb_build_object(
    'id_user', _updated_id,
    'user_name', _user_name,
    'user_nick', _user_nick,
    'message', 'Usuario actualizado exitosamente'
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible actualizar el usuario';
END;
$$ LANGUAGE plpgsql;


--DELETE USER
CREATE OR REPLACE FUNCTION delete_user(
  _id_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _deleted_id UUID;
BEGIN
  DELETE FROM users
  WHERE id_user = _id_user
  RETURNING id_user INTO _deleted_id;

  IF _deleted_id IS NULL THEN
    RAISE EXCEPTION 'Usuario no encontrado';
  END IF;

  RETURN jsonb_build_object(
    'id_user', _deleted_id,
    'message', 'Usuario eliminado exitosamente'
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible eliminar el usuario';
END;
$$ LANGUAGE plpgsql;

--VALIDATE USER
CREATE OR REPLACE FUNCTION validate_user(
  _user_nick character varying, 
  _password character varying
) RETURNS jsonb
AS $$
DECLARE
  user_password varchar;
  _id UUID;
  _user_name varchar;
  _id_area UUID;
  _id_role UUID;
BEGIN
  -- Buscar al usuario por su nickname
  SELECT id_user, 
         pgp_sym_decrypt(password_user::bytea, 'AES_KEY'), 
         user_name, 
         id_area, 
         id_role, 
  INTO _id, user_password, _user_name, _id_area, _id_role
  FROM users
  WHERE user_nick = _user_nick;

  -- Verificar si la contraseña proporcionada coincide
  IF user_password IS NOT NULL AND user_password = _password THEN
    RETURN jsonb_build_object(
      'id_user', _id,
      'user_name', _user_name,
      'user_nick', _user_nick,
      'id_area', _id_area,
      'id_role', _id_role,
      'message', 'Usuario autenticado exitosamente'
    );
  ELSE
    RAISE EXCEPTION 'Credenciales incorrectas';
  END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE EXCEPTION 'Usuario no encontrado';
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Error en la validación del usuario';
END;
$$ LANGUAGE plpgsql;
