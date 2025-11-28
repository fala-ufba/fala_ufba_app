## IDEIAS PRINCIPAIS

1) Usuários poderão criar reportes/chamados para resolver problemas de infraestrutura
    - Tela de criar reporte (multistep form)
    - Estrutura do reporte
        - Titulo
        - Descrição
        - Local (Dropdown com todas as localizações possíveis - Para a demo seriam apenas 10 lugares)
        - Descrição do Local
        - Anexos/Evidências (Fotos)
        - Criado em
        - Atualizado em

2) Usuários poderão dar upvote nos reportes de outros usuários ao visualizarem no feed
    - Feed na Home com os reportes feitos por outros usuários
        - Possibilidade de filtrar por localização (PAF2, PAF1, Biblioteca, etc)
    - Thumb up (Também Vi!)
    - Adicionar um contador na tabela de reports
    - Se necessário armazenar qual pessoa deu upvote em qual report, criar uma tabela auxiliar upvote_report

3) Usuários poderão atualizar e/ou fechar seus reportes | Acompanhar seus reportes
    - Adicionar política para isso
    - Tela de editar report
    - Tela de "Meus reportes"

4) Usuários poderão habilitar notificações para movimentação de status dos reportes
    - Checar a possibilidade de usar notificações

5) Usuários terão informações adicionais
    - Nome
    - Email
    - Senha 
    ---- até aqui é informado no cadastro, usar trigger do supabase para popular a tabela users/profiles
    - Curso (se for discente)
    - Departamento/Setor (se for docente/servidor)
    - 


## TELAS

TELA 1 - LOGIN ✅
TELA 2 - CADASTRAR-SE ✅
TELA 3 - PERFIL
    - Opção de editar informações gerais do usuário
    - Alterar preferências de notificação
    - Trocar a senha (não seria recuperar, trocar mesmo)
TELA 4 - HOME(FEED)
    - Feed com todos os reportes dos usuários (usaremos infinite scroll)
    - Cards de reportes (opção de dar upvote, local, titulo e breve descrição, primeiro anexo, quando foi atualizado pela ultima vez)

TELA 5 - REPORTAR
    - Formulário com múltiplos passos
        1) Titulo +  Descrição
        2) Local (teremos um dropdown com as localidades possíveis), Descrição do Local (Andar, sala, corredor, etc)
        3) Anexos (fotos -> usuário pode abrir a câmera no momento ou selecionar uma foto da galeria)

TELA 6



## ENTIDADES

```sql
    CREATE TYPE profile_role as ENUM ('Visitante', 'Discente', 'Docente', 'Servidor');

    CREATE TABLE profiles IF NOT EXISTS (
        id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
        full_name VARCHAR(255) NOT NULL,
        email VARCHAR(255) NOT NULL,
        phone_number VARCHAR(20),
        role profile_role DEFAULT 'Visitante',
        course VARCHAR(255),
        department VARCHAR(255),
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW()
    );

    CREATE TYPE campus as ENUM ('Ondina/Federação', 'Canela', 'Piedade');

    CREATE TABLE buildings IF NOT EXISTS (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        campus
        created_at TIMESTAMP DEFAULT NOW()
    );

    CREATE TYPE report_status AS ENUM ('UNKNOWN', 'OPEN', 'IN_PROGRESS', 'SOLVED', 'CLOSED');

    CREATE TABLE reports IF NOT EXISTS (
        id SERIAL PRIMARY KEY,
        public_id VARCHAR(32) UNIQUE,
        reporter_id UUID NOT NULL,
        title VARCHAR(60) NOT NULL,
        description TEXT,
        attachments TEXT[],
        status report_status NOT NULL DEFAULT 'OPEN',
        created_at TIMESTAMP NOT NULL DEFAULT NOW(),
        updated_at TIMESTAMP NOT NULL DEFAULT NOW()
    );
```