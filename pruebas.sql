SELECT * FROM super_user;

SELECT create_super_user(
	'reportsData',
	'a1b2c3d4c0'
);

SELECT validate_super_user(
	'reportsData',
	'a1b2c3d4c0'
);

--AREAS
SELECT * FROM areas;

SELECT create_area(
	gen_random_uuid(),
	'Politica',
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

SELECT update_area(
	'c7e30e65-92a9-4a15-bd4d-ab65c64073c8',
	'Política',
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

SELECT delete_area(
	'08705333-cb6e-4f4b-8fad-1297162f1fda'
);

--ROLES
SELECT * FROM roles;
SELECT create_role(
	gen_random_uuid(),
	'Director',
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

SELECT update_role(
	'46ed3da4-c92f-4da4-844e-ac01fe97959f',
	'Director',
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

SELECT delete_role(
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

--REGIONS
SELECT * FROM regions;
SELECT create_region(
	gen_random_uuid(),
	'El Alto',
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

SELECT update_region(
	'b01994a9-3605-4aaf-bfdb-20bdefdfdd81',
	'La Paz',
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

SELECT delete_region(
	'b01994a9-3605-4aaf-bfdb-20bdefdfdd81'
);

--USERS
SELECT * FROM users;
SELECT * FROM audit_users;

SELECT validate_user(
	'cabreraSam',
	'a1b2c3d4c0'
)

SELECT create_user(
	gen_random_uuid(),
	'Alejandro Cabrera',
	'cabreraSam',
	'a1b2c3d4c0',
	'56328e57-8059-4446-a976-09f19d3b89b4',
	'b0f73d01-1435-4cb6-a362-c6a41fb9d70b',
	'ce34f46d-e226-4fae-8ec6-6867b76d86c6',
	'1df31daf-7851-4847-b88d-8dfa4d6cc92f'
);

SELECT update_user(
	'63a56041-76af-4d27-b327-29e63b834ea8',
	'Alejandro Alcazar Cabrera',
	'SaAlcazar',
	'a1b2c3d4c0',
	'dd74da3d-5330-453b-b97e-29e22196ca07',
	'f4175392-c139-4905-b8cc-ec015968f1a0',
	'8fe0dbf5-4d97-4886-8fdf-4781c64e54a4',
	'4fd4099a-949a-4f24-8adc-071f92f469fe'
);

SELECT delete_user(
	'56d70c8b-a4d7-4395-888b-0df26c804dc6'
);

--REPORTS
SELECT * FROM reports;
SELECT * FROM audit_reports;

SELECT create_report(
	'Politica',
	'Monitoreo',
	'Media',
	'Media',
	'20',
	'2024-11-11',
	'Dirección del informe',
	'c7e30e65-92a9-4a15-bd4d-ab65c64073c8',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_report(	
	'cb570205-6fb5-4a7e-b7e8-b25f66032446',
	'Politica',
	'Monitoreo',
	'Alta',
	'Alta',
	'20',
	'2024-11-11',
	'Dirección del informe',
	'c7e30e65-92a9-4a15-bd4d-ab65c64073c8',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_report(
	'cb570205-6fb5-4a7e-b7e8-b25f66032446'
);

--WEEKLY
SELECT * FROM weekly;
SELECT * FROM audit_reports;

SELECT create_weekly(
	'20',
	'2024-11-11',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_weekly(
	'04bda59c-2d67-4ca2-888a-f9d658ea68d0',
	'35',
	'2024-11-11',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_weekly(
	'04bda59c-2d67-4ca2-888a-f9d658ea68d0'
);

SELECT * FROM issues_report;