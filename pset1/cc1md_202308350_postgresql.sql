--
-- Apagando esquema / banco de dados / usuários se existerem
--

DROP SCHEMA lojas CASCADE;
DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS pedro;

--
--  Criação do usuário (sua senha e todas as suas permissões)
--

CREATE USER pedro WITH
ENCRYPTED PASSWORD 'vasco'
CREATEDB
CREATEROLE
LOGIN
;

--
--  Criação do banco de dados 'uvv' e a conexão com o BD com o usuário e a senha escolhidas por mim
--

CREATE DATABASE uvv 
OWNER = pedro
template = template0
encoding = UTF8
lc_collate = 'pt_BR.UTF-8'
lc_ctype = 'pt_BR.UTF-8'
ALLOW_CONNECTIONS = true
;

\c "host=localhost dbname=uvv user=pedro password=vasco"

--
--  Criação do schema (esquema) e colocando meu usuário como proprietário
--

CREATE SCHEMA lojas;
ALTER SCHEMA lojas OWNER TO pedro;

--
--  Criação da tabela produtos
--

CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produtos_pk PRIMARY KEY (produto_id)
);
COMMENT ON TABLE lojas.produtos IS 'Tabela produtos, tem por sua funcionalidade especificar todas as características dos produtos. Diferenciando-los pela PK produto_id.';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'PK da tabela produtos. Especifica e diferencia todos os produtos.';
COMMENT ON COLUMN lojas.produtos.nome IS 'nome do produto (obrigatório)';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'preço unitário de cada produto (opcional)';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'detalhes do produto (opcional)';
COMMENT ON COLUMN lojas.produtos.imagem IS 'imagem do produto (opcional)';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS '"imagem_mime_type" do produto (opcional)';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'arquivo da imagem do produto (opcional)';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'charset da imagem do produto (opcional)';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'data das ultimas atualizações de imagem do produto (opcional)';

--
--  Criação da tabela lojas
--

CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT lojas_pk PRIMARY KEY (loja_id),
                CONSTRAINT minimo_um_endereco CHECK (COALESCE(endereco_web, endereco_fisico) IS NOT NULL)
);
COMMENT ON TABLE lojas.lojas IS 'Tabela lojas responsável por registrar todas as lojas e suas especificações. Para diferencia-los tem a PK loja_id.';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'PK da tabela lojas. Especifica e diferencia cada loja';
COMMENT ON COLUMN lojas.lojas.nome IS 'Nome da loja (obrigatório)';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'Endereço web da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'Endereço físico da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.latitude IS 'latitude da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.longitude IS 'longitude da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.logo IS 'logo da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS '"logo mime type" da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'arquivo da logo da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'logo charset da loja (opcional)';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'data das ultimas atualizações de logo da loja (opcional)';

--
--  Criação da tabela estoques
--

CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoques_pk PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE lojas.estoques IS 'Tabela estoques. Responsável por controlar quantidade do produto para a loja. Diferencia os estoques pela PK estoque_id. Além da FK loja_id da tabela lojas e da FK produto_id da tabela produtos';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'PK da tabela estoques. Diferencia todos os estoques.';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'PK da tabela lojas. Especifica e diferencia cada loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'PK da tabela produtos. Especifica e diferencia todos os produtos.';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'quantidade do produto da loja no estoque (obrigatório)';

--
--  Criação da tabela clientes
--

CREATE TABLE lojas.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT clientes_pk PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE lojas.clientes IS 'A tabela clientes se refere aos clientes das lojas, possue todas as suas especificações e é responsável por diferencia-los pela PK cliente_id.';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'PK da tabela clientes. Diferencia todos os clientes.';
COMMENT ON COLUMN lojas.clientes.email IS 'email dos clientes (obrigatório)';
COMMENT ON COLUMN lojas.clientes.nome IS 'nome dos clientes (obrigatório)';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'telefone 1 dos clientes (opcional)';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'telefone 2 dos clientes (opcional)';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'telefone 3 dos clientes (opcional)';

--
--  Criação da tabela pedidos
--

CREATE TABLE lojas.pedidos (
                pedido_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_pk PRIMARY KEY (pedido_id),
                CONSTRAINT status_pedidos CHECK (status IN ('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'))
);
COMMENT ON TABLE lojas.pedidos IS 'Tabela pedidos. responsável por diferenciar cada pedido feito entre cliente e loja. tem como PK pedido_id para diferenciar os pedidos, além da FK cliente_id da tabela clientes e da FK loja_id da tabela lojas.';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'PK da tabela pedidos. Diferencia todos os pedidos.';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'data e hora da realização dos pedidos (obrigatório)';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'PK da tabela clientes. Diferencia todos os clientes.';
COMMENT ON COLUMN lojas.pedidos.status IS 'status do pedido (obrigatório)';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'PK da tabela lojas. Especifica e diferencia cada loja';

--
--  Criação da tabela envios
--

CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envios_pk PRIMARY KEY (envio_id),
                CONSTRAINT status_envios CHECK(status IN ('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'))
);
COMMENT ON TABLE lojas.envios IS 'Tabela envios, informa todos os envios feitos, seu destino, status, etc. Diferencia os envios pela PK envio_id. Além da FK loja_id da tabela lojas e da FK cliente_id da tabela clientes';
COMMENT ON COLUMN lojas.envios.envio_id IS 'PK da tabela envios. Diferencia todos os envios e suas especificações.';
COMMENT ON COLUMN lojas.envios.loja_id IS 'PK da tabela lojas. Especifica e diferencia cada loja';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'PK da tabela clientes. Diferencia todos os clientes.';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'endereço de entrega do pedido (obrigatório)';
COMMENT ON COLUMN lojas.envios.status IS 'status do envio (obrigatório)';

--
--  Criação da tabela pedidos_itens
--

CREATE TABLE lojas.pedidos_itens (
                pedido_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedido_id, produto_id)
);
COMMENT ON TABLE lojas.pedidos_itens IS 'Tabela pedidos_itens. Serve para cumprir o relacionamento de cardinalidade N:N entre a tabela pedidos e produtos. Contém a PFK pedido_id da tabela pedidos e a PFK produto_id da tabela produtos. E especificar os dados dessa relação. Além da FK envio_id da tabela envios.';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'PK da tabela pedidos. Diferencia todos os pedidos.';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'PK da tabela produtos. Especifica e diferencia todos os produtos.';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'numero da linha do item pedido (obrigatório)';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'preço unitário dos itens pedidos (obrigatório)';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'quantidade dos itens pedidos (obrigatório)';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'PK da tabela envios. Diferencia todos os envios e suas especificações.';

--
--  Adição da FK produto_id, da tabela produtos, na tabela estoques
--

ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da FK produto_id, da tabela produtos, na tabela pedidos_itens
--

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da FK loja_id, da tabela lojas, na tabela envios
--

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da FK lojas_id, da tabela lojas, na tabela estoques
--

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da FK loja_id, da tabela lojas, na tabela pedidos
--

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da FK cliente_id, da tabela clientes, na tabela envios
--

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da FK cliente_id, da tabela clientes, na tabela pedidos
--

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da PFK pedido_id, da tabela pedidos, na tabela pedidos_itens
--

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--
--  Adição da PFK envio_id, da tabela envios, na tabela pedidos_itens
--

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
