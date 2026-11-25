window.ATLAS = {
  "modules": [
    {
      "id": "ml",
      "title": "Machine Learning",
      "subtitle": "Dados, objetivos e generalização",
      "icon": "chart.xyaxis.line"
    },
    {
      "id": "neural",
      "title": "Redes neurais",
      "subtitle": "Pesos, ativações e treinamento",
      "icon": "circle.hexagongrid"
    },
    {
      "id": "deep",
      "title": "Deep Learning",
      "subtitle": "Camadas e representações",
      "icon": "square.3.layers.3d"
    },
    {
      "id": "llm",
      "title": "IA generativa",
      "subtitle": "Transformers, LLMs e RAG",
      "icon": "sparkles"
    },
    {
      "id": "agents",
      "title": "Agentes e skills",
      "subtitle": "Ferramentas, autonomia e equipes",
      "icon": "point.3.connected.trianglepath.dotted"
    }
  ],
  "lessons": [
    {
      "id": "mapa",
      "module": "ml",
      "title": "O mapa da inteligência artificial",
      "summary": "Entenda onde aprendizado de máquina, deep learning e IA generativa se encontram.",
      "minutes": 4,
      "sections": [
        {
          "title": "Da tarefa ao sistema",
          "text": "Inteligência artificial (IA) reúne técnicas para executar tarefas como planejar, reconhecer padrões e produzir linguagem. Um planejador pode buscar caminhos em um mapa usando regras e custos definidos por pessoas. Um modelo treinado pode prever a duração do trajeto a partir de viagens anteriores."
        },
        {
          "title": "Aprender com exemplos",
          "text": "Machine learning (ML) é a família de métodos que ajusta modelos a partir de dados. Deep learning é um subconjunto de ML que usa redes neurais com várias camadas. Muitos sistemas generativos atuais usam deep learning para produzir texto, áudio ou imagens."
        },
        {
          "title": "Modelo e produto",
          "text": "O modelo faz uma previsão ou gera uma saída. O produto liga o modelo a uma interface, dados, políticas e mecanismos de avaliação. A utilidade final depende do sistema inteiro e de como ele será usado."
        }
      ],
      "example": "Num app de rotas, a previsão de trânsito pode vir de um modelo treinado. A escolha do trajeto pode combinar essa previsão com regras para ruas bloqueadas e um algoritmo de busca.",
      "explain": "Peça dois exemplos para a turma: uma regra que alguém escreveria e um padrão difícil de descrever que poderia ser aprendido com dados.",
      "quiz": {
        "prompt": "Qual tarefa é um caso típico de ML?",
        "options": [
          "Consultar um preço fixo numa tabela",
          "Prever trânsito com viagens passadas",
          "Ordenar números por valor"
        ],
        "answer": 1,
        "feedback": "A previsão ajusta um modelo a exemplos históricos para lidar com situações futuras."
      },
      "lab": null
    },
    {
      "id": "paradigmas",
      "module": "ml",
      "title": "Três formas de aprender",
      "summary": "Compare aprendizado supervisionado, não supervisionado e por reforço.",
      "minutes": 6,
      "sections": [
        {
          "title": "Supervisionado",
          "text": "Cada exemplo de treinamento tem entradas e um alvo conhecido. Na regressão, o alvo é um valor numérico, como consumo de energia. Na classificação, é uma categoria, como spam ou mensagem legítima."
        },
        {
          "title": "Não supervisionado",
          "text": "O modelo explora estrutura sem rótulos de classe fornecidos. Clustering agrupa exemplos segundo uma noção de similaridade. Os grupos dependem das variáveis e da métrica de distância escolhidas."
        },
        {
          "title": "Por reforço",
          "text": "Um agente interage com um ambiente e recebe recompensas. Ele aprende uma política de ações para maximizar a recompensa acumulada esperada. Uma ação com benefício imediato pode diminuir a recompensa futura."
        }
      ],
      "example": "Com filmes já marcados por gênero, treine um classificador. Com apenas históricos de visualização, procure grupos de comportamento. Num jogo simulado, recompense decisões que aumentem a pontuação final.",
      "explain": "Use o mesmo cenário, uma biblioteca. Classificar livros rotulados, agrupar hábitos de leitura e aprender políticas de recomendação com recompensas ilustram três sinais de aprendizado diferentes.",
      "quiz": {
        "prompt": "Qual sinal caracteriza aprendizado por reforço?",
        "options": [
          "Recompensas pela interação",
          "Rótulos fixos para todas as entradas",
          "Distância entre grupos como único sinal"
        ],
        "answer": 0,
        "feedback": "A política melhora a partir de recompensas observadas ao interagir com o ambiente."
      },
      "lab": null
    },
    {
      "id": "treino",
      "module": "ml",
      "title": "Treino, validação e teste",
      "summary": "Ajuste uma previsão e aprenda a medir se ela funciona com dados novos.",
      "minutes": 7,
      "sections": [
        {
          "title": "Treinar um modelo",
          "text": "Uma função de perda mede a diferença entre a saída e o alvo. Na regressão, o erro quadrático médio é a média dos quadrados dos resíduos. A descida do gradiente usa derivadas para ajustar parâmetros na direção que reduz a perda localmente."
        },
        {
          "title": "Escolher e medir",
          "text": "O conjunto de treino ajusta parâmetros. A validação ajuda a escolher configurações como a regularização. O teste reservado estima desempenho final. Em séries temporais, separe períodos em ordem cronológica para evitar treinamento com informação do futuro."
        },
        {
          "title": "Generalização e métricas",
          "text": "Sobreajuste ocorre quando o modelo se adapta a particularidades do treino e perde qualidade em exemplos novos. Em classificação com classe rara, examine precisão, a fração dos positivos previstos que são corretos, e revocação, a fração dos positivos reais que foram encontrados."
        }
      ],
      "example": "Se 99 de 100 mensagens são legítimas, responder sempre “legítima” dá 99% de acurácia e detecta zero spams. A revocação da classe spam revela a falha.",
      "explain": "Mostre uma reta no laboratório. Peça um palpite para a melhor inclinação, ajuste a reta e pergunte como verificar o desempenho em pontos que ninguém viu.",
      "quiz": {
        "prompt": "Qual conjunto deve ficar reservado para a avaliação final?",
        "options": [
          "Treino",
          "Validação",
          "Teste"
        ],
        "answer": 2,
        "feedback": "O teste mantém uma estimativa independente das decisões tomadas durante treino e validação."
      },
      "lab": "regression"
    },
    {
      "id": "neuronio",
      "module": "neural",
      "title": "O neurônio artificial",
      "summary": "Veja como entradas, pesos, viés e ativação formam a unidade básica de uma rede.",
      "minutes": 6,
      "sections": [
        {
          "title": "Soma ponderada",
          "text": "Cada entrada xᵢ recebe um peso wᵢ. O neurônio calcula z = Σ(wᵢxᵢ) + b. Os pesos controlam a contribuição de cada entrada. O viés b desloca o resultado mesmo quando todas as entradas valem zero."
        },
        {
          "title": "Função de ativação",
          "text": "Uma ativação transforma z. ReLU produz max(0, z). A sigmoide leva z a um valor entre zero e um e pode representar uma pontuação de classificação binária. Interpretar essa pontuação como probabilidade confiável requer avaliação de calibração."
        },
        {
          "title": "Compor camadas",
          "text": "Uma camada calcula várias saídas em paralelo. As saídas podem alimentar novas camadas. Empilhar operações que são apenas afins produziria outra operação afim. As ativações não lineares permitem modelar relações mais complexas."
        }
      ],
      "example": "Com entradas 0,8 e 0,4, pesos 1,2 e −0,5 e viés −0,3, a soma é 0,46. A sigmoide produz aproximadamente 0,61.",
      "explain": "Peça que a turma preveja a direção da mudança quando um peso passa de positivo para negativo. Confirme no laboratório.",
      "quiz": {
        "prompt": "Qual componente desloca z com todas as entradas iguais a zero?",
        "options": [
          "A entrada de maior índice",
          "O viés",
          "A perda do modelo"
        ],
        "answer": 1,
        "feedback": "Quando as entradas valem zero, todos os produtos wᵢxᵢ desaparecem e z é igual ao viés."
      },
      "lab": "neuron"
    },
    {
      "id": "backprop",
      "module": "neural",
      "title": "Como uma rede aprende",
      "summary": "Acompanhe o caminho da previsão até a atualização dos pesos.",
      "minutes": 7,
      "sections": [
        {
          "title": "Passagem para frente",
          "text": "A rede aplica as camadas à entrada e calcula uma previsão. A função de perda compara a previsão ao alvo. A perda deve estar alinhada com o comportamento que desejamos incentivar."
        },
        {
          "title": "Retropropagação",
          "text": "A regra da cadeia calcula como pequenas mudanças em cada parâmetro influenciam a perda. A retropropagação reutiliza resultados intermediários e percorre as operações em ordem inversa, a partir da saída."
        },
        {
          "title": "Otimizador e lotes",
          "text": "O otimizador usa os gradientes para atualizar os parâmetros. Na descida do gradiente mais simples, o passo é o gradiente negativo multiplicado pela taxa de aprendizado. Em mini-batches, cada atualização usa um subconjunto dos exemplos. Uma época corresponde a uma passagem pelo conjunto de treino."
        }
      ],
      "example": "Se um peso tem gradiente +0,6 e a taxa é 0,1, o passo é −0,06. Um peso de 0,50 vira 0,44 na descida do gradiente simples.",
      "explain": "Desenhe três caixas: previsão, perda, atualização. Mostre as setas que seguem a entrada e o caminho inverso usado para calcular os gradientes.",
      "quiz": {
        "prompt": "Qual tarefa a retropropagação realiza?",
        "options": [
          "Embaralha os exemplos",
          "Define o formato da saída",
          "Calcula gradientes da perda"
        ],
        "answer": 2,
        "feedback": "O cálculo fornece ao otimizador as derivadas necessárias para atualizar os parâmetros."
      },
      "lab": null
    },
    {
      "id": "profundidade",
      "module": "deep",
      "title": "Profundidade e representações",
      "summary": "Entenda o que muda quando uma rede usa muitas camadas.",
      "minutes": 6,
      "sections": [
        {
          "title": "Representações aprendidas",
          "text": "Cada camada transforma a representação anterior. Em visão, algumas redes aprendem primeiro padrões locais como bordas e depois combinam sinais em padrões maiores. A divisão entre camadas varia com dados, arquitetura e objetivo."
        },
        {
          "title": "Custo e regularização",
          "text": "A profundidade dá ao modelo recursos para compor transformações. Também aumenta o custo de treino e pode dificultar a otimização. Regularização, aumento de dados e monitoramento de validação ajudam a controlar sobreajuste."
        },
        {
          "title": "Transferência de aprendizado",
          "text": "Um modelo pré-treinado já aprendeu padrões reutilizáveis. Você pode extrair representações com pesos congelados ou ajustar parte dos pesos usando dados da nova tarefa. A transferência funciona melhor quando a origem e a tarefa compartilham padrões relevantes."
        }
      ],
      "example": "Uma equipe com poucas fotos rotuladas de plantas pode reaproveitar uma rede de visão pré-treinada e treinar uma cabeça de classificação específica para espécies locais.",
      "explain": "Desenhe quatro camadas de uma tarefa de visão e peça sugestões de padrões que cada camada poderia representar. Trate as sugestões como hipóteses.",
      "quiz": {
        "prompt": "O que significa congelar uma camada?",
        "options": [
          "Impedir a atualização dos seus pesos",
          "Impedir que produza saídas",
          "Apagar os pesos aprendidos"
        ],
        "answer": 0,
        "feedback": "Uma camada congelada continua na passagem para frente com os parâmetros fixos."
      },
      "lab": null
    },
    {
      "id": "arquiteturas",
      "module": "deep",
      "title": "CNNs, recorrência e Transformers",
      "summary": "Escolha uma arquitetura entendendo o tipo de relações que ela favorece.",
      "minutes": 7,
      "sections": [
        {
          "title": "Convolução e localidade",
          "text": "Uma rede convolucional (CNN) aplica os mesmos filtros em diferentes posições. Essa reutilização permite detectar um padrão local em vários pontos da entrada e reduz o número de pesos em comparação com conexões distintas entre todos os pixels."
        },
        {
          "title": "Recorrência e sequência",
          "text": "Uma rede recorrente (RNN) processa uma sequência mantendo um estado que passa de um passo ao próximo. LSTMs e GRUs usam mecanismos de controle para atualizar esse estado. O processamento entre passos tem dependências sequenciais."
        },
        {
          "title": "Atenção e contexto",
          "text": "Transformers usam atenção para conectar posições de uma sequência e usam informações de posição para representar ordem. Na atenção densa padrão, o número de pares comparados cresce quadraticamente com o tamanho da sequência."
        }
      ],
      "example": "Textura em uma foto favorece filtros locais. Uma série de medições pode ser processada como sequência. Uma referência entre palavras distantes é um caso em que uma conexão direta via atenção pode ser útil.",
      "explain": "Mostre as três arquiteturas com o mesmo objetivo de reconhecer um padrão. Pergunte quais partes da entrada cada uma combina em primeiro lugar.",
      "quiz": {
        "prompt": "Qual mecanismo reaproveita um filtro em posições diferentes de uma imagem?",
        "options": [
          "Recorrência",
          "Convolução",
          "Tokenização"
        ],
        "answer": 1,
        "feedback": "A convolução desliza filtros com pesos compartilhados pela entrada."
      },
      "lab": null
    },
    {
      "id": "atencao",
      "module": "llm",
      "title": "Atenção e o Transformer",
      "summary": "Entenda por que a representação de uma palavra depende das palavras ao redor.",
      "minutes": 7,
      "sections": [
        {
          "title": "Consulta, chaves e valores",
          "text": "Para cada posição, a atenção calcula uma consulta Q. Ela compara Q às chaves K de posições permitidas. A pontuação típica é o produto escalar dividido pela raiz quadrada da dimensão da chave. O softmax transforma pontuações em pesos com soma igual a um."
        },
        {
          "title": "Contextualizar",
          "text": "A saída é a soma dos vetores de valor V ponderados pelos pesos. Cada cabeça aprende suas próprias projeções, o que permite combinar informações de maneiras diferentes. Interprete uma visualização de atenção como uma descrição da mistura, com cautela ao inferir causas do comportamento final."
        },
        {
          "title": "Máscara causal",
          "text": "Nos Transformers geradores autorregressivos, a máscara permite que uma posição use posições anteriores e a própria posição. Isso evita acesso a tokens futuros durante treino e respeita a ordem usada na geração."
        }
      ],
      "example": "Em “o banco da praça”, a palavra “praça” pode influenciar a representação de “banco”. Em “o banco aprovou o crédito”, o contexto econômico favorece outro significado.",
      "explain": "Mostre o laboratório e troque a consulta de um contexto de jardim para um financeiro. Aponte como as mesmas chaves recebem pesos diferentes.",
      "quiz": {
        "prompt": "O que o softmax faz na atenção padrão?",
        "options": [
          "Apaga os valores",
          "Transforma pontuações em pesos normalizados",
          "Define todas as chaves como iguais"
        ],
        "answer": 1,
        "feedback": "Os pesos resultantes somam um e passam a controlar a mistura dos vetores de valor."
      },
      "lab": "attention"
    },
    {
      "id": "llms",
      "module": "llm",
      "title": "Como os LLMs geram texto",
      "summary": "Explore tokens, pré-treino, instruções e amostragem.",
      "minutes": 7,
      "sections": [
        {
          "title": "Tokens e contexto",
          "text": "Um tokenizador converte o texto em IDs. Um token pode corresponder a uma palavra, um pedaço de palavra ou outro fragmento. A janela de contexto limita a quantidade de tokens que o modelo pode processar de uma vez, com orçamento que depende do sistema."
        },
        {
          "title": "Pré-treino e pós-treino",
          "text": "Um objetivo comum no pré-treino é prever o próximo token observado. No pós-treino, exemplos de instruções e sinais de preferência podem melhorar o seguimento de tarefas, o formato e outros aspectos do comportamento."
        },
        {
          "title": "Inferência e amostragem",
          "text": "O modelo produz pontuações para tokens candidatos. O decodificador escolhe um e o acrescenta ao contexto, repetindo o processo. Com amostragem, uma temperatura maior tende a espalhar a distribuição. Top-p restringe a escolha ao menor grupo de tokens mais prováveis cuja probabilidade acumulada atinge p."
        }
      ],
      "example": "Dado “a capital do”, há várias continuações plausíveis. Com “a capital do Brasil é”, a distribuição tende a favorecer tokens que compõem “Brasília”. A plausibilidade textual por si só pode produzir erros factuais.",
      "explain": "Proponha um jogo de completar frases palavra por palavra. Apresente tokens como as peças reais usadas pelo modelo e discuta por que uma continuação plausível pode falhar.",
      "quiz": {
        "prompt": "O que é a janela de contexto?",
        "options": [
          "A quantidade total de exemplos de treino",
          "A lista de APIs do produto",
          "O limite de tokens processados numa chamada"
        ],
        "answer": 2,
        "feedback": "Instruções, mensagens e documentos consomem parte dessa capacidade."
      },
      "lab": null
    },
    {
      "id": "rag",
      "module": "llm",
      "title": "Embeddings, busca e RAG",
      "summary": "Conecte respostas a trechos recuperados de uma coleção de documentos.",
      "minutes": 7,
      "sections": [
        {
          "title": "Representar e recuperar",
          "text": "Embeddings são vetores numéricos aprendidos que podem aproximar textos semanticamente relacionados. Uma busca vetorial compara a consulta com trechos usando métricas como similaridade do cosseno. Uma busca lexical também pode recuperar nomes, códigos e termos exatos."
        },
        {
          "title": "Montar o contexto",
          "text": "RAG, geração aumentada por recuperação, divide e indexa documentos, recupera trechos relevantes e os inclui no contexto do modelo. A etapa de geração combina a pergunta e as fontes recuperadas para compor a resposta."
        },
        {
          "title": "Avaliar em dois níveis",
          "text": "Primeiro, verifique se a busca trouxe os trechos necessários, usando uma métrica como recall@k. Depois, verifique se a resposta é correta e sustentada pelas fontes. Trechos vencidos, permissões incorretas e citações imprecisas afetam o resultado."
        }
      ],
      "example": "Uma escola quer responder dúvidas sobre prazos. A busca deve priorizar o calendário vigente e a resposta deve citar o trecho que contém a data.",
      "explain": "Faça uma demonstração em papel. Uma pessoa escolhe as páginas relevantes de um manual e outra responde usando só as páginas encontradas. Compare falhas de busca e de síntese.",
      "quiz": {
        "prompt": "Qual passo caracteriza o RAG na hora de responder?",
        "options": [
          "Recuperar trechos e incluí-los no contexto",
          "Retreinar todos os pesos",
          "Escolher sempre o próximo token mais provável"
        ],
        "answer": 0,
        "feedback": "O contexto recuperado oferece material de referência ao modelo durante a geração."
      },
      "lab": null
    },
    {
      "id": "adaptacao",
      "module": "llm",
      "title": "Prompts, ajustes e avaliação",
      "summary": "Compare maneiras de orientar um modelo e medir a qualidade das respostas.",
      "minutes": 6,
      "sections": [
        {
          "title": "Instruções e exemplos",
          "text": "Um prompt pode definir objetivo, público, formato, limites e critérios. Exemplos curtos ajudam a demonstrar o padrão desejado. Respostas estruturadas podem ser validadas por um esquema quando outro sistema precisa consumir a saída."
        },
        {
          "title": "Quando ajustar pesos",
          "text": "Fine-tuning adapta pesos usando exemplos de uma tarefa ou estilo. RAG injeta conteúdo pesquisável durante a inferência. A escolha depende de qual mudança se quer, da frequência de atualização das fontes e da disponibilidade de exemplos avaliados."
        },
        {
          "title": "Um conjunto de avaliação",
          "text": "Colete casos comuns, cenários difíceis e situações em que faltam dados. Compare versões com critérios claros como correção factual, completude, fidelidade à fonte, latência e custo. Inclua revisão humana quando a qualidade depender de julgamento."
        }
      ],
      "example": "Um assistente de secretaria usa um prompt para escrever em linguagem clara, recuperação para consultar formulários atualizados e um teste com perguntas reais para comparar versões.",
      "explain": "Entregue a mesma pergunta a duas pessoas, com instruções diferentes. Compare as respostas usando critérios combinados antes do exercício.",
      "quiz": {
        "prompt": "Qual mudança lida diretamente com um regulamento atualizado toda semana?",
        "options": [
          "Aumentar a temperatura",
          "Atualizar o índice consultado pelo RAG",
          "Aumentar o tamanho das respostas"
        ],
        "answer": 1,
        "feedback": "Dados recuperados em cada chamada podem refletir mudanças sem atualizar os pesos do modelo."
      },
      "lab": null
    },
    {
      "id": "agente",
      "module": "agents",
      "title": "Do chat ao agente",
      "summary": "Acompanhe como um sistema escolhe ações em busca de uma meta.",
      "minutes": 7,
      "sections": [
        {
          "title": "Meta, estado e ações",
          "text": "Um agente recebe um objetivo e observa o estado da tarefa. Ele escolhe uma ação, chama uma ferramenta ou responde, lê o resultado e decide o próximo passo. O controlador do aplicativo define ações permitidas, limites e condições de parada."
        },
        {
          "title": "Estado e memória",
          "text": "O estado pode guardar resultados e decisões da tarefa atual. A memória persistente pode reaproveitar preferências autorizadas de sessões anteriores. Trate retenção, validade e exclusão desses registros como decisões explícitas de produto."
        },
        {
          "title": "Fluxo e autonomia",
          "text": "Fluxos fixos são adequados quando os passos já são conhecidos. Um agente ajuda quando a próxima ação depende de evidências coletadas durante a execução. Registre decisões observáveis e defina orçamentos de chamadas, tempo e custo."
        }
      ],
      "example": "Para achar um livro, um agente consulta o catálogo, compara alternativas e apresenta a melhor opção. Fazer uma reserva exige uma ação adicional com efeito no sistema.",
      "explain": "Faça o papel do agente e peça para alguém representar a ferramenta. A cada resultado, explique sua próxima ação e quando você pediria confirmação.",
      "quiz": {
        "prompt": "O que deve ocorrer depois que a ferramenta retorna um resultado?",
        "options": [
          "Limpar o objetivo",
          "Repetir sempre a mesma chamada",
          "Atualizar o estado e decidir a próxima ação"
        ],
        "answer": 2,
        "feedback": "A observação atualiza a tarefa e orienta a decisão de agir, pedir informação ou encerrar."
      },
      "lab": "agent"
    },
    {
      "id": "tools",
      "module": "agents",
      "title": "Ferramentas, APIs e MCP",
      "summary": "Mostre como um agente consulta sistemas e executa ações por interfaces definidas.",
      "minutes": 7,
      "sections": [
        {
          "title": "Contratos de ferramentas",
          "text": "Uma ferramenta descreve seu nome, parâmetros e tipos esperados. O modelo sugere uma chamada estruturada. A aplicação valida argumentos, identidade e permissões antes de executar a função e devolve um resultado interpretável."
        },
        {
          "title": "MCP",
          "text": "O Model Context Protocol padroniza a comunicação entre aplicações clientes e servidores que fornecem ferramentas, recursos e prompts. Uma integração MCP ainda precisa de decisões de autorização, isolamento, tratamento de erros e instruções para o modelo."
        },
        {
          "title": "Efeitos no mundo",
          "text": "Consultar disponibilidade e criar uma reserva têm consequências diferentes. O controlador pode pedir aprovação para a segunda ação, limitar permissões e usar uma chave de idempotência para evitar efeitos duplicados em novas tentativas."
        }
      ],
      "example": "Uma ferramenta busca livros por assunto e outra cria uma reserva pelo identificador do exemplar. O aplicativo valida o exemplar selecionado e exibe os dados da operação antes de aprová-la.",
      "explain": "Compare uma ferramenta de leitura e uma de escrita. Peça à turma que defina os parâmetros e quem poderia executar cada uma.",
      "quiz": {
        "prompt": "Quem deve validar a permissão antes de uma chamada que grava dados?",
        "options": [
          "A aplicação que executa a ação",
          "A função softmax",
          "O texto da descrição por si só"
        ],
        "answer": 0,
        "feedback": "A camada executora tem acesso à identidade e pode aplicar as permissões efetivas."
      },
      "lab": null
    },
    {
      "id": "skills",
      "module": "agents",
      "title": "Skills e procedimentos reutilizáveis",
      "summary": "Empacote instruções, referências e recursos para uma tarefa recorrente.",
      "minutes": 6,
      "sections": [
        {
          "title": "Uma capacidade documentada",
          "text": "O termo skill pode variar por plataforma. Em sistemas de agentes, costuma designar um pacote reutilizável com descrição de quando usar, instruções, exemplos e, quando necessário, arquivos ou scripts auxiliares."
        },
        {
          "title": "Ativação e uso",
          "text": "Um sistema pode começar com nome e descrição para escolher uma skill e carregar os detalhes quando precisar. As instruções podem orientar várias chamadas de ferramenta, indicar critérios de qualidade e definir o formato do resultado."
        },
        {
          "title": "Manutenção e teste",
          "text": "Versione a skill e teste situações em que ela deve ser usada e casos próximos em que ela seria inadequada. Registre dependências, permissões e comportamento quando falta informação. A execução de ferramentas continua sujeita às permissões da aplicação."
        }
      ],
      "example": "Uma skill de resumo de aula descreve como identificar objetivos didáticos e montar perguntas. Ela pode usar uma ferramenta de leitura para consultar o material fornecido.",
      "explain": "Peça à turma que escreva cinco passos para alguém repetir uma revisão de material didático. Inclua o formato da entrega e um critério para considerar a tarefa pronta.",
      "quiz": {
        "prompt": "Qual opção descreve uma skill nesse contexto?",
        "options": [
          "Um vetor que representa uma palavra",
          "Um procedimento reutilizável com instruções e recursos",
          "A permissão de administrador de um servidor"
        ],
        "answer": 1,
        "feedback": "A skill reúne o método de trabalho para executar uma tarefa de forma consistente."
      },
      "lab": null
    },
    {
      "id": "multi",
      "module": "agents",
      "title": "Sistemas multiagentes",
      "summary": "Divida responsabilidades e compare os custos de coordenação.",
      "minutes": 7,
      "sections": [
        {
          "title": "Divisão do trabalho",
          "text": "Uma equipe pode ter agentes com papéis, contextos e ferramentas diferentes. Um orquestrador decide quem recebe cada parte, como os resultados são agregados e quando uma etapa precisa de revisão."
        },
        {
          "title": "Topologias de coordenação",
          "text": "Em série, um agente consome a saída do anterior. Em paralelo, tarefas independentes avançam juntas e depois convergem. Um revisor pode testar afirmações contra fontes, embora agentes que compartilham modelo e dados também possam compartilhar os mesmos erros."
        },
        {
          "title": "Contratos e limites",
          "text": "Defina o formato das mensagens, as responsabilidades, o número máximo de rodadas e critérios para resolver divergências. Compare com um fluxo mais simples usando latência, custo, qualidade e rastreabilidade."
        }
      ],
      "example": "Para preparar uma aula, um agente revisa as referências enquanto outro revisa clareza. Se a clareza depender do texto corrigido pela primeira revisão, execute as etapas em série.",
      "explain": "Distribua os papéis entre três pessoas. Repita a tarefa em série e em paralelo e compare o que se perdeu ou ganhou em cada organização.",
      "quiz": {
        "prompt": "Quando rodar dois agentes em paralelo é mais adequado?",
        "options": [
          "Quando ambos precisam da saída final do outro",
          "Quando não há critério de encerramento",
          "Quando as subtarefas são independentes"
        ],
        "answer": 2,
        "feedback": "A independência permite sobrepor o trabalho e combinar os resultados depois."
      },
      "lab": "team"
    },
    {
      "id": "operacao",
      "module": "agents",
      "title": "Qualidade, supervisão e operação",
      "summary": "Defina critérios para acompanhar um agente antes e depois de colocá-lo em uso.",
      "minutes": 7,
      "sections": [
        {
          "title": "Avaliar comportamento",
          "text": "Crie casos com resultados verificáveis. Meça sucesso da tarefa, uso correto das ferramentas, intervenções humanas, custo e tempo. Analise caminhos diferentes até o mesmo resultado para identificar chamadas redundantes ou frágeis."
        },
        {
          "title": "Conteúdo e permissões",
          "text": "Resultados de busca e arquivos são dados externos. O controlador separa esses dados das instruções que governam a aplicação. Limite os recursos disponíveis à tarefa e revise operações que tenham consequências relevantes."
        },
        {
          "title": "Observabilidade e recuperação",
          "text": "Registre chamadas, resultados, aprovações e erros com minimização de dados pessoais. Use limites de execução, recuperação de falhas e caminhos de transferência a pessoas. Monitore mudanças na qualidade quando dados, modelos ou dependências mudarem."
        }
      ],
      "example": "Em um piloto de biblioteca, use um catálogo simulado para testar livro disponível, livro indisponível, falha de busca e recusa de reserva. Registre a decisão tomada em cada caso.",
      "explain": "Peça três exemplos em que o agente deveria parar. Discuta quais sinais e limites o controlador precisaria observar.",
      "quiz": {
        "prompt": "Qual caso avalia a supervisão humana?",
        "options": [
          "Uma reserva recusada que deve encerrar sem gravação",
          "A cor do botão de pesquisa",
          "O número de letras no nome do produto"
        ],
        "answer": 0,
        "feedback": "O caso verifica se o agente e a aplicação respeitam a decisão humana diante de uma ação com efeito."
      },
      "lab": null
    }
  ],
  "glossary": [
    {
      "term": "Agente",
      "definition": "Sistema que escolhe ações em função de uma meta e revisa o próximo passo após observar os resultados.",
      "lesson": "agente"
    },
    {
      "term": "Amostragem",
      "definition": "Escolha de uma saída segundo uma distribuição de probabilidades. Em LLMs, pode ser aplicada a cada novo token.",
      "lesson": "llms"
    },
    {
      "term": "Aprendizado por reforço",
      "definition": "Ajuste de uma política de ações a partir das recompensas de um ambiente.",
      "lesson": "paradigmas"
    },
    {
      "term": "Atenção",
      "definition": "Mecanismo que combina vetores de valor com pesos dependentes da consulta e das chaves.",
      "lesson": "atencao"
    },
    {
      "term": "Ativação",
      "definition": "Função que transforma a soma ponderada de um neurônio. ReLU e sigmoide são exemplos.",
      "lesson": "neuronio"
    },
    {
      "term": "Avaliação",
      "definition": "Medição de desempenho com casos, critérios e dados definidos de acordo com a tarefa.",
      "lesson": "adaptacao"
    },
    {
      "term": "Camada",
      "definition": "Etapa de uma rede que transforma entradas em uma nova representação.",
      "lesson": "profundidade"
    },
    {
      "term": "CNN",
      "definition": "Rede neural convolucional. Usa filtros compartilhados para detectar padrões locais em posições diferentes.",
      "lesson": "arquiteturas"
    },
    {
      "term": "Deep Learning",
      "definition": "Aprendizado de máquina com redes neurais que compõem várias camadas de transformação.",
      "lesson": "profundidade"
    },
    {
      "term": "Embeddings",
      "definition": "Vetores aprendidos que representam itens como palavras, documentos ou imagens.",
      "lesson": "rag"
    },
    {
      "term": "Época",
      "definition": "Uma passagem pelo conjunto de exemplos de treino.",
      "lesson": "backprop"
    },
    {
      "term": "Ferramenta",
      "definition": "Operação com um contrato de chamada que permite a um agente consultar um sistema ou solicitar uma ação.",
      "lesson": "tools"
    },
    {
      "term": "Fine-tuning",
      "definition": "Ajuste de alguns ou todos os pesos de um modelo pré-treinado, feito com dados de uma nova tarefa.",
      "lesson": "adaptacao"
    },
    {
      "term": "Generalização",
      "definition": "Capacidade de manter um bom desempenho em exemplos novos.",
      "lesson": "treino"
    },
    {
      "term": "Gradiente",
      "definition": "Vetor de derivadas que indica como a perda varia localmente com os parâmetros.",
      "lesson": "backprop"
    },
    {
      "term": "IA generativa",
      "definition": "Sistemas que produzem saídas como texto, imagens ou áudio a partir de um contexto.",
      "lesson": "llms"
    },
    {
      "term": "Inferência",
      "definition": "Uso de um modelo treinado para produzir uma previsão ou saída.",
      "lesson": "llms"
    },
    {
      "term": "Janela de contexto",
      "definition": "Limite de tokens que um modelo pode usar em um processamento.",
      "lesson": "llms"
    },
    {
      "term": "LLM",
      "definition": "Modelo de linguagem de grande escala. Um objetivo de treinamento comum é prever o próximo token.",
      "lesson": "llms"
    },
    {
      "term": "Machine Learning",
      "definition": "Métodos que ajustam modelos a partir de dados para identificar padrões ou tomar decisões.",
      "lesson": "mapa"
    },
    {
      "term": "MCP",
      "definition": "Model Context Protocol. Protocolo para fornecer ferramentas, recursos e prompts a aplicações clientes.",
      "lesson": "tools"
    },
    {
      "term": "Orquestração",
      "definition": "Coordenação de tarefas, dependências, mensagens e condições de parada entre componentes.",
      "lesson": "multi"
    },
    {
      "term": "Perda",
      "definition": "Medida numérica do desvio entre a saída de um modelo e o objetivo de treinamento.",
      "lesson": "treino"
    },
    {
      "term": "Prompt",
      "definition": "Entrada que fornece uma tarefa, instruções ou exemplos a um modelo generativo.",
      "lesson": "adaptacao"
    },
    {
      "term": "RAG",
      "definition": "Geração aumentada por recuperação. Inclui material recuperado de fontes no contexto do modelo.",
      "lesson": "rag"
    },
    {
      "term": "Rede neural",
      "definition": "Modelo que organiza transformações parametrizadas em camadas conectadas.",
      "lesson": "neuronio"
    },
    {
      "term": "Retropropagação",
      "definition": "Cálculo eficiente dos gradientes usando a regra da cadeia da saída em direção às operações anteriores.",
      "lesson": "backprop"
    },
    {
      "term": "Skill",
      "definition": "Pacote reutilizável de instruções e recursos para conduzir uma tarefa recorrente.",
      "lesson": "skills"
    },
    {
      "term": "Sobreajuste",
      "definition": "Ajuste excessivo a particularidades dos dados de treino, com perda de qualidade em exemplos novos.",
      "lesson": "treino"
    },
    {
      "term": "Softmax",
      "definition": "Transformação de pontuações em valores positivos que somam um.",
      "lesson": "atencao"
    },
    {
      "term": "Token",
      "definition": "Unidade em que um tokenizador divide uma entrada, como uma palavra ou um fragmento.",
      "lesson": "llms"
    },
    {
      "term": "Transformer",
      "definition": "Arquitetura que combina mecanismos de atenção, transformações por posição e informações sobre ordem.",
      "lesson": "atencao"
    },
    {
      "term": "Validação",
      "definition": "Uso de dados separados do treino para ajustar configurações e comparar alternativas.",
      "lesson": "treino"
    }
  ],
  "labs": [
    {
      "id": "regression",
      "title": "Ajuste uma reta",
      "summary": "Ajuste os parâmetros ou deixe a descida do gradiente reduzir o erro.",
      "module": "ml"
    },
    {
      "id": "neuron",
      "title": "Por dentro do neurônio",
      "summary": "Mude a influência de cada entrada e observe a ativação.",
      "module": "neural"
    },
    {
      "id": "attention",
      "title": "Quem recebe atenção?",
      "summary": "Troque a consulta e veja como os pesos se redistribuem.",
      "module": "llm"
    },
    {
      "id": "agent",
      "title": "O ciclo de um agente",
      "summary": "Conduza uma busca de livros, da meta à aprovação de uma reserva.",
      "module": "agents"
    },
    {
      "id": "team",
      "title": "Monte uma equipe de agentes",
      "summary": "Compare uma revisão em etapas com uma revisão que ocorre em paralelo.",
      "module": "agents"
    }
  ]
};
