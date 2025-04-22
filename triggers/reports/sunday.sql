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
