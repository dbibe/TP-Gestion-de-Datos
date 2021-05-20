------------------------------------------------------------------------
-----------CREACION DE TABLAS BI----------------------------------------
------------------------------------------------------------------------

--------------------DIMENSION_HOTEL----------------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_HOTEL(
    hotel_calle nvarchar(50),
    hotel_nro_calle decimal(18,0),
    hotel_cant_estrellas decimal(18,0),
    CONSTRAINT pk_dimension_hotel PRIMARY KEY NONCLUSTERED (hotel_calle, hotel_nro_calle)   
);

--------------------DIMENSION_TIPO_DE_HABITACION-------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_TIPO_DE_HABITACION(
    tipo_habitacion_codigo decimal(18,0),
    tipo_habitacion_desc nvarchar(50),
    primary key(tipo_habitacion_codigo)
);

--------------------DIMENSION_SUCURSAL--------------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_SUCURSAL (
    sucursal_id int identity(1,1),
    sucursal_dir nvarchar(255) not null,
    sucursal_mail nvarchar(255),
    sucursal_telefono decimal(18,0),
    primary key(sucursal_id)
);

--------------------DIMENSION_CLIENTE----------------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_CLIENTE(
    cliente_id int identity(1,1),
    cliente_apellido nvarchar(255),
    cliente_nombre nvarchar(255),
    cliente_dni decimal(18, 0) not null,
    cliente_fecha_nac datetime2(3),
    cliente_mail nvarchar(255),
    cliente_telefono int,
    cliente_edad int,   
    primary key (cliente_id)
);

--------------------DIMENSION_PROVEEDOR----------------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_PROVEEDOR(
    proveedor_id int identity(1,1),
    empresa_razon_social nvarchar(255),
    primary key(proveedor_id)
);

--------------------DIMENSION_CIUDAD----------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_CIUDAD(
    ciudad_id int identity(1,1),
    ciudad_detalle nvarchar(255) not null,
    primary key(ciudad_id)
);

--------------------DIMENSION_AVION----------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_AVION(
    avion_modelo nvarchar(50) ,
    avion_identificador nvarchar(50) not null,
    primary key(avion_identificador)
);

--------------------DIMENSION_RUTA----------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_RUTA(
    ruta_aerea_id decimal(18,0) not null,
    ruta_aerea_ciu_origen nvarchar(255) ,
    ruta_aerea_ciu_destino nvarchar(255) ,
    primary key(ruta_aerea_id)
);


--------------------DIMENSION_TIPO_PASAJE----------------------
CREATE TABLE PI_DE_PICANTES.DIMENSION_TIPO_PASAJE(
    tipo_pasaje_id int identity(1,1),
    tipo_butaca_desc nvarchar(255),
    primary key(tipo_pasaje_id)
);

--------------------HECHO_ESTADIA----------------------
CREATE TABLE PI_DE_PICANTES.HECHOS_ESTADIA(

    mes_venta int,
    anio_venta int,
    cliente_id int,
    sucursal_id int,
    hotel_calle nvarchar(50),
    hotel_nro_calle decimal(18,0),
    tipo_habitacion_codigo decimal(18,0),
    proveedor_id int,

    promedio_venta decimal(18,0),
    promedio_compra decimal(18,0),
    cant_camas int,
    cant_habitaciones int,
    ganancia_estadia decimal(18,0),

    CONSTRAINT pk_hechos_estadia PRIMARY KEY  (mes_venta, anio_venta, cliente_id, sucursal_id,hotel_calle, hotel_nro_calle,
                                                           tipo_habitacion_codigo,proveedor_id),
                                                        
    CONSTRAINT fk_cliente_estadia foreign key (cliente_id) references PI_DE_PICANTES.DIMENSION_CLIENTE(cliente_id),
    CONSTRAINT fk_sucursal_estadia foreign key (sucursal_id) references PI_DE_PICANTES.DIMENSION_SUCURSAL(sucursal_id),
    CONSTRAINT fk_hotel_estadia foreign key (hotel_calle, hotel_nro_calle) references PI_DE_PICANTES.DIMENSION_HOTEL(hotel_calle, hotel_nro_calle),
    CONSTRAINT fk_tipo_habitacion_estadia foreign key(tipo_habitacion_codigo) references PI_DE_PICANTES.DIMENSION_TIPO_DE_HABITACION(tipo_habitacion_codigo),
    CONSTRAINT fk_proveedor_estadia foreign key(proveedor_id) references PI_DE_PICANTES.DIMENSION_PROVEEDOR(proveedor_id)
 
);


--------------------HECHO_PASAJE----------------------
CREATE TABLE PI_DE_PICANTES.HECHOS_PASAJE(
    mes_venta int,
    anio_venta int,
    tipo_pasaje_id int,
    ciudad_id int,
    avion_identificador nvarchar(50),
    ruta_aerea_id decimal(18,0),
    sucursal_id int,
    cliente_id int,
    proveedor_id int,

    promedio_venta decimal(18,0),
    promedio_compra decimal(18,0),
    cant_pasajes_vendidos int,
    cant_butacas int,
    ganancia_pasajes decimal(18,0),

    CONSTRAINT pk_hechos_pasaje PRIMARY KEY  (mes_venta,anio_venta,tipo_pasaje_id, ciudad_id,avion_identificador,ruta_aerea_id,sucursal_id,
                                    cliente_id,proveedor_id),

    CONSTRAINT fk_pasaje_pasaje foreign key (tipo_pasaje_id) references PI_DE_PICANTES.DIMENSION_TIPO_PASAJE(tipo_pasaje_id),
    CONSTRAINT fk_ciudad_pasaje foreign key (ciudad_id) references PI_DE_PICANTES.DIMENSION_CIUDAD(ciudad_id),
    CONSTRAINT fk_avion_pasaje foreign key (avion_identificador) references PI_DE_PICANTES.DIMENSION_AVION(avion_identificador),
    CONSTRAINT fk_ruta_pasaje foreign key (ruta_aerea_id) references PI_DE_PICANTES.DIMENSION_RUTA(ruta_aerea_id),
    CONSTRAINT fk_sucursal_pasaje foreign key (sucursal_id) references PI_DE_PICANTES.DIMENSION_SUCURSAL(sucursal_id),
    CONSTRAINT fk_cliente_pasaje foreign key (cliente_id) references PI_DE_PICANTES.DIMENSION_CLIENTE(cliente_id),
    CONSTRAINT fk_proveedor_pasaje foreign key(proveedor_id) references PI_DE_PICANTES.DIMENSION_PROVEEDOR(proveedor_id)

);


go
    ------------------------------------------------------------------------------------------------------------------------------
    --------------------------------------------MIGRACION DE DATOS----------------------------------------------------------------
    -----------------------------------------------------------------------------------------------------------------------------


    ---------------------------------------------MIGRAR DIMENSION HOTEL----------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_hotel AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_HOTEL(
                hotel_calle,
                hotel_nro_calle,
                hotel_cant_estrellas
            )
            SELECT DISTINCT
                hotel_calle,
                hotel_nro_calle,
                hotel_cant_estrellas
            FROM [GD1C2020].PI_DE_PICANTES.HOTEL
        END
        GO

    -------------------------------MIGRAR DIMENSION TIPO_HABITACION ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_tipo_habitacion AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_TIPO_DE_HABITACION(
                tipo_habitacion_codigo,
                tipo_habitacion_desc
            )
            SELECT DISTINCT
                tipo_habitacion_codigo,
                tipo_habitacion_desc
            FROM [GD1C2020].PI_DE_PICANTES.TIPO_HABITACION
        END
        GO

    -------------------------------MIGRAR DIMENSION SUCURSAL ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_sucursal AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_SUCURSAL(
                sucursal_dir,
                sucursal_mail,
                sucursal_telefono
            )
            SELECT DISTINCT
                sucursal_dir,
                sucursal_mail,
                sucursal_telefono
            FROM [GD1C2020].PI_DE_PICANTES.SUCURSAL
        END
        GO

    -------------------------------MIGRAR DIMENSION CLIENTE ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_cliente AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_CLIENTE(
                cliente_apellido,
                cliente_nombre,
                cliente_dni,
                cliente_fecha_nac,
                cliente_mail,
                cliente_telefono,
                cliente_edad
            )
            SELECT DISTINCT
                cliente_apellido,
                cliente_nombre,
                cliente_dni,
                cliente_fecha_nac,
                cliente_mail,
                cliente_telefono,
                YEAR(CURRENT_TIMESTAMP)- YEAR(cliente_fecha_nac)
            FROM [GD1C2020].PI_DE_PICANTES.CLIENTE
        END
        GO

    -------------------------------MIGRAR DIMENSION PROVEEDOR ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_proveedor AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_PROVEEDOR(
                empresa_razon_social
            )
            SELECT DISTINCT
                empresa_razon_social
            FROM [GD1C2020].PI_DE_PICANTES.EMPRESA
        END
        GO
    -------------------------------MIGRAR DIMENSION CIUDAD ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_ciudad AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_CIUDAD(
                ciudad_detalle
            )
            SELECT DISTINCT
                ciudad_detalle
            FROM [GD1C2020].PI_DE_PICANTES.CIUDAD
        END
        GO

    -------------------------------MIGRAR DIMENSION AVION ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_avion AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_AVION(
                avion_identificador,
                avion_modelo
            )
            SELECT DISTINCT
                avion_identificador,
                avion_modelo
            FROM [GD1C2020].PI_DE_PICANTES.AVION
        END
        GO

    -------------------------------MIGRAR DIMENSION RUTA ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_ruta AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_RUTA(
                ruta_aerea_id,
                ruta_aerea_ciu_origen,
                ruta_aerea_ciu_destino
            )
            SELECT DISTINCT
                ruta_aerea_id,
                ruta_aerea_ciu_origen,
                ruta_aerea_ciu_destino
            FROM [GD1C2020].PI_DE_PICANTES.RUTA
        END
        GO

    -------------------------------MIGRAR DIMENSION TIPO_PASAJE ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_dimension_tipo_pasaje AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.DIMENSION_TIPO_PASAJE(
                tipo_butaca_desc
            )
            SELECT DISTINCT
                tipo_butaca_desc
            FROM [GD1C2020].PI_DE_PICANTES.TIPO_BUTACA
        END
        GO

    -------------------------------MIGRAR DIMENSION HECHOS_ESTADIA ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_hechos_estadia AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.HECHOS_ESTADIA(
                mes_venta,
                anio_venta,
                cliente_id,
                sucursal_id,
                hotel_calle,
                hotel_nro_calle,
                tipo_habitacion_codigo,
                proveedor_id,

                promedio_venta,
                promedio_compra,
                cant_camas,
                cant_habitaciones,
                ganancia_estadia
            )
            SELECT DISTINCT
                month(factura_fecha),
                year(factura_fecha),
                cliente_id,
                sucursal_id,
                hotel_calle,
                hotel_nro_calle,
                tipo_habitacion_codigo,
                proveedor_id, 

                avg(habitacion_precio),
                avg(habitacion_costo),
                sum(case   when tipo_habitacion_desc = 'Base Simple' then 1  --se utiliza case para poder asignarle un valor (cant de camas por habitacion)
                        when tipo_habitacion_desc= 'Base Doble' then 2       -- y asi poder sumar la cantidad de camas totales 
                        when tipo_habitacion_desc='Base Triple' then 3 
                        when tipo_habitacion_desc='Base Cuadruple' then 4 
                        when tipo_habitacion_desc='King' then 1
                end),
                count(habitacion_est_id),
                sum(habitacion_precio)-sum(habitacion_costo)

            FROM [GD1C2020].PI_DE_PICANTES.FACTURA 
                join [GD1C2020].PI_DE_PICANTES.DIMENSION_SUCURSAL on sucursal_dir = fact_sucursal
                join [GD1C2020].PI_DE_PICANTES.ESTADIA on estadia_factura = factura_numero
                join [GD1C2020].PI_DE_PICANTES.HOTEL on hotel_calle = estadia_hotel_calle and hotel_nro_calle = estadia_hotel_nro
                join [GD1C2020].PI_DE_PICANTES.HABITACION_POR_ESTADIA on habitacion_est_id = estadia_id
                join [GD1C2020].PI_DE_PICANTES.HABITACION on habitacion_id = habitacion_est_numero
                join [GD1C2020].PI_DE_PICANTES.TIPO_HABITACION on tipo_habitacion_id = habitacion_tipo_hab
                join [GD1C2020].PI_DE_PICANTES.DIMENSION_PROVEEDOR on empresa_razon_social = estadia_emp_raz_social
                join [GD1C2020].PI_DE_PICANTES.DIMENSION_CLIENTE on cliente_apellido = fact_cliente_apellido and cliente_nombre = fact_cliente_nombre and fact_cliente = cliente_dni

            group by year(factura_fecha), month(factura_fecha),cliente_id,sucursal_id, hotel_calle, hotel_nro_calle, tipo_habitacion_codigo,proveedor_id
            order by year(factura_fecha), month(factura_fecha) 
            
        END

    GO

    -------------------------------------------------------------------------------------------------------------------
    -------------------------------MIGRAR DIMENSION HECHOS PASAJE ------------------------------------------------------------------------
    CREATE PROCEDURE PI_DE_PICANTES.migrar_hechos_pasajes AS
        BEGIN
            INSERT INTO PI_DE_PICANTES.HECHOS_PASAJE(
                mes_venta,
                anio_venta,
                tipo_pasaje_id,
                ciudad_id,
                avion_identificador,
                ruta_aerea_id,
                sucursal_id,
                cliente_id,
                proveedor_id,

                promedio_venta,
                promedio_compra,
                cant_pasajes_vendidos,
                cant_butacas,
                ganancia_pasajes
            )
            SELECT DISTINCT
                month(factura_fecha),
                year(factura_fecha),
                tipo_pasaje_id,
                ciudad_id,
                avion_identificador,
                ruta_aerea_id,
                sucursal_id,
                cliente_id,
                proveedor_id,

                avg(pasaje_precio),
                avg(pasaje_costo),
                count(pasaje_id),
                count(butaca_avion_id),
                sum(pasaje_precio)-sum(pasaje_costo)

            FROM PI_DE_PICANTES.FACTURA
                join PI_DE_PICANTES.PASAJE on factura_numero = pasaje_factura 
                join PI_DE_PICANTES.BUTACA_POR_AVION on butaca_avion_id = pasaje_nro_butaca
                join PI_DE_PICANTES.BUTACA on butaca_id = butaca_avion_numero
                join PI_DE_PICANTES.VUELO on vuelo_codigo=pasaje_cod_vuelo
                join PI_DE_PICANTES.DIMENSION_RUTA on vuelo_ruta_aerea_cod = ruta_aerea_id
                join PI_DE_PICANTES.DIMENSION_CIUDAD on ruta_aerea_ciu_origen = ciudad_detalle  
                join PI_DE_PICANTES.DIMENSION_TIPO_PASAJE t on t.tipo_butaca_desc = butaca_tipo
                join PI_DE_PICANTES.DIMENSION_AVION on avion_identificador=butaca_avion_identificador
                join PI_DE_PICANTES.DIMENSION_SUCURSAL on fact_sucursal = sucursal_dir
                join PI_DE_PICANTES.DIMENSION_CLIENTE on cliente_apellido = fact_cliente_apellido and cliente_nombre = fact_cliente_nombre and fact_cliente = cliente_dni
                join PI_DE_PICANTES.DIMENSION_PROVEEDOR on empresa_razon_social = pasaje_emp_raz_social

            group by month(factura_fecha),year(factura_fecha),sucursal_id, avion_identificador, ciudad_id,cliente_id,proveedor_id,ruta_aerea_id,tipo_pasaje_id, t.tipo_butaca_desc
        
        END
        GO

------------------------------------------------------------------------
------------------------EJECUTAR MIGRACIONES----------------------------
------------------------------------------------------------------------

EXEC PI_DE_PICANTES.migrar_dimension_hotel
EXEC PI_DE_PICANTES.migrar_dimension_tipo_habitacion
EXEC PI_DE_PICANTES.migrar_dimension_sucursal
EXEC PI_DE_PICANTES.migrar_dimension_cliente
EXEC PI_DE_PICANTES.migrar_dimension_proveedor
EXEC PI_DE_PICANTES.migrar_dimension_tipo_pasaje
EXEC PI_DE_PICANTES.migrar_dimension_ciudad
EXEC PI_DE_PICANTES.migrar_dimension_avion
EXEC PI_DE_PICANTES.migrar_dimension_ruta
EXEC PI_DE_PICANTES.migrar_hechos_estadia
EXEC PI_DE_PICANTES.migrar_hechos_pasajes

