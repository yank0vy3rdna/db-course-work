--Объявление всех таблиц БД

CREATE TABLE ПЕРСОНАЛЬНЫЕ_ДАННЫЕ
(
    ID            SERIAL PRIMARY KEY,
    ФАМИЛИЯ       varchar(45) NOT NULL,
    ИМЯ           varchar(45) NOT NULL,
    ОТЧЕСТВО      varchar(45) NOT NULL,
    ПОЛ           boolean,
    ДАТА_РОЖДЕНИЯ timestamp
);

CREATE TABLE МЕСТО
(
    ID     SERIAL PRIMARY KEY,
    СТРАНА varchar(90) NOT NULL,
    ГОРОД  varchar(90) NOT NULL,
    УЛИЦА  varchar(90) NOT NULL,
    ДОМ    integer
);

CREATE TABLE ЭКСПОНАТ
(
    ID                SERIAL PRIMARY KEY,
    НАЗВАНИЕ          varchar(90)                   NOT NULL DEFAULT 'МАДОННА С МЛАДЕНЦЕМ',
    АВТОР             integer references ПЕРСОНАЛЬНЫЕ_ДАННЫЕ (ID),
    ДАТА_СОЗДАНИЯ     timestamp,
    НАПРАВЛЕНИЕ       varchar(45),
    МЕСТОРАСПОЛОЖЕНИЕ integer references МЕСТО (ID) NOT NULL
);

CREATE TABLE ВЫСТАВКА
(
    ID                SERIAL PRIMARY KEY,
    НАЗВАНИЕ          varchar(90)                                                       NOT NULL,
    ВЛАДЕЛЕЦ          integer references ПЕРСОНАЛЬНЫЕ_ДАННЫЕ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    МЕСТОРАСПОЛОЖЕНИЕ integer references МЕСТО (ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE МУЗЕЙ
(
    ID                SERIAL PRIMARY KEY,
    НАЗВАНИЕ          varchar(90)                                                       NOT NULL,
    МЕСТОРАСПОЛОЖЕНИЕ integer references МЕСТО (ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL
);

CREATE TABLE ПАСПОРТ
(
    ID             serial primary key,
    СЕРИЯ_ПАСПОРТА integer      NOT NULL,
    НОМЕР_ПАСПОРТА integer      NOT NULL,
    ФАМИЛИЯ        varchar(45)  NOT NULL,
    ИМЯ            varchar(45)  NOT NULL,
    ОТЧЕСТВО       varchar(45)  NOT NULL,
    ПОЛ            boolean      NOT NULL,
    ДАТА_РОЖДЕНИЯ  timestamp    NOT NULL CHECK ( ДАТА_РОЖДЕНИЯ > '1940-01-01' ),
    ПАСПОРТ_ВЫДАН  varchar(200) NOT NULL,
    ДАТА_ВЫДАЧИ    timestamp    NOT NULL CHECK ( ДАТА_ВЫДАЧИ > '1960-01-01' )
);

CREATE TABLE ГИД
(
    МОБИЛЬНЫЙ_НОМЕР bigint CHECK ( МОБИЛЬНЫЙ_НОМЕР::text ~ '^[0-9]{10}$' ),
    ПАСПОРТ_ID      integer references ПАСПОРТ (ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    ПОЧТА           varchar(45)                                                         NOT NULL UNIQUE CHECK (ПОЧТА ~ '^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$'),
    PRIMARY KEY (МОБИЛЬНЫЙ_НОМЕР)
);

CREATE TABLE ЭКСКУРСАНТ
(
    ID              SERIAL PRIMARY KEY,
    ЧЕЛОВЕК         integer references ПЕРСОНАЛЬНЫЕ_ДАННЫЕ (ID) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    МОБИЛЬНЫЙ_НОМЕР varchar(45),
    ПОЧТА           varchar(45)
);

CREATE TABLE ЭКСКУРСИЯ
(
    ID                SERIAL PRIMARY KEY,
    НАЗВАНИЕ          varchar(90)  NOT NULL,
    ОПИСАНИЕ          varchar(400) NOT NULL DEFAULT 'Самая незабываемая и интересная экскурсия, которую можно посетить.',
    ПРОДОЛЖИТЕЛЬНОСТЬ integer      NOT NULL CHECK ( ПРОДОЛЖИТЕЛЬНОСТЬ < 23 )
);

CREATE TABLE ДОКУМЕНТ_СТАТУС
(
    ID                 SERIAL PRIMARY KEY,
    УЧРЕЖДЕНИЕ         varchar(180),
    НАИМЕНОВАНИЕ       varchar(180) NOT NULL,
    ДАТА_ВЫДАЧИ        timestamp    NOT NULL CHECK ( ДАТА_ВЫДАЧИ > '1940-01-01' ),
    ДАТА_АННУЛИРОВАНИЯ timestamp    NOT NULL
);

CREATE TABLE ГРУППА
(
    ID              SERIAL PRIMARY KEY,
    ЭКСКУРСИЯ_ID    integer references ЭКСКУРСИЯ (ID) ON DELETE CASCADE ON UPDATE CASCADE       NOT NULL,
    ГИД             bigint references ГИД (МОБИЛЬНЫЙ_НОМЕР) ON DELETE CASCADE ON UPDATE CASCADE NOT NULL,
    ВРЕМЯ           timestamp                                                                   NOT NULL,
    СТОМОСТЬ        integer                                                                     NOT NULL,
    КОЛИЧЕСТВО_МЕСТ integer                                                                     NOT NULL CHECK ( КОЛИЧЕСТВО_МЕСТ < 20 ),
    МЕСТО_СБОРА     integer references МЕСТО (ID) ON DELETE CASCADE ON UPDATE CASCADE           NOT NULL,
    МЕСТО_ОКОНЧАНИЯ integer references МЕСТО (ID) ON DELETE CASCADE ON UPDATE CASCADE           NOT NULL
);

CREATE TABLE ДОКУМЕНТ_АККРЕДИТАЦИИ
(
    ID                     SERIAL PRIMARY KEY,
    УЧРЕЖДЕНИЕ             varchar(100) NOT NULL,
    НАИМЕНОВАНИЕ_ДОКУМЕНТА varchar(180) NOT NULL,
    ДАТА_ВЫДАЧИ            timestamp    NOT NULL CHECK ( ДАТА_ВЫДАЧИ > '2010-01-01' ),
    ДАТА_АННУЛИРОВАНИЯ     timestamp    NOT NULL
);

CREATE TABLE ГИД_ДОКУМЕНТ_АККРЕДИТАЦИИ
(
    ГИД_ID                   bigint references ГИД (МОБИЛЬНЫЙ_НОМЕР) ON DELETE CASCADE ON UPDATE CASCADE,
    ДОКУМЕНТ_АККРЕДИТАЦИИ_ID integer references ДОКУМЕНТ_АККРЕДИТАЦИИ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ГИД_ID, ДОКУМЕНТ_АККРЕДИТАЦИИ_ID)
);

CREATE TABLE ЭКСКУРСАНТ_ДОКУМЕНТ_СТАТУС
(
    ЭКСКУРСАНТ_ID      integer references ЭКСКУРСАНТ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ДОКУМЕНТ_СТАТУС_ID integer references ДОКУМЕНТ_СТАТУС (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ЭКСКУРСАНТ_ID, ДОКУМЕНТ_СТАТУС_ID)
);

CREATE TABLE ГРУППА_ЭКСКУРСАНТ
(
    ГРУППА_ID     integer references ГРУППА (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ЭКСКУРСАНТ_ID integer references ЭКСКУРСАНТ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ГРУППА_ID, ЭКСКУРСАНТ_ID)
);

CREATE TABLE ЭКСКУРСИЯ_МУЗЕЙ
(
    ЭКСКУРСИЯ_ID integer references ЭКСКУРСИЯ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    МУЗЕЙ_ID     integer references МУЗЕЙ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ЭКСКУРСИЯ_ID, МУЗЕЙ_ID)
);

CREATE TABLE ЭКСКУРСИЯ_ВЫСТАВКА
(
    ЭКСКУРСИЯ_ID integer references ЭКСКУРСИЯ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ВЫСТАВКА_ID  integer references ВЫСТАВКА (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ЭКСКУРСИЯ_ID, ВЫСТАВКА_ID)
);

CREATE TABLE ЭКСКУРСИЯ_ЭКСПОНАТ
(
    ЭКСКУРСИЯ_ID integer references ЭКСКУРСИЯ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ЭКСПОНАТ_ID  integer references ЭКСПОНАТ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ЭКСКУРСИЯ_ID, ЭКСПОНАТ_ID)
);

CREATE TABLE МУЗЕЙ_ВЫСТАВКА
(
    МУЗЕЙ_ID    integer references МУЗЕЙ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ВЫСТАВКА_ID integer references ВЫСТАВКА (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (МУЗЕЙ_ID, ВЫСТАВКА_ID)
);

CREATE TABLE ВЫСТАВКА_ЭКСПОНАТ
(
    ВЫСТАВКА_ID integer references ВЫСТАВКА (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    ЭКСПОНАТ_ID integer references ЭКСПОНАТ (ID) ON DELETE CASCADE ON UPDATE CASCADE,
    PRIMARY KEY (ВЫСТАВКА_ID, ЭКСПОНАТ_ID)
);