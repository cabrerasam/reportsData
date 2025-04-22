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

--REPORTS

--DIARY
CREATE TABLE specials (
	id_special UUID DEFAULT gen_random_uuid() NOT NULL,
	create_special timestamp DEFAULT NOW(),
	type_special varchar(255) NOT NULL,
	priority_special varchar(255) NOT NULL,
	confidentiality_special varchar(255) NOT NULL,
	num_special varchar(255) NOT NULL,
	date_special DATE NOT NULL,
	link_special varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT specials_pk PRIMARY KEY (id_special),
	CONSTRAINT specials_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
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

--SUNDAY
CREATE TABLE sundays (
	id_sunday UUID DEFAULT gen_random_uuid() NOT NULL,
	create_sunday timestamp DEFAULT NOW(),
	type_sunday varchar(255) NOT NULL,
	priority_sunday varchar(255) NOT NULL,
	confidentiality_sunday varchar(255) NOT NULL,
	num_sunday varchar(255) NOT NULL,
	date_sunday DATE NOT NULL,
	link_sunday varchar(255) NOT NULL,
	id_user UUID NOT NULL,
	CONSTRAINT sundays_pk PRIMARY KEY (id_sunday),
	CONSTRAINT sundays_users_fk FOREIGN KEY (id_user) REFERENCES users (id_user)
);

--ISSUES REPORT
CREATE TABLE issues_report (
	id_issues_report UUID DEFAULT gen_random_uuid() NOT NULL,
	create_issues_report timestamp DEFAULT NOW(),
	issue_report varchar(255) NOT NULL,
	tags_issues_report varchar(255) NOT NULL,
	id_report UUID NOT NULL,
	CONSTRAINT issues_report_pk PRIMARY KEY (id_issues_report)
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
