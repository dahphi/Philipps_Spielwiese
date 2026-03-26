-- liquibase formatted sql
-- changeset AM_MAIN:1774556571726 stripComments:false logicalFilePath:SCDP/am_main/package_specs/pck_bsi_grundschutz.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_bsi_grundschutz.sql:null:697c91d30ce0ff9d90edc0da6e652a9465858fb7:create

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

end pck_bsi_grundschutz;
/

