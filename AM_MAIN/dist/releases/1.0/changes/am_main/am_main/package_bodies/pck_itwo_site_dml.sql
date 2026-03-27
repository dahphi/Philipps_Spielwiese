-- liquibase formatted sql
-- changeset AM_MAIN:1774600119632 stripComments:false logicalFilePath:am_main/am_main/package_bodies/pck_itwo_site_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_itwo_site_dml.sql:null:841bdd07f3b68d0e9d9e22e81035b9685557ba50:create

create or replace package body am_main.pck_itwo_site_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

    procedure p_insert (
        pior_itwo_site in out itwo_site%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';

  --pior_ITWO_SITE.inserted         := SYSDATE;
  --pior_ITWO_SITE.inserted_by      := pck_env.fv_user;

        insert into itwo_site values pior_itwo_site;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ITWO_SITE_import_hist! Parameter: ' || fv_print( pir_row => pior_ITWO_SITE_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert;

    procedure p_update (
        pior_itwo_site in out itwo_site%rowtype
    ) is
        r_itwo_site    itwo_site%rowtype;  
  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';

    --select inserted, inserted_by  
    --  into r_ITWO_SITE.inserted, r_ITWO_SITE.inserted_by  
    --  from ITWO_SITE  
    --  where  OBJ_ID  = pior_ITWO_SITE.OBJ_ID; 

        r_itwo_site.obj_id := pior_itwo_site.obj_id;
        r_itwo_site.site := pior_itwo_site.site;
        r_itwo_site.plz := pior_itwo_site.plz;
        r_itwo_site.stadt := pior_itwo_site.stadt;
        r_itwo_site.strasse := pior_itwo_site.strasse;
        r_itwo_site.haus_nr := pior_itwo_site.haus_nr;

      --dbms_output.put_line(r_ITWO_SITE.OBJ_ID || r_ITWO_SITE.SITE || r_ITWO_SITE.inserted);
        update itwo_site
        set
            row = r_itwo_site
        where
            obj_id = pior_itwo_site.obj_id;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle ITWO_SITE_import_hist! Parameter: ' || fv_print( pir_row => pior_ITWO_SITE_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_update;

end pck_itwo_site_dml;
/

