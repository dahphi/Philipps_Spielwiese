alter table ftth_glascontainer_produkte
    add constraint ftth_glascontainer_produkte_aktion_fk
        foreign key ( aktion )
            references ftth_glascontainer_aktionen ( code )
        enable;


-- sqlcl_snapshot {"hash":"a94296af2d0ba333ed07d4c775d69533b47cf4ca","type":"REF_CONSTRAINT","name":"FTTH_GLASCONTAINER_PRODUKTE_AKTION_FK","schemaName":"ROMA_MAIN","sxml":""}