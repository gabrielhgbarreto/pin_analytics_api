# [Pin Analytics]

Importador de base de dados via CSV com insights de clima organizacional a partir de funcionários.

---

## A Jornada

### Avaliação de Requisitos
Para esse tópico, foram utilizadas as classificações Esforço, Impacto e Prioridade.

Os requisitos foram passados a limpo em uma planilha de priorização para ser executada uma implementação guiada.

| Requisito | Impacto de negócio (1-5) | Esforço (1-5) | Classificação | Negociável? |
| :--- | :---: | :---: | :--- | :---: |
| **Task 1 - Banco de dados** | 5 | 2 | **Essencial** | N |
| **Task 2: Dashboard básico** | 5 | 4 | **Essencial** | S |
| **Task 6, 7 e 8: Dashboards por área** | 5 | 5 | **Essencial** | S |
| **Task 9: API** | 5 | 2 | **Essencial** | N |
| Task 10: Análise de sentimento | 3 | 5 | Desejável | S |
| Task 3: Test Suite | 2 | 2 | Desejável | N |
| Task 5: Exploratory Data Analysis | 2 | 3 | Desejável | S |
| Task 11: Relatório | 2 | 4 | Desejável | S |
| Task 4: Docker Compose Setup | 1 | 1 | Opcional | S |
| Task 12: Hipóteses sobre o relatório | 1 | 2 | Opcional | S |

Depois de interação com IA para interpretar a priorização, percebi uma quebra voltada para um desenvolvedor Backend e não exatamente o caminho para um produto completo.

Cheguei então em um coeficiente de viável. Produto construído e conceitos de backend a mostra.

| Esforço \ Impacto | ALTO | MÉDIO | BAIXO |
| :--- | :---: | :---: | :---: |
| **BAIXO** | **1, 9** | **3** | **4** |
| **MÉDIO** | **2** | **11** | **12** |
| **ALTO** | **6, 7, 8** | **5, 10** | - |

O resultado da matriz de priorização permitiu traçar fases de implementação isoladas.

- Fase 1: Banco de dados (tecnologia, entidades), dependências (imagens e gems) e CI funcional.

- Fase 2: Importar o CSV e povoar o Banco de dados.

- Fase 3: Endpoint de análises de dados que apoiarão as fases posteriores (parei aqui).

- Fase 4: Trazer os dados para determinada interface. A decidir se relatório ou dashboard.

Opinião pessoal: A quebra foi fundamental para conhecer e interagir com as tasks, mas com o tempo proposto, era melhor ter iniciado as obrigatórias o quanto antes.

### Fase 1
Explique por que escolheu a arquitetura atual (ex: MVC, Clean Architecture, Hexagonal).
* **Decisão 1:** Escolha de tal tecnologia por motivo X.
* **Decisão 2:** Estrutura de pastas para facilitar Y.

### 🚧 Desafios e Soluções
* **Desafio:** Descreva um problema técnico difícil encontrado (ex: performance na importação, modelagem complexa).
* **Solução:** Como você resolveu? (ex: uso de filas, cache, padrão de projeto específico).

### 📚 Aprendizados
O que você aprendeu ou melhorou durante a execução deste projeto?

---

## 🚀 Como executar o projeto

Instruções para rodar a aplicação em ambiente local.

### 📋 Pré-requisitos
Liste o que precisa estar instalado na máquina antes de começar.
* Linguagem/Runtime (ex: Ruby 3.x, Node 18)
* Banco de Dados (ex: PostgreSQL, MySQL)
*
