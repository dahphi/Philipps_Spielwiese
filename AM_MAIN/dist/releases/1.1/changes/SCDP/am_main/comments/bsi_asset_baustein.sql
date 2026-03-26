-- liquibase formatted sql
-- changeset am_main:1774557115096 stripComments:false logicalFilePath:SCDP/am_main/comments/bsi_asset_baustein.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/comments/bsi_asset_baustein.sql:null:bfee3d49869f78b19b83311ba180e8f54230d82e:create

comment on column am_main.bsi_asset_baustein.asset_typ is
    'Assettypen, Quelle ASM_AM_ASSETTYPEN';

comment on column am_main.bsi_asset_baustein.ass_uid_fk is
    'FK auf ASSETS(aus verschiedenen Tabellen)';

comment on column am_main.bsi_asset_baustein.bsi_uid_fk is
    'FK auf BSI_GRUNDSCHUTZBAUSTEINE';

