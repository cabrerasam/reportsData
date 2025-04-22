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
