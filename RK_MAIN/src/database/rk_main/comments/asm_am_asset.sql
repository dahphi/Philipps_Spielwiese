comment on column rk_main.asm_am_asset.ass_beschreibung is
    'Beschreibung des Objekts';

comment on column rk_main.asm_am_asset.ass_custodian_san is
    'SAMAccountName Data Custodian gemäß AD';

comment on column rk_main.asm_am_asset.ass_dataowner_san is
    'sAMAccountname Data Owner gemäß AD';

comment on column rk_main.asm_am_asset.ass_id is
    'eindeutige Bezeichnung';

comment on column rk_main.asm_am_asset.ass_kritis_relevant is
    '0=nein, 1=ja';

comment on column rk_main.asm_am_asset.ass_spot_referenz is
    'URL zur Asset-Definition';

comment on column rk_main.asm_am_asset.ass_uid is
    'Primärschlüssel';

comment on column rk_main.asm_am_asset.aut_lfd_nr is
    'Fremdschlüssel SBF Authentizität';

comment on column rk_main.asm_am_asset.fkl_uid is
    'UID der Funktionsklasse';

comment on column rk_main.asm_am_asset.gek_lfd_nr is
    'Foreign Key Geschäftskitikalität';

comment on column rk_main.asm_am_asset.inserted is
    'Insert Datum';

comment on column rk_main.asm_am_asset.inserted_by is
    'Insert User';

comment on column rk_main.asm_am_asset.int_lfd_nr is
    'Fremdschlüssel SBF Integrität';

comment on column rk_main.asm_am_asset.updated is
    'Update Datum';

comment on column rk_main.asm_am_asset.updated_by is
    'Update User';

comment on column rk_main.asm_am_asset.vef_lfd_nr is
    'Fremdschlüssel SBF Verfügbarkeit';

comment on column rk_main.asm_am_asset.vet_lfd_nr is
    'Fremdschlüssel SBF Vertraulichkeit';


-- sqlcl_snapshot {"hash":"091924e27c574f1145954aa0e63d91f7c1de37fb","type":"COMMENT","name":"asm_am_asset","schemaName":"rk_main","sxml":""}