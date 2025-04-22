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
