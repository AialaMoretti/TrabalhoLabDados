-- =====================================================
-- BANCO DE DADOS: SISTEMA DE SEGURANÇA
-- Autor: Bianca Aiala 
-- Descrição: Controle de usuários, acessos e monitoramento
-- SGBD: MySQL
-- =====================================================

-- =============================
-- CRIAÇÃO DO BANCO
-- =============================
CREATE DATABASE sistema_seguranca;

-- =============================
-- TABELA USUARIO
-- =============================
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome_primeiro VARCHAR(50) NOT NULL,
    nome_sobrenome VARCHAR(100) NOT NULL,
    telefone VARCHAR(20),
    tipo VARCHAR(20) NOT NULL
);

-- =============================
-- TABELAS DE ESPECIALIZAÇÃO
-- =============================

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

-- =============================
-- TABELA LOCAL
-- =============================
CREATE TABLE local (
    id_local INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    tipo VARCHAR(50)
);

-- =============================
-- TABELA DISPOSITIVO
-- =============================
CREATE TABLE dispositivo (
    id_dispositivo INT AUTO_INCREMENT PRIMARY KEY,
    id_local INT,
    localizacao VARCHAR(100),
    status VARCHAR(20),
    tipo VARCHAR(50),

    FOREIGN KEY (id_local) REFERENCES local(id_local)
);

-- =============================
-- TABELA PERMISSAO (N:N)
-- =============================
CREATE TABLE permissao (
    id_permissao INT AUTO_INCREMENT PRIMARY KEY,
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

-- =============================
-- TABELA LOG_ACESSO
-- =============================
CREATE TABLE log_acesso (
    id_acesso INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_dispositivo INT,
    data_hora DATETIME,
    status VARCHAR(20),

    FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
    FOREIGN KEY (id_dispositivo) REFERENCES dispositivo(id_dispositivo)
);

-- =============================
-- TABELA EVENTO
-- =============================
CREATE TABLE evento (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    id_acesso INT,
    data_hora DATETIME,
    tipo_evento VARCHAR(50),
    descricao TEXT,

    FOREIGN KEY (id_acesso) REFERENCES log_acesso(id_acesso)
);

-- =============================
-- TABELA MONITORAMENTO
-- =============================
CREATE TABLE monitoramento (
    id_monitoramento INT AUTO_INCREMENT PRIMARY KEY,
    id_dispositivo INT,
    ultima_verificacao DATETIME,
    status_conexao VARCHAR(20),
    alerta_ativo BOOLEAN,

    FOREIGN KEY (id_dispositivo) REFERENCES dispositivo(id_dispositivo)
);

-- =====================================================
-- INSERÇÃO DE DADOS (POPULAÇÃO)
-- =====================================================

-- USUARIOS
INSERT INTO usuario (cpf, nome_primeiro, nome_sobrenome, telefone, tipo) VALUES
('11111111111', 'Ana', 'Silva', '999999999', 'morador'),
('22222222222', 'Carlos', 'Souza', '888888888', 'funcionario'),
('33333333333', 'Pedro', 'Oliveira', '777777777', 'visitante');

-- ESPECIALIZAÇÕES
INSERT INTO morador VALUES (1, 'A101');
INSERT INTO funcionario VALUES (2, 'Porteiro');
INSERT INTO visitante VALUES (3, 'RG123456');

-- LOCAL
INSERT INTO local (nome, tipo) VALUES
('Portaria', 'Entrada'),
('Garagem', 'Interno');

-- DISPOSITIVO
INSERT INTO dispositivo (id_local, localizacao, status, tipo) VALUES
(1, 'Porta principal', 'ativo', 'biometrico'),
(2, 'Entrada garagem', 'ativo', 'cartao');

-- PERMISSAO
INSERT INTO permissao (id_usuario, id_local, id_dispositivo, nivel_acesso, data_inicio, data_fim) VALUES
(1, 1, 1, 'total', NOW(), NULL),
(2, 1, 1, 'admin', NOW(), NULL),
(3, 1, 1, 'restrito', NOW(), NOW());

-- LOG DE ACESSO
INSERT INTO log_acesso (id_usuario, id_dispositivo, data_hora, status) VALUES
(1, 1, NOW(), 'permitido'),
(3, 1, NOW(), 'negado');

-- EVENTOS
INSERT INTO evento (id_acesso, data_hora, tipo_evento, descricao) VALUES
(1, NOW(), 'entrada', 'Acesso autorizado'),
(2, NOW(), 'tentativa', 'Acesso negado');

-- MONITORAMENTO
INSERT INTO monitoramento (id_dispositivo, ultima_verificacao, status_conexao, alerta_ativo) VALUES
(1, NOW(), 'online', FALSE),
(2, NOW(), 'offline', TRUE);

-- =====================================================
-- CONSULTAS (SELECT)
-- =====================================================

-- Listar usuários
SELECT * FROM usuario;

-- Listar acessos com nome do usuário
SELECT u.nome_primeiro, l.data_hora, l.status
FROM log_acesso l
JOIN usuario u ON u.id_usuario = l.id_usuario;

-- Listar permissões
SELECT u.nome_primeiro, p.nivel_acesso, l.nome AS local
FROM permissao p
JOIN usuario u ON u.id_usuario = p.id_usuario
JOIN local l ON l.id_local = p.id_local;

-- =====================================================
-- ATUALIZAÇÕES (UPDATE)
-- =====================================================

-- Atualizar telefone
UPDATE usuario
SET telefone = '999000000'
WHERE id_usuario = 1;

-- Atualizar status de dispositivo
UPDATE dispositivo
SET status = 'manutencao'
WHERE id_dispositivo = 2;