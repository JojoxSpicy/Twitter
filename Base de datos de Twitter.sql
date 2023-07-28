Create database Twitter;

drop database twitter;
------------------------------------------------------------------------------------------------------------------------------
-- uso de la base de datos
use Twitter;
-- Creación de la tabla 'users' para almacenar la información de los usuarios
CREATE TABLE Usuario (
    ID_usuario INT PRIMARY KEY AUTO_INCREMENT,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Usuario VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    Contador_Seguidores int NOT NULL DEFAULT 0,
	created_at TIMESTAMP not null default (now())
);
------------------------------------------------------------------------------------------------------------------------------
insert into usuario (Nombre,Apellido,usuario,email) 
values 
('Jose Enrique','Tejada Ramirez','JojoxSpicy','Kike.Jose199@gmail.com'),
('Hasill','Peña Monegro','K4cY','Hasill@gamil.com'),
('Alexander Gabriel','Tapia Ramirez','AlexWTF','Ale@gmail.com'),
('Roy','Acevedo Valdez','AceKillua','Roy@gmail.com');

Insert into usuario (nombre,apellido,usuario,email) values ('Empresa','de ropa','Oxorius','Oxorius.com');

select * from usuario;
------------------------------------------------------------------------------------------------------------------------------
-- Creación de la tabla 'tweets' para almacenar los tweets
CREATE TABLE tweets (
    tweet_id INT PRIMARY KEY AUTO_INCREMENT,
    ID_usuario INT NOT NULL,
    tweet_text VARCHAR(280) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario)
);

-- Insertando Tweets
INSERT INTO tweets (ID_usuario,tweet_text)
VALUES
(1,'Hola Mundo'),
(2,'Free Oxorius'),
(3,'Let me Cook'),
(4,'Si');

select * from tweets;
------------------------------------------------------------------------------------------------------------------------------

-- Creación de la tabla 'Seguidores' para almacenar las relaciones de seguimiento entre usuarios
CREATE TABLE Seguidores (
    follow_id INT PRIMARY KEY AUTO_INCREMENT,
    Seguidos_id INT NOT NULL,
    seguidores_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Seguidos_id) REFERENCES Usuario(ID_usuario),
    FOREIGN KEY (seguidores_id) REFERENCES Usuario(ID_usuario)
);
------------------------------------------------------------------------------------------------------------------------------
-- trigger para evitar que un usuario se siga a sí mismo
DELIMITER //
CREATE TRIGGER evitar_seguir_a_si_mismo BEFORE INSERT ON Seguidores
FOR EACH ROW
BEGIN
    IF NEW.Seguidos_id = NEW.seguidores_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No puedes seguirte a ti mismo.';
    END IF;
END;
//
DELIMITER ;

------------------------------------------------------------------------------------------------------------
-- Crear el trigger para aumentar el contador de seguidores al seguir a alguien
DELIMITER //
CREATE TRIGGER seguir_usuario AFTER INSERT ON Seguidores
FOR EACH ROW
BEGIN
    -- Actualizar el contador de seguidores para el usuario seguido (incrementar en 1)
    UPDATE Usuario
    SET Contador_Seguidores = Contador_Seguidores + 1
    WHERE ID_usuario = NEW.Seguidos_id;
END;
//

-- Crear el trigger para disminuir el contador de seguidores al dejar de seguir a alguien
CREATE TRIGGER dejar_seguir_usuario AFTER DELETE ON Seguidores
FOR EACH ROW
BEGIN
    -- Restar 1 al contador de seguidores para el usuario seguido
    UPDATE Usuario
    SET Contador_Seguidores = Contador_Seguidores - 1
    WHERE ID_usuario = OLD.Seguidos_id;
END;
//
DELIMITER ;

-- ----------------------------------------------------------------------------------------------------------
INSERT INTO Seguidores (Seguidos_id,seguidores_id)
VALUES
(1,5), -- el 5 sigue al 1 etc
(2,5), -- el 5 sigue al 2 etc
(3,5),-- el 5 sigue al 3 etc
(4,5);-- el 5 sigue al 4 etc

Insert into seguidores (seguidos_id,Seguidores_id)
values
(5,1),-- el 1 sigue al 5 etc
(5,2),-- el 1 sigue al 5 etc
(5,3),-- el 1 sigue al 5 etc
(5,4);-- el 1 sigue al 5 etc

select * from Seguidores;
------------------------------------------------------------------------------------------------------------

-- Creación de la tabla 'likes' para almacenar los likes dados a los tweets
CREATE TABLE likes (
    like_id INT PRIMARY KEY AUTO_INCREMENT,
    ID_usuario INT NOT NULL,
    tweet_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ID_usuario) REFERENCES Usuario(ID_usuario),
    FOREIGN KEY (tweet_id) REFERENCES tweets(tweet_id)
);
------------------------------------------------------------------------------------------------------------
-- Creación de una vista para obtener los seguidores de un usuario con su nombre de usuario y nombre real
CREATE VIEW vista_seguidores AS
SELECT
    seguidor.Nombre AS nombre_seguidor,
    seguidor.Usuario AS nombre_usuario_seguidor,
    usuario.ID_usuario AS ID_seguido,
    usuario.Nombre AS nombre_seguido,
    usuario.Usuario AS nombre_usuario_seguido
FROM
    Seguidores
INNER JOIN
    Usuario AS seguidor ON Seguidores.seguidores_id = seguidor.ID_usuario
INNER JOIN
    Usuario AS usuario ON Seguidores.Seguidos_id = usuario.ID_usuario;

SELECT * FROM vista_seguidores WHERE ID_seguido = 5;

drop view vista_seguidores;
------------------------------------------------------------------------------------------------------------
-- creacion de una vista para obtener los tweets de las personas
	





