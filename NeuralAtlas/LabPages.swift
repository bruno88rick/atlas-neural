import SwiftUI
import Charts

struct LabPage: View {
    let lab: Lab
    let back: () -> Void

    var body: some View {
        let module = Catalog.module(lab.module)
        VStack(alignment: .leading, spacing: 18) {
            BackButton(action: back)
            VStack(alignment: .leading, spacing: 13) {
                IconTile(icon: lab.icon, tint: module.tint, accent: module.accent, size: 54)
                PageHeading(title: lab.title, subtitle: lab.blurb)
            }

            switch lab {
            case .regression: RegressionLab()
            case .neuron: NeuronLab()
            case .attention: AttentionLab()
            case .agent: AgentLab()
            case .team: TeamLab()
            }
        }
        .frame(maxWidth: 800, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct RegressionLab: View {
    @State private var model = LinearModel()
    @State private var steps = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            LabPanel {
                HStack {
                    Metric(label: "Erro quadrático médio", value: number(model.loss))
                    Spacer()
                    Metric(label: "Passos de treino", value: String(steps))
                }
                Chart {
                    ForEach([-2.4, 2.4], id: \.self) { x in
                        LineMark(x: .value("Entrada", x), y: .value("Previsão", model.predict(x)))
                            .foregroundStyle(Palette.forest)
                            .lineStyle(StrokeStyle(lineWidth: 3))
                    }
                    ForEach(LinearModel.samples) { point in
                        PointMark(x: .value("Entrada", point.x), y: .value("Valor observado", point.y))
                            .symbolSize(58)
                            .foregroundStyle(Color(hex: 0x5C4389))
                    }
                }
                .chartXScale(domain: -2.6...2.6)
                .chartYScale(domain: -7.0...7.0)
                .chartXAxisLabel("Entrada x")
                .chartYAxisLabel("Valor y")
                .frame(height: 248)
                .accessibilityLabel("Gráfico dos dados e da reta")
                HStack(spacing: 15) {
                    Label("Dados", systemImage: "circle.fill").foregroundStyle(Color(hex: 0x5C4389))
                    Label("Previsão", systemImage: "line.diagonal").foregroundStyle(Palette.forest)
                }
                .font(.caption.weight(.medium))
            }

            LabPanel {
                ParameterSlider(label: "Inclinação", value: $model.slope, range: -2...2)
                ParameterSlider(label: "Intercepto", value: $model.intercept, range: -2...2)
                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 10) { actions }
                    VStack(alignment: .leading, spacing: 8) { actions }
                }
            }
            LabNote(text: "A reta produz ŷ = mx + b. A perda é a média dos quadrados das diferenças entre os pontos e as previsões. Cada passo usa todos os sete pontos para atualizar m e b.")
        }
    }

    @ViewBuilder private var actions: some View {
        Button("Dar um passo") {
            model.trainStep()
            steps += 1
        }
        .buttonStyle(AtlasButtonStyle())
        Button("Reiniciar") {
            model = LinearModel()
            steps = 0
        }
        .buttonStyle(AtlasButtonStyle(foreground: Palette.forest, background: Palette.softGreen))
    }
}

struct NeuronLab: View {
    @State private var model = NeuronModel()

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            LabPanel {
                Text("σ(0,8 × w₁ + 0,4 × w₂ + b)")
                    .font(.system(.title2, design: .monospaced).weight(.medium))
                    .foregroundStyle(Palette.forest)
                    .accessibilityLabel("Sigmoide da soma ponderada mais o viés")
                HStack(spacing: 22) {
                    Metric(label: "Soma ponderada", value: number(model.weightedSum))
                    Metric(label: "Ativação sigmoide", value: number(model.sigmoid))
                }
                ProgressView(value: model.sigmoid)
                    .accessibilityLabel("Ativação sigmoide")
            }

            LabPanel {
                ParameterSlider(label: "Peso da entrada 0,8", value: $model.weightA, range: -3...3)
                ParameterSlider(label: "Peso da entrada 0,4", value: $model.weightB, range: -3...3)
                ParameterSlider(label: "Viés", value: $model.bias, range: -3...3)
                Button("Reiniciar") { model = NeuronModel() }
                    .buttonStyle(AtlasButtonStyle(foreground: Palette.forest, background: Palette.softGreen))
            }
            LabNote(text: "A sigmoide leva a soma a um valor entre zero e um. Uma soma igual a zero produz 0,5. Somatórios muito altos ou baixos aproximam a saída dos extremos.")
        }
    }
}

struct AttentionLab: View {
    @State private var query: AttentionQuery = .garden
    private let keys = ["praça", "árvore", "crédito", "conta"]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            LabPanel {
                Picker("Consulta", selection: $query) {
                    ForEach(AttentionQuery.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Contexto da consulta")
                Text(query == .garden ? "A consulta de «banco» está no contexto de uma praça." :
                        "A consulta de «banco» está num contexto financeiro.")
                    .foregroundStyle(Palette.muted)

                let weights = query.weights
                ForEach(keys.indices, id: \.self) { index in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(keys[index]).font(.subheadline.weight(.semibold))
                            Spacer()
                            Text(weights[index].formatted(.percent.precision(.fractionLength(1)).locale(Locale(identifier: "pt_BR"))))
                                .font(.subheadline.monospacedDigit())
                        }
                        ProgressView(value: weights[index])
                            .tint(index < 2 ? Palette.forest : Color(hex: 0x765017))
                            .accessibilityHidden(true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            LabNote(text: "As pontuações do exemplo são didáticas. O app calcula o softmax dessas pontuações para mostrar como a consulta redistribui os pesos entre as mesmas chaves. Os pesos somam 100% antes do arredondamento.")
        }
    }
}

struct AgentLab: View {
    @State private var trace: [AgentStage] = [.goal]

    var body: some View {
        let current = trace.last ?? .goal
        VStack(alignment: .leading, spacing: 18) {
            LabPanel {
                Text("Histórico da execução").font(.headline).accessibilityAddTraits(.isHeader)
                ForEach(trace) { stage in
                    HStack(alignment: .top, spacing: 11) {
                        IconTile(icon: stage == current ? "circle.inset.filled" : "checkmark",
                                 tint: Palette.softGreen, accent: Palette.forest, size: 33)
                        VStack(alignment: .leading, spacing: 5) {
                            Text(stage.title).font(.subheadline.weight(.semibold))
                            Text(stage.detail).foregroundStyle(Palette.muted)
                        }
                    }
                    .accessibilityElement(children: .combine)
                    .accessibilityAddTraits(stage == current ? .isSelected : [])
                }
                if let next = current.next {
                    Button(next.title) { trace.append(next) }
                        .buttonStyle(AtlasButtonStyle())
                } else if current == .approval {
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 10) { approvalButtons }
                        VStack(alignment: .leading, spacing: 8) { approvalButtons }
                    }
                }
                if trace.count > 1 {
                    Button("Reiniciar simulação") { trace = [.goal] }
                        .buttonStyle(AtlasButtonStyle(foreground: Palette.forest, background: Palette.softGreen))
                }
            }
            LabNote(text: "Esta simulação usa um catálogo fictício. Compare os registros após aprovar e recusar. O estado muda na etapa de reserva somente após a aprovação.")
        }
    }

    @ViewBuilder private var approvalButtons: some View {
        Button("Aprovar reserva") { trace.append(.reserved) }
            .buttonStyle(AtlasButtonStyle())
        Button("Recusar") { trace.append(.declined) }
            .buttonStyle(AtlasButtonStyle(foreground: Palette.forest, background: Palette.softGreen))
    }
}

struct TeamLab: View {
    @State private var mode: TeamMode = .serial

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            LabPanel {
                Picker("Coordenação", selection: $mode) {
                    ForEach(TeamMode.allCases) { item in
                        Text(item.rawValue).tag(item)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Modo de coordenação")
                Metric(label: "Tempo total simulado", value: "\(mode.total) min")

                ForEach(Array(mode.schedule.enumerated()), id: \.element.id) { index, task in
                    let color = [Palette.forest, Color(hex: 0x5C4389), Color(hex: 0x31597D)][index]
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Label(task.title, systemImage: task.icon)
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text("\(task.start)–\(task.start + task.duration) min")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(Palette.muted)
                        }
                        GeometryReader { proxy in
                            let unit = proxy.size.width / 6
                            Capsule().fill(Palette.line)
                            Capsule().fill(color)
                                .frame(width: unit * CGFloat(task.duration))
                                .offset(x: unit * CGFloat(task.start))
                        }
                        .frame(height: 11)
                        .accessibilityHidden(true)
                    }
                    .accessibilityElement(children: .combine)
                }
            }
            LabNote(text: mode == .serial ?
                "A revisão de clareza começa após a checagem de fontes. A consolidação começa quando as duas já terminaram." :
                "As duas revisões começam ao mesmo tempo. A consolidação ainda espera ambas terminarem. Esse arranjo funciona se nenhuma revisão depender do resultado da outra.")
        }
    }
}

private struct LabPanel<Content: View>: View {
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 15) { content }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .card()
    }
}

private struct LabNote: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("O que observar", systemImage: "lightbulb").font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text(text).foregroundStyle(Palette.muted).lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .card(color: Palette.softGreen, radius: 16)
    }
}

private struct Metric: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(label).font(.caption.weight(.medium)).foregroundStyle(Palette.muted)
            Text(value).font(.system(.title2, design: .monospaced).weight(.semibold))
        }
        .accessibilityElement(children: .combine)
    }
}

private struct ParameterSlider: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label).font(.subheadline.weight(.semibold))
                Spacer()
                Text(number(value)).font(.subheadline.monospacedDigit())
            }
            .accessibilityHidden(true)
            Slider(value: $value, in: range, label: { Text(label) })
                .accessibilityValue(number(value))
        }
    }
}

private func number(_ value: Double) -> String {
    value.formatted(.number.precision(.fractionLength(2)).locale(Locale(identifier: "pt_BR")))
}
