alter table awh_main.awh_erheb_anhang
    add constraint awh_erheb_anhang_fk1
        foreign key ( asy_lfd_nr )
            references awh_main.awh_system ( asy_lfd_nr )
        enable;


-- sqlcl_snapshot {"hash":"f54f8728606058f678c071daf5e948e3f84a1cf3","type":"REF_CONSTRAINT","name":"AWH_ERHEB_ANHANG_FK1","schemaName":"AWH_MAIN","sxml":""}