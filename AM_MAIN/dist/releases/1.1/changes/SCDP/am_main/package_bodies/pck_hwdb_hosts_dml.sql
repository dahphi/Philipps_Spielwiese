-- liquibase formatted sql
-- changeset AM_MAIN:1774557119476 stripComments:false logicalFilePath:SCDP/am_main/package_bodies/pck_hwdb_hosts_dml.sql runAlways:false runOnChange:false replaceIfExists:true failOnError:true
-- sqlcl_snapshot AM_MAIN/src/database/am_main/package_bodies/pck_hwdb_hosts_dml.sql:null:f60079e4ab666d450aec89fa9678c686fd7a5687:create

create or replace package body am_main.pck_hwdb_hosts_dml as

  -- Variablen etc.
    gcv_package_name constant varchar2(100) := $$plsql_unit;

    procedure p_insert (
        pior_hwdb_hosts in out hwdb_hosts%rowtype
    ) is

  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_INSERT';
        pior_hwdb_hosts.inserted := sysdate;
        pior_hwdb_hosts.inserted_by := pck_env.fv_user;
        insert into hwdb_hosts values pior_hwdb_hosts;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle HWDB_HOSTS_import_hist! Parameter: ' || fv_print( pir_row => pior_HWDB_HOSTS_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_insert;

    procedure p_update (
        pior_hwdb_hosts in out hwdb_hosts%rowtype
    ) is
        r_hwdb_hosts   hwdb_hosts%rowtype;  
  -- fuer exceptions
        v_routine_name logs.routine_name%type;
        c_message      clob;
    begin
  -- fuer exceptions
        v_routine_name := gcv_package_name || '.P_UPDATE';
        select
            inserted,
            inserted_by
        into
            r_hwdb_hosts.inserted,
            r_hwdb_hosts.inserted_by
        from
            hwdb_hosts
        where
            hostname = pior_hwdb_hosts.hostname;

        r_hwdb_hosts.hostname := pior_hwdb_hosts.hostname;
        r_hwdb_hosts.hersteller := pior_hwdb_hosts.hersteller;
        r_hwdb_hosts.modell := pior_hwdb_hosts.modell;
        r_hwdb_hosts.funktionsklasse := pior_hwdb_hosts.funktionsklasse;
        r_hwdb_hosts.location := pior_hwdb_hosts.location;
        r_hwdb_hosts.raum := pior_hwdb_hosts.raum;
        r_hwdb_hosts.updated := sysdate;
        r_hwdb_hosts.updated_by := pck_env.fv_user;
        r_hwdb_hosts.status := pior_hwdb_hosts.status;

      --dbms_output.put_line(r_HWDB_HOSTS.HOSTNAME || r_HWDB_HOSTS.HERSTELLER || r_HWDB_HOSTS.inserted);
        update hwdb_hosts
        set
            row = r_hwdb_hosts
        where
            hostname = pior_hwdb_hosts.hostname;

    exception
        when others then
    -- Fehlerprotokollierung
    --c_message := 'Fehler bei Insert in Tabelle HWDB_HOSTS_import_hist! Parameter: ' || fv_print( pir_row => pior_HWDB_HOSTS_import_hist );
    --pck_logs.p_error( piv_routine_name => v_routine_name, pic_message => c_message );
            raise;
    end p_update;

end pck_hwdb_hosts_dml;
/

