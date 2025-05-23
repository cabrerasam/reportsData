SELECT * FROM super_user;

SELECT create_super_user(
	'reportsData',
	'a1b2c3d4c0'
);

SELECT validate_super_user(
	'searchData',
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

--INDIVIDUALS
SELECT * FROM individuals;
SELECT * FROM audit_subjects;

SELECT create_individual(
	gen_random_uuid(),
	'Samuel Alejandro Alcazar',
	'Boliviano',
	'1984-07-07',
	'La Paz',
	'Masculino',
	'Casado',
	'https://ruined.dev/_next/image/?url=https%3A%2F%2Fruined.dev%2Fwp-content%2Fuploads%2F2022%2F07%2Farcane_viktor.jpg&w=1200&q=75',
	'MAS',
	'Programador',
	'Ingeniero en sistemas',
	'alcazar.samuel@gmail.com',
	'71208298',
	'{"facebook": "https://facebook.com/saalcazar", "twitter": "https://twitter.com/saalcazar"}',
	'8e659619-3a12-4d0e-ac92-d066c3bc747a'
);

SELECT update_individual(
	'edce428c-adfb-4857-a99a-9f54408decb4',
	'Samuel Alejandro Alcazar Cabrera',
	'Bolivianosss',
	'1984-07-14',
	'El Alto',
	'Masculino',
	'Viudo',
	'http://photo.net',
	'MAS-IPSP',
	'Diseñador',
	'Diseñador gráfico',
	'btv.samuel@gmail.com',
	'76714278',
	'{"facebook": "https://facebook.com/Samuel", "twitter": "https://twitter.com/saalcazar"}',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_individual(
	'edce428c-adfb-4857-a99a-9f54408decb4'
);

--COLLECTIVE
SELECT * FROM collectives;
SELECT * FROM audit_subjects;

SELECT create_collective(
	'MAS-IPSP',
	'Boliviana',
	'Partido político',
	'Cochabamba',
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc purus orci, euismod eget ex quis, sagittis consectetur lacus. Phasellus a tellus eleifend, blandit ante in, pharetra dolor. In pharetra finibus iaculis. Nunc vestibulum metus at justo ultrices, vel euismod dui interdum. Cras ac eros sed sem ullamcorper euismod vel eu nibh. Maecenas condimentum, lacus sit amet pretium mattis, mauris nunc ornare dui, sit amet commodo tortor nunc nec mauris. Integer et tincidunt nunc. Fusce tempor lacus vel quam convallis consectetur.',
	'Integer elit orci, fermentum ut pretium ut, cursus id augue. Suspendisse ut lectus nec nulla sollicitudin sagittis et eget lectus. Sed imperdiet blandit feugiat. Integer eu lacus pulvinar, venenatis velit blandit, condimentum mauris. Sed nulla massa, lacinia in lectus ac, malesuada facilisis purus. Donec feugiat metus et est tincidunt auctor. Proin sit amet tincidunt libero. Nam aliquet nisi sit amet dui interdum, faucibus fringilla felis pretium. Curabitur ut laoreet metus, sed suscipit nunc. Nulla pulvinar auctor dictum. Vestibulum ut placerat quam. Morbi vel pellentesque lorem. Sed ligula nibh, gravida ut nunc in, facilisis pulvinar metus. Vivamus vel faucibus metus. Etiam nec est et tortor luctus tincidunt tristique ut risus.',
	'{"facebook": "https://facebook.com/Samuel", "twitter": "https://twitter.com/saalcazar"}',
	'Área rural',
	'Aportes voluntarios',
	'{"jefe:": "Evo Morales", "vice": "Ramon Loayza"}',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_collective(
	'cbd3cef1-a67e-4aaa-9a23-d67f65bd62dd',
	'MAS-IPSP',
	'Boliviana',
	'Partido político',
	'Cochabamba',
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
	'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc purus orci, euismod eget ex quis, sagittis consectetur lacus. Phasellus a tellus eleifend, blandit ante in, pharetra dolor. In pharetra finibus iaculis. Nunc vestibulum metus at justo ultrices, vel euismod dui interdum. Cras ac eros sed sem ullamcorper euismod vel eu nibh. Maecenas condimentum, lacus sit amet pretium mattis, mauris nunc ornare dui, sit amet commodo tortor nunc nec mauris. Integer et tincidunt nunc. Fusce tempor lacus vel quam convallis consectetur.',
	'Integer elit orci, fermentum ut pretium ut, cursus id augue. Suspendisse ut lectus nec nulla sollicitudin sagittis et eget lectus. Sed imperdiet blandit feugiat. Integer eu lacus pulvinar, venenatis velit blandit, condimentum mauris. Sed nulla massa, lacinia in lectus ac, malesuada facilisis purus. Donec feugiat metus et est tincidunt auctor. Proin sit amet tincidunt libero. Nam aliquet nisi sit amet dui interdum, faucibus fringilla felis pretium. Curabitur ut laoreet metus, sed suscipit nunc. Nulla pulvinar auctor dictum. Vestibulum ut placerat quam. Morbi vel pellentesque lorem. Sed ligula nibh, gravida ut nunc in, facilisis pulvinar metus. Vivamus vel faucibus metus. Etiam nec est et tortor luctus tincidunt tristique ut risus.',
	'{"facebook": "https://facebook.com/Samuel", "twitter": "https://twitter.com/saalcazar"}',
	'Área rural',
	'Aportes voluntarios',
	'{"jefe:": "Periquito de los palotes", "vice": "Juancito Pinto"}'
);

SELECT delete_collective(
	'cbd3cef1-a67e-4aaa-9a23-d67f65bd62dd'
);

--SPEACH
SELECT * FROM speachs;

SELECT create_speach(
	gen_random_uuid(),
	'Por la madre tierra',
	'Dirección del discurso',
	'cdabc1d9-51a3-42fc-9774-0ab27a926cf7',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_speach(
	'59786df3-d8cf-4183-b78b-a22770b6bcab',
	'Dirección del discurso 2.0',
	'cbb286b9-ef00-46bd-a9c1-db1e80c15e8b',
	'9662a42c-615a-47a4-933a-bc309edd9eac'
);

SELECT delete_speach(
	'59786df3-d8cf-4183-b78b-a22770b6bcab'
)

--WORK
SELECT * FROM works;

SELECT create_work(
	'Embajador en Cuba',
	'cdabc1d9-51a3-42fc-9774-0ab27a926cf7',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_work(
	'ddcdd2bd-beca-422a-af22-fc4a2848e347',
	'Embajador en Rusia',
	'cbb286b9-ef00-46bd-a9c1-db1e80c15e8b',
	'9662a42c-615a-47a4-933a-bc309edd9eac'
);

SELECT delete_work(
	'ddcdd2bd-beca-422a-af22-fc4a2848e347'
);

--ASSOCIATION
SELECT * FROM associations;

SELECT create_association(
	gen_random_uuid(),
	'Pacto de unidad',
	'b4b23652-3a82-4d0d-a541-a1f88fd93f6f'
);

SELECT update_association(
	'd57125d9-f1fb-4efd-b4a3-1e8fe74fd41e',
	'Estado Mayor del Pueblo',
	'b4b23652-3a82-4d0d-a541-a1f88fd93f6f'
);

SELECT delete_association(
	'091de1df-d999-400d-a62a-72087a40e117'
);

SELECT insert_subjects_associations(
	'ef9c86c8-e5b0-4caf-9be1-7b17d74cd4c3',
	'd57125d9-f1fb-4efd-b4a3-1e8fe74fd41e'
)

--REPORTS

--DIARY
SELECT * FROM diaries;
SELECT * FROM audit_reports;

SELECT create_diary(
	'Resumen',
	'Media',
	'Alta',
	'15',
	'2024-11-11',
	'Golpe de estado, COB',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_diary(
	'766540e3-4d4f-42e2-a475-2781de60d1d7',
	'De todo un poco',
	'Alta',
	'Alta',
	'155',
	'2024-11-11',
	'Golpe de estado, COB',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_diary(
	'766540e3-4d4f-42e2-a475-2781de60d1d7'
);

--MONITORING
SELECT * FROM monitoring;
SELECT * FROM audit_reports;

SELECT create_monitoring(
	'Politica',
	'Media',
	'Media',
	'20',
	'2024-11-11',
	'Dirección del informe',
	'c7e30e65-92a9-4a15-bd4d-ab65c64073c8',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_monitoring(
	'cb570205-6fb5-4a7e-b7e8-b25f66032446',
	'Politica',
	'Alta',
	'Alta',
	'20',
	'2024-11-11',
	'Dirección del informe',
	'c7e30e65-92a9-4a15-bd4d-ab65c64073c8',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_monitoring(
	'cb570205-6fb5-4a7e-b7e8-b25f66032446'
);

--ALERT
SELECT * FROM alerts;
SELECT * FROM audit_reports;

SELECT create_alert(
	'Politica',
	'Media',
	'Media',
	'20',
	'2024-11-11',
	'COB, MAS, Arce',
	'Dirección del informe',
	'c7e30e65-92a9-4a15-bd4d-ab65c64073c8',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_alert(
	'62878e8f-86a4-4347-9569-52718b7c3e41',
	'Politica',
	'Alta',
	'Alta',
	'20',
	'2024-11-11',
	'COB, MAS, Arce',
	'Dirección del informe',
	'c7e30e65-92a9-4a15-bd4d-ab65c64073c8',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_alert(
	'62878e8f-86a4-4347-9569-52718b7c3e41'
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

--NGO WEEKLY
SELECT * FROM ngo_weekly;
SELECT * FROM audit_reports;

SELECT create_ngo_weekly(
	'20',
	'2024-11-11',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_ngo_weekly(
	'54c52817-21f0-4330-b56e-77bdc9e786b8',
	'35',
	'2024-11-11',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_ngo_weekly(
	'54c52817-21f0-4330-b56e-77bdc9e786b8'
);

--SUNDAY
SELECT * FROM sundays;
SELECT * FROM audit_reports;

SELECT create_sunday(
	'Política',
	'Media',
	'Alta',
	'15',
	'2024-11-11',
	'Golpe de estado, COB',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT update_sunday(
	'7136e942-ff07-45b3-9446-6c81cf2beabc',
	'De todo un poco',
	'Alta',
	'Alta',
	'155',
	'2024-11-11',
	'Golpe de estado, COB',
	'Dirección del informe',
	'be565884-17ad-4dbb-b649-b59b37d85f0c'
);

SELECT delete_sunday(
	'7136e942-ff07-45b3-9446-6c81cf2beabc'
);

SELECT * FROM issues_report;