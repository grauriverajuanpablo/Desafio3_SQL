
--- item 1
--- 1.1 crear BBDD 
create database desafio3_JuanPablo_Grau_315_3digitos;

---	1.2	crear tabla usuarios

CREATE TABLE usuarios (
    id SERIAL PRIMARY KEY,
    rol VARCHAR,
    email VARCHAR,
    nombre VARCHAR,
    apellido VARCHAR
);

--- 1.3	insertar datos tabla usuarios

INSERT INTO usuarios (rol, email, nombre, apellido)
VALUES
    ('administrador', 'juanadmin@gracar.com', 'Juan', 'grau'),
    ('usuario', 'raul.gonzalez@gracar.com', 'raul', 'gonzalez'),
    ('usuario', 'ramon.ramirez@gracar.com', 'ramon', 'ramirez'),
    ('usuario', 'carlo.uentes@gracar.com', 'carlos', 'fuentes'),
    ('usuario', 'eduardo.montenegro@gracar.com', 'eduardo', 'Montenegro');
   
   select *
   from usuarios;
  
---	1.4	crea tabla posts
  
  CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    titulo VARCHAR,
    contenido TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_actualizacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    destacado BOOLEAN,
    usuario_id BIGINT
);

---	1.5	insertar datos tabla posts

INSERT INTO posts (id, titulo, contenido, fecha_creacion, fecha_actualizacion, destacado, usuario_id)
VALUES
    (1, 'Título del post 1', 'Contenido del post 1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, true, 1),
    (2, 'Título del post 2', 'Contenido del post 2', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, true, 1),
    (3, 'Título del post 3', 'Contenido del post 3', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, 2),
    (4, 'Título del post 4', 'Contenido del post 4', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, 2),
    (5, 'Título del post 5', 'Contenido del post 5', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, false, NULL);

--- 1.6 luego asigno usuarios con update
   
   	UPDATE posts SET usuario_id = 1 WHERE id IN (1, 2); -- Asignar al usuario administrador
	UPDATE posts SET usuario_id = 3 WHERE id IN (3, 4); -- Asignar a otro usuario

	
	select *
	from posts;

--- 1.7 crea tabla comentarios

CREATE TABLE comentarios (
    id SERIAL PRIMARY KEY,
    contenido TEXT,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario_id BIGINT,
    post_id BIGINT
);

--- 1.8 inserta datos tabla comentarios

INSERT INTO comentarios (id, contenido, usuario_id, post_id)
VALUES
    (1, 'Este es el comentario 1', 1, 1),
    (2, 'Este es el comentario 2', 2, 1),
    (3, 'Este es el comentario 3', 3, 1),
    (4, 'Este es el comentario 4', 1, 2),
    (5, 'Este es el comentario 5', 2, 2);
   
 ---- item 2 Cruza los datos de la tabla usuarios y posts, mostrando las siguientes columnas:
 ---- nombre y email del usuario junto al título y contenido del post.
   
SELECT u.nombre, u.email, p.titulo, p.contenido
FROM usuarios u
JOIN posts p ON u.id = p.usuario_id;

--- item 3 Muestra el id, título y contenido de los posts de los administradores El administrador puede ser cualquier id.

SELECT p.id, p.titulo, p.contenido
FROM posts p
JOIN usuarios u ON p.usuario_id = u.id
WHERE u.rol = 'administrador';

--- item 4  Cuenta la cantidad de posts de cada usuario.

SELECT u.id AS usuario_id, u.email, COUNT(p.id) AS cantidad_posts
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

--- item 5 Muestra el email del usuario que ha creado más posts.

SELECT u.email
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email
ORDER BY COUNT(p.id) DESC
LIMIT 1;

--- item 6 Muestra la fecha del último post de cada usuario


SELECT u.id AS usuario_id, u.email, MAX(p.fecha_creacion) AS ultima_fecha_post
FROM usuarios u
LEFT JOIN posts p ON u.id = p.usuario_id
GROUP BY u.id, u.email;

--- item 7 Muestra el título y contenido del post (artículo) con más comentarios.

SELECT p.titulo, p.contenido
FROM posts p
LEFT JOIN comentarios c ON p.id = c.post_id
GROUP BY p.id, p.titulo, p.contenido
ORDER BY COUNT(c.id) DESC
LIMIT 1;

--- item 8 Muestra en una tabla el título de cada post, el contenido de cada post y el contenido

SELECT p.titulo AS "Título del Post", p.contenido AS "Contenido del Post",
       c.contenido AS "Contenido del Comentario", u.email AS "Email del Usuario"
FROM posts p
LEFT JOIN comentarios c ON p.id = c.post_id
LEFT JOIN usuarios u ON c.usuario_id = u.id;

--- item 9 Muestra el contenido del último comentario de cada usuario 


SELECT u.email, c.contenido AS "Último Comentario"
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
WHERE c.fecha_creacion = (SELECT MAX(fecha_creacion) FROM comentarios WHERE usuario_id = u.id);


--- item 10 Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT u.email
FROM usuarios u
LEFT JOIN comentarios c ON u.id = c.usuario_id
WHERE c.id IS NULL;







