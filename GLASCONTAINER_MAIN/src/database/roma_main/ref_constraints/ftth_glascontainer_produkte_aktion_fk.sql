alter table roma_main.ftth_glascontainer_produkte
    add constraint ftth_glascontainer_produkte_aktion_fk
        foreign key ( aktion )
            references roma_main.ftth_glascontainer_aktionen ( code )
        enable;


-- sqlcl_snapshot {"hash":"546f9abe241170403c2cef65c2454952948fed7c","type":"REF_CONSTRAINT","name":"FTTH_GLASCONTAINER_PRODUKTE_AKTION_FK","schemaName":"ROMA_MAIN","sxml":""}