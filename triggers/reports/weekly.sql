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
  RETURN OLD;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_weekly
AFTER DELETE ON weekly
FOR EACH ROW EXECUTE PROCEDURE tg_delete_weekly();
