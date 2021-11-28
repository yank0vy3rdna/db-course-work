create or replace function future_excursions_count() returns int as
$$
SELECT count(id) as result
from "ГРУППА"
where "ВРЕМЯ" > now();
$$ language sql;
create or replace function accredited_guides_count() returns int as
$$
SELECT count(DISTINCT "МОБИЛЬНЫЙ_НОМЕР") as result
from "ГИД"
         join "ГИД_ДОКУМЕНТ_АККРЕДИТАЦИИ" ГДА on "ГИД"."МОБИЛЬНЫЙ_НОМЕР" = ГДА."ГИД_id"
         join "ДОКУМЕНТ_АККРЕДИТАЦИИ" ДА on ДА.id = ГДА."ДОКУМЕНТ_АККРЕДИТАЦИИ_id"
where ДА."ДАТА_АННУЛИРОВАНИЯ" > now();
$$ language sql;


create or replace function if_guide_accessed_to_museum(guide_phone bigint, museum_id integer) returns bool as
$$
SELECT count(DISTINCT "МОБИЛЬНЫЙ_НОМЕР") != 0 as result
from "ГИД"
         join "ГИД_ДОКУМЕНТ_АККРЕДИТАЦИИ" ГДА on "ГИД"."МОБИЛЬНЫЙ_НОМЕР" = ГДА."ГИД_id"
         join "ДОКУМЕНТ_АККРЕДИТАЦИИ" ДА on ДА.id = ГДА."ДОКУМЕНТ_АККРЕДИТАЦИИ_id"
where ДА."ДАТА_АННУЛИРОВАНИЯ" > now()
  and ДА."УЧРЕЖДЕНИЕ" = (select "НАЗВАНИЕ" from "МУЗЕЙ" where id = museum_id)
  and "МОБИЛЬНЫЙ_НОМЕР" = guide_phone;
$$ language sql;
