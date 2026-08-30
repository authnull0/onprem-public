CREATE SCHEMA IF NOT EXISTS did;

DROP TABLE IF EXISTS did.access_conf;
CREATE TABLE did.access_conf (
	user_name varchar(512) NULL,
	"access" varchar(512) NULL
);


DROP TABLE IF EXISTS did.account_group_rels;
CREATE TABLE did.account_group_rels (
	id bigserial NOT NULL,
	service_account_id int4 NOT NULL,
	endpoint_group_id int4 NOT NULL,
	CONSTRAINT account_group_rels_pkey PRIMARY KEY (id),
	CONSTRAINT account_group_rels_service_account_id_key UNIQUE (service_account_id)
);



DROP TABLE IF EXISTS did.active_directories;

CREATE TABLE did.active_directories (
	id serial4 NOT NULL,
	domain_id int8 NOT NULL,
	domain_name VARCHAR(255) NOT NULL,
	directory_name varchar(255) NOT NULL,
	dc1 varchar(255) NULL,
	dc2 varchar(255) NULL,
	policy_id int4 NULL,
	"serviceAccountDomain" varchar NULL,
	credential_rotation_policy_id int4 NULL,
	status varchar NULL,
	created_at timestamp NULL,
	last_sync_time timestamp NULL,
	updated_at timestamp NULL,
	port int4 NULL,
	"password" varchar(255) NULL,
	dc varchar(255) NULL,
	ad_host varchar(255) NULL,
	last_password_updated_time timestamp NULL,
	ad_mfa int4 NULL,
	ad_admin_username varchar NULL,
	identity_source varchar(50) NULL,
	integration_type varchar(50) NULL,
	sync_filter_groups varchar NULL,
	sync_filter_ous varchar NULL,
	CONSTRAINT active_directories_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.active_directory;

CREATE TABLE did.active_directory (
	id serial4 NOT NULL,
	directory_name varchar(255) NOT NULL,
	integration_type varchar(255) DEFAULT ''::character varying NOT NULL,
	domain_id int4 DEFAULT 0 NOT NULL,
	account_name varchar(255) DEFAULT ''::character varying NOT NULL,
	proxy_url text NULL,
	app_url text NULL,
	user_app_id int4 DEFAULT 0 NOT NULL,
	org_unit_id int4 DEFAULT 0 NOT NULL,
	device_id int4 DEFAULT 0 NOT NULL,
	users_count int4 DEFAULT 0 NOT NULL,
	group_count int4 DEFAULT 0 NOT NULL,
	status_agent varchar(255) DEFAULT ''::character varying NOT NULL,
	status_groups varchar(255) DEFAULT ''::character varying NOT NULL,
	status_users varchar(255) DEFAULT ''::character varying NOT NULL,
	CONSTRAINT active_directory_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_access_logs;

CREATE TABLE did.ad_access_logs (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	user_name varchar(255) NULL,
	domain_name varchar(255) NULL,
	log_description text NULL,
	destination_ip varchar(45) NULL,
	component varchar(255) NULL,
	status varchar(45) NULL,
	created_at int8 DEFAULT EXTRACT(epoch FROM now()) NULL,
	source_ip varchar(45) NULL,
	sub_component varchar(255) NULL,
	CONSTRAINT ad_access_logs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_attributes;

CREATE TABLE did.ad_attributes (
	id serial4 NOT NULL,
	ad_id int8 NOT NULL,
	directory_name varchar(255) DEFAULT ''::character varying NOT NULL,
	integration_type varchar(255) DEFAULT ''::character varying NOT NULL,
	account_name varchar(255) DEFAULT ''::character varying NOT NULL,
	proxy_url varchar(255) DEFAULT ''::character varying NOT NULL,
	app_url varchar(255) DEFAULT ''::character varying NOT NULL,
	user_app_id int4 DEFAULT 0 NOT NULL,
	org_unit_id int4 DEFAULT 0 NOT NULL,
	device_id int4 DEFAULT 0 NOT NULL,
	users_count int4 DEFAULT 0 NOT NULL,
	group_count int4 DEFAULT 0 NOT NULL,
	status_agent varchar(255) DEFAULT ''::character varying NULL,
	status_groups varchar(255) DEFAULT ''::character varying NULL,
	status_users varchar(255) DEFAULT ''::character varying NULL,
	CONSTRAINT ad_attributes_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_group_jobs;

CREATE TABLE did.ad_group_jobs (
	id serial4 NOT NULL,
	ad_id varchar NULL,
	ou varchar NULL,
	username varchar NULL,
	created_at varchar NULL,
	permission_type varchar NULL,
	permission_status varchar NULL,
	CONSTRAINT ad_group_jobs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_group_policy_events;

CREATE TABLE did.ad_group_policy_events (
	id serial4 NOT NULL,
	org_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	domain_id int4 NOT NULL,
	policy_id uuid NOT NULL,
	"action" varchar(255) NOT NULL,
	status varchar(255) NOT NULL,
	wallet_user varchar(255) NOT NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL
);

DROP TABLE IF EXISTS did.ad_gateways;

CREATE TABLE did.ad_gateways (
    id serial4 NOT NULL,
    org_id int4 NULL,
    tenant_id int4 NULL,
    domain_id int4 NULL,
    gateway_name varchar(255) NULL,
    gateway_ip varchar(255) NULL,
    gateway_port int4 NULL,
    status varchar(50) DEFAULT 'Active' NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT ad_gateways_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_mfa_provider_config;

CREATE TABLE did.ad_mfa_provider_config (
    id serial4 NOT NULL,
    org_id int4 NULL,
    tenant_id int4 NULL,
    provider varchar(255) DEFAULT 'expo' NULL,
    config jsonb NULL,
    status varchar(50) DEFAULT 'Active' NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    updated_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    CONSTRAINT ad_mfa_provider_config_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_groups;

CREATE TABLE did.ad_groups (
	id serial4 NOT NULL,
	ad_id int8 NOT NULL,
	parent_id int8 NULL,
	group_name varchar(255) NOT NULL,
	grouptype varchar NULL,
	CONSTRAINT ad_groups_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_logs_groups;

CREATE TABLE did.ad_logs_groups (
	id serial4 NOT NULL,
	ad_id varchar NULL,
	ou varchar NULL,
	username varchar NULL,
	created_at varchar NULL,
	source_ip varchar NULL,
	destination_ip varchar NULL,
	status varchar(512) DEFAULT 'Active'::character varying NULL,
	authentication_status varchar NULL,
	component varchar NULL,
	sub_component varchar NULL,
	CONSTRAINT ad_logs_groups_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_ous;

CREATE TABLE did.ad_ous (
	id serial4 NOT NULL,
	ad_id int8 NOT NULL,
	ou_name varchar(255) NOT NULL,
	CONSTRAINT ad_ous_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_shadow_group_mapping;

CREATE TABLE did.ad_shadow_group_mapping (
	id serial4 NOT NULL,
	orgid int4 NOT NULL,
	tenantid int4 NOT NULL,
	adid int4 NOT NULL,
	wallet_id int4 NOT NULL,
	group_source varchar(255) NOT NULL,
	shadow_group_name varchar(255) NOT NULL,
	group_name varchar(255) NOT NULL,
	policy_id uuid NULL,
	CONSTRAINT ad_shadow_group_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ad_user_group_mappings;

CREATE TABLE did.ad_user_group_mappings (
	ad_user_id int4 NOT NULL,
	ad_group_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.ad_user_ou_mappings;

CREATE TABLE did.ad_user_ou_mappings (
	ad_user_id int4 NOT NULL,
	ad_ou_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.ad_users;

CREATE TABLE did.ad_users (
	id serial4 NOT NULL,
	email_id text NULL,
	status text NULL,
	domain_id int8 NULL,
	tenant_id int8 NULL,
	cn text NULL,
	username text NULL,
	logoname text NULL,
	user_type text NULL,
	mfa_flag int8 NULL,
	last_password_updated_time timestamp NULL,
	business_phones text NULL,
	display_name text NULL,
	given_name text NULL,
	job_title text NULL,
	mail text NULL,
	mobile_phone text NULL,
	office_location text NULL,
	preferred_language text NULL,
	surname text NULL,
	user_principal_name text NULL,
	entra_id text NULL,
	org_id int8 NULL,
	groups text NULL,
	CONSTRAINT ad_users_entra_id_key UNIQUE (entra_id),
	CONSTRAINT aduser_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.agent_keys;

CREATE TABLE did.agent_keys (
	id serial4 NOT NULL,
	agent_name varchar(255) DEFAULT ''::character varying NOT NULL,
	agent_key varchar(255) DEFAULT ''::character varying NOT NULL,
	expiry timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	domain_id int4 NULL,
	CONSTRAINT agent_keys_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.agent_logs;

CREATE TABLE did.agent_logs (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	public_ip varchar(50) NULL,
	component varchar(100) NULL,
	log_message text NULL,
	host_name varchar NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	os varchar(255) NULL,
	CONSTRAINT agent_logs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.agents;

CREATE TABLE did.agents (
	id serial4 NOT NULL,
	machine_id varchar(255) NOT NULL,
	"name" varchar(255) NULL,
	tags jsonb NULL,
	"role" varchar(100) NULL,
	"token" text NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT agents_machine_id_key UNIQUE (machine_id),
	CONSTRAINT agents_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.app_group_mapping;

CREATE TABLE did.app_group_mapping (
	id serial4 NOT NULL,
	group_id int4 NOT NULL,
	app_id int4 NOT NULL,
	CONSTRAINT app_group_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.apps;

CREATE TABLE did.apps (
	app_id serial4 NOT NULL,
	app_name varchar(255) NOT NULL,
	logo varchar(255) NOT NULL,
	type_of_regn varchar(255) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	app_url text NOT NULL,
	domain_id varchar(255) DEFAULT ''::character varying NOT NULL,
	fieldmappings text NOT NULL,
	CONSTRAINT apps_pkey PRIMARY KEY (app_id)
);

DROP TABLE IF EXISTS did.attribute_types;

CREATE TABLE did.attribute_types (
	id serial4 NOT NULL,
	attribute_type varchar(50) NULL,
	CONSTRAINT attribute_types_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.audit_log;

CREATE TABLE did.audit_log (
	id serial4 NOT NULL,
	user_id int4 NOT NULL,
	email_id varchar(255) NOT NULL,
	browser varchar(255) NOT NULL,
	user_agent varchar(255) NOT NULL,
	session_time varchar(255) NOT NULL,
	session_length varchar(255) NOT NULL,
	auth_type varchar(255) NOT NULL,
	device_id int4 NOT NULL,
	CONSTRAINT audit_log_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.auth_log_entries;

CREATE TABLE did.auth_log_entries (
	id serial4 NOT NULL,
	"timestamp" varchar NULL,
	source_ip varchar NULL,
	service_name varchar NULL,
	authentication varchar NULL,
	destination_ip varchar NULL,
	"user" varchar NULL,
	protocol varchar NULL,
	CONSTRAINT auth_log_entries_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.auth_logs;

CREATE TABLE did.auth_logs (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	org_id int8 NULL,
	tenant_id int8 NULL,
	log_type text NULL,
	os text NULL,
	ad_user text NULL,
	ad_user_type text NULL,
	ad_user_match text NULL,
	ad_domain text NULL,
	ad_ou text NULL,
	source_endpoint text NULL,
	source_endpoint_type text NULL,
	source_endpoint_match text NULL,
	destination_endpoint text NULL,
	destination_endpoint_type text NULL,
	destination_endpoint_match text NULL,
	endpoint_user text NULL,
	endpoint_user_type text NULL,
	endpoint_user_match text NULL,
	access_medium text NULL,
	protocol text NULL,
	"timestamp" int4 NULL,
	login_status text NULL,
	sam_account_name text NULL,
	destination_endpoint_ip text NULL,
	source_endpoint_ip varchar NULL,
	CONSTRAINT auth_logs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.auth_log;

CREATE TABLE did.auth_log (
    id serial4 NOT NULL,
    tenant_id int4 NULL,
    org_id int4 NULL,
    username varchar(255) NULL,
    domain_name varchar(255) NULL,
    log_description text NULL,
    destination_ip varchar(45) NULL,
    component varchar(255) NULL,
    status varchar(45) NULL,
    created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
    source_ip varchar(45) NULL,
    sub_component varchar(255) NULL,
	ts_unix_ms bigint DEFAULT EXTRACT(epoch FROM now())::bigint NULL,
	gateway_id varchar(255) NULL,
	correlation_id varchar(255) NULL,
    protocol varchar(50) NULL,
    principal varchar(255) NULL,
    realm varchar(255) NULL,
    service_spn varchar(255) NULL,
    client_ip varchar(45) NULL,
    decision varchar(50) NULL,
    reason varchar(255) NULL,
    upstream_error_code int4 NULL,
    challenge_id varchar(255) NULL,
    CONSTRAINT auth_log_pkey PRIMARY KEY (id),
    CONSTRAINT auth_log_unique UNIQUE (gateway_id, correlation_id, decision)
);


DROP TABLE IF EXISTS did.auth_policies;

CREATE TABLE did.auth_policies (
	id int4 GENERATED ALWAYS AS IDENTITY( INCREMENT BY 1 MINVALUE 1 MAXVALUE 2147483647 START 1 CACHE 1 NO CYCLE) NOT NULL,
	org_id int8 NULL,
	tenant_id int8 NULL,
	policy_name text NULL,
	policy_type text NULL,
	os text NULL,
	ad_user text NULL,
	ad_user_type text NULL,
	ad_user_match text NULL,
	ad_domain text NULL,
	ad_ou text NULL,
	source_endpoint text NULL,
	source_endpoint_type text NULL,
	source_endpoint_match text NULL,
	destination_endpoint text NULL,
	destination_endpoint_type text NULL,
	destination_endpoint_match text NULL,
	endpoint_user text NULL,
	endpoint_user_type text NULL,
	endpoint_user_match text NULL,
	access_medium text NULL,
	protocol text NULL,
	"timestamp" int4 NULL,
	policy_status text NULL,
	sam_account_name bool NULL,
	created_by int8 NULL,
	updated_by int8 NULL,
	auth_count int8 DEFAULT 1 NULL,
	updated_at int4 NULL,
	policy_flow varchar(8) NULL,
	wallet_users varchar(1024) NULL,
	CONSTRAINT auth_policies_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.auth_policy_json;

CREATE TABLE did.auth_policy_json (
	id uuid NULL,
	policy_name varchar NULL,
	policy_type varchar NULL,
	policy_json jsonb NULL,
	status varchar NULL,
	policy_invokation_count varchar NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL,
	created_by varchar NULL,
	updated_by varchar NULL,
	"version" int4 NULL,
	parent_id uuid NULL,
	generated_by varchar(10) DEFAULT 'Manual'::character varying NOT NULL,
	priority int4 NULL,
	is_baseline bool NULL DEFAULT false,
	policy_scope varchar NULL,
	policy_template_type varchar NULL,
	discovery_source varchar NULL,
	source_ad_group_id uuid NULL
);

DROP TABLE IF EXISTS did.auth_requests;

CREATE TABLE did.auth_requests (
	org_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	source_endpoint varchar(255) NULL,
	destination_endpoint varchar(255) NULL,
	os varchar(16) NULL,
	user_type varchar(16) NULL,
	username varchar(24) NULL,
	protocol bpchar(8) NULL,
	access_mode varchar(16) NULL,
	login_status varchar(16) NULL,
	sam_account_name varchar(24) NULL,
	user_ad_domain varchar(48) NULL,
	user_ad_ou varchar(64) NULL,
	request_count int4 NULL,
	"timestamp" int8 NULL,
	platform_user varchar(256) NULL,
	destination_endpoint_ip varchar(24) NULL,
	status varchar(24) NULL,
	source_endpoint_ip varchar NULL
);

DROP TABLE IF EXISTS did.authentication_methods;

CREATE TABLE did.authentication_methods (
	id serial4 NOT NULL,
	tenant_id int4 NULL,
	authentication_method varchar(255) NULL,
	sso_url varchar(255) NULL,
	module_name varchar(50) NULL,
	single_sign_on_url varchar(255) NULL,
	single_logout_url varchar(255) NULL,
	metadata_url varchar(255) NULL,
	api_key varchar(255) NULL,
	CONSTRAINT authentication_methods_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.bc_user_details;

CREATE TABLE did.bc_user_details (
	id serial4 NOT NULL,
	dn varchar(255) DEFAULT ''::character varying NOT NULL,
	cn varchar(255) DEFAULT ''::character varying NOT NULL,
	sn varchar(255) DEFAULT ''::character varying NOT NULL,
	c varchar(255) DEFAULT ''::character varying NOT NULL,
	l varchar(255) DEFAULT ''::character varying NOT NULL,
	st varchar(255) DEFAULT ''::character varying NOT NULL,
	title varchar(255) DEFAULT ''::character varying NOT NULL,
	description varchar(255) DEFAULT ''::character varying NOT NULL,
	postal_address varchar(255) DEFAULT ''::character varying NOT NULL,
	postal_code varchar(255) DEFAULT ''::character varying NOT NULL,
	physical_delivery_office_name varchar(255) DEFAULT ''::character varying NOT NULL,
	telephone_number varchar(255) DEFAULT ''::character varying NOT NULL,
	given_name varchar(255) DEFAULT ''::character varying NOT NULL,
	generation_qualifier varchar(255) DEFAULT ''::character varying NOT NULL,
	distinguished_name varchar(255) DEFAULT ''::character varying NOT NULL,
	instance_type varchar(255) DEFAULT ''::character varying NOT NULL,
	when_created varchar(255) DEFAULT ''::character varying NOT NULL,
	when_changed varchar(255) DEFAULT ''::character varying NOT NULL,
	display_name varchar(255) DEFAULT ''::character varying NOT NULL,
	usnc_created varchar(255) DEFAULT ''::character varying NOT NULL,
	info varchar(255) DEFAULT ''::character varying NOT NULL,
	usnc_changed varchar(255) DEFAULT ''::character varying NOT NULL,
	co varchar(255) DEFAULT ''::character varying NOT NULL,
	department varchar(255) DEFAULT ''::character varying NOT NULL,
	company varchar(255) DEFAULT ''::character varying NOT NULL,
	admin_display_name varchar(255) DEFAULT ''::character varying NOT NULL,
	admin_description varchar(255) DEFAULT ''::character varying NOT NULL,
	street_address varchar(255) DEFAULT ''::character varying NOT NULL,
	employee_number varchar(255) DEFAULT ''::character varying NOT NULL,
	home_postal_address varchar(255) DEFAULT ''::character varying NOT NULL,
	user_name varchar(255) DEFAULT ''::character varying NOT NULL,
	user_account_control varchar(255) DEFAULT ''::character varying NOT NULL,
	bad_pwd_count varchar(255) DEFAULT ''::character varying NOT NULL,
	code_page text NOT NULL,
	country_code varchar(255) DEFAULT ''::character varying NOT NULL,
	employee_id varchar(255) DEFAULT ''::character varying NOT NULL,
	home_directory varchar(255) DEFAULT ''::character varying NOT NULL,
	bad_password_time varchar(255) DEFAULT ''::character varying NOT NULL,
	last_logon varchar(255) DEFAULT ''::character varying NOT NULL,
	pwd_last_set varchar(255) DEFAULT ''::character varying NOT NULL,
	primary_group_id varchar(255) DEFAULT ''::character varying NOT NULL,
	acount_expires varchar(255) DEFAULT ''::character varying NOT NULL,
	logon_count varchar(255) DEFAULT ''::character varying NOT NULL,
	sam_account_name varchar(255) DEFAULT ''::character varying NOT NULL,
	division varchar(255) DEFAULT ''::character varying NOT NULL,
	sam_account_type varchar(255) DEFAULT ''::character varying NOT NULL,
	desktop_profile varchar(255) DEFAULT ''::character varying NOT NULL,
	primary_telex_number varchar(255) DEFAULT ''::character varying NOT NULL,
	user_principal_name varchar(255) DEFAULT ''::character varying NOT NULL,
	lockout_time varchar(255) DEFAULT ''::character varying NOT NULL,
	object_category varchar(255) DEFAULT ''::character varying NOT NULL,
	account_name_history varchar(255) DEFAULT ''::character varying NOT NULL,
	ds_core_propagation_data varchar(255) DEFAULT ''::character varying NOT NULL,
	last_logon_time varchar(255) DEFAULT ''::character varying NOT NULL,
	ms_ds_last_successful_interactive_logon_time varchar(255) DEFAULT ''::character varying NOT NULL,
	ms_ds_last_failed_interactive_logon_time varchar(255) DEFAULT ''::character varying NOT NULL,
	ms_ds_failed_interactive_logon_count_at_last_successful_logon varchar(255) DEFAULT ''::character varying NOT NULL,
	mail varchar(255) DEFAULT ''::character varying NOT NULL,
	manager varchar(255) DEFAULT ''::character varying NOT NULL,
	mobile varchar(255) DEFAULT ''::character varying NOT NULL,
	department_number varchar(255) DEFAULT ''::character varying NOT NULL,
	uid_number varchar(255) DEFAULT ''::character varying NOT NULL,
	gid_number varchar(255) DEFAULT ''::character varying NOT NULL,
	gecos varchar(255) DEFAULT ''::character varying NOT NULL,
	login_shell varchar(255) DEFAULT ''::character varying NOT NULL,
	CONSTRAINT bc_user_details_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.business_categories;

CREATE TABLE did.business_categories (
	id serial4 NOT NULL,
	category varchar(255) NOT NULL,
	CONSTRAINT business_categories_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.checkout_jobs;

CREATE TABLE did.checkout_jobs (
	id serial4 NOT NULL,
	job_name varchar(255) NOT NULL,
	status varchar(255) NOT NULL,
	epm_user_id int4 NOT NULL,
	epm_machine_id int4 NOT NULL,
	domain_id int4 DEFAULT 0 NOT NULL,
	issuer_id int4 DEFAULT 0 NOT NULL,
	user_id int4 NOT NULL,
	issue_verified_credential bool DEFAULT false NOT NULL,
	shareconnection bool DEFAULT false NOT NULL,
	protocol varchar NULL,
	port int4 NULL,
	credential_id int4 NULL,
	jump_server_id int4 NULL,
	created_at timestamptz DEFAULT CURRENT_TIMESTAMP NULL,
	assignment_time_limit varchar(255) NULL,
	CONSTRAINT checkout_jobs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.client_apps;

CREATE TABLE did.client_apps (
	id varchar(64) NOT NULL,
	tenant_id int4 NULL,
	org_id int4 NULL,
	user_id int4 NULL,
	app_name varchar(255) NULL,
	description varchar(1024) NULL,
	auth_method varchar(255) NULL,
	client_id varchar(128) NULL,
	client_secret varchar(128) NULL,
	app_url varchar(1024) NULL,
	auth_url varchar(1024) NULL,
	login_url varchar(1024) NULL,
	logout_url varchar(1024) NULL,
	metadata_url varchar(1024) NULL,
	app_logo varchar(1024) NULL,
	status varchar(255) NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL,
	CONSTRAINT client_apps_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.client_details;

CREATE TABLE did.client_details (
	id serial4 NOT NULL,
	org_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	client_name varchar(255) NOT NULL,
	client_type varchar(255) NOT NULL,
	client_id varchar(512) NOT NULL,
	client_secret varchar(512) NOT NULL,
	created_by varchar(255) NOT NULL,
	status varchar(255) DEFAULT 'pending'::character varying NULL,
	created_at int8 NOT NULL,
	CONSTRAINT client_details_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.credential_policies;

CREATE TABLE did.credential_policies (
	id serial4 NOT NULL,
	policy_name varchar(255) NOT NULL,
	user_type varchar(255) NOT NULL,
	rules_rotate_every varchar(255) NOT NULL,
	rules_access_credential varchar(255) NOT NULL,
	CONSTRAINT credential_policies_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.credential_policy_endpoints_mapping;

CREATE TABLE did.credential_policy_endpoints_mapping (
	credential_policy_id int4 NOT NULL,
	machine_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.credential_policy_epm_server_group_mapping;

CREATE TABLE did.credential_policy_epm_server_group_mapping (
	credential_policy_id int4 NOT NULL,
	epm_server_group_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.credential_rotation_jobs;

CREATE TABLE did.credential_rotation_jobs (
	id bigserial NOT NULL,
	job_date varchar NULL,
	job_hour int4 NULL,
	job_type varchar NULL,
	credential_address varchar NULL,
	no_of_credential_processed int4 NULL,
	processed_time int8 NULL,
	job_status varchar NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	CONSTRAINT credential_rotation_jobs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.credential_rotation_policy;

CREATE TABLE did.credential_rotation_policy (
	policy_id serial4 NOT NULL,
	policy_name varchar(255) NOT NULL,
	rotation_timeframe_days int4 DEFAULT 0 NOT NULL,
	credential_medium varchar(255) DEFAULT ''::character varying NOT NULL,
	session_expiry_time int4 DEFAULT 0 NOT NULL,
	user_type varchar(255) NOT NULL,
	domain_id int8 DEFAULT 0 NOT NULL,
	key_format varchar NULL,
	key_encryption varchar NULL,
	public_key_folder_path varchar NULL,
	credential_type varchar NULL,
	new_server_group_id int4 NULL,
	status varchar(255) DEFAULT 'Active'::character varying NOT NULL,
	last_modified timestamp DEFAULT now() NOT NULL,
	pwd_complexity int4 NULL,
	pwd_length int4 NULL,
	pwd_upper_case int4 NULL,
	pwd_lower_case int4 NULL,
	pwd_numeric int4 NULL,
	pwd_spl_char int4 NULL,
	CONSTRAINT credential_rotation_policy_pkey PRIMARY KEY (policy_id)
);

DROP TABLE IF EXISTS did.credential_submission_queue;

CREATE TABLE did.credential_submission_queue (
	id serial4 NOT NULL,
	wallet_id int4 NOT NULL,
	credential_id int4 NOT NULL,
	status varchar(255) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT credential_submission_queue_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.csv_jobs;

CREATE TABLE did.csv_jobs (
	id serial4 NOT NULL,
	domain_id int8 NOT NULL,
	file_name varchar(255) DEFAULT ''::character varying NOT NULL,
	file_path varchar(255) DEFAULT ''::character varying NOT NULL,
	status varchar(255) DEFAULT 'QUEUED'::character varying NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT csv_jobs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.custom_presentation_response_submission_queue;

CREATE TABLE did.custom_presentation_response_submission_queue (
	id serial4 NOT NULL,
	wallet_id int4 NOT NULL,
	presentation_request_submission_id int4 NOT NULL,
	presentation_response text NOT NULL,
	status bpchar(10) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	holder_did text NULL,
	CONSTRAINT custom_presentation_response_submission_queue_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.database_job_queue;

CREATE TABLE did.database_job_queue (
	id serial4 NOT NULL,
	job_name varchar(255) NOT NULL,
	status varchar(255) NOT NULL,
	db_user_id int4 NOT NULL,
	db_id int4 NOT NULL,
	wallet_user_id int4 NOT NULL,
	host varchar NOT NULL,
	domain_id int4 DEFAULT 0 NOT NULL,
	issuer_id int4 DEFAULT 0 NOT NULL,
	port int4 NULL,
	credential_id int4 NULL,
	table_name varchar NOT NULL,
	fields varchar NOT NULL,
	updated_at timestamptz DEFAULT CURRENT_TIMESTAMP NULL,
	created_at timestamptz DEFAULT CURRENT_TIMESTAMP NULL,
	"privileges" varchar NULL,
	policy_id uuid NULL,
	CONSTRAINT database_job_queue_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.db_field;

CREATE TABLE did.db_field (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	db_type varchar(255) NULL,
	db_id int4 NULL,
	table_name varchar(255) NULL,
	field_name varchar(255) NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now()) NULL,
	instance_id int4 NULL
);

DROP TABLE IF EXISTS did.db_hosts;

CREATE TABLE did.db_hosts (
	id serial4 NOT NULL,
	org_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	agent_vm_ip varchar(255) NOT NULL,
	host_vm_ip varchar(255) NOT NULL,
	port int4 DEFAULT 5432 NULL,
	db_type varchar(50) DEFAULT 'postgres'::character varying NULL,
	status varchar(50) DEFAULT 'active'::character varying NULL,
	created_at int8 DEFAULT EXTRACT(epoch FROM CURRENT_TIMESTAMP)::bigint NULL,
	updated_at int8 DEFAULT EXTRACT(epoch FROM CURRENT_TIMESTAMP)::bigint NULL,
	CONSTRAINT db_hosts_org_id_tenant_id_agent_vm_ip_host_vm_ip_key UNIQUE (org_id, tenant_id, agent_vm_ip, host_vm_ip),
	CONSTRAINT db_hosts_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.db_privilege;

CREATE TABLE did.db_privilege (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	db_id int4 NULL,
	user_id int4 NULL,
	privilege varchar(255) NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now()) NULL,
	instance_id int4 NULL
);

DROP TABLE IF EXISTS did.db_synchronization;

CREATE TABLE did.db_synchronization (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	db_name varchar(255) NULL,
	db_type varchar(255) NULL,
	host varchar(255) NULL,
	status varchar(45) NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now()) NULL,
	port varchar(255) NULL,
	"uuid" varchar(255) NULL,
	instance_id int4 NULL,
	host_id int4 NULL,
	agent_vm_ip varchar(255) NULL,
	agent_vm_private_ip varchar(255) NULL,
	agent_vm_host_name varchar(255) NULL
);

DROP TABLE IF EXISTS did.db_table;

CREATE TABLE did.db_table (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	db_type varchar(255) NULL,
	db_id int4 NULL,
	table_name varchar(255) NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now()) NULL,
	instance_id int4 NULL
);

DROP TABLE IF EXISTS did.db_user;

CREATE TABLE did.db_user (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	db_id int4 NULL,
	user_name varchar(255) NULL,
	status varchar(45) NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now()) NULL,
	"role" varchar(255) NULL,
	host varchar(255) NULL,
	instance_id int4 NULL,
	host_id int4 NULL,
	default_hostgroup int4 NULL,
	default_schema varchar(255) NULL
);

DROP TABLE IF EXISTS did.destination_endpoint;

CREATE TABLE did.destination_endpoint (
	id bigserial NOT NULL,
	service_account_endpoints_id int4 NOT NULL,
	endpoint_id int4 NOT NULL,
	CONSTRAINT destination_endpoint_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.destination_endpoint_group;

CREATE TABLE did.destination_endpoint_group (
	id bigserial NOT NULL,
	service_account_endpoints_id int4 NOT NULL,
	endpoint_group_id int4 NOT NULL,
	CONSTRAINT destination_endpoint_group_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.devices;

CREATE TABLE did.devices (
	device_id serial4 NOT NULL,
	device_name varchar(255) NOT NULL,
	user_id int4 NOT NULL,
	last_accessed timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT devices_pkey PRIMARY KEY (device_id)
);

DROP TABLE IF EXISTS did.dit_permissions;

CREATE TABLE did.dit_permissions (
	id int4 NULL,
	segment_id int4 NULL,
	dit_permission varchar NULL,
	status varchar NULL
);

DROP TABLE IF EXISTS did."domain";

CREATE TABLE did."domain" (
	domain_id serial4 NOT NULL,
	domain_name varchar(255) NOT NULL,
	org_unit_id int4 NOT NULL,
	CONSTRAINT domain_one_to_one_org_unit_id UNIQUE (org_unit_id),
	CONSTRAINT domain_pkey PRIMARY KEY (domain_id)
);

DROP TABLE IF EXISTS did.domain_tokens;

CREATE TABLE did.domain_tokens (
	domain_id serial4 NOT NULL,
	domain_name varchar(255) DEFAULT ''::character varying NOT NULL,
	access_token varchar(255) DEFAULT ''::character varying NOT NULL,
	refresh_token varchar(255) DEFAULT ''::character varying NOT NULL,
	refresh_token_expiry varchar(255) DEFAULT ''::character varying NOT NULL,
	access_token_expiry varchar(255) DEFAULT ''::character varying NOT NULL,
	CONSTRAINT domain_tokens_pkey PRIMARY KEY (domain_id)
);

DROP TABLE IF EXISTS did.domains;

CREATE TABLE did.domains (
	id serial4 NOT NULL,
	organization_name varchar(255) NOT NULL,
	did_method varchar(10) DEFAULT NULL::character varying NULL,
	CONSTRAINT domains_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.endpoint_auth_logs;

CREATE TABLE did.endpoint_auth_logs (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	src_ip varchar(45) NULL,
	dest_ip varchar(45) NULL,
	user_name varchar(255) NULL,
	service varchar(255) NULL,
	login_status varchar(45) NULL,
	message varchar(255) NULL,
	count int4 NULL,
	created_at int8 DEFAULT EXTRACT(epoch FROM now()) NULL,
	component varchar(45) NULL,
	host_name varchar(255) NULL
);

DROP TABLE IF EXISTS did.endpoint_group_mapping;

CREATE TABLE did.endpoint_group_mapping (
	id serial4 NOT NULL,
	org_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	endpoint_name varchar(255) NOT NULL,
	ip_address varchar(255) NOT NULL,
	group_name varchar(255) NOT NULL,
	CONSTRAINT endpoint_group_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.endpoint_groups;

CREATE TABLE did.endpoint_groups (
	id bigserial NOT NULL,
	group_name varchar(255) NULL,
	CONSTRAINT endpoint_groups_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.endpoint_rules;

CREATE TABLE did.endpoint_rules (
	id serial4 NOT NULL,
	rule_name varchar NULL,
	source_ip varchar NULL,
	destination_ip varchar NULL,
	status varchar NULL,
	created_at varchar DEFAULT CURRENT_TIMESTAMP NULL,
	username varchar NULL,
	service varchar NULL,
	has_permission bool DEFAULT false NOT NULL,
	endpoint_auth_status varchar NULL,
	protocols varchar DEFAULT 'SSH'::character varying NULL,
	CONSTRAINT endpoint_rules_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.endpoint_rules_conditions;

CREATE TABLE did.endpoint_rules_conditions (
	id serial4 NOT NULL,
	rule_name varchar NULL,
	rule_conditions varchar NULL,
	rule_permission varchar NULL,
	created_at varchar NULL,
	endpoint_name varchar NULL,
	status varchar DEFAULT 'Active'::character varying NULL,
	CONSTRAINT endpoint_rules_conditions_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.endpoint_rules_permission;

CREATE TABLE did.endpoint_rules_permission (
	id serial4 NOT NULL,
	rule_id varchar NULL,
	endpoint_permission_type varchar NULL,
	endpoint_permission_value varchar NULL,
	created_at varchar DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT endpoint_rules_permission_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.entra_config;

CREATE TABLE did.entra_config (
	org_id int4 NOT NULL,
	client_id text NOT NULL,
	client_secret text NOT NULL,
	last_synced_at timestamptz NULL,
	entra_tenant_id text NOT NULL,
	tenant_id int4 NULL,
	id serial4 NOT NULL,
	CONSTRAINT entra_configs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.epm_group_machine_mapping;

CREATE TABLE did.epm_group_machine_mapping (
	group_id int4 NOT NULL,
	machine_id int8 NOT NULL,
	group_name varchar(255) DEFAULT ''::character varying NOT NULL
);

DROP TABLE IF EXISTS did.epm_machines;

CREATE TABLE did.epm_machines (
	machine_id serial4 NOT NULL,
	machine_key text NOT NULL,
	public_ip_address varchar(512) NOT NULL,
	auth_type varchar(255) NOT NULL,
	private_ip_address varchar(255) NOT NULL,
	os_id text NOT NULL,
	status varchar(255) DEFAULT ''::character varying NOT NULL,
	hostname varchar(255) DEFAULT ''::character varying NOT NULL,
	ip_address varchar(255) DEFAULT ''::character varying NOT NULL,
	localuser varchar(255) DEFAULT ''::character varying NOT NULL,
	password_policy_id int4 DEFAULT 0 NULL,
	auth_code varchar(512) DEFAULT ''::character varying NOT NULL,
	jump_server_id int4 DEFAULT 0 NULL,
	domain_id int4 NOT NULL,
	vnc_password varchar(255) DEFAULT ''::character varying NOT NULL,
	factors varchar(512) NULL,
	status_guacd bool NULL,
	status_services bool NULL,
	instance_id int8 DEFAULT 0 NOT NULL,
	last_active varchar(255) DEFAULT '1696919403' NOT NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now())::integer NULL,
	is_jumpserver bool DEFAULT false NULL,
	"uuid" varchar(255) NULL,
	epm_id int4 NULL,
	epm_public_ip_address varchar NULL,
	epm_hostname varchar NULL,
	auto_populate bool DEFAULT false NULL,
	machine_type varchar(255) DEFAULT 'endpoint'::character varying NULL,
	description varchar(255) NULL,
	fqdn varchar(255) NULL,
	CONSTRAINT epm_machines_pkey PRIMARY KEY (machine_id)
);

DROP TABLE IF EXISTS did.epm_machines_activity;

CREATE TABLE did.epm_machines_activity (
	id serial4 NOT NULL,
	epm_user_id int4 NOT NULL,
	machine_id int8 DEFAULT '0'::bigint NOT NULL,
	session_recorded_time varchar(255) DEFAULT ''::character varying NOT NULL,
	session_record varchar(255) DEFAULT ''::character varying NOT NULL,
	CONSTRAINT epm_machines_activity_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.epm_machines_password_mapping;

CREATE TABLE did.epm_machines_password_mapping (
	machine_id int8 DEFAULT '0'::bigint NULL,
	policy_id int4 DEFAULT 0 NULL
);

DROP TABLE IF EXISTS did.epm_machines_users_mapping;

CREATE TABLE did.epm_machines_users_mapping (
	user_id int4 NOT NULL,
	machine_id int8 NOT NULL,
	instanceid varchar(255) DEFAULT '0'::character varying NOT NULL
);

DROP TABLE IF EXISTS did.epm_server_group;

CREATE TABLE did.epm_server_group (
	id serial4 NOT NULL,
	epm_server_group_machine_id varchar(255) DEFAULT ''::character varying NOT NULL,
	epm_server_group_machine_name varchar(255) DEFAULT ''::character varying NOT NULL,
	factors varchar(512) NULL,
	auth_type varchar(512) NULL,
	domain_id int4 NULL,
	CONSTRAINT epm_server_group_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.epm_server_group_mapping;

CREATE TABLE did.epm_server_group_mapping (
	id serial4 NOT NULL,
	epm_server_group_id int4 NOT NULL,
	machine_id int8 NOT NULL,
	server_group_id int4 DEFAULT 0 NOT NULL,
	CONSTRAINT epm_server_group_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.epm_users;

CREATE TABLE did.epm_users (
	id serial4 NOT NULL,
	epm_user_name varchar(255) DEFAULT ''::character varying NOT NULL,
	status varchar(255) DEFAULT ''::character varying NOT NULL,
	user_source varchar(255) DEFAULT ''::character varying NOT NULL,
	sync_method varchar(255) DEFAULT ''::character varying NOT NULL,
	user_type varchar(255) DEFAULT ''::character varying NOT NULL,
	password_managed varchar(255) DEFAULT ''::character varying NOT NULL,
	credential_type varchar(255) DEFAULT ''::character varying NOT NULL,
	ttl_user int4 DEFAULT 0 NOT NULL,
	ttl_password int4 DEFAULT 0 NOT NULL,
	home_dir varchar(255) DEFAULT ''::character varying NOT NULL,
	privileged_user int2 DEFAULT '0'::smallint NOT NULL,
	auth_method varchar(255) DEFAULT ''::character varying NOT NULL,
	custom_mapping varchar(255) DEFAULT ''::character varying NOT NULL,
	domain_id int4 DEFAULT 0 NOT NULL,
	epm_user_password varchar(255) DEFAULT ''::character varying NOT NULL,
	sshkey varchar(5000) DEFAULT ''::character varying NOT NULL,
	assign int2 DEFAULT '0'::smallint NOT NULL,
	servername varchar(255) DEFAULT ''::character varying NOT NULL,
	servergroupname varchar(255) DEFAULT ''::character varying NOT NULL,
	authnullusername varchar(255) DEFAULT ''::character varying NOT NULL,
	authnullusergroup varchar(255) DEFAULT ''::character varying NOT NULL,
	motp varchar(255) DEFAULT ''::character varying NOT NULL,
	did varchar(255) DEFAULT ''::character varying NOT NULL,
	escalated_date date NULL,
	credential_expiry varchar(255) DEFAULT ''::character varying NOT NULL,
	assignment_time_limit varchar(255) DEFAULT ''::character varying NOT NULL,
	access_credential bool DEFAULT false NOT NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now())::integer NULL,
	epm_machine_id int4 NULL,
	epm_machine_hostname varchar NULL,
	epm_machine_public_ip_address varchar NULL,
	epm_machine_uuid varchar NULL,
	is_system_admin bool DEFAULT false NULL,
	CONSTRAINT epm_users_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.epm_users_buffer;

CREATE TABLE did.epm_users_buffer (
	id serial4 NOT NULL,
	epm_user_name varchar(255) DEFAULT ''::character varying NOT NULL,
	instance_id int4 DEFAULT 0 NULL,
	domain_id int4 DEFAULT 0 NOT NULL,
	CONSTRAINT epm_users_buffer_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.epm_users_cred_management;

CREATE TABLE did.epm_users_cred_management (
	id serial4 NOT NULL,
	epm_user_id int4 DEFAULT 0 NULL,
	encrypted_password varchar(255) DEFAULT ''::character varying NOT NULL,
	ssh_key varchar(255) DEFAULT ''::character varying NOT NULL,
	decentralized_id varchar(255) DEFAULT ''::character varying NOT NULL,
	CONSTRAINT epm_users_cred_management_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.epm_users_group_mapping;

CREATE TABLE did.epm_users_group_mapping (
	group_id int4 NOT NULL,
	epm_user_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.escalate_privilege;

CREATE TABLE did.escalate_privilege (
	id serial4 NOT NULL,
	active_directory_user varchar(255) DEFAULT ''::character varying NOT NULL,
	active_directory_id int4 DEFAULT 0 NOT NULL,
	epm_user_id int4 DEFAULT 0 NULL,
	privileged_user bool DEFAULT false NULL,
	credential_expiry varchar DEFAULT '0' NULL,
	escalation_time_limit int4 DEFAULT 0 NULL,
	did_credential_expiry int4 DEFAULT 0 NULL,
	wallet_id int4 DEFAULT 0 NULL,
	assignment_time_limit int4 DEFAULT 0 NULL,
	CONSTRAINT escalate_privilege_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.ethereum_address;

CREATE TABLE did.ethereum_address (
	id serial4 NOT NULL,
	cid varchar(255) NOT NULL,
	chain_address varchar(255) NOT NULL,
	"date" varchar(255) NOT NULL,
	"hour" varchar NOT NULL,
	merkle_hash varchar(255) NOT NULL,
	user_email varchar(255) NOT NULL,
	generated_hour int4 NULL,
	"time" varchar(255) NULL,
	domain_id varchar DEFAULT '7'::character varying NULL,
	CONSTRAINT ethereum_address_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.field_mapping;

CREATE TABLE did.field_mapping (
	mapping_id serial4 NOT NULL,
	app_id int4 NOT NULL,
	source_fn varchar(255) NOT NULL,
	target_fn varchar(255) NOT NULL,
	CONSTRAINT field_mapping_one_to_one UNIQUE (app_id),
	CONSTRAINT field_mapping_pkey PRIMARY KEY (mapping_id)
);

DROP TABLE IF EXISTS did.identity_group_relations;

CREATE TABLE did.identity_group_relations (
	id bigserial NOT NULL,
	workload_identity_id int4 NOT NULL,
	identity_group_id int4 NOT NULL,
	CONSTRAINT identity_group_relations_pkey PRIMARY KEY (id),
	CONSTRAINT identity_group_relations_workload_identity_id_key UNIQUE (workload_identity_id)
);

DROP TABLE IF EXISTS did.import_jobs;

CREATE TABLE did.import_jobs (
	job_id serial4 NOT NULL,
	job_name varchar(255) NOT NULL,
	selected_group varchar(255) NOT NULL,
	status varchar(255) NOT NULL,
	created_at time(0) DEFAULT NULL::time without time zone NULL,
	CONSTRAINT import_jobs_pkey PRIMARY KEY (job_id)
);

DROP TABLE IF EXISTS did.issuer_credential_schema;

CREATE TABLE did.issuer_credential_schema (
	id serial4 NOT NULL,
	domain_id int4 NOT NULL,
	issuer_did varchar(64) NOT NULL,
	schema_id varchar(36) NOT NULL,
	schema_name varchar(255) NOT NULL,
	status varchar(20) NOT NULL,
	created_at time(0) NOT NULL,
	updated_at time(0) NOT NULL,
	CONSTRAINT issuer_credential_schema_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.issuer_credentials;

CREATE TABLE did.issuer_credentials (
	id serial4 NOT NULL,
	domain_id int4 NOT NULL,
	issuer_id int4 NOT NULL,
	schema_id int4 NOT NULL,
	credential_id varchar(255) NOT NULL,
	credential_name varchar(255) NOT NULL,
	status varchar(64) NOT NULL,
	expirationdate varchar(45) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT issuer_credentials_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.issuer_dids;

CREATE TABLE did.issuer_dids (
	id serial4 NOT NULL,
	domain_id int4 NOT NULL,
	did text NOT NULL,
	private_key varchar(128) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	issuer_name varchar(45) NOT NULL,
	description varchar(45) NOT NULL,
	status varchar(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
	is_default bool DEFAULT false NULL,
	CONSTRAINT issuer_dids_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.jobs;

CREATE TABLE did.jobs (
	id serial4 NOT NULL,
	domain_id int8 NOT NULL,
	job_type varchar(255) DEFAULT ''::character varying NOT NULL,
	file_path varchar(255) DEFAULT ''::character varying NOT NULL,
	status varchar(255) DEFAULT 'QUEUED'::character varying NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	file_name varchar(255) DEFAULT ''::character varying NOT NULL,
	issuer_id int4 NOT NULL,
	CONSTRAINT jobs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.jump_server;

CREATE TABLE did.jump_server (
	id serial4 NOT NULL,
	server_id varchar(50) DEFAULT ''::character varying NOT NULL,
	public_ip_address varchar(50) DEFAULT ''::character varying NOT NULL,
	region varchar(255) DEFAULT ''::character varying NOT NULL,
	status varchar(20) NOT NULL,
	domain_id int4 NOT NULL,
	server_name varchar(255) NOT NULL,
	is_default bool DEFAULT false NULL,
	private_ip varchar(16) NULL,
	connect_by int4 DEFAULT 0 NULL,
	CONSTRAINT jump_servers_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.jump_server_connection_endpoints;

CREATE TABLE did.jump_server_connection_endpoints (
	jump_server_connection_id int4 NOT NULL,
	instance_id int4 NOT NULL,
	CONSTRAINT pk_jsce PRIMARY KEY (jump_server_connection_id, instance_id)
);

DROP TABLE IF EXISTS did.jump_server_domains;

CREATE TABLE did.jump_server_domains (
	jump_server_id int4 NOT NULL,
	domain_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.jump_server_endpoint_jobs;

CREATE TABLE did.jump_server_endpoint_jobs (
	id serial4 NOT NULL,
	jump_server_id int4 NOT NULL,
	epm_machine_id int4 NOT NULL,
	status varchar(20) DEFAULT 'QUEUED'::character varying NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT jump_server_endpoint_jobs_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.jump_server_endpoints;

CREATE TABLE did.jump_server_endpoints (
	jump_server_id int4 NOT NULL,
	epm_machine_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.jump_server_epm_users;

CREATE TABLE did.jump_server_epm_users (
	jump_server_id int4 NOT NULL,
	epm_user_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.jump_server_recordings;

CREATE TABLE did.jump_server_recordings (
	id serial4 NOT NULL,
	jump_server_connection_id int4 DEFAULT 0 NOT NULL,
	recording_url varchar(1024) DEFAULT ''::character varying NOT NULL,
	recording_mime_type varchar(255) DEFAULT ''::character varying NOT NULL,
	session_recording_time varchar(255) NOT NULL,
	username varchar(512) NOT NULL,
	recording_length varchar(512) DEFAULT '00'::character varying NOT NULL,
	endpoint varchar(512) DEFAULT '00'::character varying NOT NULL,
	user_id int8 NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT jump_servers_connections_recordings_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.jump_servers_connections;

CREATE TABLE did.jump_servers_connections (
	id serial4 NOT NULL,
	jump_server_id int4 DEFAULT 0 NOT NULL,
	epm_user_id int4 DEFAULT 0 NOT NULL,
	protocol varchar(50) DEFAULT ''::character varying NOT NULL,
	port int4 DEFAULT 0 NOT NULL,
	hashed_password varchar(255) NOT NULL,
	user_id int8 NULL,
	machine_id int4 NULL,
	status varchar(32) NULL,
	expire_at timestamp NULL,
	CONSTRAINT jump_servers_connections_pkey PRIMARY KEY (id),
	CONSTRAINT unique_protocol UNIQUE (id)
);

DROP TABLE IF EXISTS did.linux_commands;

CREATE TABLE did.linux_commands (
	id serial4 NOT NULL,
	linux_command varchar NULL,
	CONSTRAINT linux_commands_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.log_entries;

CREATE TABLE did.log_entries (
	id serial4 NOT NULL,
	time_created varchar(255) NOT NULL,
	message varchar(255) NULL,
	endpoint_id varchar(255) NULL,
	event_id int4 NULL,
	provider_name varchar(255) NULL,
	CONSTRAINT log_entries_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.log_output_elasticsearch;

CREATE TABLE did.log_output_elasticsearch (
	id serial4 NOT NULL,
	tenant_id int4 NOT NULL,
	output_name varchar(255) NOT NULL,
	host varchar(255) NOT NULL,
	port int4 DEFAULT 9200 NOT NULL,
	log_type varchar(255) NULL,
	index_name varchar(255) NOT NULL,
	http_user varchar(255) NULL,
	http_passwd varchar(255) NULL,
	tls bool DEFAULT true NULL,
	tls_verify bool DEFAULT true NULL,
	CONSTRAINT log_output_elasticsearch_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.log_output_http;

CREATE TABLE did.log_output_http (
	id serial4 NOT NULL,
	host varchar(255) NOT NULL,
	port int4 DEFAULT 443 NULL,
	uri varchar(255) DEFAULT '/'::character varying NULL,
	http_method varchar(10) DEFAULT 'POST'::character varying NULL,
	content_type varchar(100) DEFAULT 'application/json'::character varying NULL,
	custom_headers varchar NULL,
	use_tls bool DEFAULT true NULL,
	tls_verify bool DEFAULT true NULL,
	json_date_key varchar(50) DEFAULT 'date'::character varying NULL,
	json_date_format varchar(50) DEFAULT 'iso8601'::character varying NULL,
	match_pattern varchar(255) DEFAULT '*'::character varying NULL,
	retry_limit int4 DEFAULT 5 NULL,
	retry_delay_sec int4 DEFAULT 10 NULL,
	log_type varchar NULL,
	tenant_id int4 NULL,
	CONSTRAINT log_output_http_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.log_output_splunk;

CREATE TABLE did.log_output_splunk (
	id serial4 NOT NULL,
	tenant_id int4 NOT NULL,
	output_name varchar(255) NOT NULL,
	host varchar(255) NOT NULL,
	"password" varchar(255) NULL,
	auth_token varchar(255) NULL,
	http_username varchar(255) NULL,
	http_password varchar(255) NULL,
	port int4 NOT NULL,
	logtype varchar(255) NULL,
	CONSTRAINT log_output_setup_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.log_output_syslog;

CREATE TABLE did.log_output_syslog (
	id serial4 NOT NULL,
	host varchar(255) NOT NULL,
	port int4 DEFAULT 514 NULL,
	"mode" varchar(10) DEFAULT 'tcp'::character varying NOT NULL,
	syslog_format varchar(20) DEFAULT 'rfc3164'::character varying NULL,
	message_key varchar(50) DEFAULT 'message'::character varying NULL,
	tls_verify bool DEFAULT true NULL,
	match_pattern varchar(255) DEFAULT '*'::character varying NULL,
	workers int4 DEFAULT 1 NULL,
	retry_limit int4 DEFAULT 5 NULL,
	retry_delay_sec int4 DEFAULT 10 NULL,
	log_type varchar NULL,
	tenant_id int4 NULL,
	CONSTRAINT log_output_syslog_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.master_attribute_list;

CREATE TABLE did.master_attribute_list (
	id serial4 NOT NULL,
	attribute_type_id int4 NULL,
	attribute_name varchar(255) NULL,
	parent_id varchar(512) NULL,
	attribute_label varchar(255) NULL,
	is_collected int4 NULL,
	CONSTRAINT master_attribute_list_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.merkle_hash;

CREATE TABLE did.merkle_hash (
	id serial4 NOT NULL,
	ldap_user varchar(255) NULL,
	local_user varchar(255) NULL,
	transaction_id varchar(255) NULL,
	merkle_hash varchar(64) NULL,
	cid varchar(255) NULL,
	merkle_status varchar(20) NULL,
	created_at varchar(255) NULL,
	generated_hour int4 NULL,
	"time" varchar(255) NULL,
	domain_id varchar DEFAULT '7'::character varying NULL,
	CONSTRAINT merkle_hash_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.mfa_config;

CREATE TABLE did.mfa_config (
	id serial4 NOT NULL,
	tenant_id int4 NULL,
	"name" varchar(255) NULL,
	description varchar(255) NULL,
	status varchar(16) NULL,
	factor_type varchar(32) NULL,
	is_default bool DEFAULT false NULL,
	CONSTRAINT mfa_config_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.mfa_methods;

CREATE TABLE did.mfa_methods (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	client_id text NOT NULL,
	method_type varchar(20) NOT NULL,
	method_data jsonb NULL,
	enabled bool DEFAULT false NULL,
	verified bool DEFAULT false NULL,
	backup_codes _text NULL,
	enrolled_at timestamptz NULL,
	last_used_at timestamptz NULL,
	expires_at timestamptz NULL,
	created_at timestamptz DEFAULT now() NULL,
	updated_at timestamptz DEFAULT now() NULL,
	user_id int4 NULL,
	CONSTRAINT mfa_methods_pkey PRIMARY KEY (id)
);

CREATE TABLE did.network_devices (
	id uuid DEFAULT gen_random_uuid() NOT NULL,
	device_type varchar NOT NULL,
	"name" varchar NOT NULL,
	device_id varchar NOT NULL,
	ip_address varchar NOT NULL,
	org_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	event_type varchar DEFAULT 'radius_auth'::character varying NOT NULL,
	nas_identifier varchar DEFAULT ''::character varying NOT NULL,
	client_ip varchar DEFAULT ''::character varying NOT NULL,
	nas_port int4 NOT NULL,
	nas_port_type varchar NOT NULL,
	nas_port_id varchar(20) NOT NULL,
	created_at timestamp DEFAULT now() NULL,
	CONSTRAINT client_ip UNIQUE (client_ip),
	CONSTRAINT network_devices_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.object_classes;

CREATE TABLE did.object_classes (
	id serial4 NOT NULL,
	class_name varchar(255) NOT NULL,
	CONSTRAINT object_classes_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.okta_configuration;

CREATE TABLE did.okta_configuration (
	id int4 NOT NULL,
	api varchar NULL,
	"token" varchar NULL,
	domain_id int4 NULL,
	status varchar(50) DEFAULT 'Active'::character varying NULL,
	CONSTRAINT okta_configuration_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.oktalog_entries;

CREATE TABLE did.oktalog_entries (
	id serial4 NOT NULL,
	"timestamp" varchar NULL,
	source_ip varchar NULL,
	user_id varchar NULL,
	user_name varchar NULL,
	browser varchar NULL,
	operating_system varchar NULL,
	city varchar NULL,
	country varchar NULL,
	authentication_result varchar NULL,
	CONSTRAINT oktalog_entries_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.org_unit;

CREATE TABLE did.org_unit (
	org_unit_id serial4 NOT NULL,
	org_unit_name varchar(255) NOT NULL,
	CONSTRAINT org_unit_pkey PRIMARY KEY (org_unit_id)
);

DROP TABLE IF EXISTS did.organizations;

CREATE TABLE did.organizations (
    id BIGSERIAL NOT NULL,
    organization_name TEXT NULL,
    admin_email TEXT NULL,
    site_url TEXT NULL,
    created_at TIMESTAMPTZ NULL,
    updated_at TIMESTAMPTZ NULL,
    status TEXT NULL,
    authentication_method TEXT NULL,
    database_status VARCHAR NULL,
    database_name VARCHAR,
    CONSTRAINT organizations_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.os_info;

CREATE TABLE did.os_info (
	os_id serial4 NOT NULL,
	os_name varchar(255) NOT NULL,
	CONSTRAINT os_info_pkey PRIMARY KEY (os_id)
);

DROP TABLE IF EXISTS did.password_policy;

CREATE TABLE did.password_policy (
	policy_id serial4 NOT NULL,
	policy_name varchar(255) NOT NULL,
	rules_min_length varchar(255) DEFAULT ''::character varying NOT NULL,
	rules_max_length varchar(255) DEFAULT ''::character varying NOT NULL,
	rules_first_character varchar(255) DEFAULT ''::character varying NOT NULL,
	rules_allow_all_upperlower varchar(255) DEFAULT ''::character varying NOT NULL,
	rules_allow_all_special varchar(255) DEFAULT ''::character varying NOT NULL,
	rules_how_many_numeric varchar(255) DEFAULT ''::character varying NOT NULL,
	CONSTRAINT password_policy_pkey PRIMARY KEY (policy_id)
);

DROP TABLE IF EXISTS did.permissions;

CREATE TABLE did.permissions (
	id int4 NOT NULL,
	"permission" varchar(255) NULL,
	permission_type int4 NULL,
	resource_type_id int4 NULL,
	CONSTRAINT permissions_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.pgina_logs;

CREATE TABLE did.pgina_logs (
	id serial4 NOT NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	user_name varchar(255) NULL,
	domain_name varchar(255) NULL,
	group_name varchar(255) NULL,
	host_name varchar(255) NULL,
	log_description text NULL,
	source_ip varchar(45) NULL,
	destination_ip varchar(45) NULL,
	component varchar(255) NULL,
	status varchar(45) NULL,
	created_at int8 DEFAULT EXTRACT(epoch FROM now()) NULL,
	sub_component varchar(255) NULL
);

DROP TABLE IF EXISTS did.platform_ad_user_mapping;

CREATE TABLE did.platform_ad_user_mapping (
	user_id serial4 NOT NULL,
	wallet_id int4 NOT NULL,
	ad_user_id int4 NOT NULL,
	epm_user_id int4 NOT NULL,
	service_account_id int4 NOT NULL,
	credential_id int4 NOT NULL,
	credential_schema_id int4 NOT NULL,
	issuer_id int4 NOT NULL,
	status varchar(50) NULL,
	policy_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	ou_id int4 NOT NULL,
	verifier_id int4 NOT NULL,
	endpoint_id int4 NOT NULL,
	user_type varchar(256) NOT NULL,
	CONSTRAINT platform_ad_user_mapping_pkey PRIMARY KEY (user_id, wallet_id, ad_user_id, epm_user_id, service_account_id, credential_id, credential_schema_id, issuer_id, policy_id, tenant_id, ou_id, verifier_id, endpoint_id, user_type)
);

DROP TABLE IF EXISTS did.policy_credential_mapping;

CREATE TABLE did.policy_credential_mapping (
	policy_id uuid NOT NULL,
	credential_id int4 NOT NULL,
	id serial4 NOT NULL,
	CONSTRAINT policy_credential_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.presentation_request_submission_queue;

CREATE TABLE did.presentation_request_submission_queue (
	id serial4 NOT NULL,
	wallet_id int4 NOT NULL,
	presentation_request_bytes text NULL,
	status varchar(20) DEFAULT 'RAISED'::character varying NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	verifier_id int4 DEFAULT 1 NOT NULL,
	defination_id int4 DEFAULT 1 NOT NULL,
	holder_did text NULL,
	presentation_request_json text NULL,
	verifier_did text NULL,
	acknowledged int2 DEFAULT '0'::smallint NOT NULL,
	pr_type varchar NULL,
	user_wallet_ip varchar(50) NULL,
	CONSTRAINT presentation_request_submission_queue_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.presentation_response_submission_queue;

CREATE TABLE did.presentation_response_submission_queue (
	id serial4 NOT NULL,
	wallet_id int4 NOT NULL,
	presentation_request_submission_id int4 NOT NULL,
	presentation_response_bytes text NOT NULL,
	status bpchar(10) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	holder_did text NULL,
	user_wallet_ip varchar(50) NULL,
	CONSTRAINT presentation_response_submission_queue_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.rules;

CREATE TABLE did.rules (
	id serial4 NOT NULL,
	rule_name varchar NULL,
	status varchar NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL,
	created_by varchar(256) NULL,
	CONSTRAINT rules_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.rules_condition;

CREATE TABLE did.rules_condition (
	id serial4 NOT NULL,
	rule_id int4 NOT NULL,
	"attribute" varchar NULL,
	"operator" varchar NULL,
	value varchar NULL,
	CONSTRAINT rules_condition_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.segment_attribute_values;

CREATE TABLE did.segment_attribute_values (
	id serial4 NOT NULL,
	segment_attribute_id int4 NULL,
	attribute_value varchar(255) NULL,
	CONSTRAINT segment_attribute_values_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.segment_attributes;

CREATE TABLE did.segment_attributes (
	id serial4 NOT NULL,
	segment_id int4 NULL,
	attribute_name varchar(255) NULL,
	attribute_datatype varchar(50) NULL,
	attribute_match_pattern varchar(255) NULL,
	attribute_value_occurrence int4 NULL,
	attribute_is_must bool NULL,
	attribute_is_optional bool NULL,
	CONSTRAINT segment_attributes_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.segments;

CREATE TABLE did.segments (
	id serial4 NOT NULL,
	segments_name varchar(255) NULL,
	status varchar(512) NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL,
	segments_type varchar(512) NULL,
	bu varchar(512) NULL,
	is_dynamic varchar(512) NULL,
	app_or_endpoint varchar(512) NULL,
	CONSTRAINT segments_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.service_account_credential_mapping;

CREATE TABLE did.service_account_credential_mapping (
	id serial4 NOT NULL,
	source_endpoint_id int4 NOT NULL,
	destination_endpoint_id int4 NOT NULL,
	destination_epmuser_id int4 NOT NULL,
	credential_id int4 NOT NULL,
	user_source varchar(255) NOT NULL,
	status varchar(50) NOT NULL,
	user_id int4 NULL,
	eth_address varchar NULL,
	created_at varchar NULL,
	updated_at varchar NULL,
	created_hour varchar NULL,
	eth_status varchar NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	issuer_id int4 NULL,
	pr_submission varchar DEFAULT 'offline'::character varying NOT NULL,
	user_type varchar NULL,
	CONSTRAINT service_account_credential_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.service_account_credential_mapping;

CREATE TABLE did.service_account_credential_mapping (
	id serial4 NOT NULL,
	source_endpoint_id int4 NOT NULL,
	destination_endpoint_id int4 NOT NULL,
	destination_epmuser_id int4 NOT NULL,
	credential_id int4 NOT NULL,
	user_source varchar(255) NOT NULL,
	status varchar(50) NOT NULL,
	user_id int4 NULL,
	eth_address varchar NULL,
	created_at varchar NULL,
	updated_at varchar NULL,
	created_hour varchar NULL,
	eth_status varchar NULL,
	org_id int4 NULL,
	tenant_id int4 NULL,
	issuer_id int4 NULL,
	pr_submission varchar DEFAULT 'offline'::character varying NOT NULL,
	user_type varchar NULL,
	CONSTRAINT service_account_credential_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.service_account_delegations;

CREATE TABLE did.service_account_delegations (
	id serial4 NOT NULL,
	user_id int4 NOT NULL,
	wallet_id int4 NOT NULL,
	"token" text NULL,
	issuer_id int4 NULL,
	CONSTRAINT service_account_delegations_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.service_accounts;

CREATE TABLE did.service_accounts (
	id bigserial NOT NULL,
	domain_id int4 NOT NULL,
	username varchar(255) NOT NULL,
	status varchar(255) DEFAULT 'active'::character varying NOT NULL,
	description text NULL,
	CONSTRAINT service_accounts_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.service_accounts_endpoints;

CREATE TABLE did.service_accounts_endpoints (
	id bigserial NOT NULL,
	"access" bool NULL,
	source_type varchar(100) NULL,
	destination_type varchar(100) NULL,
	service_account_id int8 NOT NULL,
	created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
	created_by int4 NULL,
	wallet_id int8 NOT NULL,
	CONSTRAINT service_accounts_endpoints_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.sid_histories;

CREATE TABLE did.sid_histories (
	sid varchar(255) NOT NULL,
	user_id int4 NOT NULL,
	CONSTRAINT sid_histories_pkey PRIMARY KEY (sid)
);

CREATE TABLE did.source_endpoint (
	id bigserial NOT NULL,
	service_account_endpoints_id int4 NOT NULL,
	endpoint_id int4 NOT NULL,
	CONSTRAINT source_endpoint_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.source_endpoint_group;

CREATE TABLE did.source_endpoint_group (
	id bigserial NOT NULL,
	service_account_endpoints_id int4 NOT NULL,
	endpoint_group_id int4 NOT NULL,
	CONSTRAINT source_endpoint_group_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.sudoers_permission;

CREATE TABLE did.sudoers_permission (
	alias varchar(512) NULL,
	sudoers_user varchar(512) NULL,
	sudoers_host varchar(512) NULL,
	command varchar(512) NULL,
	hostname varchar NULL,
	id serial4 NOT NULL,
	CONSTRAINT sudoers_permission_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.system_log_entries;

CREATE TABLE did.system_log_entries (
	id serial4 NOT NULL,
	time_created varchar(255) NOT NULL,
	message varchar(255) NULL,
	endpoint_id varchar(255) NULL,
	event_id int4 NULL,
	provider_name varchar(255) NULL,
	CONSTRAINT system_log_entries_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.tenant_mfa_config;

CREATE TABLE did.tenant_mfa_config (
	tenant_id varchar(255) NULL,
	factor_id int4 DEFAULT '-1'::integer NULL,
	factor_order int4 DEFAULT '-1'::integer NULL,
	status varchar(16) DEFAULT 'Active'::character varying NULL,
	factor_type varchar(32) NULL
);

DROP TABLE IF EXISTS did.tenant_setup;

CREATE TABLE did.tenant_setup (
	id serial4 NOT NULL,
	tenant_id varchar(255) NOT NULL,
	setup_name varchar NOT NULL,
	setup_status varchar(255) NOT NULL,
	parent_id int4 NULL,
	tenant_status varchar NULL,
	CONSTRAINT tenant_setup_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.tenant_vault_config;

CREATE TABLE did.tenant_vault_config (
	id serial4 NOT NULL,
	tenant_id varchar(512) NULL,
	vault_type varchar(512) NULL,
	root_token varchar(1024) NULL,
	port varchar(524) NULL,
	ip_address varchar(524) NULL,
	CONSTRAINT tenant_vault_config_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.tenants;

CREATE TABLE did.tenants (
	id bigserial NOT NULL,
	tenant_name text NULL,
	admin_email text NULL,
	site_url text NULL,
	created_at timestamptz NULL,
	updated_at timestamptz NULL,
	organization_id int8 NULL,
	status text NULL,
	authentication_method varchar NULL,
	platform_mfa int4 NULL,
	mfa_devices int4 NULL,
	authentication_policy int4 NULL,
	sso_mfa int4 NULL,
	entity_authentication int4 NULL,
	connection_mode int4 NULL,
	credential_store int4 NULL,
	credential_share_mode int4 NULL,
	credential_mode int4 DEFAULT 0 NULL,
	vault_flag varchar NULL,
	sso_mfa_end_user int4 DEFAULT 0 NULL,
	end_user_mfa_cache int4 DEFAULT 0 NOT NULL,
	admin_mfa_cache int4 DEFAULT 0 NOT NULL,
	default_issuer varchar NULL,
	is_dit_enabled varchar NULL,
	time_zone varchar NULL,
	log_output_name varchar NULL,
	image_url varchar(100) NULL,
	session_recording_key varchar(100) NULL,
	session_recording_secret varchar(100) NULL,
	session_recording_region varchar(100) NULL,
	bucket_name varchar(255) NULL,
	disable_root_access bool DEFAULT true NULL,
	CONSTRAINT tenants_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.transactions;

CREATE TABLE did.transactions (
	id serial4 NOT NULL,
	cid varchar(512) NOT NULL,
	chain_address varchar(512) NULL,
	transaction_type varchar(512) NOT NULL,
	ldap_user varchar(512) NOT NULL,
	local_user varchar(512) NOT NULL,
	resource_type varchar(512) NOT NULL,
	resource_ip varchar(512) NOT NULL,
	user_ip varchar(512) NOT NULL,
	date_time varchar(512) NOT NULL,
	transaction_status varchar(512) NOT NULL,
	merkle_hash varchar(512) NOT NULL,
	merkle_status varchar DEFAULT 'NEW'::character varying NOT NULL,
	domain_id varchar DEFAULT '1' NULL,
	transaction_message varchar(512) NULL,
	generated_hour int4 NULL,
	"time" varchar(255) NULL,
	CONSTRAINT transaction_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.trusted_attributes;

CREATE TABLE did.trusted_attributes (
	id serial4 NOT NULL,
	user_name varchar NULL,
	trusted_device varchar(512) NULL,
	trusted_network varchar(255) NULL,
	trusted_city varchar(512) NULL,
	trusted_state varchar(512) NULL,
	trusted_country varchar(512) NULL,
	trusted_region varchar NULL,
	last_updated timestamp NULL,
	CONSTRAINT trusted_attributes_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_access_url;

CREATE TABLE did.user_access_url (
	user_role_id int4 NULL,
	url varchar(1024) NULL
);

DROP TABLE IF EXISTS did.user_ad_groups;

CREATE TABLE did.user_ad_groups (
	user_id int4 NOT NULL,
	group_id int8 NOT NULL
);

DROP TABLE IF EXISTS did.user_app;

CREATE TABLE did.user_app (
	user_app_id serial4 NOT NULL,
	user_id int4 NOT NULL,
	app_id int4 NOT NULL,
	CONSTRAINT user_app_pkey PRIMARY KEY (user_app_id)
);

DROP TABLE IF EXISTS did.user_auth_stats_count;

CREATE TABLE did.user_auth_stats_count (
	id serial4 NOT NULL,
	username varchar NULL,
	groupname varchar NULL,
	identity_type varchar NULL,
	"identity" varchar NULL,
	auth_status varchar NULL,
	auth_count int4 NULL,
	last_updated_time timestamp NULL,
	CONSTRAINT user_auth_stats_count_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_business_categories;

CREATE TABLE did.user_business_categories (
	user_id int4 NOT NULL,
	business_category_id int8 NOT NULL
);

DROP TABLE IF EXISTS did.user_credential_mapping;

CREATE TABLE did.user_credential_mapping (
	id serial4 NOT NULL,
	epm_user_id int4 NOT NULL,
	credential_id int4 NOT NULL,
	user_source varchar(255) DEFAULT NULL::character varying NOT NULL,
	status varchar(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
	CONSTRAINT user_credential_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_creds;

CREATE TABLE did.user_creds (
	id serial4 NOT NULL,
	user_id int4 NOT NULL,
	pub_key text NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT fk_one_to_one UNIQUE (user_id),
	CONSTRAINT user_creds_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_group;

CREATE TABLE did.user_group (
	group_id serial4 NOT NULL,
	group_name varchar(255) NOT NULL,
	roles varchar(255) DEFAULT ''::character varying NOT NULL,
	otp_method varchar(255) DEFAULT ''::character varying NOT NULL,
	metadata varchar(255) DEFAULT ''::character varying NOT NULL,
	domain_id varchar(255) DEFAULT ''::character varying NOT NULL,
	base_dn varchar(255) DEFAULT ''::character varying NOT NULL,
	cn varchar(255) DEFAULT ''::character varying NOT NULL,
	ou varchar(255) DEFAULT ''::character varying NOT NULL,
	fieldmappings varchar(255) DEFAULT ''::character varying NOT NULL,
	CONSTRAINT user_group_pkey PRIMARY KEY (group_id)
);

DROP TABLE IF EXISTS did.user_group_mapping;

CREATE TABLE did.user_group_mapping (
	id serial4 NOT NULL,
	group_id int4 NOT NULL,
	user_id int4 NOT NULL,
	CONSTRAINT user_group_mapping_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_mfa_config;

CREATE TABLE did.user_mfa_config (
	user_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	org_id int4 NOT NULL,
	app_id int4 NOT NULL,
	mfa_type int4 NOT NULL,
	mfa_detail text NULL,
	status varchar(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp DEFAULT now() NULL
);

DROP TABLE IF EXISTS did.user_object_classes;

CREATE TABLE did.user_object_classes (
	object_class_id int8 NOT NULL,
	user_id int4 NOT NULL
);

DROP TABLE IF EXISTS did.user_privileges;

CREATE TABLE did.user_privileges (
	id serial4 NOT NULL,
	userid varchar(512) NOT NULL,
	resource_name varchar(512) NOT NULL,
	resource_type varchar(512) NOT NULL,
	status_code varchar(50) NOT NULL,
	approved_by varchar(512) NULL,
	created_at timestamp DEFAULT now() NULL,
	updated_at timestamp NULL,
	resource_path varchar(512) NULL,
	endpoints varchar(512) NULL,
	operations varchar(512) NOT NULL,
	user_roles_permission_id serial4 NOT NULL,
	CONSTRAINT user_privileges_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_roles_permission;

CREATE TABLE did.user_roles_permission (
	id serial4 NOT NULL,
	"role" varchar(255) DEFAULT ''::character varying(1) NOT NULL,
	permissions varchar(255) DEFAULT ''::character varying(1) NOT NULL,
	CONSTRAINT user_roles_permission_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_segment_permission;

CREATE TABLE did.user_segment_permission (
	id int4 NOT NULL,
	user_id int4 NULL,
	segment_id int4 NULL,
	permission_id int4 NULL,
	permission_type int4 NULL,
	status varchar(50) DEFAULT 'Active'::character varying NULL,
	CONSTRAINT user_segment_permission_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_verifiable_credentials;

CREATE TABLE did.user_verifiable_credentials (
	id serial4 NOT NULL,
	domain_id int4 NOT NULL,
	issuer_did varchar(64) NOT NULL,
	holder_did varchar(64) NOT NULL,
	vc_id varchar(64) DEFAULT NULL::character varying NULL,
	status varchar(45) NOT NULL,
	user_id int4 NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NULL,
	CONSTRAINT user_verifiable_credentials_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_wallet_credentials;

CREATE TABLE did.user_wallet_credentials (
	id serial4 NOT NULL,
	wallet_id int4 NOT NULL,
	user_id int4 NOT NULL,
	credential_id int4 NOT NULL,
	acknowledgement varchar(10) DEFAULT 'ASSIGNED'::character varying NOT NULL,
	CONSTRAINT user_wallet_credentials_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.user_wallets;

CREATE TABLE did.user_wallets (
	id serial4 NOT NULL,
	domain_id int4 NOT NULL,
	wallet_url varchar(64) NOT NULL,
	user_id int4 NOT NULL,
	status varchar(64) NOT NULL,
	wallet_key varchar(45) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	registered_country varchar NULL,
	registered_state varchar NULL,
	registered_city varchar NULL,
	device_id varchar NULL,
	coord varchar NULL,
	biometric_protected bool NULL,
	device_os varchar NULL,
	network varchar(255) NULL,
	CONSTRAINT user_wallets_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.users;

CREATE TABLE did.users (
	user_id serial4 NOT NULL,
	email_address varchar(255) DEFAULT ''::character varying NOT NULL,
	phone_number varchar(255) DEFAULT ''::character varying NOT NULL,
	city varchar(255) DEFAULT ''::character varying NOT NULL,
	country varchar(255) DEFAULT ''::character varying NOT NULL,
	industry varchar(255) DEFAULT ''::character varying NOT NULL,
	organization varchar(255) DEFAULT ''::character varying NOT NULL,
	company_headcount varchar(255) DEFAULT ''::character varying NOT NULL,
	firstname varchar(255) DEFAULT ''::character varying NOT NULL,
	lastname varchar(255) DEFAULT ''::character varying NOT NULL,
	address varchar(255) DEFAULT ''::character varying NOT NULL,
	user_password varchar(255) DEFAULT ''::character varying NOT NULL,
	domain_id varchar NULL,
	status varchar(255) DEFAULT ''::character varying NOT NULL,
	otp_method varchar(255) DEFAULT ''::character varying NOT NULL,
	metadata varchar(255) DEFAULT ''::character varying NOT NULL,
	dn varchar(255) DEFAULT ''::character varying NOT NULL,
	user_role_id int2 DEFAULT '0'::smallint NOT NULL,
	logon_name varchar(255) DEFAULT ''::character varying NOT NULL,
	org_id int4 NULL,
	first_login varchar(255) NULL,
	created_at int4 DEFAULT EXTRACT(epoch FROM now())::integer NULL,
	CONSTRAINT users_pkey PRIMARY KEY (user_id)
);

DROP TABLE IF EXISTS did.users_dids;

CREATE TABLE did.users_dids (
	id serial4 NOT NULL,
	user_id int4 NOT NULL,
	did varchar(64) NOT NULL,
	private_key varchar(128) NOT NULL,
	issuer_did varchar(64) NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	domain_id int4 NOT NULL,
	description varchar(45) NOT NULL,
	status varchar(20) DEFAULT 'ACTIVE'::character varying NOT NULL,
	did_name varchar(45) NOT NULL,
	CONSTRAINT users_dids_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.verifiable_credentials;

CREATE TABLE did.verifiable_credentials (
	id serial4 NOT NULL,
	domain_id int4 NOT NULL,
	issuer_id int4 NOT NULL,
	credential_id varchar(255) NOT NULL,
	status varchar(15) DEFAULT 'INACTIVE'::character varying NOT NULL,
	created_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	updated_at timestamp(0) DEFAULT CURRENT_TIMESTAMP NOT NULL,
	CONSTRAINT verifiable_credentials_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.verifier_dids;

CREATE TABLE did.verifier_dids (
	id serial4 NOT NULL,
	did varchar(64) NOT NULL,
	domain_id int4 NOT NULL,
	issuer_id int4 NOT NULL,
	private_key varchar(128) DEFAULT NULL::character varying NULL,
	CONSTRAINT verifier_dids_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.wallet_user_ad_mapping;

CREATE TABLE did.wallet_user_ad_mapping (
	ad_id serial4 NOT NULL,
	wallet_user_id int4 NOT NULL,
	tenant_id int4 NOT NULL,
	ad_domain_id int4 NOT NULL,
	CONSTRAINT wallet_user_ad_mapping_pkey PRIMARY KEY (ad_id)
);

DROP TABLE IF EXISTS did.workload_identities;

CREATE TABLE did.workload_identities (
	id bigserial NOT NULL,
	domain_id int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	"type" varchar(255) NOT NULL,
	created_by varchar(255) NOT NULL,
	CONSTRAINT workload_identities_pkey PRIMARY KEY (id)
);

DROP TABLE IF EXISTS did.workload_identity_groups;

CREATE TABLE did.workload_identity_groups (
	id bigserial NOT NULL,
	domain_id int4 NOT NULL,
	"name" varchar(255) NOT NULL,
	CONSTRAINT workload_identity_groups_pkey PRIMARY KEY (id)
);

CREATE TABLE did.ad_user_devices (
    id              SERIAL PRIMARY KEY,
    org_id          INTEGER NOT NULL,
    tenant_id       INTEGER NOT NULL,
    user_id         INTEGER NOT NULL,
    email           VARCHAR NOT NULL,
    expo_push_token VARCHAR NOT NULL,
    platform        VARCHAR NOT NULL,
    device_name     VARCHAR NOT NULL,
    is_active       BOOLEAN NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_used_at    TIMESTAMPTZ
);

CREATE TABLE did.ad_mfa_enrollments (
    id         SERIAL PRIMARY KEY,
    org_id     INTEGER NOT NULL,
    tenant_id  INTEGER NOT NULL,
    user_id    INTEGER NOT NULL,
    email      VARCHAR NOT NULL,
    token      VARCHAR NOT NULL,
    used       BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMPTZ NOT NULL
);

CREATE TABLE did.ad_mfa_challenges (
    id                    SERIAL PRIMARY KEY,
    org_id                INTEGER NOT NULL,
    tenant_id             INTEGER NOT NULL,
    gateway_id            VARCHAR NOT NULL,
    email                 VARCHAR NOT NULL,
    binding_message       VARCHAR NOT NULL,
    status                VARCHAR NOT NULL,
    provider              VARCHAR NOT NULL,
    external_challenge_id VARCHAR,
    created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    expires_at            TIMESTAMPTZ NOT NULL,
    responded_at          TIMESTAMPTZ
);

CREATE TABLE did.ad_mfa_provider_config (
    org_id     INTEGER NOT NULL,
    provider   VARCHAR NOT NULL,
    config     TEXT NOT NULL,   -- AES-GCM encrypted JSON
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (org_id)
);