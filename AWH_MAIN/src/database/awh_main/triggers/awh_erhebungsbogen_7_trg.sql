create or replace editionable trigger awh_main.awh_erhebungsbogen_7_trg before
    insert on awh_main.awh_erhebungsbogen_7
    for each row
begin
    << column_sequences >> begin
        null;
    end column_sequences;
end;
/

alter trigger awh_main.awh_erhebungsbogen_7_trg enable;


-- sqlcl_snapshot {"hash":"cb9835f80481e170edab7b675382048da929ecb8","type":"TRIGGER","name":"AWH_ERHEBUNGSBOGEN_7_TRG","schemaName":"AWH_MAIN","sxml":""}