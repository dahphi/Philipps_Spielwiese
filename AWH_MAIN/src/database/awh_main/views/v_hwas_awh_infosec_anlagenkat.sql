create or replace force editionable view awh_main.v_hwas_awh_infosec_anlagenkat (
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


-- sqlcl_snapshot {"hash":"5775e729643b392c555fa89c0a2765d4c951479e","type":"VIEW","name":"V_HWAS_AWH_INFOSEC_ANLAGENKAT","schemaName":"AWH_MAIN","sxml":""}