<h1>teste</h1>
<p> 
CREATE TABLE public.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id)
);
COMMENT ON TABLE public.produtos IS 'A tabela produtos é usada para especificar todos os produtos e todos seus detalhes/especificações. Os produtos são diferenciados pela PK produto_id.';


CREATE TABLE public.lojas (
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
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
);
COMMENT ON TABLE public.lojas IS 'a tabela lojas mostra tocas as especificações de todas as lojas, sendo diferenciadas pelo PK loja_id';


CREATE TABLE public.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                CONSTRAINT estoques_id PRIMARY KEY (estoque_id)
);
COMMENT ON TABLE public.estoques IS 'A tabela estoque existe para verificar a quantidade do produto específico, tendo como FK loja_id da tabela lojas e a FK produto_id da tabela produtos. E o estoque é diferenciado pela PK estoque_id.';


CREATE TABLE public.clientes (
                cliente_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                email VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT cliente_id PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE public.clientes IS 'A tabela clientes se refere a todos os clientes que podem ou não fazer pedidos e podem ou não fazer envios, contendo todas as suas especificações. Todos diferenciados pela PK cliente_id';


CREATE TABLE public.pedidos (
                pedidos_id NUMERIC(38) NOT NULL,
                data_hora TIMESTAMP NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                status VARCHAR(15) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_id PRIMARY KEY (pedidos_id)
);
COMMENT ON TABLE public.pedidos IS 'A tabela pedidos é feita para registrar todos os detalhes dos pedidos feitos pelos clientes em conjunto das lojas. São diferenciados pela PK pedidos_id. Além da FK cliente_id da tabela clientes e da FK loja_id da tabela lojas';


CREATE TABLE public.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC(38) NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
);
COMMENT ON TABLE public.envios IS 'A tabela envios se refere a todas as especificações dos envios feitos e que estão em rota de entrega. Diferenciados pela PK envio_id. com a FK cliente_id e com a FK loja_id';


CREATE TABLE public.pedidos_itens (
                pedidos_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                numero_da_linha NUMERIC(38) NOT NULL,
                preco_unitario NUMERIC(10,2) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                envio_id NUMERIC(38) NOT NULL,
                CONSTRAINT pedidos_itens_pk PRIMARY KEY (pedidos_id, produto_id)
);
COMMENT ON TABLE public.pedidos_itens IS 'A tabela pedidos_itens é usada   para ligar os pedidos com os produtos. Tendo todas as especificações dos pedidos dos itens. São diferenciados pela PFK pedidos_id da tabela pedidos e pela PFK produto_id da tabela produtos. Além da FK envio_id da tabela envios';


ALTER TABLE public.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES public.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES public.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES public.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES public.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES public.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES public.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES public.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedidos_id)
REFERENCES public.pedidos (pedidos_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES public.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;</p>
