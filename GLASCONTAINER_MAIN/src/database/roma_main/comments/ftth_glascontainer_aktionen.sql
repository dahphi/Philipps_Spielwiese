comment on table roma_main.ftth_glascontainer_aktionen is
    'Liste aller im Glascontainer jemals verwendeten Produktgenerationen, auch zukünftige.';

comment on column roma_main.ftth_glascontainer_aktionen.aktuell is
    'Genau ein Datensatz darf das Flag 1 besitzen. Dies entspricht der aktuellen Produktgeneration. Sie wird erst dann als aktuelle Generation behandelt, wenn dieses Flag = 1 ist UND das GUELTIG_AB-Datum erreicht ist.'
    ;

comment on column roma_main.ftth_glascontainer_aktionen.code is
    'Primärschlüssel der Aktion, üblicherweise der nominelle kalendarische Beginn der Produktgeneration im Format YYYY-MM';

comment on column roma_main.ftth_glascontainer_aktionen.gueltig_ab is
    'Bei allen Versionen steht in diesem Feld die erste Sekunde, ab der die Produktgeneration gültig wird.';

comment on column roma_main.ftth_glascontainer_aktionen.gueltig_bis is
    'Bei allen nicht-aktuellen Versionen steht in diesem Feld die letzte Sekunde, zu der die Produktgeneration noch gültig ist.';

comment on column roma_main.ftth_glascontainer_aktionen.name is
    'Im Glascontainer angezeigter Name der Produktgeneration ("Aktion")';

comment on column roma_main.ftth_glascontainer_aktionen.status is
    'Üblicherweise leer. Wenn X, dann wird diese Aktion nirgends mehr im Glascontainer angezeigt - dies sollte erst dann gesetzt werden, nachdem alle früheren Produkte auf eine andere Produktgeneration migriert worden sind.'
    ;


-- sqlcl_snapshot {"hash":"42e6fdd46ac75acbaa5aee1e7be30d9a797ca525","type":"COMMENT","name":"ftth_glascontainer_aktionen","schemaName":"roma_main","sxml":""}