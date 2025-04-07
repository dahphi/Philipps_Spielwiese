--Einfügen der Spalte mit Kommentar in Vermarktungscluster

ALTER TABLE VERMARKTUNGSCLUSTER
ADD LOESCHGRUND NUMBER;

COMMENT ON COLUMN "ROMA_MAIN"."VERMARKTUNGSCLUSTER"."LOESCHGRUND" IS '@ticket FTTH-2323: Grund, der beim Löschen eines Vermarktungsclusters angegeben werden muss: 1 = Projekt fertiggestellt 2 = Projekt zurückgezogen 3 = Test';




-- sqlcl_snapshot {"hash":"421b9248294a73f25a5e46571159dddf22f54eda","type":"APEX_APPLICATION","name":"f1210","schemaName":"APEX_EXPORT_USER"}