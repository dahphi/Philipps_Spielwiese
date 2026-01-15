alter table ftth_glascontainer_produkte
    add constraint ftth_glascontainer_produkte_folgeprodukt_fk
        foreign key ( folgeprodukt_template_id )
            references ftth_glascontainer_produkte ( template_id )
        enable;


-- sqlcl_snapshot {"hash":"bf45755b46c31378ad5dd7001a2117ed154ca308","type":"REF_CONSTRAINT","name":"FTTH_GLASCONTAINER_PRODUKTE_FOLGEPRODUKT_FK","schemaName":"ROMA_MAIN","sxml":""}