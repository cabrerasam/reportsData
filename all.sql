CREATE EXTENSION pgcrypto;

--TABLAS USUARIOS--

--SUPER USER
CREATE TABLE super_user (
	id UUID DEFAULT gen_random_uuid() NOT NULL,
	name varchar(255) NOT NULL,
	password varchar(255) NOT NULL,
	CONSTRAINT super_user_pk PRIMARY KEY (id),
	CONSTRAINT super_user_uk UNIQUE (name)
);

--Areas
CREATE TABLE areas (
	id_area UUID DEFAULT gen_random_uuid() NOT NULL,
	create_area timestamp DEFAULT NOW(),
	name_area varchar(255) NOT NULL,
	id_super_user UUID,
	CONSTRAINT areas_pk PRIMARY KEY (id_area),
	CONSTRAINT areas_uk UNIQUE (name_area),
	CONSTRAINT areas_super_user_fk FOREIGN KEY (id_super_user) REFERENCES super_user (id)
);

--Roles
CREATE TABLE roles (
	id_role UUID DEFAULT gen_random_uuid() NOT NULL,
	create_role timestamp DEFAULT NOW(),
	name_role varchar(255) NOT NULL,
	id_super_user UUID,
	CONSTRAINT roles_pk PRIMARY KEY (id_role),
	CONSTRAINT roles_uk UNIQUE (name_role),
	CONSTRAINT roles_super_user_fk FOREIGN KEY (id_super_user) REFERENCES super_user (id)
);

--USER
CREATE TABLE users (
	id_user UUID DEFAULT gen_random_uuid() NOT NULL,
	create_user timestamp DEFAULT NOW(),
	user_name varchar(255) NOT NULL,
	user_nick varchar(255) NOT NULL,
	password_user varchar(255) NOT NULL,
	id_area UUID NOT NULL,
	id_role UUID NOT NULL,
	id_super_user UUID NOT NULL,
	CONSTRAINT users_pk PRIMARY KEY (id_user),
	CONSTRAINT users_uk UNIQUE (user_nick),
	CONSTRAINT users_areas_fk FOREIGN KEY (id_area) REFERENCES areas (id_area),
	CONSTRAINT users_roles_fk FOREIGN KEY (id_role) REFERENCES roles (id_role),
	CONSTRAINT users_super_user_fk FOREIGN KEY (id_super_user) REFERENCES super_user (id)
);

--REPORTS

--DIARY
CREATE TABLE specials (
	id_special UUID DEFAULT gen_random_uuid() NOT NULL,
	create_special timestamp DEFAULT NOW(),
	type_special varchar(255) NOT NULL,
	priority_special varchar(255) NOT NULL,
	confidentiality_special varchar(255) NOT NULL,
	num_special varchar(255) NOT NULL,
	date_special DATE NOT NULL,
	link_special varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT specials_pk PRIMARY KEY (id_special),
	CONSTRAINT specials_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--MONITORING
CREATE TABLE monitoring (
	id_monitoring UUID DEFAULT gen_random_uuid() NOT NULL,
	create_monitoring timestamp DEFAULT NOW(),
	type_monitoring varchar(255) NOT NULL,
	priority_monitoring varchar(255) NOT NULL,
	confidentiality_monitoring varchar(255) NOT NULL,
	num_monitoring varchar(255) NOT NULL,
	date_monitoring DATE NOT NULL,
	link_monitoring varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT monitoring_pk PRIMARY KEY (id_monitoring),
	CONSTRAINT monitoring_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--ALERT MONITORING
CREATE TABLE alerts (
	id_alert UUID DEFAULT gen_random_uuid() NOT NULL,
	create_alert timestamp DEFAULT NOW(),
	type_alert varchar(255) NOT NULL,
	priority_alert varchar(255) NOT NULL,
	confidentiality_alert varchar(255) NOT NULL,
	num_alert varchar(255) NOT NULL,
	date_alert DATE NOT NULL,
	link_alert varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT alerts_pk PRIMARY KEY (id_alert),
	CONSTRAINT alerts_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--WEEKLY
CREATE TABLE weekly (
	id_weekly UUID DEFAULT gen_random_uuid() NOT NULL,
	create_weekly timestamp DEFAULT NOW(),
	num_weekly varchar(255) NOT NULL,
	date_weekly DATE NOT NULL,
	link_weekly varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT weekly_pk PRIMARY KEY (id_weekly),
	CONSTRAINT weekly_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--NGO WEEKLY
CREATE TABLE ngo_weekly (
	id_ngo_weekly UUID DEFAULT gen_random_uuid() NOT NULL,
	create_ngo_weekly timestamp DEFAULT NOW(),
	num_ngo_weekly varchar(255) NOT NULL,
	date_ngo_weekly DATE NOT NULL,
	link_ngo_weekly varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT ngo_weekly_pk PRIMARY KEY (id_ngo_weekly),
	CONSTRAINT ngo_weekly_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--SUNDAY
CREATE TABLE sundays (
	id_sunday UUID DEFAULT gen_random_uuid() NOT NULL,
	create_sunday timestamp DEFAULT NOW(),
	type_sunday varchar(255) NOT NULL,
	priority_sunday varchar(255) NOT NULL,
	confidentiality_sunday varchar(255) NOT NULL,
	num_sunday varchar(255) NOT NULL,
	date_sunday DATE NOT NULL,
	link_sunday varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT sundays_pk PRIMARY KEY (id_sunday),
	CONSTRAINT sundays_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--ISSUES REPORT
CREATE TABLE issues_report (
	id_issues_report UUID DEFAULT gen_random_uuid() NOT NULL,
	create_issues_report timestamp DEFAULT NOW(),
	issue_report varchar(255) NOT NULL,
	tags_issues_report varchar(255) NOT NULL,
	id_report UUID NOT NULL,
	CONSTRAINT issues_report_pk PRIMARY KEY (id_issues_report)
);

--TABLES AUDIT
CREATE TABLE audit_users (
	id_audit_user UUID DEFAULT gen_random_uuid() NOT NULL,
	create_audit_user timestamp DEFAULT NOW(),
	action_audit_user varchar(255) NOT NULL,
	table_audit_user varchar(255) NOT NULL,
	last_audit_user json NOT NULL,
	new_audit_user json,
	id_user UUID NOT NULL,
	CONSTRAINT id_audit_user_pk PRIMARY KEY (id_audit_user)
);

CREATE TABLE audit_reports (
	id_audit_report UUID DEFAULT gen_random_uuid() NOT NULL,
	create_audit_report timestamp DEFAULT NOW(),
	action_audit_report varchar(255) NOT NULL,
	table_audit_report varchar(255) NOT NULL,
	last_audit_report json NOT NULL,
	new_audit_report json,
	id_user UUID NOT NULL,
	CONSTRAINT id_audit_report_pk PRIMARY KEY (id_audit_report)
);

--FUNCTIONS

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

--USERS

--CREATE USER
CREATE OR REPLACE FUNCTION create_user(
  _id_user UUID,
  _user_name varchar,
  _user_nick varchar,
  _password_user varchar,
  _id_area UUID,
  _id_role UUID,
  _id_region UUID,
  _id_super_user UUID
) RETURNS jsonb
AS $$
DECLARE
  _id UUID;
BEGIN
  INSERT INTO users (id_user, user_name, user_nick, password_user, id_area, id_role, id_region, id_super_user)
  VALUES (_id_user, _user_name, _user_nick, PGP_SYM_ENCRYPT(_password_user, 'AES_KEY'), _id_area, _id_role, _id_region, _id_super_user)
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
  _id_region UUID,
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
    id_region = _id_region,
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
  _id_region UUID;
BEGIN
  -- Buscar al usuario por su nickname
  SELECT id_user, 
         pgp_sym_decrypt(password_user::bytea, 'AES_KEY'), 
         user_name, 
         id_area, 
         id_role, 
         id_region
  INTO _id, user_password, _user_name, _id_area, _id_role, _id_region
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
      'id_region', _id_region,
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

--ROLES

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

--AREAS

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

--REPORTS

-- CREATE ALERT
CREATE OR REPLACE FUNCTION create_alert(
  _id_alert UUID,
  _type_alert VARCHAR,
  _priority_alert VARCHAR,
  _confidentiality_alert VARCHAR,
  _num_alert VARCHAR,
  _date_alert DATE,
  _link_alert VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO alerts (id_alert, type_alert, priority_alert, confidentiality_alert, num_alert, date_alert, link_alert, id_user)
  VALUES (_id_alert, _type_alert, _priority_alert, _confidentiality_alert, _num_alert, _date_alert, _link_alert, _id_user)
  RETURNING id_alert INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Alert created successfully',
    'id_alert', new_id,
    'type_alert', _type_alert,
    'priority_alert', _priority_alert,
    'confidentiality_alert', _confidentiality_alert,
    'num_alert', _num_alert,
    'date_alert', _date_alert,
    'link_alert', _link_alert,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create alert'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE ALERT
CREATE OR REPLACE FUNCTION update_alert(
  _id_alert UUID,
  _type_alert VARCHAR,
  _priority_alert VARCHAR,
  _confidentiality_alert VARCHAR,
  _num_alert VARCHAR,
  _date_alert DATE,
  _link_alert VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE alerts
  SET type_alert = _type_alert,
      priority_alert = _priority_alert,
      confidentiality_alert = _confidentiality_alert,
      num_alert = _num_alert,
      date_alert = _date_alert,
      link_alert = _link_alert,
      id_user = _id_user
  WHERE id_alert = _id_alert
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Alert updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Alert not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update alert'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE ALERT
CREATE OR REPLACE FUNCTION delete_alert(
  _id_alert UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM alerts WHERE id_alert = _id_alert;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Alert deleted successfully',
      'id_alert', _id_alert
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Alert not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete alert'
    );
END;
$$ LANGUAGE plpgsql;

-- CREATE MONITORING
CREATE OR REPLACE FUNCTION create_monitoring(
  _id_monitoring UUID,
  _type_monitoring VARCHAR,
  _priority_monitoring VARCHAR,
  _confidentiality_monitoring VARCHAR,
  _num_monitoring VARCHAR,
  _date_monitoring DATE,
  _link_monitoring VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO monitoring (id_monitoring, type_monitoring, priority_monitoring, confidentiality_monitoring, num_monitoring, date_monitoring, link_monitoring, id_user)
  VALUES (_id_monitoring, _type_monitoring, _priority_monitoring, _confidentiality_monitoring, _num_monitoring, _date_monitoring, _link_monitoring, _id_user)
  RETURNING id_monitoring INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Monitoring created successfully',
    'id_monitoring', new_id,
    'type_monitoring', _type_monitoring,
    'priority_monitoring', _priority_monitoring,
    'confidentiality_monitoring', _confidentiality_monitoring,
    'num_monitoring', _num_monitoring,
    'date_monitoring', _date_monitoring,
    'link_monitoring', _link_monitoring,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create monitoring'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE MONITORING
CREATE OR REPLACE FUNCTION update_monitoring(
  _id_monitoring UUID,
  _type_monitoring VARCHAR,
  _priority_monitoring VARCHAR,
  _confidentiality_monitoring VARCHAR,
  _num_monitoring VARCHAR,
  _date_monitoring DATE,
  _link_monitoring VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE monitoring
  SET type_monitoring = _type_monitoring,
      priority_monitoring = _priority_monitoring,
      confidentiality_monitoring = _confidentiality_monitoring,
      num_monitoring = _num_monitoring,
      date_monitoring = _date_monitoring,
      link_monitoring = _link_monitoring,
      id_user = _id_user
  WHERE id_monitoring = _id_monitoring
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Monitoring updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Monitoring not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update monitoring'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE MONITORING
CREATE OR REPLACE FUNCTION delete_monitoring(
  _id_monitoring UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM monitoring WHERE id_monitoring = _id_monitoring;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Monitoring deleted successfully',
      'id_monitoring', _id_monitoring
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Monitoring not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete monitoring'
    );
END;
$$ LANGUAGE plpgsql;

-- CREATE NGO WEEKLY
CREATE OR REPLACE FUNCTION create_ngo_weekly(
  _id_ngo_weekly UUID,
  _num_ngo_weekly VARCHAR,
  _date_ngo_weekly DATE,
  _link_ngo_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO ngo_weekly (id_ngo_weekly, num_ngo_weekly, date_ngo_weekly, link_ngo_weekly, id_user)
  VALUES (_id_ngo_weekly, _num_ngo_weekly, _date_ngo_weekly, _link_ngo_weekly, _id_user)
  RETURNING id_ngo_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'NGO Weekly created successfully',
    'id_ngo_weekly', new_id,
    'num_ngo_weekly', _num_ngo_weekly,
    'date_ngo_weekly', _date_ngo_weekly,
    'link_ngo_weekly', _link_ngo_weekly,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create NGO Weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE NGO WEEKLY
CREATE OR REPLACE FUNCTION update_ngo_weekly(
  _id_ngo_weekly UUID,
  _num_ngo_weekly VARCHAR,
  _date_ngo_weekly DATE,
  _link_ngo_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE ngo_weekly
  SET num_ngo_weekly = _num_ngo_weekly,
      date_ngo_weekly = _date_ngo_weekly,
      link_ngo_weekly = _link_ngo_weekly,
      id_user = _id_user
  WHERE id_ngo_weekly = _id_ngo_weekly
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'NGO Weekly updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'NGO Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update NGO Weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE NGO WEEKLY
CREATE OR REPLACE FUNCTION delete_ngo_weekly(
  _id_ngo_weekly UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM ngo_weekly WHERE id_ngo_weekly = _id_ngo_weekly;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'NGO Weekly deleted successfully',
      'id_ngo_weekly', _id_ngo_weekly
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'NGO Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete NGO Weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- CREATE DIARY
CREATE OR REPLACE FUNCTION create_special(
  _id_special UUID,
  _type_special VARCHAR,
  _priority_special VARCHAR,
  _confidentiality_special VARCHAR,
  _num_special VARCHAR,
  _date_special DATE,
  _issue_special VARCHAR,
  _link_special VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO specials (id_special, type_special, priority_special, confidentiality_special, num_special, date_special, link_special, id_user)
  VALUES (_id_special, _type_special, _priority_special, _confidentiality_special, _num_special, _date_special, _link_special, _id_user)
  RETURNING id_special INTO new_id;

  RETURN jsonb_build_object(
    'message', 'special created successfully',
    'id_special', new_id,
    'type_special', _type_special,
    'priority_special', _priority_special,
    'confidentiality_special', _confidentiality_special,
    'num_special', _num_special,
    'date_special', _date_special,
    'link_special', _link_special,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create special',
      'error', SQLERRM
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE special
CREATE OR REPLACE FUNCTION update_special(
  _id_special UUID,
  _type_special VARCHAR,
  _priority_special VARCHAR,
  _confidentiality_special VARCHAR,
  _num_special VARCHAR,
  _date_special DATE,
  _link_special VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE specials
  SET type_special = _type_special,
      priority_special = _priority_special,
      confidentiality_special = _confidentiality_special,
      num_special = _num_special,
      date_special = _date_special,
      link_special = _link_special,
      id_user = _id_user
  WHERE id_special = _id_special
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'special updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'special not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update special'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE special
CREATE OR REPLACE FUNCTION delete_special(
  _id_special UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM specials WHERE id_special = _id_special;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'special deleted successfully',
      'id_special', _id_special
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'special not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete special'
    );
END;
$$ LANGUAGE plpgsql;

-- CREATE SUNDAY
CREATE OR REPLACE FUNCTION create_sunday(
  _id_sunday UUID,
  _type_sunday VARCHAR,
  _priority_sunday VARCHAR,
  _confidentiality_sunday VARCHAR,
  _num_sunday VARCHAR,
  _date_sunday DATE,
  _issue_sunday VARCHAR,
  _link_sunday VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO sundays (id_sunday, type_sunday, priority_sunday, confidentiality_sunday, num_sunday, date_sunday, link_sunday, id_user)
  VALUES (_id_sunday, _type_sunday, _priority_sunday, _confidentiality_sunday, _num_sunday, _date_sunday, _link_sunday, _id_user)
  RETURNING id_sunday INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Sunday created successfully',
    'id_sunday', new_id,
    'type_sunday', _type_sunday,
    'priority_sunday', _priority_sunday,
    'confidentiality_sunday', _confidentiality_sunday,
    'num_sunday', _num_sunday,
    'date_sunday', _date_sunday,
    'link_sunday', _link_sunday,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create Sunday'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE SUNDAY
CREATE OR REPLACE FUNCTION update_sunday(
  _id_sunday UUID,
  _type_sunday VARCHAR,
  _priority_sunday VARCHAR,
  _confidentiality_sunday VARCHAR,
  _num_sunday VARCHAR,
  _date_sunday DATE,
  _link_sunday VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE sundays
  SET type_sunday = _type_sunday,
      priority_sunday = _priority_sunday,
      confidentiality_sunday = _confidentiality_sunday,
      num_sunday = _num_sunday,
      date_sunday = _date_sunday,
      link_sunday = _link_sunday,
      id_user = _id_user
  WHERE id_sunday = _id_sunday
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Sunday updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Sunday not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update Sunday'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE SUNDAY
CREATE OR REPLACE FUNCTION delete_sunday(
  _id_sunday UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM sundays WHERE id_sunday = _id_sunday;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Sunday deleted successfully',
      'id_sunday', _id_sunday
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Sunday not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete Sunday'
    );
END;
$$ LANGUAGE plpgsql;

-- CREATE WEEKLY
CREATE OR REPLACE FUNCTION create_weekly(
  _id_weekly UUID,
  _num_weekly VARCHAR,
  _date_weekly DATE,
  _link_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  new_id UUID;
BEGIN
  INSERT INTO weekly (id_weekly, num_weekly, date_weekly, link_weekly, id_user)
  VALUES (_id_weekly, _num_weekly, _date_weekly, _link_weekly, _id_user)
  RETURNING id_weekly INTO new_id;

  RETURN jsonb_build_object(
    'message', 'Weekly created successfully',
    'id_weekly', new_id,
    'num_weekly', _num_weekly,
    'date_weekly', _date_weekly,
    'link_weekly', _link_weekly,
    'id_user', _id_user
  );
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to create weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- UPDATE WEEKLY
CREATE OR REPLACE FUNCTION update_weekly(
  _id_weekly UUID,
  _num_weekly VARCHAR,
  _date_weekly DATE,
  _link_weekly VARCHAR,
  _id_user UUID
) RETURNS jsonb AS $$
DECLARE
  updated_row RECORD;
BEGIN
  UPDATE weekly
  SET num_weekly = _num_weekly,
      date_weekly = _date_weekly,
      link_weekly = _link_weekly,
      id_user = _id_user
  WHERE id_weekly = _id_weekly
  RETURNING * INTO updated_row;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Weekly updated successfully',
      'data', row_to_json(updated_row)
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to update weekly'
    );
END;
$$ LANGUAGE plpgsql;

-- DELETE WEEKLY
CREATE OR REPLACE FUNCTION delete_weekly(
  _id_weekly UUID
) RETURNS jsonb AS $$
BEGIN
  DELETE FROM weekly WHERE id_weekly = _id_weekly;

  IF FOUND THEN
    RETURN jsonb_build_object(
      'message', 'Weekly deleted successfully',
      'id_weekly', _id_weekly
    );
  ELSE
    RETURN jsonb_build_object(
      'message', 'Weekly not found'
    );
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RETURN jsonb_build_object(
      'message', 'Failed to delete weekly'
    );
END;
$$ LANGUAGE plpgsql;

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

--TRIGGERS

--AUDIT CREATE USER
CREATE OR REPLACE FUNCTION tg_create_user()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_users (id_user, action_audit_user, table_audit_user, last_audit_user, new_audit_user)
    SELECT NEW.id_user, 'INSERTAR', 'USER', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_user
AFTER INSERT ON users
FOR EACH ROW EXECUTE PROCEDURE tg_create_user();

--Audit update user
CREATE OR REPLACE FUNCTION tg_update_user()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_users (id_user, action_audit_user, table_audit_user, last_audit_user, new_audit_user)
    SELECT NEW.id_user, 'ACTUALIZAR', 'USER', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_user
AFTER UPDATE ON users
FOR EACH ROW EXECUTE PROCEDURE tg_update_user();

--Audit delete user
CREATE OR REPLACE FUNCTION tg_delete_user()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_users (id_user, action_audit_user, table_audit_user, last_audit_user, new_audit_user)
    SELECT OLD.id_user, 'ELIMINAR', 'USER', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_user
AFTER DELETE ON users
FOR EACH ROW EXECUTE PROCEDURE tg_delete_user();

--AUDIT CREATE ALERTS
CREATE OR REPLACE FUNCTION tg_create_alert()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'ALERTA', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_alert
AFTER INSERT ON alerts
FOR EACH ROW EXECUTE PROCEDURE tg_create_alert();

--AUDIT UPDATE ALERTS
CREATE OR REPLACE FUNCTION tg_update_alert()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'ALERTA', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_alert
AFTER UPDATE ON alerts
FOR EACH ROW EXECUTE PROCEDURE tg_update_alert();

--AUDIT DELETE ALERTS
CREATE OR REPLACE FUNCTION tg_delete_alert()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'ALERTA', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_alert
AFTER DELETE ON alerts
FOR EACH ROW EXECUTE PROCEDURE tg_delete_alert();

--AUDIT CREATE DIARY
CREATE OR REPLACE FUNCTION tg_create_special()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'ESPECIAL', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_special
AFTER INSERT ON specials
FOR EACH ROW EXECUTE PROCEDURE tg_create_special();

--AUDIT UPDATE_special
CREATE OR REPLACE FUNCTION tg_update_special()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'ESPECIAL', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_special
AFTER UPDATE ON specials
FOR EACH ROW EXECUTE PROCEDURE tg_update_special();

--AUDIT DELETE_special
CREATE OR REPLACE FUNCTION tg_delete_special()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'ESPECIAL', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_special
AFTER DELETE ON specials
FOR EACH ROW EXECUTE PROCEDURE tg_delete_special();

--AUDIT CREATE MONITORING
CREATE OR REPLACE FUNCTION tg_create_monitoring()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'MONITOREO', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_monitoring
AFTER INSERT ON monitoring
FOR EACH ROW EXECUTE PROCEDURE tg_create_monitoring();

--AUDIT UPDATE MONITORING
CREATE OR REPLACE FUNCTION tg_update_monitoring()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'MONITOREO', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_monitoring
AFTER UPDATE ON monitoring
FOR EACH ROW EXECUTE PROCEDURE tg_update_monitoring();

--AUDIT DELETE MONITORING
CREATE OR REPLACE FUNCTION tg_delete_monitoring()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'MONITOREO', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_monitoring
AFTER DELETE ON monitoring
FOR EACH ROW EXECUTE PROCEDURE tg_delete_monitoring();

--AUDIT CREATE NGO WEEKLY
CREATE OR REPLACE FUNCTION tg_create_ngo_weekly()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'SEMANAL ONG', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_ngo_weekly
AFTER INSERT ON ngo_weekly
FOR EACH ROW EXECUTE PROCEDURE tg_create_ngo_weekly();

--AUDIT UPDATE NGO WEEKLY
CREATE OR REPLACE FUNCTION tg_update_ngo_weekly()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'SEMANAL ONG', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_ngo_weekly
AFTER UPDATE ON ngo_weekly
FOR EACH ROW EXECUTE PROCEDURE tg_update_ngo_weekly();

--AUDIT DELETE NGO WEEKLY
CREATE OR REPLACE FUNCTION tg_delete_ngo_weekly()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'SEMANAL ONG', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_ngo_weekly
AFTER DELETE ON ngo_weekly
FOR EACH ROW EXECUTE PROCEDURE tg_delete_ngo_weekly();

--AUDIT CREATE SUNDAYS
CREATE OR REPLACE FUNCTION tg_create_sunday()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'DOMINICAL', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_sunday
AFTER INSERT ON sundays
FOR EACH ROW EXECUTE PROCEDURE tg_create_sunday();

--AUDIT UPDATE SUNDAYS
CREATE OR REPLACE FUNCTION tg_update_sunday()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'DOMINICAL', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_sunday
AFTER UPDATE ON sundays
FOR EACH ROW EXECUTE PROCEDURE tg_update_sunday();

--AUDIT DELETE SUNDAYS
CREATE OR REPLACE FUNCTION tg_delete_sunday()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'DOMINICAL', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_sunday
AFTER DELETE ON sundays
FOR EACH ROW EXECUTE PROCEDURE tg_delete_sunday();

--AUDIT CREATE WEEKLY
CREATE OR REPLACE FUNCTION tg_create_weekly()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'SEMANAL', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_weekly
AFTER INSERT ON weekly
FOR EACH ROW EXECUTE PROCEDURE tg_create_weekly();

--AUDIT UPDATE WEEKLY
CREATE OR REPLACE FUNCTION tg_update_weekly()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'SEMANAL', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_weekly
AFTER UPDATE ON weekly
FOR EACH ROW EXECUTE PROCEDURE tg_update_weekly();

--AUDIT DELETE WEEKLY
CREATE OR REPLACE FUNCTION tg_delete_weekly()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'SEMANAL', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_weekly
AFTER DELETE ON weekly
FOR EACH ROW EXECUTE PROCEDURE tg_delete_weekly();
