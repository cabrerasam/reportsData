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