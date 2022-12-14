/*

 Estudo SQL
 By José Américo Doiche Junior 28/04/2022

*/

#Criando base de dados

	#CREATE DATABASE IF NOT EXISTS TESTE;


#Selecionando uma base de dados

	#USE DATABASE TESTE;

# Mostrar tabelas
	SHOW TABLES;
	
# Criando uma tabela	
 
	CREATE TABLE FRUTAS(
	ID INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT,
	NOME VARCHAR(20),
	DTCADASTRO DATE);
	
	CREATE TABLE PEDIDO(
	ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	DTPEDIDO DATE,
	VALOR NUMERIC(10,2));
	
# Descrevendo uma tabelas
	DESC FRUTAS;

# Inserindo dados em uma tabela

	INSERT INTO FRUTAS (NOME,DTCADASTRO) VALUES 
	('MAÇA','2022-04-28'),
	('BANANA','2022-03-28');
	
	INSERT INTO PEDIDO(DTPEDIDO,VALOR) VALUES 
	('2022-04-01',10.000),
	('2022-04-01',10000.000),
	('2000-01-01',15.000);
	
		
	
#*******************
	SELECT *FROM FRUTAS;
	
# FIM DOS REGISTROS	
	
# Exemplo de select(s)
	#Select entre periodos
	
		SELECT *FROM FRUTAS WHERE DTCADASTRO BETWEEN '2022-03-01' AND '2022-04-28';	
	
	#Select por nome
	
		SELECT *FROM FRUTAS WHERE NOME ='maça';
	
	#Select por nome utilizando o operador like
	
		SELECT *FROM FRUTAS WHERE NOME LIKE '%a%';
		
	#Utilizando o comando join 	
	# INNER: Semelhante ao uso do operador “=” os registros sem correspondências não são incluídos.
	
	
#******************	
	
	#Exercícios para fixação
	
	CREATE TABLE PRODUTO(
	CODIGO INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	DESCRICAO VARCHAR(100),
	QTDESTOQUE INTEGER,
	UNIDADE CHAR(2),
	VALORCOMPRA NUMERIC(10,2),
	VALORVENDA NUMERIC(10,2),
	DTCADASTRO DATETIME);
	
	INSERT INTO PRODUTO(DESCRICAO,QTDESTOQUE,UNIDADE,VALORCOMPRA,VALORVENDA,DTCADASTRO) VALUES 
	('SALSICHA',20,'kg',10.00,15.00,current_date),
	('MAIONESE HELLMANS',20,'pt',10.00,15.00,current_date),
	('CATCHUP HIZZ',20,'pt',7.00,15.00,current_date);
	
	CREATE TABLE CLIENTE(
	CODIGO INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	NOME VARCHAR(100),
	CPF VARCHAR(20),
	RG VARCHAR(20),
	ENDERECO VARCHAR(50),
	CIDADE VARCHAR(20),
	CEP VARCHAR(20),
	TELEFONE VARCHAR(20),
	CELULAR VARCHAR(20),
	EMAIL VARCHAR(20)
	DTCADASTRO DATETIME);
	
	INSERT INTO CLIENTE (NOME,CPF,RG,ENDERECO,CIDADE,TELEFONE,CELULAR,EMAIL,DTCADASTRO) VALUES
	('JOSE DA SILVA','328.104.222-89','40.107666-8','RUA XV DE NOVEMBRO', 500,'ASSIS','(18)99766-8008','teste@gmail','2022-04-28'),
	('JOAO PEDRO ','328.104.222-89','40.107666-8','RUA XV DE NOVEMBRO', 500,'ASSIS','(18)99766-8008','teste@gmail','2022-04-28');

	
	CREATE TABLE VENDA(
	ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	DTVENDA DATETIME,
	VALORTOTAL NUMERIC(10,2));
	
	INSERT INTO VENDA (DTVENDA,VALORTOTAL) VALUES
	('2022-04-28', 2000.00),
	('2022-04-30', 3000.00);
	
	CREATE TABLE PRODUTO_VENDA (
	ID INTEGER NOT NULL AUTO_INCREMENT PRIMARY KEY,
	VENDA INTEGER NOT NULL,
	PRODUTO INTEGER NOT NULL,
	CLIENTE INTEGER NOT NULL,
	CONSTRAINT FOREIGN KEY PRODUTO_VENDA_PRODUTO (PRODUTO) REFERENCES PRODUTO(CODIGO),
	CONSTRAINT FOREIGN KEY PRODUTO_VENDA_VENDA (VENDA) REFERENCES VENDA(ID), 
	CONSTRAINT FOREIGN KEY PRODUTO_VENDA_CLI (CLIENTE) REFERENCES CLIENTE(CODIGO));
	
	INSERT INTO PRODUTO_VENDA(VENDA,PRODUTO,CLIENTE) VALUES 
	(1,1,1),
	(1,2,1);
	
	SELECT PRODUTO.DESCRICAO FROM PRODUTO_VENDA,VENDA,PRODUTO,CLIENTE WHERE PRODUTO_VENDA.VENDA = VENDA.ID AND PRODUTO_VENDA.PRODUTO= PRODUTO.CODIGO AND PRODUTO_VENDA.CLIENTE = CLIENTE.CODIGO AND CLIENTE.CODIGO =1;
	
	#VIEW trabalhando com views 
	
	/*
		CREATE [OR REPLACE] [ALGORITHM = algorithm_type] VIEW  VIEW view_name [(column_list)]
		AS select_statement
		[WITH [CASCADED | LOCAL] CHECK OPTION]
		
		
		
	
	*/
	
	# listando uma lista de uma tabela com view_name
	
	
	# ---CRIANDO A VIEW
	CREATE VIEW vw_Produto as 	
	select codigo, descricao
	from PRODUTO;
	
	# ---CHAMANDO A VIEW
	
	
	SELECT * FROM vw_Produto limit 3;
	
	#---CRIANDO OUTRA VIEW
	
	CREATE OR REPLACE VIEW vw_Produto1 AS
	SELECT DESCRICAO
	FROM PRODUTO;
	
	
	SELECT *FROM vw_Produto1;
	
	# 
	
	
	CREATE OR REPLACE VIEW vw_ProdutoVenda as 
	SELECT PRODUTO_VENDA.ID,PRODUTO_VENDA, CLIENTE.NOME,PRODUTO_VENDA.PRODUTO.DESCRICAO, FROM PRODUTO,VENDA,PRODUTO_VENDA 
	WHERE PRODUTO_VENDA = VENDA.CODIGO AND PRODUTO_VENDA.PRODUTO = PRODUTO.CODIGO AND PRODUTO_VENDA.CLIENTE = CLIENTE.CODIGO; 
	
	#EXERCICIO 
	
	#CRIAR UMA VIEW QUE DEVOLVE OS PRODUTOS VENDIDOS PARA O CLIENTE DE CODIGO 1 e em seguida EXECUTAR A VIEW;
	
	CREATE OR REPLACE VIEW vw_Prod_Cli_cod as 
	SELECT PRODUTO.NOME FROM PRODUTO_VENDA,VENDA,PRODUTO,CLIENTE WHERE 
	PRODUTO.CODIGO = PRODUTO_VENDA.CODIGO AND VENDA.CODIGO = PRODUTO_VENDA.VENDA AND 
	PRODUTO_VENDA.CLIENTE = CLIENTE.CODIGO AND CLIENTE.CODIGO = 1;
	
	#EXECUTANDO A VIEW 
	SELECT *FROM vw_Prod_Cli_cod;
	
	
	
	
	#TRIGGER
	
		
		/*CREATE TRIGGER nome momento evento
			ON tabela
			FOR EACH ROW
			FOR EACH ROW
			BEGIN
	/*corpo do código*/
	
	
	DELIMITER $

			CREATE TRIGGER Tgr_ItensVenda_Insert AFTER INSERT
			ON ItensVenda
			FOR EACH ROW
			BEGIN
				UPDATE Produtos SET Estoque = Estoque - NEW.Quantidade
			WHERE Referencia = NEW.Produto;
			END$

			CREATE TRIGGER Tgr_ItensVenda_Delete AFTER DELETE
			ON ItensVenda
			FOR EACH ROW
			BEGIN
				UPDATE Produtos SET Estoque = Estoque + OLD.Quantidade
			WHERE Referencia = OLD.Produto;
			END$

			DELIMITER ;
	
	
END/*
	
	#STORE PROCEDURE
			