-- ====================================================================
-- Trabalho Prático - Administração de Banco de Dados (1º Bimestre)
-- Banco de Dados: PostgreSQL Sample (DVDRental)
-- Objetivo: Aplicar conceitos de views, joins, sequences e consultas SQL
-- ====================================================================

/*
	Membros:
		- Paulo Junior Walbueno dos Santos
		- Bruno de Morais Euzébio
*/


-- Atividades avaliativas

-- --------------------------------------------------------------------
-- ITEM 1
-- Importação dos dados foi feita corretamente, para visualizar as tabelas importadas, basta executar:
SELECT tablename 
FROM pg_tables 
WHERE schemaname = 'public';
-- --------------------------------------------------------------------


-- --------------------------------------------------------------------
-- ITEM 2
-- Criação de uma visão simples baseada em uma única tabela.
-- A view retorna os dados básicos dos atores cadastrados.
-- --------------------------------------------------------------------
CREATE VIEW v_atores AS
SELECT actor_id, first_name, last_name FROM actor;

--Consulta:
SELECT * FROM v_atores;


-- --------------------------------------------------------------------
-- ITEM 3
-- Criação de uma visão com junção entre duas tabelas com relação 1:N.
-- Neste caso, um país (country) pode ter várias cidades (city).
-- A consulta retorna o nome da cidade e seu respectivo país.
-- --------------------------------------------------------------------
CREATE VIEW v_cidades_paises AS
SELECT ci.city AS cidade, co.country AS pais FROM city ci
	INNER JOIN country co 
    	ON ci.country_id = co.country_id;

--Consulta:
SELECT * FROM v_cidades_paises;


-- --------------------------------------------------------------------
-- ITEM 4
-- Criação de duas sequences para geração de identificadores únicos.
-- Em seguida, são realizados inserts utilizando essas sequences.
-- O valor inicial foi definido como 1000 para evitar conflito com dados existentes.
-- --------------------------------------------------------------------

-- Sequences
CREATE SEQUENCE seq_ator START WITH 1000;
CREATE SEQUENCE seq_categoria START WITH 1000;

-- Inserts na tabela actor
INSERT INTO actor (actor_id, first_name, last_name) 
VALUES (nextval('seq_ator'), 'Paulo', 'Santos');

INSERT INTO actor (actor_id, first_name, last_name) 
VALUES (nextval('seq_ator'), 'Bruno', 'Euzébio');

-- Inserts na tabela category (incluindo campo obrigatório last_update)
INSERT INTO category (category_id, name, last_update) 
VALUES (nextval('seq_categoria'), 'Anime', NOW());

INSERT INTO category (category_id, name, last_update) 
VALUES (nextval('seq_categoria'), 'Podcast', NOW());

--Consulta Inserts:
SELECT * FROM actor
ORDER BY actor_id DESC;

--Consulta Categorias:
SELECT * FROM category
ORDER BY category_id DESC;


-- --------------------------------------------------------------------
-- ITEM 5
-- Criação de uma visão utilizando UNION.
-- A consulta une os nomes completos de clientes e funcionários.
-- O UNION elimina possíveis duplicidades entre os resultados.
-- --------------------------------------------------------------------
CREATE VIEW v_nomes_pessoas AS
SELECT first_name || ' ' || last_name AS nome 
FROM customer
UNION
SELECT first_name || ' ' || last_name AS nome 
FROM staff;

--Consulta
SELECT * FROM v_nomes_pessoas;


-- --------------------------------------------------------------------
-- ITEM 6
-- Criação de uma visão que retorna o nome completo do cliente
-- e a quantidade de filmes alugados.
-- Utiliza LEFT JOIN para garantir que clientes sem aluguel apareçam
-- com quantidade igual a 0.
-- --------------------------------------------------------------------
CREATE VIEW v_alugueis_cliente AS
SELECT c.first_name || ' ' || c.last_name AS nome, COUNT(r.rental_id) AS total_alugueis FROM customer c
LEFT JOIN rental r 
    ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

--Consulta:
SELECT * FROM v_alugueis_cliente
ORDER BY total_alugueis DESC;


-- --------------------------------------------------------------------
-- ITEM 7
-- Criação de uma visão que retorna o nome do cliente e os títulos
-- dos filmes alugados.
-- A consulta percorre as tabelas: customer -> rental -> inventory -> film.
-- O uso de LEFT JOIN garante que clientes sem aluguel apareçam com valor nulo.
-- --------------------------------------------------------------------
CREATE VIEW v_filmes_cliente AS
SELECT c.first_name || ' ' || c.last_name AS nome, f.title AS titulo_filme FROM customer c
LEFT JOIN rental r 
    ON c.customer_id = r.customer_id
LEFT JOIN inventory i 
    ON r.inventory_id = i.inventory_id
LEFT JOIN film f 
    ON i.film_id = f.film_id;
	
--Consulta:
SELECT * FROM v_filmes_cliente;
