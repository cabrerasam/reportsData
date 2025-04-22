--SUPER USER

--CREATE SUPER USER
CREATE OR REPLACE FUNCTION create_super_user (
  _name character varying,
  _password character varying
) RETURNS jsonb
AS $$
DECLARE
  _id UUID;
BEGIN
  INSERT INTO super_user (name, password)
  VALUES (_name, PGP_SYM_ENCRYPT(_password, 'AES_KEY'))
  RETURNING id INTO _id;

  RETURN jsonb_build_object(
    'id', _id,
    'name', _name
  );

EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'No fue posible crear el Super Usuario';
END;
$$
LANGUAGE plpgsql;

--VALIDATE SUPER USER
CREATE OR REPLACE FUNCTION validate_super_user (
  _name character varying, 
  _password character varying
) RETURNS jsonb
AS $$
DECLARE
  super_user_password super_user.password%TYPE;
  _id UUID;
BEGIN
  SELECT id, pgp_sym_decrypt(password::bytea, 'AES_KEY') 
  INTO _id, super_user_password
  FROM super_user
  WHERE name = _name;
  IF _password = super_user_password THEN
    RETURN jsonb_build_object(
      'id', _id,
      'name', _name
    );
  ELSE
    RAISE EXCEPTION 'Credenciales incorrectas';
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE EXCEPTION 'Registro no encontrado o error de autenticación';
END;
$$ LANGUAGE plpgsql;
