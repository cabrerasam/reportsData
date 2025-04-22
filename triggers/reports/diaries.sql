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
