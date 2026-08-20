
CREATE INDEX idx_db_hosts_agent_vm ON did.db_hosts USING btree (agent_vm_ip);
CREATE INDEX idx_db_hosts_org_tenant ON did.db_hosts USING btree (org_id, tenant_id);
CREATE INDEX fk2_linuxmachinesmachine_id ON did.epm_group_machine_mapping USING btree (machine_id);
CREATE INDEX fk1_esgm_machine_id_epmm_machine_id ON did.epm_server_group_mapping USING btree (machine_id);
CREATE INDEX fk2_esg_id_epsgm_epm_server_group_id ON did.epm_server_group_mapping USING btree (epm_server_group_id);
CREATE INDEX epm_user_id ON did.epm_users_cred_management USING btree (epm_user_id);
CREATE INDEX fk1_user_group_group_id ON did.epm_users_group_mapping USING btree (group_id);
CREATE INDEX fk2_linux_machines_linux_user_id ON did.epm_users_group_mapping USING btree (epm_user_id);
CREATE INDEX fk1_jobs_domain_id_domains_domain_id ON did.jobs USING btree (domain_id);
CREATE INDEX idx_mfa_methods_client_enabled ON did.mfa_methods USING btree (client_id, enabled);
CREATE INDEX idx_mfa_methods_expires ON did.mfa_methods USING btree (expires_at);
CREATE INDEX idx_mfa_methods_type ON did.mfa_methods USING btree (method_type);
CREATE INDEX idx_mfa_methods_user_id ON did.mfa_methods USING btree (user_id);
CREATE UNIQUE INDEX idx_user_method_unique ON did.mfa_methods USING btree (user_id, method_type);
CREATE UNIQUE INDEX unique_client_method ON did.mfa_methods USING btree (client_id, method_type);
CREATE INDEX fk1_sh_user_id_users_user_id ON did.sid_histories USING btree (user_id);
ALTER TABLE did.account_group_rels ADD CONSTRAINT account_group_rels_endpoint_group_id_fkey FOREIGN KEY (endpoint_group_id) REFERENCES did.endpoint_groups(id) ON DELETE CASCADE;
ALTER TABLE did.account_group_rels ADD CONSTRAINT account_group_rels_service_account_id_fkey FOREIGN KEY (service_account_id) REFERENCES did.service_accounts(id) ON DELETE CASCADE;
