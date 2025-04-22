--AUDIT CREATE USER
CREATE OR REPLACE FUNCTION tg_create_individual()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_subjects (id_user, action_audit_subject, table_audit_subject, last_audit_subject, new_audit_subject)
    SELECT NEW.id_user, 'INSERTAR', 'INDIVIDUAL', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_individual
AFTER INSERT ON individuals
FOR EACH ROW EXECUTE PROCEDURE tg_create_individual();

--Audit update subject
CREATE OR REPLACE FUNCTION tg_update_individual()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_subjects (id_user, action_audit_subject, table_audit_subject, last_audit_subject, new_audit_subject)
    SELECT NEW.id_user, 'ACTUALIZAR', 'INDIVIDUAL', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_individual
AFTER UPDATE ON individuals
FOR EACH ROW EXECUTE PROCEDURE tg_update_individual();

--Audit delete subject
CREATE OR REPLACE FUNCTION tg_delete_individual()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_subjects (id_user, action_audit_subject, table_audit_subject, last_audit_subject, new_audit_subject)
    SELECT OLD.id_user, 'ELIMINAR', 'INDIVIDUAL', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_individual
AFTER DELETE ON individuals
FOR EACH ROW EXECUTE PROCEDURE tg_delete_individual();