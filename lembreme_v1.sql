CREATE DATABASE lembreme;

USE lembreme;

CREATE TABLE usuario(
	idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    email VARCHAR(45) NOT NULL UNIQUE,
    senha VARCHAR(45) NOT NULL
);

CREATE TABLE album(
	idAlbum INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45)
);

CREATE TABLE foto(
	idFoto INT PRIMARY KEY AUTO_INCREMENT,
    fkAlbum INT,
		CONSTRAINT fkFotoAlbum
			FOREIGN KEY (fkAlbum)
				REFERENCES album(idAlbum),
	descricao TEXT
);

CREATE TABLE curtida(
	idFoto INT,
    idUsuario INT,
		CONSTRAINT pkCurtida
			PRIMARY KEY (idFoto, idUsuario),
		CONSTRAINT fkCurtidaFoto
			FOREIGN KEY (idFoto)
				REFERENCES foto(idFoto),
		CONSTRAINT fkCurtidaUsuario
			FOREIGN KEY (fkUSuario)
				REFERENCES usuario(idUsuario),
	dtCurtida DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE visualizacao(
	idFoto INT,
    idUsuario INT,
		CONSTRAINT pkVisualizacao
			PRIMARY KEY (idFoto, idUsuario),
		CONSTRAINT fkVisualizacaoFoto
			FOREIGN KEY (idFoto)
				REFERENCES foto(idFoto),
		CONSTRAINT fkVisualizacaoUsuario
			FOREIGN KEY (fkUSuario)
				REFERENCES usuario(idUsuario),
	dtVisualizacao DATETIME DEFAULT CURRENT_TIMESTAMP
);
