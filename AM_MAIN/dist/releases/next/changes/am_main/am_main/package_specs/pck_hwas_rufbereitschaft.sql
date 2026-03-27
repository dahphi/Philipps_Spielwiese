-- liquibase formatted sql
-- changeset AM_MAIN:1774600121497 stripComments:false logicalFilePath:am_main/am_main/package_specs/pck_hwas_rufbereitschaft.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_specs/pck_hwas_rufbereitschaft.sql:null:590abc6997e26716a9382816d3347b3ff642965b:create

create or replace package am_main.pck_hwas_rufbereitschaft as
  -- Merge eines einzelnen Datensatzes
    procedure merge_row (
        p_row  in hwas_rufbereitschaft%rowtype,
        p_user in varchar2 default nvl(
            sys_context('APEX$SESSION', 'APP_USER'),
            user
        )
    );

  -- Löschen per Primärschlüssel
    procedure delete_row (
        p_ruf_uid in number
    );

end pck_hwas_rufbereitschaft;
/

