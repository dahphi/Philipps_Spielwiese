alter table apex_export_user.templates
    add
        foreign key ( parent_template_id )
            references apex_export_user.templates ( id )
        enable;


-- sqlcl_snapshot {"hash":"4366e396b96b19fb29cdac7ec8823aeca55cf02c","type":"REF_CONSTRAINT","name":"TEMPLATES.APEX_EXPORT_USER.TEMPLATES","schemaName":"APEX_EXPORT_USER"}