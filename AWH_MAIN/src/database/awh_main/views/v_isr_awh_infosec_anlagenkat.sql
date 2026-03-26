create or replace force editionable view awh_main.v_isr_awh_infosec_anlagenkat (
    ank_lfd_nr,
    asy_lfd_nr,
    ank_kat1,
    ank_kat2,
    ank_kat3,
    ank_user,
    ank_timestamp,
    ank_funk
) as
    select
        ank_lfd_nr,
        asy_lfd_nr,
        ank_kat1,
        ank_kat2,
        ank_kat3,
        ank_user,
        ank_timestamp,
        ank_funk
    from
        awh_infosec_anlagenkat;


-- sqlcl_snapshot {"hash":"c2d1a44cee51cbe79c5344ff34bbc5ffde5b93b7","type":"VIEW","name":"V_ISR_AWH_INFOSEC_ANLAGENKAT","schemaName":"AWH_MAIN","sxml":""}