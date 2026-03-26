grant select on awh_main.v_hwas_awh_system to am_apex;

grant select on awh_main.v_hwas_awh_system to rk_apex;

grant select on awh_main.v_hwas_awh_system to am_main;

grant select on awh_main.v_hwas_awh_system to rk_main;

grant select on awh_main.v_hwas_awh_system to awh_apex;

grant references on awh_main.v_hwas_awh_system to am_main;

grant references on awh_main.v_hwas_awh_system to am_apex;

grant references on awh_main.v_hwas_awh_system to rk_main;

grant references on awh_main.v_hwas_awh_system to rk_apex;




-- sqlcl_snapshot {"hash":"f388c98e8bfc5ea4f2d230878ab1ad9e978f551f","type":"OBJECT_GRANT","name":"object_grants_as_grantor.AWH_MAIN.VIEW.V_HWAS_AWH_SYSTEM","schemaName":"AWH_MAIN","sxml":""}