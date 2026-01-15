alter table roma_main.ftth_glascontainer_produkte
    add constraint ftth_glascontainer_produkte_folgeprodukt_fk
        foreign key ( folgeprodukt_template_id )
            references roma_main.ftth_glascontainer_produkte ( template_id )
        enable;


-- sqlcl_snapshot {"hash":"e8cdebe3878779ef8489ac0ec8353ff0d4201602","type":"REF_CONSTRAINT","name":"FTTH_GLASCONTAINER_PRODUKTE_FOLGEPRODUKT_FK","schemaName":"ROMA_MAIN","sxml":""}