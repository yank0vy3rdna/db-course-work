--Создание ндексов для ускорения select-запросов

CREATE INDEX ЭКСК_ПРОД ON "ЭКСКУРСИЯ" USING btree("ПРОДОЛЖИТЕЛЬНОСТЬ");

CREATE INDEX ЭКСП_НАПР ON "ЭКСПОНАТ" USING hash("НАПРАВЛЕНИЕ");

CREATE INDEX ЭКСП_СОЗД ON "ЭКСПОНАТ" USING btree("ДАТА_СОЗДАНИЯ");

CREATE INDEX ПЕРС_ФАМ ON "ПЕРСОНАЛЬНЫЕ_ДАННЫЕ" USING hash("ФАМИЛИЯ");

CREATE INDEX ГРУП_ВРЕМЯ ON "ГРУППА" USING btree("ВРЕМЯ");

CREATE INDEX ГРУП_СТОМ ON "ГРУППА" USING btree("СТОМОСТЬ");

CREATE INDEX ПАСП_НОМ ON "ПАСПОРТ" USING hash("НОМЕР_ПАСПОРТА");

CREATE INDEX ПАСП_СЕР ON "ПАСПОРТ" USING hash("СЕРИЯ_ПАСПОРТА");

CREATE INDEX ПАСП_ФАМ ON "ПАСПОРТ" USING hash("ФАМИЛИЯ");

CREATE INDEX ПАСП_РОЖД ON "ПАСПОРТ" USING hash("ДАТА_РОЖДЕНИЯ");