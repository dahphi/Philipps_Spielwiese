grant select on awh_main.v_hwas_awh_mtn_sys_vm to am_apex;

grant select on awh_main.v_hwas_awh_mtn_sys_vm to am_main;

grant select on awh_main.v_hwas_awh_mtn_sys_vm to rk_main;

grant select on awh_main.v_hwas_awh_mtn_sys_vm to rk_apex;

grant references on awh_main.v_hwas_awh_mtn_sys_vm to am_main;

grant references on awh_main.v_hwas_awh_mtn_sys_vm to am_apex;

grant references on awh_main.v_hwas_awh_mtn_sys_vm to rk_main;

grant references on awh_main.v_hwas_awh_mtn_sys_vm to rk_apex;




-- sqlcl_snapshot {"hash":"dc99493e4483accb13df98ec0724aa3f2dedd451","type":"OBJECT_GRANT","name":"object_grants_as_grantor.AWH_MAIN.VIEW.V_HWAS_AWH_MTN_SYS_VM","schemaName":"AWH_MAIN","sxml":""}