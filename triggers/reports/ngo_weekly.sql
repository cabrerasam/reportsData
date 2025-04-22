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
