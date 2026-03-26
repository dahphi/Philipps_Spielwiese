create or replace editionable trigger awh_main.trg_awh_system_eudsgvo after
    insert on awh_main.awh_system
    for each row
begin
    merge into awh_eudsgvo dest
    using (
        select
            :new.asy_lfd_nr as asy_lfd_nr
        from
            dual
    ) src on ( src.asy_lfd_nr = dest.asy_lfd_nr )
    when not matched then
    insert ( asy_lfd_nr )
    values
        ( src.asy_lfd_nr );

end;
/

alter trigger awh_main.trg_awh_system_eudsgvo enable;


-- sqlcl_snapshot {"hash":"955e92bf8e0a3492f85e7ea552c85733de074473","type":"TRIGGER","name":"TRG_AWH_SYSTEM_EUDSGVO","schemaName":"AWH_MAIN","sxml":""}