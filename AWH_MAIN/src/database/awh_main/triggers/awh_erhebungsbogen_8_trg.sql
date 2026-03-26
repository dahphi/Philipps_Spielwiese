create or replace editionable trigger awh_main.awh_erhebungsbogen_8_trg before
    insert on awh_main.awh_erhebungsbogen_8
    for each row
begin
    << column_sequences >> begin
        if
            inserting
            and :new.eb8_lfd_nr is null
        then
            select
                awh_erhebungsbogen_8_seq.nextval
            into :new.eb8_lfd_nr
            from
                sys.dual;

        end if;
    end column_sequences;
end;
/

alter trigger awh_main.awh_erhebungsbogen_8_trg enable;


-- sqlcl_snapshot {"hash":"5bff96bcc94f6e54a656683f7229354e3fe641e8","type":"TRIGGER","name":"AWH_ERHEBUNGSBOGEN_8_TRG","schemaName":"AWH_MAIN","sxml":""}