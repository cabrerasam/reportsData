--AUDIT CREATE USER
CREATE OR REPLACE FUNCTION tg_create_collective()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_subjects (id_user, action_audit_subject, table_audit_subject, last_audit_subject, new_audit_subject)
    SELECT NEW.id_user, 'INSERTAR', 'COLECTIVO', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_collective
AFTER INSERT ON collectives
FOR EACH ROW EXECUTE PROCEDURE tg_create_collective();

--Audit update subject
CREATE OR REPLACE FUNCTION tg_update_collective()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_subjects (id_user, action_audit_subject, table_audit_subject, last_audit_subject, new_audit_subject)
    SELECT NEW.id_user, 'ACTUALIZAR', 'COLECTIVO', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_collective
AFTER UPDATE ON collectives
FOR EACH ROW EXECUTE PROCEDURE tg_update_collective();

--Audit delete subject
CREATE OR REPLACE FUNCTION tg_delete_collective()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_subjects (id_user, action_audit_subject, table_audit_subject, last_audit_subject, new_audit_subject)
    SELECT OLD.id_user, 'ELIMINAR', 'COLECTIVO', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_collective
AFTER DELETE ON collectives
FOR EACH ROW EXECUTE PROCEDURE tg_delete_collective();