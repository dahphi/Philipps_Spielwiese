grant delete on awh_main.awh_system to awh_apex;

grant insert on awh_main.awh_system to awh_apex;

grant select on awh_main.awh_system to awh_apex;

grant select on awh_main.awh_system to am_main;

grant select on awh_main.awh_system to am_apex;

grant select on awh_main.awh_system to rk_apex;

grant update on awh_main.awh_system to awh_apex;

grant references on awh_main.awh_system to am_main;

grant read on awh_main.awh_system to awh_read_jira;




-- sqlcl_snapshot {"hash":"2bac5e10f9d5c2b169fbf2ee754cadc838251498","type":"OBJECT_GRANT","name":"object_grants_as_grantor.AWH_MAIN.TABLE.AWH_SYSTEM","schemaName":"AWH_MAIN","sxml":""}