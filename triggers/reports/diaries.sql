--AUDIT CREATE DIARY
CREATE OR REPLACE FUNCTION tg_create_diary()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'INSERTAR', 'DIARIO', row_to_json(NEW.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_create_diary
AFTER INSERT ON diaries
FOR EACH ROW EXECUTE PROCEDURE tg_create_diary();

--AUDIT UPDATE DIARY
CREATE OR REPLACE FUNCTION tg_update_diary()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT NEW.id_user, 'ACTUALIZAR', 'DIARIO', row_to_json(OLD.*), row_to_json(NEW.*);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_update_diary
AFTER UPDATE ON diaries
FOR EACH ROW EXECUTE PROCEDURE tg_update_diary();

--AUDIT DELETE DIARY
CREATE OR REPLACE FUNCTION tg_delete_diary()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'DELETE' THEN
    INSERT INTO audit_reports (id_user, action_audit_report, table_audit_report, last_audit_report, new_audit_report)
    SELECT OLD.id_user, 'ELIMINAR', 'DIARIO', row_to_json(OLD.*), null;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgSQL;

CREATE TRIGGER tg_delete_diary
AFTER DELETE ON diaries
FOR EACH ROW EXECUTE PROCEDURE tg_delete_diary();
