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

Depois da interação com IA para interpretar a priorização, percebi uma quebra voltada para um desenvolvedor Backend e não exatamente o caminho para um produto completo.

Cheguei então em um coeficiente de viável. Produto construído e conceitos de backend à mostra.

| Esforço \ Impacto | ALTO | MÉDIO | BAIXO |
| :--- | :---: | :---: | :---: |
| **BAIXO** | **1, 9** | **3** | **4** |
| **MÉDIO** | **2** | **11** | **12** |
| **ALTO** | **6, 7, 8** | **5, 10** | - |

O resultado da matriz de priorização permitiu traçar fases de implementação isoladas.

- Fase 1: Banco de dados (tecnologia, entidades), dependências (imagens e gems) e CI funcional.

- Fase 2: Importar o CSV e povoar o banco de dados.

- Fase 3: Endpoint de análises de dados que apoiarão as fases posteriores (parei aqui).

- Fase 4: Trazer os dados para determinada interface. A decidir se relatório ou dashboard.

Percepção de resultado: A quebra foi fundamental para conhecer e interagir com as tasks, mas com o tempo proposto, seria melhor ter iniciado as obrigatórias o quanto antes.

### Desafios da Fase 1
Dentre as opções de bancos relacionais, terminei entre MySQL (MariaDB) e Postgres. MySQL pela simplicidade e experiência e Postgres pelos índices e queries complexas. Como o Active Record abstrai bastante as interações com o banco, optei pelo Postgres.

Essas foram algumas barreiras na modelagem do banco:
- A primeira foi em como abrigar a hierarquia de departamentos (n0_empresa, n1_diretoria...). Fugi das recursões e aninhamentos pelas queries recursivas e dificuldades de update e acabei encontrando valor no materialized paths, ainda mais pela popular gem ancestry.

- A segunda foi em como lidar com o tempo_de_empresa, dados os valores subjetivos. Escolhi abstrair para um enum, o que permitiu filtros por tempo de casa.

Sobre os containers, optei por isolá-los. Afinal, banco tende a crescer para cima (robustez), enquanto server para os lados (mais instâncias e load balancer).

### Caminho da Fase 2
A fase que pediu premissas e abordagens interessantes.

O caminho escolhido foi baixar o CSV pelo server e não o receber como parâmetro, até porque nunca sabemos o tamanho do monstro que pode chegar.

Quando recebida a request, o server paraleliza com um worker, devolve uma resposta para o cliente e executa o flow abaixo:
Download da url em chunks para um tempfile -> Leitura linha a linha do arquivo para preservar a memória -> Processamento em batches para minimizar os inserts no banco.

### A última Fase 3
Ansioso para interagir com os dados que demoraram tanto para estarem prontos no banco, acabei não tendo tempo o bastante de gerar valor analítico.

Construí um endpoint que pode receber filtros de tempo de empresa e departamento para trazer o NPS dos funcionários que respeitem essa combinação. Caso sem filtros, calcula baseado na empresa inteira.

E aqui terminou a jornada.

### Aprendizados
- Primeira experiência de povoar tantas entidades relacionadas com CSV.
- Solucionar hierarquia de dados com materialized path.
- Só pensar nas fases finais depois de terminar as iniciais.
- Projeto com Rails 8 e as novidades de worker em banco relacional com Solid Queue.

## Como rodar o projeto
Iniciar os servers de banco e backend:

```
docker compose up --build

docker exec -it <container web> bash

bin/rails db:prepare

bin/jobs
```

Caso tenha problemas para iniciar o Solid Queue:

```
Deletar o arquivo queue_schema.rb

rails db:drop:queue

rails solid_queue:install

rails db:prepare
```

## Endpoints
A action POST localhost:3000/api/v1/csv_imports espera receber a url raw do CSV no body.
```
{
  "csv_url": "https://raw.githubusercontent.com/pin-people/tech_playground/refs/heads/main/data.csv"
}
```

A action GET localhost:3000/api/v1/analytics/nps funciona sem filtros, mas pode receber ID de departamento e Integer de tempo de empresa (department_id e tenure).

## Tasks report
- [X] Task 1: Create a Basic Database
- [X] Task 3: Create a Test Suite
- [X] Task 4: Create a Docker Compose Setup
- [X] Task 9: Build a Simple API
