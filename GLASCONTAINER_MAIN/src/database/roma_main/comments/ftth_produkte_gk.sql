comment on table ftth_produkte_gk is
    'Tabelle um die Produkte für GK abzubilden.';

comment on column ftth_produkte_gk.fpgk_access_type is
    'Access Type des Produktes, dem die Produkte zugeordnet werden';

comment on column ftth_produkte_gk.fpgk_id is
    'PK';

comment on column ftth_produkte_gk.fpgk_produktname is
    'Name des Produktes, der angezeigt wird';

comment on column ftth_produkte_gk.fpgk_status is
    'Status des Produktes. Wertemenge: AKTIV, INAKTIV';

comment on column ftth_produkte_gk.fpgk_template_id is
    'Template ID des Produktes';

comment on column ftth_produkte_gk.inserted is
    'Insert Datum';

comment on column ftth_produkte_gk.inserted_by is
    'Insert User';

comment on column ftth_produkte_gk.updated is
    'Update Datum';

comment on column ftth_produkte_gk.updated_by is
    'Update User';


-- sqlcl_snapshot {"hash":"ac000511a80269c7af7f3f50c319c57db04fed0e","type":"COMMENT","name":"ftth_produkte_gk","schemaName":"roma_main","sxml":""}