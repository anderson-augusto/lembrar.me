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

INSERT INTO album (nome, descricao) VALUES
('Infância', 'memórias antigas'),
('Viagens', 'cidades marcantes'),
('Família', 'momentos importantes'),
('Amigos', 'momentos especiais');

INSERT INTO foto (fkAlbum, descricao) VALUES
(1, 'primeira bicicleta'),
(1, 'aniversário 5 anos'),
(2, 'Rio de Janeiro 2021'),
(2, 'Fernando de Noronha'),
(3, 'Natal em família'),
(4, 'festa da faculdade'),
(4, 'boteco com amigos');

INSERT INTO curtida (idFoto, idUsuario) VALUES
(1, 2),
(1, 3),
(2, 4),
(3, 2),
(3, 3),
(3, 4),
(4, 2),
(7, 3);

INSERT INTO visualizacao (idFoto, idUsuario) VALUES
(1,2),(1,3),(1,3),(1,4),(1,null),
(2,3),(2,4),(2,null),
(3,2),(3,2),(3,4),(3,4),(3,null),(3,null),
(4,2),(4,3),
(5,2),(5,null),
(6,3),(6,null),
(7,4),(7,null),(7,null);

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
    DATE_FORMAT(dtCriacao,'%Y-%m')
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
    
SELECT * FROM usuario;