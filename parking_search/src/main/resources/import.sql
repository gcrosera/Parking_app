-- 12345678
INSERT INTO usuarios (email, senha, phone, nome) VALUES ('fabianojesus1991@gmail.com', '$2a$12$.bPF9WkGJjzfKsxe10UhFeu5wyPj8LYVKVKm7ZRv6jjC.zkkAHg5W', '11991675528','Fabiano');
-- 310331
INSERT INTO usuarios (email, senha, phone, nome) VALUES ('faah772@gmail.com', '$2a$12$K8vGtJq3q4fz7BRRXSOg/u.txCUIv3pXE1LBsJZPWoeFLhXs9mUDS','12993678527','Fabricio');
-- 121212
INSERT INTO usuarios (email, senha, phone, nome) VALUES ('larissa1.almeida@example.com', '$2a$12$svsF9WZ5UKHoRTKb69FbnOpKntgOni41W6F2C.1acvJ9ur3HYJR66','14991675526','Larissa');
--121212
INSERT INTO usuarios (email, senha, phone, nome) VALUES ('carlos.silva@example.com', '$2a$12$svsF9WZ5UKHoRTKb69FbnOpKntgOni41W6F2C.1acvJ9ur3HYJR66','18991675525','Carlos Andrade');
--121212
INSERT INTO usuarios (email, senha, phone, nome) VALUES ('gustavo@example.com', '$2a$12$svsF9WZ5UKHoRTKb69FbnOpKntgOni41W6F2C.1acvJ9ur3HYJR66','22394575534','Gustavo Lobo');

SHOW COLUMNS FROM tbl_proprietario;

ALTER TABLE tbl_proprietario RENAME COLUMN password TO user_password;

-- 12345678
INSERT INTO tbl_proprietario (usuario_id, email, user_password, phone, name) VALUES (1,'fabianojesus1991@gmail.com', '$2a$12$.bPF9WkGJjzfKsxe10UhFeu5wyPj8LYVKVKm7ZRv6jjC.zkkAHg5W', '11991675528','Fabiano');
-- 310331
INSERT INTO tbl_proprietario (usuario_id, email, user_password, phone, name) VALUES (2,'faah772@gmail.com', '$2a$12$K8vGtJq3q4fz7BRRXSOg/u.txCUIv3pXE1LBsJZPWoeFLhXs9mUDS','12993678527','Fabricio');
-- 121212
INSERT INTO tbl_proprietario (usuario_id, email, user_password, phone, name) VALUES (3,'larissa1.almeida@example.com', '$2a$12$svsF9WZ5UKHoRTKb69FbnOpKntgOni41W6F2C.1acvJ9ur3HYJR66','14991675526','Larissa');
--121212
INSERT INTO tbl_proprietario (usuario_id, email, user_password, phone, name) VALUES (4,'carlos.silva@example.com', '$2a$12$svsF9WZ5UKHoRTKb69FbnOpKntgOni41W6F2C.1acvJ9ur3HYJR66','18991675525','Carlos Andrade');

INSERT INTO tbl_proprietario (usuario_id, email, user_password, phone, name) VALUES (5,'gustavo@example.com', '$2a$12$svsF9WZ5UKHoRTKb69FbnOpKntgOni41W6F2C.1acvJ9ur3HYJR66','22394575534','Gustavo Lobo');

ALTER TABLE tbl_proprietario RENAME COLUMN user_password TO password;

-- Inserir 30 vagas na tabela tbl_vaga
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga próxima ao MASP', 20, '01310000', 'Avenida Paulista', '1578', 'Bela Vista', 'São Paulo', 'SP', 1, '/uploads/1725908147653_bicicleta-encostada-no-fundo-de-uma-vaga-de-garagem-de-condominio-foto-nicholas-mazzaccaro-unsplash.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga perto do Parque Ibirapuera', 25, '04029000', 'Avenida Pedro Álvares Cabral', '1000', 'Ibirapuera', 'São Paulo', 'SP', 2, '/uploads/1725929454570_f4eae3f1ef2505b14796bb0301d3a5d5.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga na Rua dos Três Irmãos', 18, '05525000', 'Rua dos Três Irmãos', '78', 'Morumbi', 'São Paulo', 'SP', 3, '/uploads/1725929507517_Estacionamento-AdobeStock_329730304_web-1024x683.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga em frente ao Allianz Parque', 30, '01327000', 'Rua Palestra Itália', '200', 'Perdizes', 'São Paulo', 'SP', 4, '/uploads/1725929533812_estac.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga no Parque Villa-Lobos', 22, '05465000', 'Avenida Professor Fonseca Rodrigues', '200', 'Vila Leopoldina', 'São Paulo', 'SP', 5, '/uploads/1725929584343_garagem-coberta-com-telha-transparente.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga próxima ao Shopping Eldorado', 17, '05425000', 'Avenida Rebouças', '3970', 'Pinheiros', 'São Paulo', 'SP', 1, '/uploads/1725929607943_refletor-para-estacionamento.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga no Morumbi Shopping', 27, '05652000', 'Avenida Roque Petroni Júnior', '1089', 'Morumbi', 'São Paulo', 'SP', 2, '/uploads/1725908147653_bicicleta-encostada-no-fundo-de-uma-vaga-de-garagem-de-condominio-foto-nicholas-mazzaccaro-unsplash.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga na Rua Augusta', 23, '01305000', 'Rua Augusta', '1200', 'Consolação', 'São Paulo', 'SP', 3, '/uploads/1725929454570_f4eae3f1ef2505b14796bb0301d3a5d5.jpg');
INSERT INTO tbl_vaga (descricao, preco, cep, rua, numero, bairro, cidade, estado, proprietario_id, imagem_url) VALUES ('Vaga perto do Centro Cultural São Paulo', 19, '01510000', 'Rua Vergueiro', '1000', 'Liberdade', 'São Paulo', 'SP', 4, '/uploads/1725929507517_Estacionamento-AdobeStock_329730304_web-1024x683.jpg');
