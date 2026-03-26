-- liquibase formatted sql
-- changeset rk_main:1774554916043 stripComments:false logicalFilePath:SCDP/rk_main/comments/asm_am_assettypen.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot RK_MAIN/src/database/rk_main/comments/asm_am_assettypen.sql:null:13c58ef33b85d074f88bcf469543de5f6b830fc1:create

comment on column rk_main.asm_am_assettypen.ast_beschreibung is
    'Beschreibungstext';

comment on column rk_main.asm_am_assettypen.ast_name is
    'eindeutige Bezeichnung';

comment on column rk_main.asm_am_assettypen.ast_uid is
    'Primärschlüssel';

comment on column rk_main.asm_am_assettypen.inserted is
    'Insert Datum';

comment on column rk_main.asm_am_assettypen.inserted_by is
    'Insert User';

comment on column rk_main.asm_am_assettypen.updated is
    'Update Datum';

comment on column rk_main.asm_am_assettypen.updated_by is
    'Update User';

