# Diagrama do banco — ROTA26

Item 86 e item 87. Diagrama da solução **como ela é**, não de tecnologia
planejada. Renderizável em qualquer visualizador com suporte a Mermaid
(GitHub, VS Code, Obsidian).

---

## 1. Arquitetura da solução

```mermaid
flowchart TB
    subgraph nav["Navegador"]
      P["Participante<br/>48 situações"]
      A["Administrador de setor<br/>dashboards do próprio setor"]
      M["Administrador Master<br/>tudo + gestão de dados"]
    end

    subgraph app["Next.js 14 · App Router · hospedagem serverless"]
      SC["Server Components<br/>páginas e leitura"]
      CC["Client Components<br/>questionário, gestão"]
      API1["/api/exportar<br/>gera .xlsx no servidor"]
      API2["/api/preparar<br/>sondas de prontidão"]
      LIB["Núcleo determinístico<br/>scoring · aggregate · animais · narrative · excel"]
    end

    subgraph sup["Supabase"]
      AUTH["Auth<br/>e-mail e senha"]
      DB[("PostgreSQL<br/>RLS ativo")]
    end

    P --> CC
    A --> SC
    M --> SC
    M --> CC
    CC -->|"chave anônima<br/>sujeita ao RLS"| DB
    SC -->|"chave anônima<br/>sujeita ao RLS"| DB
    API1 -->|"sessão do usuário"| DB
    API2 -->|"service role<br/>somente para o registro is_test"| DB
    CC --> AUTH
    SC --> LIB
    API1 --> LIB
    API2 --> LIB
```

**O que não existe** e não deve ser procurado: não há backend próprio, fila,
cache distribuído, worker, microsserviço nem serviço de IA em tempo de execução.
O cálculo é uma biblioteca TypeScript pura, executada no processo do Next.js.

---

## 2. Modelo entidade-relacionamento

```mermaid
erDiagram
    SETORES ||--o{ PARTICIPANTES : "lota"
    SETORES ||--o{ ADMINISTRADORES : "delimita"
    VERSOES_INSTRUMENTO ||--o{ QUESTOES : "contém"
    QUESTOES ||--|{ ALTERNATIVAS : "tem 4"
    PARTICIPANTES ||--o{ AVALIACOES : "responde"
    AVALIACOES ||--|{ RESPOSTAS : "grava 48"
    AVALIACOES ||--o| ESCORES : "produz"
    AVALIACOES ||--o| RESULTADOS : "produz"
    AVALIACOES ||--o| RESULTADOS_FUNCIONAIS : "produz"
    AVALIACOES ||--o| RESULTADOS_BELBIN : "produz"
    PERFIS ||--o{ MATRIZ_FUNCIONAL : "pontua"
    PERFIS ||--o{ AFINIDADE_BELBIN : "pontua"
    RESULTADOS }o--|| PERFIS : "principal e secundário"

    SETORES {
        uuid id PK
        text codigo UK
        text nome
        boolean ativo
    }
    VERSOES_INSTRUMENTO {
        uuid id PK
        text codigo UK
        int peso_atitude
        int peso_funcao
        boolean ativa
    }
    QUESTOES {
        uuid id PK
        uuid versao_id FK
        text codigo
        enum tipo
        int peso
        boolean ativa
    }
    ALTERNATIVAS {
        uuid id PK
        uuid questao_id FK
        text codigo
        enum jung "chave de pontuação"
        enum eixo "chave de pontuação"
    }
    PARTICIPANTES {
        uuid id PK
        uuid user_id FK
        text nome "dado pessoal"
        text matricula UK
        uuid setor_id FK
        boolean is_demo
        boolean is_test
    }
    ADMINISTRADORES {
        uuid user_id PK
        enum papel "MASTER ou ADMIN_SETOR"
        uuid setor_id FK
    }
    AVALIACOES {
        uuid id PK
        uuid participante_id FK
        text versao_codigo "congelado"
        enum status
        boolean is_demo
        boolean is_test
        timestamptz arquivada_em
    }
    RESPOSTAS {
        uuid id PK
        uuid avaliacao_id FK
        text questao_codigo
        text alternativa_codigo
        enum jung "chave congelada"
        enum eixo "chave congelada"
        int peso
        int posicao_exibida
    }
    ESCORES {
        uuid avaliacao_id PK
        jsonb bruto
        jsonb relativo
    }
    RESULTADOS {
        uuid avaliacao_id PK
        text perfil_principal FK
        text perfil_secundario FK
        boolean empate_funcoes
    }
    RESULTADOS_FUNCIONAIS {
        uuid avaliacao_id PK
        jsonb eixos
        jsonb capacidades
        text versao_matriz
    }
    RESULTADOS_BELBIN {
        uuid avaliacao_id PK
        jsonb relativo
        text top1
        text top2
        text top3
    }
    PERFIS {
        text codigo PK
        text animal
        text cor
        jsonb conteudo
    }
    LOGS_AUDITORIA {
        bigint id PK
        uuid user_id
        text usuario_email
        text acao
        int registros_afetados
    }
```

---

## 3. Fluxo do dado, do clique ao indicador

```mermaid
sequenceDiagram
    participant U as Participante
    participant App as Next.js
    participant DB as PostgreSQL

    U->>App: escolhe a alternativa da situação 1
    App->>DB: INSERT em respostas (com a chave congelada)
    Note over DB: uma gravação por escolha,<br/>até a situação 48
    U-->>App: fecha o navegador
    U->>App: volta com a mesma matrícula
    App->>DB: avaliacao_em_andamento()
    DB-->>App: avaliação + respostas já salvas
    App-->>U: "Encontramos uma avaliação em andamento"
    U->>App: continua e finaliza
    App->>DB: SELECT respostas (relê do banco)
    App->>App: avaliar() — duas trilhas, determinístico
    App->>DB: grava escores, resultados, funcionais, Belbin
    App->>DB: UPDATE status = CONCLUIDA
    Note over DB: o gatilho recusa se<br/>houver menos de 48 respostas
    App->>DB: registrar_evento('CONCLUSAO')
    App-->>U: resultado individual, oito blocos
```

---

## 4. Onde o sigilo é aplicado

```mermaid
flowchart LR
    subgraph regras["Row Level Security — no banco, não na interface"]
      direction TB
      R1["PARTICIPANTE<br/>vê a si mesmo<br/>e as próprias 48 respostas"]
      R2["ADMIN_SETOR<br/>vê o próprio setor<br/>ZERO respostas brutas"]
      R3["MASTER<br/>vê tudo<br/>+ auditoria + gestão"]
    end
    V["vw_resultados<br/>is_demo = false<br/>is_test = false<br/>security_invoker"] --> R1 & R2 & R3
```

Verificado com três identidades reais em PostgreSQL: participante vê 1 pessoa e
48 respostas próprias; administrador de setor vê seu setor e **0** respostas
brutas, e é recusado ao tentar limpar dados; Master vê tudo.
