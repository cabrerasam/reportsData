--AUDIT CREATE REPORTS
CREATE OR REPLACE FUNCTION tg_create_reports()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'INFORME', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_reports
AFTER INSERT ON reports
FOR EACH ROW EXECUTE PROCEDURE tg_create_reports();

--AUDIT UPDATE REPORTS
CREATE OR REPLACE FUNCTION tg_update_reports()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'INFORME', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_reports
AFTER UPDATE ON reports
FOR EACH ROW EXECUTE PROCEDURE tg_update_reports();

--AUDIT DELETE REPORTS
CREATE OR REPLACE FUNCTION tg_delete_reports()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'INFORME', row_to_json(OLD.*), null;
  END IF;
  RETURN OLD;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_reports
AFTER DELETE ON reports
FOR EACH ROW EXECUTE PROCEDURE tg_delete_reports();
