CREATE DATABASE sistemaseguranca;

CREATE TABLE usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome_primeiro VARCHAR(50) NOT NULL,
    nome_sobrenome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    tipo VARCHAR(20) NOT NULL
);

CREATE TABLE morador (
    id_usuario INT PRIMARY KEY,
    apartamento VARCHAR(10),

    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE funcionario (
    id_usuario INT PRIMARY KEY,
    cargo VARCHAR(50),

    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE visitante (
    id_usuario INT PRIMARY KEY,
    documento VARCHAR(50),

    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE local (
    id_local INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50)
);
CREATE TABLE dispositivo (
    id_dispositivo INT PRIMARY KEY AUTO_INCREMENT,
    id_local INT,
    localizacao VARCHAR(100),
    status VARCHAR(20),
    tipo VARCHAR(50),

    FOREIGN KEY (id_local) REFERENCES local(id_local)
);

CREATE TABLE permissao (
    id_permissao INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_local INT,
    id_dispositivo INT,
    nivel_acesso VARCHAR(20),
    data_inicio DATETIME,
    data_fim DATETIME,

    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_local) REFERENCES local(id_local),
    FOREIGN KEY (id_dispositivo) REFERENCES dispositivo(id_dispositivo)
);

CREATE TABLE log_acesso (
    id_acesso INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT,
    id_dispositivo INT,
    data_hora DATETIME,
    status VARCHAR(20),

    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_dispositivo) REFERENCES dispositivo(id_dispositivo)
);

CREATE TABLE evento (
    id_evento INT PRIMARY KEY AUTO_INCREMENT,
    id_acesso INT,
    data_hora DATETIME,
    tipo_evento VARCHAR(50),
    descricao TEXT,

    FOREIGN KEY (id_acesso) REFERENCES log_acesso(id_acesso)
);

CREATE TABLE monitoramento (
    id_monitoramento INT PRIMARY KEY AUTO_INCREMENT,
    id_dispositivo INT,
    ultima_verificacao DATETIME,
    status_conexao VARCHAR(20),
    alerta_ativo BOOLEAN,

    FOREIGN KEY (id_dispositivo) REFERENCES dispositivo(id_dispositivo)
);

INSERT INTO usuario (cpf, nome_primeiro, nome_sobrenome, telefone, tipo)
VALUES 
('12345678900', 'Ana', 'Silva', '999999999', 'morador'),
('98765432100', 'Carlos', 'Souza', '888888888', 'funcionario');

INSERT INTO morador VALUES (1, 'A101');
INSERT INTO funcionario VALUES (2, 'Porteiro');

INSERT INTO local (nome, tipo)
VALUES ('Portaria', 'Entrada');

INSERT INTO dispositivo (id_local, localizacao, status, tipo)
VALUES (1, 'Porta principal', 'ativo', 'biometrico');

INSERT INTO permissao (id_usuario, id_local, id_dispositivo, nivel_acesso, data_inicio, data_fim)
VALUES (1, 1, 1, 'total', NOW(), NULL);

INSERT INTO log_acesso (id_usuario, id_dispositivo, data_hora, status)
VALUES (1, 1, NOW(), 'permitido');

INSERT INTO evento (id_acesso, data_hora, tipo_evento, descricao)
VALUES (1, NOW(), 'entrada', 'Acesso liberado');

INSERT INTO monitoramento (id_dispositivo, ultima_verificacao, status_conexao, alerta_ativo)
VALUES (1, NOW(), 'online', false);

-- Ver todos os usuários
SELECT * FROM usuario;

-- Ver acessos realizados
SELECT u.nome_primeiro, l.data_hora, l.status
FROM log_acesso l
JOIN usuario u ON u.id_usuario = l.id_usuario;

-- Ver permissões
SELECT u.nome_primeiro, p.nivel_acesso	
FROM permissao p
JOIN usuario u ON u.id_usuario = p.id_usuario;

UPDATE usuario
SET telefone = '777777777'
WHERE id_usuario = 1;