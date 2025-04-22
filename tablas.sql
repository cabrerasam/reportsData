CREATE EXTENSION pgcrypto;

--TABLAS USUARIOS--

--SUPER USER
CREATE TABLE super_user (
	id UUID DEFAULT gen_random_uuid() NOT NULL,
	name varchar(255) NOT NULL,
	password varchar(255) NOT NULL,
	CONSTRAINT super_user_pk PRIMARY KEY (id),
	CONSTRAINT super_user_uk UNIQUE (name)
);

--Areas
CREATE TABLE areas (
	id_area UUID DEFAULT gen_random_uuid() NOT NULL,
	create_area timestamp DEFAULT NOW(),
	name_area varchar(255) NOT NULL,
	id_super_user UUID,
	CONSTRAINT areas_pk PRIMARY KEY (id_area),
	CONSTRAINT areas_uk UNIQUE (name_area),
	CONSTRAINT areas_super_user_fk FOREIGN KEY (id_super_user) REFERENCES super_user (id)
);

--Roles
CREATE TABLE roles (
	id_role UUID DEFAULT gen_random_uuid() NOT NULL,
	create_role timestamp DEFAULT NOW(),
	name_role varchar(255) NOT NULL,
	id_super_user UUID,
	CONSTRAINT roles_pk PRIMARY KEY (id_role),
	CONSTRAINT roles_uk UNIQUE (name_role),
	CONSTRAINT roles_super_user_fk FOREIGN KEY (id_super_user) REFERENCES super_user (id)
);

--Region
CREATE TABLE regions (
	id_region UUID DEFAULT gen_random_uuid() NOT NULL,
	create_region timestamp DEFAULT NOW(),
	name_region varchar(255) NOT NULL,
	id_super_user UUID,
	CONSTRAINT regions_pk PRIMARY KEY (id_region),
	CONSTRAINT regions_uk UNIQUE (name_region),
	CONSTRAINT regions_super_user_fk FOREIGN KEY (id_super_user) REFERENCES super_user (id)
);

--USER
CREATE TABLE users (
	id_user UUID DEFAULT gen_random_uuid() NOT NULL,
	create_user timestamp DEFAULT NOW(),
	user_name varchar(255) NOT NULL,
	user_nick varchar(255) NOT NULL,
	password_user varchar(255) NOT NULL,
	id_area UUID NOT NULL,
	id_role UUID NOT NULL,
	id_region UUID NOT NULL,
	id_super_user UUID NOT NULL,
	CONSTRAINT users_pk PRIMARY KEY (id_user),
	CONSTRAINT users_uk UNIQUE (user_nick),
	CONSTRAINT users_areas_fk FOREIGN KEY (id_area) REFERENCES areas (id_area),
	CONSTRAINT users_roles_fk FOREIGN KEY (id_role) REFERENCES roles (id_role),
	CONSTRAINT users_regions_fk FOREIGN KEY (id_region) REFERENCES regions (id_region),
	CONSTRAINT users_super_user_fk FOREIGN KEY (id_super_user) REFERENCES super_user (id)
);

--TABLES SUBJECTS--

--INDIVIDUALS
CREATE TABLE individuals (
	id_individual UUID DEFAULT gen_random_uuid() NOT NULL,
	create_individual timestamp DEFAULT NOW(),
	name_individual varchar(255) NOT NULL,
	nationality_individual varchar(255) NOT NULL,
	birthdate_individual DATE NOT NULL,
	place_birth_individual varchar(255) NOT NULL,
	gender_individual varchar(255) NOT NULL,
	marital_status_individual varchar(255) NOT NULL,
	photo_individual varchar(255) NOT NULL,
	party_individual varchar(255) NOT NULL,
	work_individual varchar(255) NOT NULL,
	education_individual varchar(255) NOT NULL,
	email_individual varchar(255) NOT NULL,
	phone_individual varchar(255) NOT NULL,
	networks_individual json NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT individuals_pk PRIMARY KEY (id_individual),
	CONSTRAINT individuals_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--COLLECTIVES
CREATE TABLE collectives (
	id_collective UUID DEFAULT gen_random_uuid() NOT NULL,
	create_collective timestamp DEFAULT NOW(),
	name_collective varchar(255) NOT NULL,
	logo_collective varchar(255) NOT NULL,
	origin_collective varchar(255) NOT NULL,
	type_collective varchar(255) NOT NULL,
	headquarters_collective varchar(255) NOT NULL,
	description_collective text NOT NULL,
	mission_collective text NOT NULL,
	vision_collective text NOT NULL,
	network_collective json NOT NULL,
	inf_area_collective varchar(255) NOT NULL,
	financing_collective varchar(255) NOT NULL,
	personal_collective json NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT collectives_pk PRIMARY KEY (id_collective),
	CONSTRAINT collectives_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--SPEACHS
CREATE TABLE speachs (
	id_speach UUID DEFAULT gen_random_uuid() NOT NULL,
	create_speach timestamp DEFAULT NOW(),
	title_speach varchar(255) NOT NULL,
	speach varchar(255) NOT NULL,
	date_speach DATE NOT NULL,
	id_individual UUID NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT speachs_pk PRIMARY KEY (id_speach),
	CONSTRAINT speachs_individuals_fk FOREIGN KEY (id_individual) REFERENCES individuals (id_individual),
	CONSTRAINT speachs_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--WORKS
CREATE TABLE works (
	id_work UUID DEFAULT gen_random_uuid() NOT NULL,
	create_work timestamp DEFAULT NOW(),
	work varchar(255) NOT NULL,
	id_individual UUID NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT works_pk PRIMARY KEY (id_work),
	CONSTRAINT works_individuals_fk FOREIGN KEY (id_individual) REFERENCES individuals (id_individual),
	CONSTRAINT works_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--ASSOCIATION
CREATE TABLE associations (
	id_association UUID DEFAULT gen_random_uuid() NOT NULL,
	create_association timestamp DEFAULT NOW(),
	association varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT associations_pk PRIMARY KEY (id_association),
	CONSTRAINT associations_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--REPORTS

--DIARY
CREATE TABLE diaries (
	id_diary UUID DEFAULT gen_random_uuid() NOT NULL,
	create_diary timestamp DEFAULT NOW(),
	type_diary varchar(255) NOT NULL,
	priority_diary varchar(255) NOT NULL,
	confidentiality_diary varchar(255) NOT NULL,
	num_diary varchar(255) NOT NULL,
	date_diary DATE NOT NULL,
	issue_diary varchar(255) NOT NULL,
	link_diary varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT diaries_pk PRIMARY KEY (id_diary),
	CONSTRAINT diaries_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--MONITORING
CREATE TABLE monitoring (
	id_monitoring UUID DEFAULT gen_random_uuid() NOT NULL,
	create_monitoring timestamp DEFAULT NOW(),
	type_monitoring varchar(255) NOT NULL,
	priority_monitoring varchar(255) NOT NULL,
	confidentiality_monitoring varchar(255) NOT NULL,
	num_monitoring varchar(255) NOT NULL,
	date_monitoring DATE NOT NULL,
	link_monitoring varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT monitoring_pk PRIMARY KEY (id_monitoring),
	CONSTRAINT monitoring_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--ALERT MONITORING
CREATE TABLE alerts (
	id_alert UUID DEFAULT gen_random_uuid() NOT NULL,
	create_alert timestamp DEFAULT NOW(),
	type_alert varchar(255) NOT NULL,
	priority_alert varchar(255) NOT NULL,
	confidentiality_alert varchar(255) NOT NULL,
	num_alert varchar(255) NOT NULL,
	date_alert DATE NOT NULL,
	issue_alert varchar(255) NOT NULL,
	link_alert varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT alerts_pk PRIMARY KEY (id_alert),
	CONSTRAINT alerts_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--WEEKLY
CREATE TABLE weekly (
	id_weekly UUID DEFAULT gen_random_uuid() NOT NULL,
	create_weekly timestamp DEFAULT NOW(),
	num_weekly varchar(255) NOT NULL,
	date_weekly DATE NOT NULL,
	link_weekly varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT weekly_pk PRIMARY KEY (id_weekly),
	CONSTRAINT weekly_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--NGO WEEKLY
CREATE TABLE ngo_weekly (
	id_ngo_weekly UUID DEFAULT gen_random_uuid() NOT NULL,
	create_ngo_weekly timestamp DEFAULT NOW(),
	num_ngo_weekly varchar(255) NOT NULL,
	date_ngo_weekly DATE NOT NULL,
	link_ngo_weekly varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT ngo_weekly_pk PRIMARY KEY (id_ngo_weekly),
	CONSTRAINT ngo_weekly_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--ISSUES REPORT
CREATE TABLE issues_report (
	id_issues_report UUID DEFAULT gen_random_uuid() NOT NULL,
	create_issues_report timestamp DEFAULT NOW(),
	issue_report varchar(255) NOT NULL,
	intensity_issues_report varchar(255) NOT NULL,
	id_report UUID NOT NULL,
	CONSTRAINT issues_report_pk PRIMARY KEY (id_issues_report)
);

--SUNDAY
CREATE TABLE sundays (
	id_sunday UUID DEFAULT gen_random_uuid() NOT NULL,
	create_sunday timestamp DEFAULT NOW(),
	type_sunday varchar(255) NOT NULL,
	priority_sunday varchar(255) NOT NULL,
	confidentiality_sunday varchar(255) NOT NULL,
	num_sunday varchar(255) NOT NULL,
	date_sunday DATE NOT NULL,
	issue_sunday varchar(255) NOT NULL,
	link_sunday varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT sundays_pk PRIMARY KEY (id_sunday),
	CONSTRAINT sundays_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--TABLES AUDIT
CREATE TABLE audit_users (
	id_audit_user UUID DEFAULT gen_random_uuid() NOT NULL,
	create_audit_user timestamp DEFAULT NOW(),
	action_audit_user varchar(255) NOT NULL,
	table_audit_user varchar(255) NOT NULL,
	last_audit_user json NOT NULL,
	new_audit_user json,
	id_user UUID NOT NULL,
	CONSTRAINT id_audit_user_pk PRIMARY KEY (id_audit_user)
);

CREATE TABLE audit_subjects (
	id_audit_subject UUID DEFAULT gen_random_uuid() NOT NULL,
	create_audit_subject timestamp DEFAULT NOW(),
	action_audit_subject varchar(255) NOT NULL,
	table_audit_subject varchar(255) NOT NULL,
	last_audit_subject json NOT NULL,
	new_audit_subject json,
	id_user UUID NOT NULL,
	CONSTRAINT id_audit_subject_pk PRIMARY KEY (id_audit_subject)
);

CREATE TABLE audit_reports (
	id_audit_report UUID DEFAULT gen_random_uuid() NOT NULL,
	create_audit_report timestamp DEFAULT NOW(),
	action_audit_report varchar(255) NOT NULL,
	table_audit_report varchar(255) NOT NULL,
	last_audit_report json NOT NULL,
	new_audit_report json,
	id_user UUID NOT NULL,
	CONSTRAINT id_audit_report_pk PRIMARY KEY (id_audit_report)
);

--INTERMEDIATE TABLES FOR MANY-TO-MANY RELATIONSHIPS

-- INDIVIDUALS-DIARIES
CREATE TABLE individuals_diaries (
	id_individual UUID NOT NULL,
	id_diary UUID NOT NULL,
	CONSTRAINT individuals_diaries_pk PRIMARY KEY (id_individual, id_diary)
);

-- INDIVIDUALS-MONITORING
CREATE TABLE individuals_monitoring (
	id_individual UUID NOT NULL,
	id_monitoring UUID NOT NULL,
	CONSTRAINT individuals_monitoring_pk PRIMARY KEY (id_individual, id_monitoring)
);

-- INDIVIDUALS-ALERTS
CREATE TABLE individuals_alerts (
	id_individual UUID NOT NULL,
	id_alert UUID NOT NULL,
	CONSTRAINT individuals_alerts_pk PRIMARY KEY (id_individual, id_alert)
);

-- INDIVIDUALS WEEKLY
CREATE TABLE individuals_weekly (
	id_individual UUID NOT NULL,
	id_weekly UUID NOT NULL,
	CONSTRAINT individuals_weekly_pk PRIMARY KEY (id_individual, id_weekly)
);

-- INDIVIDUALS-NGO WEEKLY
CREATE TABLE individuals_ngo_weekly (
	id_individual UUID NOT NULL,
	id_ngo_weekly UUID NOT NULL,
	CONSTRAINT individuals_ngo_weekly_pk PRIMARY KEY (id_individual, id_ngo_weekly)
);

-- INDIVIDUALS-SUNDAYS
CREATE TABLE individuals_sundays (
	id_individual UUID NOT NULL,
	id_sunday UUID NOT NULL,
	CONSTRAINT individuals_sundays_pk PRIMARY KEY (id_individual, id_sunday)
);

-- SUBJECTS-ASSOCIATIONS
CREATE TABLE subjects_associations (
	id_subject UUID NOT NULL,
	id_association UUID NOT NULL,
	CONSTRAINT subjects_associations_pk PRIMARY KEY (id_subject, id_association)
);

-- COLLECTIVES-DIARIES
CREATE TABLE collectives_diaries (
	id_collective UUID NOT NULL,
	id_diary UUID NOT NULL,
	CONSTRAINT collectives_diaries_pk PRIMARY KEY (id_collective, id_diary)
);

-- COLLECTIVES-MONITORING
CREATE TABLE collectives_monitoring (
	id_collective UUID NOT NULL,
	id_monitoring UUID NOT NULL,
	CONSTRAINT collectives_monitoring_pk PRIMARY KEY (id_collective, id_monitoring)
);

-- COLLECTIVES-ALERTS
CREATE TABLE collectives_alerts (
	id_collective UUID NOT NULL,
	id_alert UUID NOT NULL,
	CONSTRAINT collectives_alerts_pk PRIMARY KEY (id_collective, id_alert)
);

-- COLLECTIVES-WEEKLY
CREATE TABLE collectives_weekly (
	id_collective UUID NOT NULL,
	id_weekly UUID NOT NULL,
	CONSTRAINT collectives_weekly_pk PRIMARY KEY (id_collective, id_weekly)
);

-- COLLECTIVES-NGO WEEKLY
CREATE TABLE collectives_ngo_weekly (
	id_collective UUID NOT NULL,
	id_ngo_weekly UUID NOT NULL,
	CONSTRAINT collectives_ngo_weekly_pk PRIMARY KEY (id_collective, id_ngo_weekly)
);

-- COLLECTIVES-SUNDAYS
CREATE TABLE collectives_sundays (
	id_collective UUID NOT NULL,
	id_sunday UUID NOT NULL,
	CONSTRAINT collectives_sundays_pk PRIMARY KEY (id_collective, id_sunday)
);
