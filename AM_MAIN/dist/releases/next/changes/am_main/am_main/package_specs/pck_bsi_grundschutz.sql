-- liquibase formatted sql
-- changeset AM_MAIN:1774605608080 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_bsi_grundschutz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_bsi_grundschutz.sql:697c91d30ce0ff9d90edc0da6e652a9465858fb7:24b81ac16d96af7470e6cccabfb0cfca33e82547:alter

create or replace package am_main.pck_bsi_grundschutz as

  --Merge
    procedure merge_baustein (
        p_row  in bsi_grundschutzbausteine%rowtype,
        p_user in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        )
    );

  -- Löschen perBSI BAUSTEINE
    procedure delete_baustein (
        p_bsi_uid in number
    );

    procedure sync_asset_bausteine (
        p_ass_uid_fk    in number,
        p_asset_typ     in varchar2,
        p_shuttle_value in varchar2,
        p_inserted_by   in varchar2 default null
    );

end pck_bsi_grundschutz;
/

