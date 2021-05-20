    --###########################################################################
    -- SCRIPT DE MIGRACION Y CREACION DE OBJETOS NECESARIOS
    -- GRUPO: PI_DE_PICANTES_DE_PI_DE_PICANTESCANTES
    --###########################################################################

    USE [GD1C2020]
    GO

    -----------------------------------------------------------------
    -- CREAMOS UN ESQUEMA CON EL NOMBRE DE PI_DE_PICANTES COMO PEDIA EL TP
    IF NOT EXISTS ( SELECT  *
                    FROM    sys.schemas
                    WHERE   name = 'PI_DE_PICANTES' ) 
        EXEC('CREATE SCHEMA [PI_DE_PICANTES]');
    GO

    
    --###########################################################################
    -- CREACION DE TABLAS 
    --###########################################################################

    -----------TABLA SUCURSAL-----------
   CREATE TABLE PI_DE_PICANTES.SUCURSAL (
        sucursal_dir nvarchar(255) not null,
        sucursal_mail nvarchar(255),
        sucursal_telefono decimal(18,0),
        primary key (sucursal_dir)
    );

    -----------TABLA COMPRA-----------

    CREATE TABLE PI_DE_PICANTES.COMPRA(
        compra_nro decimal(18, 0) not null,
        compra_fecha datetime2(3),
        primary key (compra_nro)
    );

    -----------TABLA HOTEL-----------

    CREATE TABLE PI_DE_PICANTES.HOTEL(
        hotel_calle nvarchar(50) not null ,
        hotel_nro_calle decimal(18, 0) not null,
        hotel_cant_estrellas decimal(18, 0),
        CONSTRAINT pk_hotel PRIMARY KEY NONCLUSTERED (hotel_calle, hotel_nro_calle) 
        --CREAMOS PK COMPUESTA PARA IDENTIFICAR CADA HOTEL HOTEL
    );

    -----------TABLA CLIENTE-----------

    CREATE TABLE PI_DE_PICANTES.CLIENTE(
        cliente_apellido nvarchar(255),
        cliente_nombre nvarchar(255),
        cliente_dni decimal(18, 0) not null,
        cliente_fecha_nac datetime2(3),
        cliente_mail nvarchar(255),
        cliente_telefono int,
        CONSTRAINT pk_cliente PRIMARY KEY NONCLUSTERED (cliente_dni, cliente_nombre,cliente_apellido)
        --COMO HABIA MAS DE UNA PERSONA CON EL MISMO DNI (ERROR DE BD), CREAMOS UNA PK QUE ESTE CONFORMADA CON DNI-NOMBRE-APELLIDO
    );


    -----------TABLA FACTURA-----------

    CREATE TABLE PI_DE_PICANTES.FACTURA(
        factura_numero decimal(18, 0) not null,
        factura_fecha datetime2(3),
        factura_nro_compra decimal(18, 0),
        fact_cliente decimal(18, 0) not null,
        fact_cliente_nombre nvarchar(255),
        fact_cliente_apellido nvarchar(255),
        fact_sucursal nvarchar(255) not null,
        primary key (factura_numero),
        constraint fk_fact_cliente foreign key (fact_cliente, fact_cliente_nombre, fact_cliente_apellido) references PI_DE_PICANTES.CLIENTE(cliente_dni,cliente_nombre, cliente_apellido),
        constraint fk_fact_sucursal foreign key (fact_sucursal) references PI_DE_PICANTES.SUCURSAL(sucursal_dir)
    
    );
    -----------TABLA EMPRESA-----------

    CREATE TABLE PI_DE_PICANTES.EMPRESA(
        empresa_razon_social nvarchar(255) not null,
        primary key (empresa_razon_social)
    );

    -----------TABLA ESTADIA-----------

    CREATE TABLE PI_DE_PICANTES.ESTADIA(
        estadia_id int identity(1,1),
        estadia_codigo decimal(18,0) not null,
        estadia_fecha_ini datetime2(3),
        estadia_cant_noches decimal(18,0),
        estadia_compra_nro decimal(18, 0) ,
        estadia_hotel_calle nvarchar(50)not null ,
        estadia_hotel_nro decimal(18, 0)not null ,
        estadia_factura decimal(18, 0) ,
        estadia_emp_raz_social nvarchar(255) not null,
        primary key (estadia_id),
        constraint fk_estadia_compra_nro foreign key (estadia_compra_nro) references PI_DE_PICANTES.COMPRA(compra_nro),
        constraint fk_estadia_factura foreign key (estadia_factura) references PI_DE_PICANTES.FACTURA(factura_numero),
        constraint fk_estadia_emp_raz_social foreign key (estadia_emp_raz_social) references PI_DE_PICANTES.EMPRESA(empresa_razon_social),
        constraint fk_estadia_hotel_calle_numero FOREIGN KEY(estadia_hotel_calle, estadia_hotel_nro) REFERENCES PI_DE_PICANTES.HOTEL(hotel_calle, hotel_nro_calle),
        
        --CREAMOS UNA PK AUTOINCREMENTAL, POR ESO USAMOS LA FUNCION IDENTITY(1,1) EMPIEZA DE 1 Y AUMENTA DE A 1, YA QUE HABIA MAS DE 
        --UNA ESTADIA CON EL MISMO CODIGO. 
    );

    -----------TABLA TIPO_HABITACION-----------

    CREATE TABLE PI_DE_PICANTES.TIPO_HABITACION(
        tipo_habitacion_id int identity(1,1),
        tipo_habitacion_codigo decimal(18, 0) not null,
        tipo_habitacion_desc nvarchar(50),
        habitacion_costo decimal(18, 2),
        habitacion_precio decimal(18, 2),
        primary key (tipo_habitacion_id)
        
        --CREAMOS UNA PK AUTOINCREMENTAL PORQUE HABIA MAS DE UN TIPO_HABITACION_CODIGO.
    );

    -----------TABLA HABITACION-----------

        CREATE TABLE PI_DE_PICANTES.HABITACION(
            habitacion_id int identity(1,1),
            habitacion_numero decimal(18, 0) ,
            habitacion_piso decimal(18, 0),
            habitacion_frente nvarchar(50),
            habitacion_tipo_hab int,
            primary key (habitacion_id),
            constraint fk_habitacion_tipo_hab foreign key (habitacion_tipo_hab) references PI_DE_PICANTES.TIPO_HABITACION(tipo_habitacion_id)
            --CREAMOS UNA PK AUTOINCREMENTAL PORQUE HABIA MAS DE UNA HABITACION_NUMERO
        );

    -----------TABLA HABITACION_POR_ESTADIA-----------

    CREATE TABLE PI_DE_PICANTES.HABITACION_POR_ESTADIA(
        habitacion_est_id int identity(1,1),
        habitacion_est_codigo int not null,
        habitacion_est_numero int  not null,
        primary key (habitacion_est_id),
        constraint fk_habitacion_est_codigo foreign key (habitacion_est_codigo) references PI_DE_PICANTES.ESTADIA(estadia_id),
        constraint fk_habitacion_est_numero foreign key (habitacion_est_numero) references PI_DE_PICANTES.HABITACION(habitacion_id)
        --CREAMOS UNA PK AUTOINCREMENTAL PORQUE NO TENIAMOS UN ATRIBUTO PARA IDENTIFICAR CADA UNO
    );

    -----------TABLA CIUDAD-----------

    CREATE TABLE PI_DE_PICANTES.CIUDAD(
        ciudad_detalle nvarchar(255) not null,
        primary key (ciudad_detalle)
    );


    -----------TABLA RUTA-----------

    CREATE TABLE PI_DE_PICANTES.RUTA(
        ruta_aerea_id int identity(1,1),
        ruta_aerea_codigo decimal(18, 0) not null,
        ruta_aerea_ciu_origen nvarchar(255) not null,
        ruta_aerea_ciu_destino nvarchar(255) not null,
        primary key (ruta_aerea_id),
        constraint fk_ruta_aerea_ciu_origen foreign key (ruta_aerea_ciu_origen) references PI_DE_PICANTES.CIUDAD(ciudad_detalle),
        constraint fk_ruta_aerea_ciu_destino foreign key (ruta_aerea_ciu_destino) references PI_DE_PICANTES.CIUDAD(ciudad_detalle)
        --CREAMOS UNA PK AUTOINCREMENTAL PORQUE HABIA MAS DE UNA RUTA_AEREA_CODIGO PARA IDENTIFICARLO COMO UNICO
    );


    -----------TABLA AVION-----------

    CREATE TABLE PI_DE_PICANTES.AVION(
        avion_modelo nvarchar(50) ,
        avion_identificador nvarchar(50) not null,
        primary key (avion_identificador)
    );

    -----------TABLA VUELO-----------

    CREATE TABLE PI_DE_PICANTES.VUELO(
        vuelo_codigo decimal(19, 0) not null,
        vuelo_fecha_salida datetime2(3),
        vuelo_fecha_llegada datetime2(3),
        vuelo_avion_id nvarchar(50) not null,
        vuelo_ruta_aerea_cod int ,
        primary key (vuelo_codigo),
        constraint fk_vuelo_avion_id foreign key (vuelo_avion_id) references PI_DE_PICANTES.AVION(avion_identificador),
        constraint fk_vuelo_ruta_aerea_cod foreign key (vuelo_ruta_aerea_cod) references PI_DE_PICANTES.RUTA(ruta_aerea_id)

    ); 

    -----------TABLA TIPO_BUTACA-----------

    CREATE TABLE PI_DE_PICANTES.TIPO_BUTACA(
        tipo_butaca_desc nvarchar(255) not null,
        primary key (tipo_butaca_desc)
    );


    -----------TABLA BUTACA-----------

    CREATE TABLE PI_DE_PICANTES.BUTACA(
        butaca_id int identity(1,1),
        butaca_numero decimal(18, 0) not null,
        butaca_tipo nvarchar(255) not null,
        primary key (butaca_id),
        constraint fk_butaca_tipo foreign key (butaca_tipo) references PI_DE_PICANTES.TIPO_BUTACA(tipo_butaca_desc)
        --CREAMOS UNA PK AUTOINCREMENTAL PORQUE HABIA MAS DE UN NUMERO DE BUTACA
    );

    -----------TABLA BUTACA_POR_AVION-----------

    CREATE TABLE PI_DE_PICANTES.BUTACA_POR_AVION(
        butaca_avion_id int IDENTITY(1,1),
        butaca_avion_identificador nvarchar(50) not null,
        butaca_avion_numero int not null,
        primary key (butaca_avion_id),
        constraint fk_butaca_avion_identificador foreign key (butaca_avion_identificador) references PI_DE_PICANTES.AVION(avion_identificador),
        constraint fk_butaca_avion_numero foreign key (butaca_avion_numero) references  PI_DE_PICANTES.BUTACA(butaca_id)
        --CREAMOS UNA PK AUTOINCREMENTAL PORQUE NO TENIA UN ATRIBUTO PK PARA IDENTIFICAR CADA VALOR
    );

    -----------TABLA PASAJE-----------
    CREATE TABLE PI_DE_PICANTES.PASAJE(
        pasaje_id int IDENTITY(1,1) ,
        pasaje_codigo decimal(18, 0),
        pasaje_costo decimal(18, 2),
        pasaje_precio decimal(18, 2),
        pasaje_compra decimal(18, 0) not null,
        pasaje_emp_raz_social nvarchar(255)not null,
        pasaje_cod_vuelo decimal(19, 0) not null,
        pasaje_nro_butaca int,
        pasaje_factura decimal(18, 0) ,
        primary key (pasaje_id),
        constraint fk_pasaje_compra foreign key (pasaje_compra) references PI_DE_PICANTES.COMPRA(compra_nro),
        constraint fk_pasaje_emp_raz_social foreign key (pasaje_emp_raz_social) references PI_DE_PICANTES.EMPRESA(empresa_razon_social),
        constraint fk_pasaje_cod_vuelo foreign key (pasaje_cod_vuelo) references PI_DE_PICANTES.VUELO(vuelo_codigo),
        constraint fk_pasaje_nro_butaca foreign key (pasaje_nro_butaca) references  PI_DE_PICANTES.BUTACA_POR_AVION(butaca_avion_id),
        constraint fk_pasaje_factura foreign key (pasaje_factura) references PI_DE_PICANTES.FACTURA(factura_numero)

        --CREAMOS UNA PK AUTOINCREMENTAL PORQUE HABIA MAS DE UN PASAJE_CODIGO 
    );

    --###########################################################################
    -- CREACION DE STORES PROCEDURES PARA LA MIGRACION DE DATOS
    --###########################################################################
    GO
    ------------------------MIGRACION DATOS SUCURSAL--------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_sucursal AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.SUCURSAL(sucursal_dir,sucursal_mail,sucursal_telefono)
        SELECT DISTINCT SUCURSAL_DIR,SUCURSAL_MAIL,SUCURSAL_TELEFONO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE SUCURSAL_DIR is not null
    END
    GO

    -----------------------MIGRACION DATOS COMPRA------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_compra AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.COMPRA(compra_nro, compra_fecha)
        SELECT DISTINCT COMPRA_NUMERO,COMPRA_FECHA
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE COMPRA_NUMERO is not null
    END
    GO
    -----------------------MIGRACION DATOS HOTEL-----------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_hotel AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.HOTEL(hotel_calle, hotel_nro_calle,hotel_cant_estrellas)
        SELECT DISTINCT HOTEL_CALLE,HOTEL_NRO_CALLE, HOTEL_CANTIDAD_ESTRELLAS
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE HOTEL_CALLE is not null and HOTEL_NRO_CALLE is not null
    END
    GO
    -----------------------MIGRACION DATOS CLIENTE-----------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_cliente AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.CLIENTE(cliente_dni,cliente_apellido, cliente_nombre,cliente_fecha_nac,cliente_mail, cliente_telefono)
        SELECT DISTINCT CLIENTE_DNI, CLIENTE_APELLIDO, CLIENTE_NOMBRE, CLIENTE_FECHA_NAC, CLIENTE_MAIL, CLIENTE_TELEFONO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE CLIENTE_DNI is not null and CLIENTE_APELLIDO is not null and CLIENTE_NOMBRE is not null
    END
    GO
    -----------------------MIGRACION DATOS FACTURA--------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_factura AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.FACTURA(factura_numero, factura_fecha, factura_nro_compra, fact_cliente,fact_cliente_nombre, fact_cliente_apellido, fact_sucursal)
        SELECT DISTINCT FACTURA_NRO, FACTURA_FECHA,COMPRA_NUMERO,CLIENTE_DNI,CLIENTE_NOMBRE, CLIENTE_APELLIDO,SUCURSAL_DIR
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE FACTURA_NRO is not null
    END
    GO

    -----------------------MIGRACION DATOS EMPRESA--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_empresa AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.EMPRESA(empresa_razon_social)
        SELECT DISTINCT EMPRESA_RAZON_SOCIAL
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE EMPRESA_RAZON_SOCIAL is not null
    END
    GO
    -----------------------MIGRACION DATOS ESTADIA----------------------------

    --[CORRECCION] Cambiamos la forma de migrar
    CREATE PROCEDURE PI_DE_PICANTES.migrar_estadia AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.ESTADIA(estadia_codigo, estadia_fecha_ini, estadia_cant_noches, estadia_compra_nro,
                                        estadia_hotel_calle, estadia_hotel_nro, estadia_factura, estadia_emp_raz_social)
        SELECT DISTINCT ESTADIA_CODIGO, ESTADIA_FECHA_INI, ESTADIA_CANTIDAD_NOCHES, COMPRA_NUMERO, HOTEL_CALLE, HOTEL_NRO_CALLE, FACTURA_NRO,EMPRESA_RAZON_SOCIAL
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE ESTADIA_CODIGO is not null and FACTURA_NRO is not null;

        INSERT INTO PI_DE_PICANTES.ESTADIA(estadia_codigo, estadia_fecha_ini, estadia_cant_noches, estadia_compra_nro,
                                        estadia_hotel_calle, estadia_hotel_nro, estadia_factura, estadia_emp_raz_social)
        SELECT DISTINCT ESTADIA_CODIGO, ESTADIA_FECHA_INI, ESTADIA_CANTIDAD_NOCHES, COMPRA_NUMERO, HOTEL_CALLE, HOTEL_NRO_CALLE, FACTURA_NRO,EMPRESA_RAZON_SOCIAL
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE ESTADIA_CODIGO is not null and ESTADIA_CODIGO not in (select estadia_codigo from PI_DE_PICANTES.ESTADIA)
    END
    GO

    -----------------------MIGRACION DATOS TIPO_HABITACION-------------------------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_tipo_habitacion  AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.TIPO_HABITACION(tipo_habitacion_codigo, tipo_habitacion_desc, habitacion_costo, habitacion_precio)
        SELECT DISTINCT TIPO_HABITACION_CODIGO, TIPO_HABITACION_DESC, HABITACION_COSTO, HABITACION_PRECIO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE TIPO_HABITACION_CODIGO is not null
    END
    GO

    -----------------------MIGRACION DATOS HABITACION-------------------------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_habitacion AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.HABITACION(habitacion_numero, habitacion_piso, habitacion_frente, habitacion_tipo_hab)
        SELECT DISTINCT HABITACION_NUMERO, 
                        HABITACION_PISO, 
                        HABITACION_FRENTE, 
                        (select distinct top 1 tipo_habitacion_id from PI_DE_PICANTES.TIPO_HABITACION 
                        where tipo_habitacion_codigo = [GD1C2020].[gd_esquema].[Maestra].TIPO_HABITACION_CODIGO and habitacion_precio = [GD1C2020].[gd_esquema].[Maestra].HABITACION_PRECIO)
                        -- BUSCAMOS LA PK AUTOINCREMENTAL EN TIPO_HABITACION, RELACIONAN DOS DATOS DE ESA TABLALA CON LOS DATOS QUE TENIAMOS 
                        --EN LA TABLA MAESTRA, PARA PODER BUSCAR CADA UNA DE LAS FILAS
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE HABITACION_NUMERO is not null
    END
    GO

    -----------------------MIGRACION DATOS HABITACION_ESTADIA--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_hab_estadia AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.HABITACION_POR_ESTADIA(
            habitacion_est_codigo,
            habitacion_est_numero
        )
        SELECT DISTINCT 
            -- ESTADIA_CODIGO,
            (select distinct top 1 estadia_id from PI_DE_PICANTES.ESTADIA 
            where estadia_codigo = [GD1C2020].[gd_esquema].[Maestra].ESTADIA_CODIGO ),

            (select distinct top 1 habitacion_id from PI_DE_PICANTES.HABITACION 
            where habitacion_numero = [GD1C2020].[gd_esquema].[Maestra].HABITACION_NUMERO )
            --BUSCAMOS LA PK AUTOINCREMENTAL EN HABITACION_ID, RELACIONANDO LOS DATOS DE ESA TABLA CON LOS DATOS QUE TENIAMOS EN LA TABLA MAESTRA,
             --PARA PODER BUSCAR CADA UNA DE LAS FILAS
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE ESTADIA_CODIGO is not null 
    END
    GO

    -----------------------MIGRACION DATOS TIPO_BUTACA--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_tipo_butaca AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.TIPO_BUTACA(
            tipo_butaca_desc
        )
        SELECT DISTINCT
            BUTACA_TIPO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE BUTACA_TIPO is not null 
    END
    GO

    -----------------------MIGRACION DATOS BUTACA--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_butaca AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.BUTACA(
            butaca_numero,
            butaca_tipo
        )
        SELECT DISTINCT
            BUTACA_NUMERO,
            BUTACA_TIPO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE BUTACA_NUMERO is not null
    END
    GO
    
    -----------------------MIGRACION DATOS AVION--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_avion AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.AVION(
            avion_identificador,
            avion_modelo
        )
        SELECT DISTINCT
            AVION_IDENTIFICADOR,
            AVION_MODELO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE AVION_IDENTIFICADOR is not null
    END
    GO

-----------------------MIGRACION DATOS BUTACA_POR_AVION--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_butaca_avion AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.BUTACA_POR_AVION(
            butaca_avion_identificador,
            butaca_avion_numero
        )
        SELECT DISTINCT
            AVION_IDENTIFICADOR,
            (select distinct top 1 butaca_id from PI_DE_PICANTES.BUTACA 
            where butaca_numero = [GD1C2020].[gd_esquema].[Maestra].BUTACA_NUMERO )
            --BUSCAMOS LA PK AUTOINCREMENTAL EN BUTACA_ID, RELACIONANDOLA CON LOS DATOS DE ESA TABLA LOS DATOS QUE TENIAMOS EN LA TABLA MAESTRA,
             --PARA PODER BUSCAR CADA UNA DE LAS FILAS
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE AVION_IDENTIFICADOR is not null
    END
    GO

-----------------------MIGRACION DATOS CIUDAD--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_ciudad AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.CIUDAD(
            ciudad_detalle    
        )
        SELECT DISTINCT 
            RUTA_AEREA_CIU_ORIG
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE RUTA_AEREA_CIU_ORIG is not null

        UNION

        SELECT DISTINCT 
            RUTA_AEREA_CIU_DEST
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE RUTA_AEREA_CIU_DEST is not null

        --UTILIZAMOS LA FUNCION UNION PARA UNIR TODAS LAS CIUDADES QUE HAY EN LA TABLA MAESTRA, Y LA FUNCION UNION NO TRAE REPETIDOS

    END
    GO

 -----------------------MIGRACION DATOS RUTA--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_ruta AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.RUTA(
            ruta_aerea_codigo,
            ruta_aerea_ciu_origen,
            ruta_aerea_ciu_destino
        )
        SELECT DISTINCT
            RUTA_AEREA_CODIGO,
            RUTA_AEREA_CIU_ORIG, 
            RUTA_AEREA_CIU_DEST
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE RUTA_AEREA_CODIGO is not null
    END
    GO

-----------------------MIGRACION DATOS VUELO--------------------------

    CREATE PROCEDURE PI_DE_PICANTES.migrar_vuelo AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.VUELO(
            vuelo_codigo,
            vuelo_fecha_salida,
            vuelo_fecha_llegada,
            vuelo_avion_id,
            vuelo_ruta_aerea_cod
        )
        SELECT DISTINCT
            VUELO_CODIGO,
            VUELO_FECHA_SALUDA,
            VUELO_FECHA_LLEGADA,
            AVION_IDENTIFICADOR,
            (select distinct top 1 ruta_aerea_id from PI_DE_PICANTES.RUTA 
            where ruta_aerea_codigo = [GD1C2020].[gd_esquema].[Maestra].RUTA_AEREA_CODIGO )
            --BUSCAMOS LA PK AUTOINCREMENTAL EN RUTA_AEREA_ID, RELACIONANDO LOS DATOS DE ESA TABLA CON LOS DATOS QUE TENIAMOS EN LA TABLA MAESTRA,
             --PARA PODER BUSCAR CADA UNA DE LAS FILAS
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE VUELO_CODIGO is not null
    END
    GO



-----------------------MIGRACION DATOS PASAJE--------------------------
 --[CORRECCION] Cambiamos la forma de migrar
 CREATE PROCEDURE PI_DE_PICANTES.migrar_pasajes AS
    BEGIN
        INSERT INTO PI_DE_PICANTES.PASAJE(
            pasaje_codigo,
            pasaje_costo,
            pasaje_precio,
            pasaje_compra,
            pasaje_emp_raz_social,
            pasaje_cod_vuelo,
            pasaje_nro_butaca,
            pasaje_factura
        )
        SELECT DISTINCT 
            PASAJE_CODIGO,
            PASAJE_COSTO,
            PASAJE_PRECIO,
            COMPRA_NUMERO,
            EMPRESA_RAZON_SOCIAL,
            VUELO_CODIGO,
            (select distinct top 1 butaca_avion_id from PI_DE_PICANTES.BUTACA_POR_AVION
            where   butaca_avion_identificador = [GD1C2020].[gd_esquema].[Maestra].AVION_IDENTIFICADOR and 
                    butaca_avion_numero = (select distinct top 1 butaca_id from PI_DE_PICANTES.BUTACA
                                            where butaca_numero = [GD1C2020].[gd_esquema].[Maestra].BUTACA_NUMERO)),

            FACTURA_NRO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE PASAJE_CODIGO is not null and FACTURA_NRO is not null;

        INSERT INTO PI_DE_PICANTES.PASAJE(
            pasaje_codigo,
            pasaje_costo,
            pasaje_precio,
            pasaje_compra,
            pasaje_emp_raz_social,
            pasaje_cod_vuelo,
            pasaje_nro_butaca,
            pasaje_factura
        )
        SELECT DISTINCT 
            PASAJE_CODIGO,
            PASAJE_COSTO,
            PASAJE_PRECIO,
            COMPRA_NUMERO,
            EMPRESA_RAZON_SOCIAL,
            VUELO_CODIGO,
            (select distinct top 1 butaca_avion_id from PI_DE_PICANTES.BUTACA_POR_AVION
            where   butaca_avion_identificador = [GD1C2020].[gd_esquema].[Maestra].AVION_IDENTIFICADOR and 
                    butaca_avion_numero = (select distinct top 1 butaca_id from PI_DE_PICANTES.BUTACA
                                            where butaca_numero = [GD1C2020].[gd_esquema].[Maestra].BUTACA_NUMERO)),

            FACTURA_NRO
        FROM [GD1C2020].[gd_esquema].[Maestra]
        WHERE PASAJE_CODIGO is not null and PASAJE_CODIGO NOT IN (SELECT pasaje_codigo FROM PI_DE_PICANTES.PASAJE)
    END
    GO
    -----------------------EJECUTAR MIGRACIONES DE DATOS-------------------------------------------

    EXEC PI_DE_PICANTES.migrar_sucursal
    EXEC PI_DE_PICANTES.migrar_compra
    EXEC PI_DE_PICANTES.migrar_hotel
    EXEC PI_DE_PICANTES.migrar_cliente
    EXEC PI_DE_PICANTES.migrar_factura
    EXEC PI_DE_PICANTES.migrar_empresa
    EXEC PI_DE_PICANTES.migrar_estadia
    EXEC PI_DE_PICANTES.migrar_tipo_habitacion 
    EXEC PI_DE_PICANTES.migrar_habitacion
    EXEC PI_DE_PICANTES.migrar_hab_estadia
    EXEC PI_DE_PICANTES.migrar_tipo_butaca
    EXEC PI_DE_PICANTES.migrar_butaca
    EXEC PI_DE_PICANTES.migrar_avion
    EXEC PI_DE_PICANTES.migrar_butaca_avion
    EXEC PI_DE_PICANTES.migrar_ciudad
    EXEC PI_DE_PICANTES.migrar_ruta
    EXEC PI_DE_PICANTES.migrar_vuelo
    EXEC PI_DE_PICANTES.migrar_pasajes
    GO
--DROP TABLE [GD1C2020].[gd_esquema].[Maestra]