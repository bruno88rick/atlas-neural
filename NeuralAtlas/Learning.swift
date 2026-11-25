import Foundation

struct LearningProgress: Codable, Equatable {
    var completed: Set<String> = []
    var saved: Set<String> = []
    var lastLesson: String?

    var completedCount: Int { Catalog.lessons.filter { completed.contains($0.id) }.count }

    var resumeLesson: Lesson? {
        if let lastLesson, let lesson = Catalog.lessons.first(where: { $0.id == lastLesson }),
           !completed.contains(lastLesson) {
            return lesson
        }
        return Catalog.lessons.first { !completed.contains($0.id) }
    }

    mutating func toggleSaved(_ id: String) {
        if saved.remove(id) == nil { saved.insert(id) }
    }
}

struct PointSample: Identifiable {
    let x: Double
    let y: Double
    var id: Double { x }
}

struct LinearModel {
    static let samples = [
        PointSample(x: -2, y: -1.8), PointSample(x: -1.2, y: -0.9),
        PointSample(x: -0.5, y: 0.2), PointSample(x: 0.4, y: 0.75),
        PointSample(x: 1.1, y: 2.1), PointSample(x: 1.7, y: 2.6),
        PointSample(x: 2.2, y: 3.35)
    ]

    var slope = 0.15
    var intercept = 0.0

    func predict(_ x: Double) -> Double { slope * x + intercept }

    var loss: Double {
        Self.samples.reduce(0) { total, point in
            let residual = predict(point.x) - point.y
            return total + residual * residual
        } / Double(Self.samples.count)
    }

    mutating func trainStep() {
        let gradient = Self.samples.reduce(into: (slope: 0.0, intercept: 0.0)) { gradient, point in
            let residual = predict(point.x) - point.y
            gradient.slope += residual * point.x
            gradient.intercept += residual
        }
        let scale = 0.32 / Double(Self.samples.count)
        slope = min(2, max(-2, slope - scale * gradient.slope))
        intercept = min(2, max(-2, intercept - scale * gradient.intercept))
    }
}

struct NeuronModel {
    var weightA = 1.2
    var weightB = -0.5
    var bias = -0.3
    var weightedSum: Double { 0.8 * weightA + 0.4 * weightB + bias }
    var sigmoid: Double { 1 / (1 + exp(-weightedSum)) }
}

enum AttentionQuery: String, CaseIterable, Identifiable {
    case garden = "Praça"
    case finance = "Finanças"
    var id: Self { self }

    var weights: [Double] {
        // Illustrative dot-product scores, not values extracted from a trained Transformer.
        let scores = self == .garden ? [2.3, 1.5, -0.7, -0.4] : [-0.7, -0.5, 2.5, 1.6]
        let maxScore = scores.max() ?? 0
        let exponents = scores.map { exp($0 - maxScore) }
        let total = exponents.reduce(0, +)
        return exponents.map { $0 / total }
    }
}

enum AgentStage: Int, CaseIterable, Identifiable {
    case goal, search, observe, approval, reserved, declined
    var id: Self { self }
    var title: String {
        switch self {
        case .goal: "Definir o objetivo"
        case .search: "Consultar o catálogo"
        case .observe: "Analisar a resposta"
        case .approval: "Pedir aprovação"
        case .reserved: "Reserva simulada"
        case .declined: "Execução encerrada"
        }
    }
    var detail: String {
        switch self {
        case .goal: "Encontrar um livro introdutório sobre IA com retirada nesta semana."
        case .search: "O agente envia assunto e prazo à ferramenta de busca."
        case .observe: "A busca retorna dois livros. Apenas IA para curiosos tem um exemplar disponível no prazo."
        case .approval: "Reservar altera o estado do catálogo. O agente apresenta livro e prazo e aguarda uma decisão."
        case .reserved: "A ferramenta simulada registra a reserva de IA para curiosos até sexta-feira."
        case .declined: "O agente encerra a tarefa e mantém a disponibilidade no catálogo."
        }
    }
    var next: Self? {
        switch self {
        case .goal: .search
        case .search: .observe
        case .observe: .approval
        case .approval, .reserved, .declined: nil
        }
    }
}

enum TeamMode: String, CaseIterable, Identifiable {
    case serial = "Em série"
    case parallel = "Em paralelo"
    var id: Self { self }
    var schedule: [TeamTask] {
        [
            TeamTask(title: "Checar fontes", icon: "text.magnifyingglass", start: 0, duration: 3),
            TeamTask(title: "Revisar clareza", icon: "pencil.line", start: self == .serial ? 3 : 0, duration: 2),
            TeamTask(title: "Consolidar", icon: "doc.text", start: self == .serial ? 5 : 3, duration: 1)
        ]
    }
    var total: Int { schedule.map { $0.start + $0.duration }.max() ?? 0 }
}

struct TeamTask: Identifiable {
    let title: String
    let icon: String
    let start: Int
    let duration: Int
    var id: String { title }
}

struct GlossaryEntry: Identifiable {
    let term: String
    let definition: String
    let lesson: String
    var id: String { term }
}

extension Catalog {
    static let glossary = [
        GlossaryEntry(term: "Agente", definition: "Sistema que escolhe ações em função de uma meta e revisa o próximo passo após observar os resultados.", lesson: "agente"),
        GlossaryEntry(term: "Amostragem", definition: "Escolha de uma saída segundo uma distribuição de probabilidades. Em LLMs, pode ser aplicada a cada novo token.", lesson: "llms"),
        GlossaryEntry(term: "Aprendizado por reforço", definition: "Ajuste de uma política de ações a partir das recompensas de um ambiente.", lesson: "paradigmas"),
        GlossaryEntry(term: "Atenção", definition: "Mecanismo que combina vetores de valor com pesos dependentes da consulta e das chaves.", lesson: "atencao"),
        GlossaryEntry(term: "Ativação", definition: "Função que transforma a soma ponderada de um neurônio. ReLU e sigmoide são exemplos.", lesson: "neuronio"),
        GlossaryEntry(term: "Avaliação", definition: "Medição de desempenho com casos, critérios e dados definidos de acordo com a tarefa.", lesson: "adaptacao"),
        GlossaryEntry(term: "Camada", definition: "Etapa de uma rede que transforma entradas em uma nova representação.", lesson: "profundidade"),
        GlossaryEntry(term: "CNN", definition: "Rede neural convolucional. Usa filtros compartilhados para detectar padrões locais em posições diferentes.", lesson: "arquiteturas"),
        GlossaryEntry(term: "Deep Learning", definition: "Aprendizado de máquina com redes neurais que compõem várias camadas de transformação.", lesson: "profundidade"),
        GlossaryEntry(term: "Embeddings", definition: "Vetores aprendidos que representam itens como palavras, documentos ou imagens.", lesson: "rag"),
        GlossaryEntry(term: "Época", definition: "Uma passagem pelo conjunto de exemplos de treino.", lesson: "backprop"),
        GlossaryEntry(term: "Ferramenta", definition: "Operação com um contrato de chamada que permite a um agente consultar um sistema ou solicitar uma ação.", lesson: "tools"),
        GlossaryEntry(term: "Fine-tuning", definition: "Ajuste de alguns ou todos os pesos de um modelo pré-treinado, feito com dados de uma nova tarefa.", lesson: "adaptacao"),
        GlossaryEntry(term: "Generalização", definition: "Capacidade de manter um bom desempenho em exemplos novos.", lesson: "treino"),
        GlossaryEntry(term: "Gradiente", definition: "Vetor de derivadas que indica como a perda varia localmente com os parâmetros.", lesson: "backprop"),
        GlossaryEntry(term: "IA generativa", definition: "Sistemas que produzem saídas como texto, imagens ou áudio a partir de um contexto.", lesson: "llms"),
        GlossaryEntry(term: "Inferência", definition: "Uso de um modelo treinado para produzir uma previsão ou saída.", lesson: "llms"),
        GlossaryEntry(term: "Janela de contexto", definition: "Limite de tokens que um modelo pode usar em um processamento.", lesson: "llms"),
        GlossaryEntry(term: "LLM", definition: "Modelo de linguagem de grande escala. Um objetivo de treinamento comum é prever o próximo token.", lesson: "llms"),
        GlossaryEntry(term: "Machine Learning", definition: "Métodos que ajustam modelos a partir de dados para identificar padrões ou tomar decisões.", lesson: "mapa"),
        GlossaryEntry(term: "MCP", definition: "Model Context Protocol. Protocolo para fornecer ferramentas, recursos e prompts a aplicações clientes.", lesson: "tools"),
        GlossaryEntry(term: "Orquestração", definition: "Coordenação de tarefas, dependências, mensagens e condições de parada entre componentes.", lesson: "multi"),
        GlossaryEntry(term: "Perda", definition: "Medida numérica do desvio entre a saída de um modelo e o objetivo de treinamento.", lesson: "treino"),
        GlossaryEntry(term: "Prompt", definition: "Entrada que fornece uma tarefa, instruções ou exemplos a um modelo generativo.", lesson: "adaptacao"),
        GlossaryEntry(term: "RAG", definition: "Geração aumentada por recuperação. Inclui material recuperado de fontes no contexto do modelo.", lesson: "rag"),
        GlossaryEntry(term: "Rede neural", definition: "Modelo que organiza transformações parametrizadas em camadas conectadas.", lesson: "neuronio"),
        GlossaryEntry(term: "Retropropagação", definition: "Cálculo eficiente dos gradientes usando a regra da cadeia da saída em direção às operações anteriores.", lesson: "backprop"),
        GlossaryEntry(term: "Skill", definition: "Pacote reutilizável de instruções e recursos para conduzir uma tarefa recorrente.", lesson: "skills"),
        GlossaryEntry(term: "Sobreajuste", definition: "Ajuste excessivo a particularidades dos dados de treino, com perda de qualidade em exemplos novos.", lesson: "treino"),
        GlossaryEntry(term: "Softmax", definition: "Transformação de pontuações em valores positivos que somam um.", lesson: "atencao"),
        GlossaryEntry(term: "Token", definition: "Unidade em que um tokenizador divide uma entrada, como uma palavra ou um fragmento.", lesson: "llms"),
        GlossaryEntry(term: "Transformer", definition: "Arquitetura que combina mecanismos de atenção, transformações por posição e informações sobre ordem.", lesson: "atencao"),
        GlossaryEntry(term: "Validação", definition: "Uso de dados separados do treino para ajustar configurações e comparar alternativas.", lesson: "treino")
    ]

    static func searchGlossary(_ query: String) -> [GlossaryEntry] {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        return glossary.sorted { $0.term.localizedStandardCompare($1.term) == .orderedAscending }
            .filter {
                query.isEmpty || $0.term.localizedStandardContains(query) || $0.definition.localizedStandardContains(query)
            }
    }
}
