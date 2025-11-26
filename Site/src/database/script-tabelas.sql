CREATE DATABASE lembreme;
USE lembreme;

-- Usuário
CREATE TABLE usuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    senha VARCHAR(60) NOT NULL,
    perfil ENUM('admin', 'user') DEFAULT 'user',
    dtCadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Álbum
CREATE TABLE album (
    idAlbum INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    descricao VARCHAR(200),
    dtCriacao DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Foto
CREATE TABLE foto (
    idFoto INT PRIMARY KEY AUTO_INCREMENT,
    fkAlbum INT NOT NULL,
    descricao TEXT,
    dtCriacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_foto_album FOREIGN KEY (fkAlbum)
        REFERENCES album(idAlbum)
);
ALTER TABLE foto
ADD url VARCHAR(255);


-- Curtida
CREATE TABLE curtida (
    idFoto INT,
    idUsuario INT,
    dtCurtida DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pkCurtida PRIMARY KEY (idFoto, idUsuario),
    CONSTRAINT fkCurtidaFoto FOREIGN KEY (idFoto) REFERENCES foto(idFoto),
    CONSTRAINT fkCurtidaUsuario FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

-- Visualização
CREATE TABLE visualizacao (
    idVisualizacao INT PRIMARY KEY AUTO_INCREMENT,
    idFoto INT NOT NULL,
    idUsuario INT,
    dtVisualizacao DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fkVisualizacaoFoto FOREIGN KEY (idFoto) REFERENCES foto(idFoto),
    CONSTRAINT fkVisualizacaoUsuario FOREIGN KEY (idUsuario) REFERENCES usuario(idUsuario)
);

INSERT INTO usuario (nome, email, senha, perfil) VALUES
('Anderson', 'admin@lembre.me', '123', 'admin'),
('Maria', 'maria@gmail.com', '123', 'user'),
('João', 'joao@gmail.com', '123', 'user'),
('Ana', 'ana@gmail.com', '123', 'user');

-- KPI album mais engajado
SELECT 
    a.nome AS album,
    COUNT(v.idFoto) + COUNT(c.idFoto) AS engajamento
FROM album a
LEFT JOIN foto f ON f.fkAlbum = a.idAlbum
LEFT JOIN visualizacao v 
    ON v.idFoto = f.idFoto 
    AND MONTH(v.dtVisualizacao) = MONTH(NOW())
LEFT JOIN curtida c
    ON c.idFoto = f.idFoto
    AND MONTH(c.dtCurtida) = MONTH(NOW())
GROUP BY a.idAlbum
ORDER BY engajamento DESC
LIMIT 1;

-- KPI Foto + impactante
SELECT 
    f.idFoto,
    f.descricao,
    ROUND( COUNT(c.idFoto) / COUNT(v.idFoto) * 100 ,1 ) AS taxa
FROM foto f
LEFT JOIN curtida c ON c.idFoto = f.idFoto
LEFT JOIN visualizacao v ON v.idFoto = f.idFoto
GROUP BY f.idFoto
HAVING COUNT(v.idFoto) > 0
ORDER BY taxa DESC
LIMIT 1;

-- KPI Álbum que mais cresceu nos últimos 30 dias
SELECT 
    a.nome AS album,
    COUNT(*) AS views
FROM album a
JOIN foto f ON f.fkAlbum = a.idAlbum
JOIN visualizacao v ON v.idFoto = f.idFoto
WHERE v.dtVisualizacao >= DATE_SUB(NOW(), INTERVAL 30 DAY)
GROUP BY a.idAlbum
ORDER BY views DESC
LIMIT 1;


-- KPI — Dia mais lembrado
SELECT 
    DATE(dtCriacao) AS dia,
    COUNT(*) AS fotos
FROM foto
GROUP BY DATE(dtCriacao)
ORDER BY fotos DESC
LIMIT 1;

-- KPI — Fotos adicionadas no último mês
SELECT 
    COUNT(*) AS fotos_mes
FROM foto
WHERE dtCriacao >= DATE_SUB(NOW(), INTERVAL 30 DAY);

-- Grafico 1
SELECT
    a.nome AS album,
    ROUND( COUNT(c.idFoto) / COUNT(v.idFoto) * 100 ,1 ) AS taxa_engajamento
FROM album a
JOIN foto f ON f.fkAlbum = a.idAlbum
LEFT JOIN curtida c ON c.idFoto = f.idFoto
LEFT JOIN visualizacao v ON v.idFoto = f.idFoto
GROUP BY a.idAlbum;

-- Gráfico 2
SELECT
    DATE_FORMAT(dtCriacao,'%Y-%m') AS ano_mes,
    DATE_FORMAT(dtCriacao,'%b') AS mes,
    COUNT(*) AS fotos
FROM foto
GROUP BY 
    ano_mes, mes
ORDER BY ano_mes;

SELECT 
    DATE_FORMAT(dtCriacao, '%b') AS mes,
    COUNT(*) AS fotos
FROM foto
GROUP BY 
    DATE_FORMAT(dtCriacao, '%b'),
    YEAR(dtCriacao),
    MONTH(dtCriacao)
ORDER BY 
    YEAR(dtCriacao),
    MONTH(dtCriacao);
    
/*INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao)
SELECT  idFoto, 2, DATE_SUB(NOW(), INTERVAL 1 WEEK)
FROM foto LIMIT 5;

-- INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
-- (1, 3, DATE_SUB(NOW(), INTERVAL 1 WEEK)),
-- (2, 4, DATE_SUB(NOW(), INTERVAL 1 WEEK)),
-- (3, 2, DATE_SUB(NOW(), INTERVAL 1 WEEK));

-- 2 semanas atrás
INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao)
SELECT  idFoto, 3, DATE_SUB(NOW(), INTERVAL 2 WEEK)
FROM foto LIMIT 6;

-- INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
-- (3, 2, DATE_SUB(NOW(), INTERVAL 2 WEEK)),
-- (4, 4, DATE_SUB(NOW(), INTERVAL 2 WEEK));


-- 3 semanas atrás
INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao)
SELECT idFoto, 4, DATE_SUB(NOW(), INTERVAL 3 WEEK)
FROM foto LIMIT 4;

INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
(1, 4, DATE_SUB(NOW(), INTERVAL 3 WEEK)),
(6, 3, DATE_SUB(NOW(), INTERVAL 3 WEEK));


-- 4 semanas atrás
INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao)
SELECT idFoto, NULL, DATE_SUB(NOW(), INTERVAL 4 WEEK)
FROM foto LIMIT 3;

-- INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
-- (2, 4, DATE_SUB(NOW(), INTERVAL 4 WEEK));


-- 5 semanas atrás
INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao)
SELECT idFoto, NULL, DATE_SUB(NOW(), INTERVAL 5 WEEK)
FROM foto LIMIT 2;*/

-- UPDATE foto SET url = 'fotos/banner_eu_pai.JPG' WHERE idFoto IN (19,20,21);


-- ALBUNS
INSERT INTO album (idAlbum, nome, descricao) VALUES
(1, 'Conexão', ''),
(2, 'Natureza', ''),
(3, 'Família', ''),
(4, 'Saúde', ''),
(5, 'Conhecimento', '');

ALTER TABLE album AUTO_INCREMENT = 6;

-- INSERIR FOTOS — CONEXÃO (34)

INSERT INTO foto (fkAlbum, descricao, url) VALUES

(1, '', 'fotos/conexao_4.JPEG'),
(1, '', 'fotos/conexao_23.WEBP'),
(1, '', 'fotos/conexao_1.JPG'),
(1, '', 'fotos/conexao_2.JPG'),
(1, '', 'fotos/conexao_3.JPG'),
(1, '', 'fotos/conexao_5.JPG'),
(1, '', 'fotos/conexao_6.JPG'),
(1, '', 'fotos/conexao_7.JPG'),
(1, '', 'fotos/conexao_8.JPG'),
(1, '', 'fotos/conexao_9.JPG'),
(1, '', 'fotos/conexao_10.JPG'),
(1, '', 'fotos/conexao_12.JPG'),
(1, '', 'fotos/conexao_13.JPG'),
(1, '', 'fotos/conexao_15.JPG'),
(1, '', 'fotos/conexao_16.JPG'),
(1, '', 'fotos/conexao_17.JPG'),
(1, '', 'fotos/conexao_18.JPG'),
(1, '', 'fotos/conexao_19.JPG'),
(1, '', 'fotos/conexao_20.JPG'),
(1, '', 'fotos/conexao_21.JPG'),
(1, '', 'fotos/conexao_22.JPG'),
(1, '', 'fotos/conexao_24.JPG'),
(1, '', 'fotos/conexao_25.JPG'),
(1, '', 'fotos/conexao_26.JPG'),
(1, '', 'fotos/conexao_27.JPG'),
(1, '', 'fotos/conexao_28.JPG'),
(1, '', 'fotos/conexao_29.JPG'),
(1, '', 'fotos/conexao_30.JPG'),
(1, '', 'fotos/conexao_31.JPG'),
(1, '', 'fotos/conexao_32.JPG'),
(1, '', 'fotos/conexao_33.JPG'),
(1, '', 'fotos/conexao_34.JPG');

-- INSERIR FOTOS — NATUREZA (11)


INSERT INTO foto (fkAlbum, descricao, url) VALUES
(2, '', 'fotos/natureza_1.JPG'),
(2, '', 'fotos/natureza_2.JPG'),
(2, '', 'fotos/natureza_3.JPG'),
(2, '', 'fotos/natureza_4.JPG'),
(2, '', 'fotos/natureza_5.JPG'),
(2, '', 'fotos/natureza_6.JPG'),
(2, '', 'fotos/natureza_7.JPG'),
(2, '', 'fotos/natureza_8.JPG'),
(2, '', 'fotos/natureza_9.JPG'),
(2, '', 'fotos/natureza_10.JPG'),
(2, '', 'fotos/natureza_11.JPG');

-- INSERIR FOTOS — FAMÍLIA (10)

INSERT INTO foto (fkAlbum, descricao, url) VALUES
(3, '', 'fotos/familia_1.JPG'),
(3, '', 'fotos/familia_2.JPG'),
(3, '', 'fotos/familia_3.JPG'),
(3, '', 'fotos/familia_4.JPG'),
(3, '', 'fotos/familia_5.JPG'),
(3, '', 'fotos/familia_6.JPG'),
(3, '', 'fotos/familia_7.JPG'),
(3, '', 'fotos/familia_8.JPG'),
(3, '', 'fotos/familia_9.JPG'),
(3, '', 'fotos/familia_10.JPEG');  


-- INSERIR FOTOS — SAÚDE (7)

INSERT INTO foto (fkAlbum, descricao, url) VALUES
(4, '', 'fotos/saude_1.JPG'),
(4, '', 'fotos/saude_2.JPG'),
(4, '', 'fotos/saude_3.JPG'),
(4, '', 'fotos/saude_4.JPG'),
(4, '', 'fotos/saude_5.JPG'),
(4, '', 'fotos/saude_6.JPG'),
(4, '', 'fotos/saude_7.JPG');

-- INSERIR FOTOS — CONHECIMENTO (8)

INSERT INTO foto (fkAlbum, descricao, url) VALUES
(5, '', 'fotos/conhecimento_1.JPG'),
(5, '', 'fotos/conhecimento_2.JPG'),
(5, '', 'fotos/conhecimento_3.JPG'),
(5, '', 'fotos/conhecimento_4.JPG'),
(5, '', 'fotos/conhecimento_5.JPG'),
(5, '', 'fotos/conhecimento_6.JPG'),
(5, '', 'fotos/conhecimento_7.JPG'),
(5, '', 'fotos/conhecimento_8.JPG');

-- CURTIDAS (últimas 6 semanas)

SELECT * from foto;
-- Anderson 
INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
(3, 1, NOW() - INTERVAL 5 DAY),
(10, 1, NOW() - INTERVAL 12 DAY),
(15, 1, NOW() - INTERVAL 20 DAY),
(28, 1, NOW() - INTERVAL 33 DAY),
(40, 1, NOW() - INTERVAL 14 DAY),
(47, 1, NOW() - INTERVAL 21 DAY),
(52, 1, NOW() - INTERVAL 6 DAY),
(58, 1, NOW() - INTERVAL 18 DAY),
(64, 1, NOW() - INTERVAL 30 DAY),
(66, 1, NOW() - INTERVAL 10 DAY);

-- Maria 
INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
(5, 2, NOW() - INTERVAL 4 DAY),
(9, 2, NOW() - INTERVAL 15 DAY),
(21, 2, NOW() - INTERVAL 28 DAY),
(36, 2, NOW() - INTERVAL 12 DAY),
(44, 2, NOW() - INTERVAL 35 DAY),
(50, 2, NOW() - INTERVAL 8 DAY),
(63, 2, NOW() - INTERVAL 17 DAY);


INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
(2, 3, NOW() - INTERVAL 9 DAY),
(14, 3, NOW() - INTERVAL 22 DAY),
(48, 3, NOW() - INTERVAL 30 DAY),
(57, 3, NOW() - INTERVAL 14 DAY);

INSERT INTO curtida (idFoto, idUsuario, dtCurtida) VALUES
(38, 4, NOW() - INTERVAL 11 DAY),
(41, 4, NOW() - INTERVAL 29 DAY),
(56, 4, NOW() - INTERVAL 5 DAY),
(59, 4, NOW() - INTERVAL 26 DAY),
(62, 4, NOW() - INTERVAL 15 DAY);

-- VISUALIZAÇÕES 

INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao) VALUES
(1, 1, NOW() - INTERVAL 2 DAY),
(2, 1, NOW() - INTERVAL 3 DAY),
(6, 1, NOW() - INTERVAL 14 DAY),
(12, 1, NOW() - INTERVAL 20 DAY),
(18, 1, NOW() - INTERVAL 32 DAY),
(29, 1, NOW() - INTERVAL 40 DAY),
(37, 1, NOW() - INTERVAL 11 DAY),
(43, 1, NOW() - INTERVAL 27 DAY),
(49, 1, NOW() - INTERVAL 9 DAY),
(55, 1, NOW() - INTERVAL 22 DAY),
(60, 1, NOW() - INTERVAL 15 DAY),
(67, 1, NOW() - INTERVAL 5 DAY);

-- Maria 
INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao) VALUES
(4, 2, NOW() - INTERVAL 8 DAY),
(7, 2, NOW() - INTERVAL 12 DAY),
(13, 2, NOW() - INTERVAL 18 DAY),
(22, 2, NOW() - INTERVAL 26 DAY),
(34, 2, NOW() - INTERVAL 38 DAY),
(40, 2, NOW() - INTERVAL 6 DAY),
(47, 2, NOW() - INTERVAL 9 DAY),
(63, 2, NOW() - INTERVAL 32 DAY);

-- João 
INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao) VALUES
(3, 3, NOW() - INTERVAL 10 DAY),
(11, 3, NOW() - INTERVAL 21 DAY),
(27, 3, NOW() - INTERVAL 33 DAY),
(46, 3, NOW() - INTERVAL 14 DAY),
(57, 3, NOW() - INTERVAL 4 DAY);

-- Ana 
INSERT INTO visualizacao (idFoto, idUsuario, dtVisualizacao) VALUES
(35, 4, NOW() - INTERVAL 2 DAY),
(38, 4, NOW() - INTERVAL 9 DAY),
(42, 4, NOW() - INTERVAL 20 DAY),
(56, 4, NOW() - INTERVAL 15 DAY),
(58, 4, NOW() - INTERVAL 27 DAY),
(61, 4, NOW() - INTERVAL 35 DAY),
(66, 4, NOW() - INTERVAL 12 DAY);



