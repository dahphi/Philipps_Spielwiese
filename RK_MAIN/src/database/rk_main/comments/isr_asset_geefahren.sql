comment on column rk_main.isr_asset_geefahren.asge_uid is
    'Primärschlüssel';

comment on column rk_main.isr_asset_geefahren.asset_uid is
    'Fremschlüssel Asset (auf am_main.V_ASSET)';

comment on column rk_main.isr_asset_geefahren.gefaehrdet is
    'NULL = nicht bewertet, 0 nicht gefaehrdet, 1 gefaehrdet';

comment on column rk_main.isr_asset_geefahren.gef_uid is
    'Fremschlüssel Gefährudnung';


-- sqlcl_snapshot {"hash":"5f519fee0e835c185e044fdfbc270775d98d0531","type":"COMMENT","name":"isr_asset_geefahren","schemaName":"rk_main","sxml":""}