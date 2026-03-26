alter table awh_main.awh_erhebungsbogen_temp
    add constraint awh_erhebungsbogen_temp_fk1
        foreign key ( asy_lfd_nr )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"91297fd0605d7c46b6c5a3a7dad47443157e3b81","type":"REF_CONSTRAINT","name":"AWH_ERHEBUNGSBOGEN_TEMP_FK1","schemaName":"AWH_MAIN","sxml":""}