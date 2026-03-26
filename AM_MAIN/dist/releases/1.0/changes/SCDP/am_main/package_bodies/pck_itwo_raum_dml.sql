-- liquibase formatted sql
-- changeset AM_MAIN:1774556571565 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_itwo_raum_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_itwo_raum_dml.sql:null:39c667ed83279a5b033cfb84e1b0f7191d7074b5:create

create or replace package body am_main.pck_itwo_raum_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

    procedure p_insert (
        pior_itwo_raum in out itwo_raum%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        insert into itwo_raum values pior_itwo_raum;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ITWO_RAUM_import_hist! Parameter: ' || fv_print( pir_row => pior_ITWO_RAUM_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert;

    procedure p_update (
        pior_itwo_raum in out itwo_raum%rowtype
    ) is
        r_itwo_raum    itwo_raum%rowtype;  
  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        r_itwo_raum.raum := pior_itwo_raum.raum;
        r_itwo_raum.site := pior_itwo_raum.site;
        r_itwo_raum.standortpfad := pior_itwo_raum.standortpfad;
        update itwo_raum
        set
            row = r_itwo_raum
        where
            raum = pior_itwo_raum.raum;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ITWO_SITE_import_hist! Parameter: ' || fv_print( pir_row => pior_ITWO_SITE_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_update;

end pck_itwo_raum_dml;
/

