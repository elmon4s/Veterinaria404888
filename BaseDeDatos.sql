CREATE DATABASE Veterinaria_404888
GO
USE Veterinaria_404888
GO
CREATE TABLE clientes
(
	cod_cliente INT IDENTITY(1,1),
	nom_cliente VARCHAR(30) NOT NULL,
	sexo_cliente BIT NOT NULL,
	CONSTRAINT pk_clientes PRIMARY KEY (cod_cliente)
)
CREATE TABLE tipo_mascotas
(
	cod_tipo INT IDENTITY(1,1),
	decripcion VARCHAR(30) NOT NULL, 
	CONSTRAINT pk_tipo_mascotas PRIMARY KEY (cod_tipo)
)
CREATE TABLE mascotas
(
	cod_mascota INT IDENTITY(1,1),
	nom_mascota VARCHAR(30) NOT NULL,
	tipo_mascota INT NOT NULL,
	fecha_nacimiento DATETIME,
	cod_dueno INT,
	CONSTRAINT pk_mascotas PRIMARY KEY (cod_mascota),
	CONSTRAINT fk_mas_cli FOREIGN KEY (cod_dueno)
		REFERENCES clientes (cod_cliente),
	CONSTRAINT fk_mas_tipo FOREIGN KEY (tipo_mascota)
		REFERENCES tipo_mascotas(cod_tipo)
)

CREATE TABLE atenciones
(
	cod_atencion INT IDENTITY(1,1),
	descripcion VARCHAR(200) NOT NULL,
	importe DECIMAL(10,2) NOT NULL,
	fecha_atencion DATETIME NOT NULL,
	cod_mascota INT NOT NULL,
	CONSTRAINT pk_atenciones PRIMARY KEY (cod_atencion),
	CONSTRAINT fk_ate_mas FOREIGN KEY (cod_mascota)
		REFERENCES mascotas(cod_mascota)
)
GO

INSERT INTO tipo_mascotas VALUES ('perro')
INSERT INTO tipo_mascotas VALUES ('gato')
INSERT INTO tipo_mascotas VALUES ('ara�a')
INSERT INTO tipo_mascotas VALUES ('iguana')

GO

CREATE PROCEDURE SP_OBTENER_CLIENTES
AS
BEGIN
	SELECT nom_cliente, sexo_cliente, cod_cliente
	FROM clientes
END

GO
CREATE PROCEDURE SP_OBTENER_MASCOTAS
	@cod_cliente INT
AS
BEGIN
	SELECT nom_mascota, DATEDIFF(YEAR, fecha_nacimiento, GETDATE()), t.decripcion, cod_mascota
	FROM mascotas m JOIN tipo_mascotas t ON m.tipo_mascota = t.cod_tipo
	WHERE cod_dueno = @cod_cliente
END
GO
CREATE PROCEDURE SP_OBTENER_ATENCIONES
	@cod_mascota INT
AS
BEGIN
	SELECT cod_atencion, descripcion, importe, fecha_atencion
	FROM atenciones
	WHERE cod_mascota = @cod_mascota
END
GO
CREATE PROCEDURE SP_AGREGAR_ATENCION
	@descripcion VARCHAR(200), @importe DECIMAL(10,2), @fecha_atencion DATETIME, @cod_mascota INT
AS
BEGIN
	INSERT INTO atenciones VALUES (@descripcion, @importe, @fecha_atencion, @cod_mascota)
END