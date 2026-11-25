import Foundation

struct Module: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let icon: String
}

struct Lesson: Identifiable, Hashable {
    let id: String
    let module: String
    let title: String
    let minutes: Int
    let summary: String
    let sections: [Section]
    let example: String
    let explain: String
    let quiz: Quiz
    let lab: Lab?

    struct Section: Hashable {
        let title: String
        let text: String
    }

    struct Quiz: Hashable {
        let prompt: String
        let options: [String]
        let answer: Int
        let feedback: String
    }

    init(_ id: String, _ module: String, _ title: String, _ minutes: Int, _ summary: String,
         _ sections: [(String, String)], _ example: String, _ explain: String,
         _ prompt: String, _ options: [String], _ answer: Int, _ feedback: String, lab: Lab? = nil) {
        self.id = id
        self.module = module
        self.title = title
        self.minutes = minutes
        self.summary = summary
        self.sections = sections.map { Section(title: $0.0, text: $0.1) }
        self.example = example
        self.explain = explain
        self.quiz = Quiz(prompt: prompt, options: options, answer: answer, feedback: feedback)
        self.lab = lab
    }
}

enum Lab: String, CaseIterable, Identifiable, Hashable {
    case regression, neuron, attention, agent, team
    var id: String { rawValue }
    var title: String {
        switch self {
        case .regression: "Ajuste uma reta"
        case .neuron: "Por dentro do neurônio"
        case .attention: "Quem recebe atenção?"
        case .agent: "O ciclo de um agente"
        case .team: "Monte uma equipe de agentes"
        }
    }
    var blurb: String {
        switch self {
        case .regression: "Ajuste os parâmetros ou deixe a descida do gradiente reduzir o erro."
        case .neuron: "Mude a influência de cada entrada e observe a ativação."
        case .attention: "Troque a consulta e veja como os pesos se redistribuem."
        case .agent: "Conduza uma busca de livros, da meta à aprovação de uma reserva."
        case .team: "Compare uma revisão em etapas com uma revisão que ocorre em paralelo."
        }
    }
    var module: String {
        switch self {
        case .regression: "ml"
        case .neuron: "neural"
        case .attention: "llm"
        case .agent, .team: "agents"
        }
    }
    var icon: String {
        switch self {
        case .regression: "chart.xyaxis.line"
        case .neuron: "circle.hexagongrid.fill"
        case .attention: "scope"
        case .agent: "point.topleft.down.to.point.bottomright.curvepath"
        case .team: "person.3.sequence.fill"
        }
    }
}

enum Catalog {
    static let modules = [
        Module(id: "ml", title: "Machine Learning", subtitle: "Dados, objetivos e generalização", icon: "chart.xyaxis.line"),
        Module(id: "neural", title: "Redes neurais", subtitle: "Pesos, ativações e treinamento", icon: "circle.hexagongrid"),
        Module(id: "deep", title: "Deep Learning", subtitle: "Camadas e representações", icon: "square.3.layers.3d"),
        Module(id: "llm", title: "IA generativa", subtitle: "Transformers, LLMs e RAG", icon: "sparkles"),
        Module(id: "agents", title: "Agentes e skills", subtitle: "Ferramentas, autonomia e equipes", icon: "point.3.connected.trianglepath.dotted")
    ]

    static func lessons(in module: String) -> [Lesson] {
        lessons.filter { $0.module == module }
    }

    static let lessons: [Lesson] = [
        .init("mapa", "ml", "O mapa da inteligência artificial", 4,
              "Entenda onde aprendizado de máquina, deep learning e IA generativa se encontram.",
              [
                ("Da tarefa ao sistema", "Inteligência artificial (IA) reúne técnicas para executar tarefas como planejar, reconhecer padrões e produzir linguagem. Um planejador pode buscar caminhos em um mapa usando regras e custos definidos por pessoas. Um modelo treinado pode prever a duração do trajeto a partir de viagens anteriores."),
                ("Aprender com exemplos", "Machine learning (ML) é a família de métodos que ajusta modelos a partir de dados. Deep learning é um subconjunto de ML que usa redes neurais com várias camadas. Muitos sistemas generativos atuais usam deep learning para produzir texto, áudio ou imagens."),
                ("Modelo e produto", "O modelo faz uma previsão ou gera uma saída. O produto liga o modelo a uma interface, dados, políticas e mecanismos de avaliação. A utilidade final depende do sistema inteiro e de como ele será usado.")
              ],
              "Num app de rotas, a previsão de trânsito pode vir de um modelo treinado. A escolha do trajeto pode combinar essa previsão com regras para ruas bloqueadas e um algoritmo de busca.",
              "Peça dois exemplos para a turma: uma regra que alguém escreveria e um padrão difícil de descrever que poderia ser aprendido com dados.",
              "Qual tarefa é um caso típico de ML?", ["Consultar um preço fixo numa tabela", "Prever trânsito com viagens passadas", "Ordenar números por valor"], 1,
              "A previsão ajusta um modelo a exemplos históricos para lidar com situações futuras."),
        .init("paradigmas", "ml", "Três formas de aprender", 6,
              "Compare aprendizado supervisionado, não supervisionado e por reforço.",
              [
                ("Supervisionado", "Cada exemplo de treinamento tem entradas e um alvo conhecido. Na regressão, o alvo é um valor numérico, como consumo de energia. Na classificação, é uma categoria, como spam ou mensagem legítima."),
                ("Não supervisionado", "O modelo explora estrutura sem rótulos de classe fornecidos. Clustering agrupa exemplos segundo uma noção de similaridade. Os grupos dependem das variáveis e da métrica de distância escolhidas."),
                ("Por reforço", "Um agente interage com um ambiente e recebe recompensas. Ele aprende uma política de ações para maximizar a recompensa acumulada esperada. Uma ação com benefício imediato pode diminuir a recompensa futura.")
              ],
              "Com filmes já marcados por gênero, treine um classificador. Com apenas históricos de visualização, procure grupos de comportamento. Num jogo simulado, recompense decisões que aumentem a pontuação final.",
              "Use o mesmo cenário, uma biblioteca. Classificar livros rotulados, agrupar hábitos de leitura e aprender políticas de recomendação com recompensas ilustram três sinais de aprendizado diferentes.",
              "Qual sinal caracteriza aprendizado por reforço?", ["Recompensas pela interação", "Rótulos fixos para todas as entradas", "Distância entre grupos como único sinal"], 0,
              "A política melhora a partir de recompensas observadas ao interagir com o ambiente."),
        .init("treino", "ml", "Treino, validação e teste", 7,
              "Ajuste uma previsão e aprenda a medir se ela funciona com dados novos.",
              [
                ("Treinar um modelo", "Uma função de perda mede a diferença entre a saída e o alvo. Na regressão, o erro quadrático médio é a média dos quadrados dos resíduos. A descida do gradiente usa derivadas para ajustar parâmetros na direção que reduz a perda localmente."),
                ("Escolher e medir", "O conjunto de treino ajusta parâmetros. A validação ajuda a escolher configurações como a regularização. O teste reservado estima desempenho final. Em séries temporais, separe períodos em ordem cronológica para evitar treinamento com informação do futuro."),
                ("Generalização e métricas", "Sobreajuste ocorre quando o modelo se adapta a particularidades do treino e perde qualidade em exemplos novos. Em classificação com classe rara, examine precisão, a fração dos positivos previstos que são corretos, e revocação, a fração dos positivos reais que foram encontrados.")
              ],
              "Se 99 de 100 mensagens são legítimas, responder sempre “legítima” dá 99% de acurácia e detecta zero spams. A revocação da classe spam revela a falha.",
              "Mostre uma reta no laboratório. Peça um palpite para a melhor inclinação, ajuste a reta e pergunte como verificar o desempenho em pontos que ninguém viu.",
              "Qual conjunto deve ficar reservado para a avaliação final?", ["Treino", "Validação", "Teste"], 2,
              "O teste mantém uma estimativa independente das decisões tomadas durante treino e validação.", lab: .regression),
        .init("neuronio", "neural", "O neurônio artificial", 6,
              "Veja como entradas, pesos, viés e ativação formam a unidade básica de uma rede.",
              [
                ("Soma ponderada", "Cada entrada xᵢ recebe um peso wᵢ. O neurônio calcula z = Σ(wᵢxᵢ) + b. Os pesos controlam a contribuição de cada entrada. O viés b desloca o resultado mesmo quando todas as entradas valem zero."),
                ("Função de ativação", "Uma ativação transforma z. ReLU produz max(0, z). A sigmoide leva z a um valor entre zero e um e pode representar uma pontuação de classificação binária. Interpretar essa pontuação como probabilidade confiável requer avaliação de calibração."),
                ("Compor camadas", "Uma camada calcula várias saídas em paralelo. As saídas podem alimentar novas camadas. Empilhar operações que são apenas afins produziria outra operação afim. As ativações não lineares permitem modelar relações mais complexas.")
              ],
              "Com entradas 0,8 e 0,4, pesos 1,2 e −0,5 e viés −0,3, a soma é 0,46. A sigmoide produz aproximadamente 0,61.",
              "Peça que a turma preveja a direção da mudança quando um peso passa de positivo para negativo. Confirme no laboratório.",
              "Qual componente desloca z com todas as entradas iguais a zero?", ["A entrada de maior índice", "O viés", "A perda do modelo"], 1,
              "Quando as entradas valem zero, todos os produtos wᵢxᵢ desaparecem e z é igual ao viés.", lab: .neuron),
        .init("backprop", "neural", "Como uma rede aprende", 7,
              "Acompanhe o caminho da previsão até a atualização dos pesos.",
              [
                ("Passagem para frente", "A rede aplica as camadas à entrada e calcula uma previsão. A função de perda compara a previsão ao alvo. A perda deve estar alinhada com o comportamento que desejamos incentivar."),
                ("Retropropagação", "A regra da cadeia calcula como pequenas mudanças em cada parâmetro influenciam a perda. A retropropagação reutiliza resultados intermediários e percorre as operações em ordem inversa, a partir da saída."),
                ("Otimizador e lotes", "O otimizador usa os gradientes para atualizar os parâmetros. Na descida do gradiente mais simples, o passo é o gradiente negativo multiplicado pela taxa de aprendizado. Em mini-batches, cada atualização usa um subconjunto dos exemplos. Uma época corresponde a uma passagem pelo conjunto de treino.")
              ],
              "Se um peso tem gradiente +0,6 e a taxa é 0,1, o passo é −0,06. Um peso de 0,50 vira 0,44 na descida do gradiente simples.",
              "Desenhe três caixas: previsão, perda, atualização. Mostre as setas que seguem a entrada e o caminho inverso usado para calcular os gradientes.",
              "Qual tarefa a retropropagação realiza?", ["Embaralha os exemplos", "Define o formato da saída", "Calcula gradientes da perda"], 2,
              "O cálculo fornece ao otimizador as derivadas necessárias para atualizar os parâmetros."),
        .init("profundidade", "deep", "Profundidade e representações", 6,
              "Entenda o que muda quando uma rede usa muitas camadas.",
              [
                ("Representações aprendidas", "Cada camada transforma a representação anterior. Em visão, algumas redes aprendem primeiro padrões locais como bordas e depois combinam sinais em padrões maiores. A divisão entre camadas varia com dados, arquitetura e objetivo."),
                ("Custo e regularização", "A profundidade dá ao modelo recursos para compor transformações. Também aumenta o custo de treino e pode dificultar a otimização. Regularização, aumento de dados e monitoramento de validação ajudam a controlar sobreajuste."),
                ("Transferência de aprendizado", "Um modelo pré-treinado já aprendeu padrões reutilizáveis. Você pode extrair representações com pesos congelados ou ajustar parte dos pesos usando dados da nova tarefa. A transferência funciona melhor quando a origem e a tarefa compartilham padrões relevantes.")
              ],
              "Uma equipe com poucas fotos rotuladas de plantas pode reaproveitar uma rede de visão pré-treinada e treinar uma cabeça de classificação específica para espécies locais.",
              "Desenhe quatro camadas de uma tarefa de visão e peça sugestões de padrões que cada camada poderia representar. Trate as sugestões como hipóteses.",
              "O que significa congelar uma camada?", ["Impedir a atualização dos seus pesos", "Impedir que produza saídas", "Apagar os pesos aprendidos"], 0,
              "Uma camada congelada continua na passagem para frente com os parâmetros fixos."),
        .init("arquiteturas", "deep", "CNNs, recorrência e Transformers", 7,
              "Escolha uma arquitetura entendendo o tipo de relações que ela favorece.",
              [
                ("Convolução e localidade", "Uma rede convolucional (CNN) aplica os mesmos filtros em diferentes posições. Essa reutilização permite detectar um padrão local em vários pontos da entrada e reduz o número de pesos em comparação com conexões distintas entre todos os pixels."),
                ("Recorrência e sequência", "Uma rede recorrente (RNN) processa uma sequência mantendo um estado que passa de um passo ao próximo. LSTMs e GRUs usam mecanismos de controle para atualizar esse estado. O processamento entre passos tem dependências sequenciais."),
                ("Atenção e contexto", "Transformers usam atenção para conectar posições de uma sequência e usam informações de posição para representar ordem. Na atenção densa padrão, o número de pares comparados cresce quadraticamente com o tamanho da sequência.")
              ],
              "Textura em uma foto favorece filtros locais. Uma série de medições pode ser processada como sequência. Uma referência entre palavras distantes é um caso em que uma conexão direta via atenção pode ser útil.",
              "Mostre as três arquiteturas com o mesmo objetivo de reconhecer um padrão. Pergunte quais partes da entrada cada uma combina em primeiro lugar.",
              "Qual mecanismo reaproveita um filtro em posições diferentes de uma imagem?", ["Recorrência", "Convolução", "Tokenização"], 1,
              "A convolução desliza filtros com pesos compartilhados pela entrada."),
        .init("atencao", "llm", "Atenção e o Transformer", 7,
              "Entenda por que a representação de uma palavra depende das palavras ao redor.",
              [
                ("Consulta, chaves e valores", "Para cada posição, a atenção calcula uma consulta Q. Ela compara Q às chaves K de posições permitidas. A pontuação típica é o produto escalar dividido pela raiz quadrada da dimensão da chave. O softmax transforma pontuações em pesos com soma igual a um."),
                ("Contextualizar", "A saída é a soma dos vetores de valor V ponderados pelos pesos. Cada cabeça aprende suas próprias projeções, o que permite combinar informações de maneiras diferentes. Interprete uma visualização de atenção como uma descrição da mistura, com cautela ao inferir causas do comportamento final."),
                ("Máscara causal", "Nos Transformers geradores autorregressivos, a máscara permite que uma posição use posições anteriores e a própria posição. Isso evita acesso a tokens futuros durante treino e respeita a ordem usada na geração.")
              ],
              "Em “o banco da praça”, a palavra “praça” pode influenciar a representação de “banco”. Em “o banco aprovou o crédito”, o contexto econômico favorece outro significado.",
              "Mostre o laboratório e troque a consulta de um contexto de jardim para um financeiro. Aponte como as mesmas chaves recebem pesos diferentes.",
              "O que o softmax faz na atenção padrão?", ["Apaga os valores", "Transforma pontuações em pesos normalizados", "Define todas as chaves como iguais"], 1,
              "Os pesos resultantes somam um e passam a controlar a mistura dos vetores de valor.", lab: .attention),
        .init("llms", "llm", "Como os LLMs geram texto", 7,
              "Explore tokens, pré-treino, instruções e amostragem.",
              [
                ("Tokens e contexto", "Um tokenizador converte o texto em IDs. Um token pode corresponder a uma palavra, um pedaço de palavra ou outro fragmento. A janela de contexto limita a quantidade de tokens que o modelo pode processar de uma vez, com orçamento que depende do sistema."),
                ("Pré-treino e pós-treino", "Um objetivo comum no pré-treino é prever o próximo token observado. No pós-treino, exemplos de instruções e sinais de preferência podem melhorar o seguimento de tarefas, o formato e outros aspectos do comportamento."),
                ("Inferência e amostragem", "O modelo produz pontuações para tokens candidatos. O decodificador escolhe um e o acrescenta ao contexto, repetindo o processo. Com amostragem, uma temperatura maior tende a espalhar a distribuição. Top-p restringe a escolha ao menor grupo de tokens mais prováveis cuja probabilidade acumulada atinge p.")
              ],
              "Dado “a capital do”, há várias continuações plausíveis. Com “a capital do Brasil é”, a distribuição tende a favorecer tokens que compõem “Brasília”. A plausibilidade textual por si só pode produzir erros factuais.",
              "Proponha um jogo de completar frases palavra por palavra. Apresente tokens como as peças reais usadas pelo modelo e discuta por que uma continuação plausível pode falhar.",
              "O que é a janela de contexto?", ["A quantidade total de exemplos de treino", "A lista de APIs do produto", "O limite de tokens processados numa chamada"], 2,
              "Instruções, mensagens e documentos consomem parte dessa capacidade."),
        .init("rag", "llm", "Embeddings, busca e RAG", 7,
              "Conecte respostas a trechos recuperados de uma coleção de documentos.",
              [
                ("Representar e recuperar", "Embeddings são vetores numéricos aprendidos que podem aproximar textos semanticamente relacionados. Uma busca vetorial compara a consulta com trechos usando métricas como similaridade do cosseno. Uma busca lexical também pode recuperar nomes, códigos e termos exatos."),
                ("Montar o contexto", "RAG, geração aumentada por recuperação, divide e indexa documentos, recupera trechos relevantes e os inclui no contexto do modelo. A etapa de geração combina a pergunta e as fontes recuperadas para compor a resposta."),
                ("Avaliar em dois níveis", "Primeiro, verifique se a busca trouxe os trechos necessários, usando uma métrica como recall@k. Depois, verifique se a resposta é correta e sustentada pelas fontes. Trechos vencidos, permissões incorretas e citações imprecisas afetam o resultado.")
              ],
              "Uma escola quer responder dúvidas sobre prazos. A busca deve priorizar o calendário vigente e a resposta deve citar o trecho que contém a data.",
              "Faça uma demonstração em papel. Uma pessoa escolhe as páginas relevantes de um manual e outra responde usando só as páginas encontradas. Compare falhas de busca e de síntese.",
              "Qual passo caracteriza o RAG na hora de responder?", ["Recuperar trechos e incluí-los no contexto", "Retreinar todos os pesos", "Escolher sempre o próximo token mais provável"], 0,
              "O contexto recuperado oferece material de referência ao modelo durante a geração."),
        .init("adaptacao", "llm", "Prompts, ajustes e avaliação", 6,
              "Compare maneiras de orientar um modelo e medir a qualidade das respostas.",
              [
                ("Instruções e exemplos", "Um prompt pode definir objetivo, público, formato, limites e critérios. Exemplos curtos ajudam a demonstrar o padrão desejado. Respostas estruturadas podem ser validadas por um esquema quando outro sistema precisa consumir a saída."),
                ("Quando ajustar pesos", "Fine-tuning adapta pesos usando exemplos de uma tarefa ou estilo. RAG injeta conteúdo pesquisável durante a inferência. A escolha depende de qual mudança se quer, da frequência de atualização das fontes e da disponibilidade de exemplos avaliados."),
                ("Um conjunto de avaliação", "Colete casos comuns, cenários difíceis e situações em que faltam dados. Compare versões com critérios claros como correção factual, completude, fidelidade à fonte, latência e custo. Inclua revisão humana quando a qualidade depender de julgamento.")
              ],
              "Um assistente de secretaria usa um prompt para escrever em linguagem clara, recuperação para consultar formulários atualizados e um teste com perguntas reais para comparar versões.",
              "Entregue a mesma pergunta a duas pessoas, com instruções diferentes. Compare as respostas usando critérios combinados antes do exercício.",
              "Qual mudança lida diretamente com um regulamento atualizado toda semana?", ["Aumentar a temperatura", "Atualizar o índice consultado pelo RAG", "Aumentar o tamanho das respostas"], 1,
              "Dados recuperados em cada chamada podem refletir mudanças sem atualizar os pesos do modelo."),
        .init("agente", "agents", "Do chat ao agente", 7,
              "Acompanhe como um sistema escolhe ações em busca de uma meta.",
              [
                ("Meta, estado e ações", "Um agente recebe um objetivo e observa o estado da tarefa. Ele escolhe uma ação, chama uma ferramenta ou responde, lê o resultado e decide o próximo passo. O controlador do aplicativo define ações permitidas, limites e condições de parada."),
                ("Estado e memória", "O estado pode guardar resultados e decisões da tarefa atual. A memória persistente pode reaproveitar preferências autorizadas de sessões anteriores. Trate retenção, validade e exclusão desses registros como decisões explícitas de produto."),
                ("Fluxo e autonomia", "Fluxos fixos são adequados quando os passos já são conhecidos. Um agente ajuda quando a próxima ação depende de evidências coletadas durante a execução. Registre decisões observáveis e defina orçamentos de chamadas, tempo e custo.")
              ],
              "Para achar um livro, um agente consulta o catálogo, compara alternativas e apresenta a melhor opção. Fazer uma reserva exige uma ação adicional com efeito no sistema.",
              "Faça o papel do agente e peça para alguém representar a ferramenta. A cada resultado, explique sua próxima ação e quando você pediria confirmação.",
              "O que deve ocorrer depois que a ferramenta retorna um resultado?", ["Limpar o objetivo", "Repetir sempre a mesma chamada", "Atualizar o estado e decidir a próxima ação"], 2,
              "A observação atualiza a tarefa e orienta a decisão de agir, pedir informação ou encerrar.", lab: .agent),
        .init("tools", "agents", "Ferramentas, APIs e MCP", 7,
              "Mostre como um agente consulta sistemas e executa ações por interfaces definidas.",
              [
                ("Contratos de ferramentas", "Uma ferramenta descreve seu nome, parâmetros e tipos esperados. O modelo sugere uma chamada estruturada. A aplicação valida argumentos, identidade e permissões antes de executar a função e devolve um resultado interpretável."),
                ("MCP", "O Model Context Protocol padroniza a comunicação entre aplicações clientes e servidores que fornecem ferramentas, recursos e prompts. Uma integração MCP ainda precisa de decisões de autorização, isolamento, tratamento de erros e instruções para o modelo."),
                ("Efeitos no mundo", "Consultar disponibilidade e criar uma reserva têm consequências diferentes. O controlador pode pedir aprovação para a segunda ação, limitar permissões e usar uma chave de idempotência para evitar efeitos duplicados em novas tentativas.")
              ],
              "Uma ferramenta busca livros por assunto e outra cria uma reserva pelo identificador do exemplar. O aplicativo valida o exemplar selecionado e exibe os dados da operação antes de aprová-la.",
              "Compare uma ferramenta de leitura e uma de escrita. Peça à turma que defina os parâmetros e quem poderia executar cada uma.",
              "Quem deve validar a permissão antes de uma chamada que grava dados?", ["A aplicação que executa a ação", "A função softmax", "O texto da descrição por si só"], 0,
              "A camada executora tem acesso à identidade e pode aplicar as permissões efetivas."),
        .init("skills", "agents", "Skills e procedimentos reutilizáveis", 6,
              "Empacote instruções, referências e recursos para uma tarefa recorrente.",
              [
                ("Uma capacidade documentada", "O termo skill pode variar por plataforma. Em sistemas de agentes, costuma designar um pacote reutilizável com descrição de quando usar, instruções, exemplos e, quando necessário, arquivos ou scripts auxiliares."),
                ("Ativação e uso", "Um sistema pode começar com nome e descrição para escolher uma skill e carregar os detalhes quando precisar. As instruções podem orientar várias chamadas de ferramenta, indicar critérios de qualidade e definir o formato do resultado."),
                ("Manutenção e teste", "Versione a skill e teste situações em que ela deve ser usada e casos próximos em que ela seria inadequada. Registre dependências, permissões e comportamento quando falta informação. A execução de ferramentas continua sujeita às permissões da aplicação.")
              ],
              "Uma skill de resumo de aula descreve como identificar objetivos didáticos e montar perguntas. Ela pode usar uma ferramenta de leitura para consultar o material fornecido.",
              "Peça à turma que escreva cinco passos para alguém repetir uma revisão de material didático. Inclua o formato da entrega e um critério para considerar a tarefa pronta.",
              "Qual opção descreve uma skill nesse contexto?", ["Um vetor que representa uma palavra", "Um procedimento reutilizável com instruções e recursos", "A permissão de administrador de um servidor"], 1,
              "A skill reúne o método de trabalho para executar uma tarefa de forma consistente."),
        .init("multi", "agents", "Sistemas multiagentes", 7,
              "Divida responsabilidades e compare os custos de coordenação.",
              [
                ("Divisão do trabalho", "Uma equipe pode ter agentes com papéis, contextos e ferramentas diferentes. Um orquestrador decide quem recebe cada parte, como os resultados são agregados e quando uma etapa precisa de revisão."),
                ("Topologias de coordenação", "Em série, um agente consome a saída do anterior. Em paralelo, tarefas independentes avançam juntas e depois convergem. Um revisor pode testar afirmações contra fontes, embora agentes que compartilham modelo e dados também possam compartilhar os mesmos erros."),
                ("Contratos e limites", "Defina o formato das mensagens, as responsabilidades, o número máximo de rodadas e critérios para resolver divergências. Compare com um fluxo mais simples usando latência, custo, qualidade e rastreabilidade.")
              ],
              "Para preparar uma aula, um agente revisa as referências enquanto outro revisa clareza. Se a clareza depender do texto corrigido pela primeira revisão, execute as etapas em série.",
              "Distribua os papéis entre três pessoas. Repita a tarefa em série e em paralelo e compare o que se perdeu ou ganhou em cada organização.",
              "Quando rodar dois agentes em paralelo é mais adequado?", ["Quando ambos precisam da saída final do outro", "Quando não há critério de encerramento", "Quando as subtarefas são independentes"], 2,
              "A independência permite sobrepor o trabalho e combinar os resultados depois.", lab: .team),
        .init("operacao", "agents", "Qualidade, supervisão e operação", 7,
              "Defina critérios para acompanhar um agente antes e depois de colocá-lo em uso.",
              [
                ("Avaliar comportamento", "Crie casos com resultados verificáveis. Meça sucesso da tarefa, uso correto das ferramentas, intervenções humanas, custo e tempo. Analise caminhos diferentes até o mesmo resultado para identificar chamadas redundantes ou frágeis."),
                ("Conteúdo e permissões", "Resultados de busca e arquivos são dados externos. O controlador separa esses dados das instruções que governam a aplicação. Limite os recursos disponíveis à tarefa e revise operações que tenham consequências relevantes."),
                ("Observabilidade e recuperação", "Registre chamadas, resultados, aprovações e erros com minimização de dados pessoais. Use limites de execução, recuperação de falhas e caminhos de transferência a pessoas. Monitore mudanças na qualidade quando dados, modelos ou dependências mudarem.")
              ],
              "Em um piloto de biblioteca, use um catálogo simulado para testar livro disponível, livro indisponível, falha de busca e recusa de reserva. Registre a decisão tomada em cada caso.",
              "Peça três exemplos em que o agente deveria parar. Discuta quais sinais e limites o controlador precisaria observar.",
              "Qual caso avalia a supervisão humana?", ["Uma reserva recusada que deve encerrar sem gravação", "A cor do botão de pesquisa", "O número de letras no nome do produto"], 0,
              "O caso verifica se o agente e a aplicação respeitam a decisão humana diante de uma ação com efeito.")
    ]
}
