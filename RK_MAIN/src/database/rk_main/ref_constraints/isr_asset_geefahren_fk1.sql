alter table rk_main.isr_asset_geefahren
    add constraint isr_asset_geefahren_fk1
        foreign key ( gef_uid )
            references rk_main.isr_brm_gefaehrdung ( gef_uid )
        enable;


-- sqlcl_snapshot {"hash":"c9f7633a56fa3add2307bfe3df75cebfff752d86","type":"REF_CONSTRAINT","name":"ISR_ASSET_GEEFAHREN_FK1","schemaName":"RK_MAIN","sxml":""}