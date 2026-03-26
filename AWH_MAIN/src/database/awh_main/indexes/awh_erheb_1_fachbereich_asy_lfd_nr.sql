create index awh_main.awh_erheb_1_fachbereich_asy_lfd_nr on
    awh_main.awh_erheb_1_fachbereich (
        asy_lfd_nr
    );


-- sqlcl_snapshot {"hash":"f15da42ccf16e859ae5a54746504c912f43e2b7f","type":"INDEX","name":"AWH_ERHEB_1_FACHBEREICH_ASY_LFD_NR","schemaName":"AWH_MAIN","sxml":"\n  <INDEX xmlns=\"http://xmlns.oracle.com/ku\" version=\"1.0\">\n   <SCHEMA>AWH_MAIN</SCHEMA>\n   <NAME>AWH_ERHEB_1_FACHBEREICH_ASY_LFD_NR</NAME>\n   <TABLE_INDEX>\n      <ON_TABLE>\n         <SCHEMA>AWH_MAIN</SCHEMA>\n         <NAME>AWH_ERHEB_1_FACHBEREICH</NAME>\n      </ON_TABLE>\n      <COL_LIST>\n         <COL_LIST_ITEM>\n            <NAME>ASY_LFD_NR</NAME>\n         </COL_LIST_ITEM>\n      </COL_LIST>\n   </TABLE_INDEX>\n</INDEX>"}