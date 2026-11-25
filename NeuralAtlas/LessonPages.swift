import SwiftUI

struct BackButton: View {
    var title = "Voltar"
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: "arrow.left")
                .font(.subheadline.weight(.semibold))
                .padding(.trailing, 10)
                .frame(minHeight: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .foregroundStyle(Palette.forest)
        .keyboardShortcut(.cancelAction)
    }
}

struct LessonPage: View {
    let lesson: Lesson
    let store: ProgressStore
    let back: () -> Void
    let open: (AtlasRoute) -> Void

    private var module: Module { Catalog.module(lesson.module) }
    private var isSaved: Bool { store.progress.saved.contains(lesson.id) }
    private var isCompleted: Bool { store.progress.completed.contains(lesson.id) }
    private var nextLesson: Lesson? {
        guard let index = Catalog.lessons.firstIndex(of: lesson) else { return nil }
        return Catalog.lessons.dropFirst(index + 1).first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                BackButton(action: back)
                Spacer()
                Button { store.progress.toggleSaved(lesson.id) } label: {
                    Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(module.accent)
                        .frame(width: 44, height: 44)
                        .background(module.tint, in: RoundedRectangle(cornerRadius: 12))
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(isSaved ? "Remover lição das salvas" : "Salvar lição")
                .help(isSaved ? "Remover lição das salvas" : "Salvar lição")
            }

            VStack(alignment: .leading, spacing: 13) {
                Label(module.title, systemImage: module.icon)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(module.accent)
                PageHeading(title: lesson.title, subtitle: lesson.summary)
                Label("\(lesson.minutes) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundStyle(Palette.muted)
                    .accessibilityLabel("\(lesson.minutes) minutos")
                Button { open(.present(lesson.id)) } label: {
                    Label("Apresentar lição", systemImage: "play.rectangle")
                }
                .buttonStyle(AtlasButtonStyle())
            }
            .padding(19)
            .frame(maxWidth: .infinity, alignment: .leading)
            .card(color: module.tint)

            VStack(alignment: .leading, spacing: 20) {
                ForEach(lesson.sections, id: \.title) { section in
                    VStack(alignment: .leading, spacing: 7) {
                        Text(section.title).font(.title3.weight(.semibold))
                            .accessibilityAddTraits(.isHeader)
                        Text(section.text)
                            .foregroundStyle(Palette.muted)
                            .lineSpacing(5)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .card()

            note("Na prática", icon: "lightbulb", text: lesson.example)
            note("Como explicar", icon: "bubble.left.and.bubble.right", text: lesson.explain)

            if let lab = lesson.lab {
                Button { open(.lab(lab)) } label: {
                    Label(lab.title, systemImage: "flask")
                }
                .buttonStyle(AtlasButtonStyle(foreground: Palette.forest, background: Palette.softGreen))
                .accessibilityHint("Abre um laboratório interativo")
            }

            LessonQuiz(quiz: lesson.quiz)
                .id(lesson.id)

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) { completionActions }
                VStack(alignment: .leading, spacing: 10) { completionActions }
            }
        }
        .frame(maxWidth: 770, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .center)
    }

    private func note(_ title: String, icon: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: icon)
                .font(.headline)
                .foregroundStyle(module.accent)
                .accessibilityAddTraits(.isHeader)
            Text(text).foregroundStyle(Palette.ink).lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .card(color: module.tint.opacity(0.64), radius: 16)
    }

    @ViewBuilder private var completionActions: some View {
        Button {
            if isCompleted {
                store.progress.completed.remove(lesson.id)
            } else {
                store.progress.completed.insert(lesson.id)
            }
        } label: {
            Label(isCompleted ? "Lição concluída" : "Marcar como concluída",
                  systemImage: isCompleted ? "checkmark.circle.fill" : "checkmark.circle")
        }
        .buttonStyle(AtlasButtonStyle(foreground: isCompleted ? Palette.forest : .white,
                                    background: isCompleted ? Palette.softGreen : Palette.forest))
        .accessibilityHint(isCompleted ? "Toque para marcar como pendente" : "Adiciona a lição ao seu progresso")
        .accessibilityAddTraits(isCompleted ? .isSelected : [])
        if let nextLesson {
            Button { open(.lesson(nextLesson.id)) } label: {
                Label("Próxima lição", systemImage: "arrow.right")
            }
            .buttonStyle(AtlasButtonStyle(foreground: Palette.forest, background: Palette.softGreen))
        }
    }
}

struct LessonQuiz: View {
    let quiz: Lesson.Quiz
    @State private var choice: Int?
    @State private var checked = false

    private var isCorrect: Bool { choice == quiz.answer }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Teste seu entendimento", systemImage: "checkmark.seal")
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text(quiz.prompt).font(.body.weight(.semibold))
            ForEach(quiz.options.indices, id: \.self) { index in
                Button {
                    choice = index
                    checked = false
                } label: {
                    HStack(alignment: .top, spacing: 10) {
                        Image(systemName: icon(for: index))
                            .foregroundStyle(checked && index == choice && !isCorrect ? Palette.warning : Palette.forest)
                            .accessibilityHidden(true)
                        Text(quiz.options[index])
                            .foregroundStyle(Palette.ink)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 11)
                    .frame(minHeight: 44)
                    .card(color: choice == index ? Palette.softGreen : Palette.white, radius: 11)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(choice == index ? .isSelected : [])
            }

            Button("Verificar resposta") { checked = true }
                .buttonStyle(AtlasButtonStyle(foreground: choice == nil || checked ? Palette.muted : .white,
                                             background: choice == nil || checked ? Palette.softGreen : Palette.forest))
                .disabled(choice == nil || checked)

            if checked {
                VStack(alignment: .leading, spacing: 6) {
                    Label(isCorrect ? "Resposta correta" : "Revise sua escolha",
                          systemImage: isCorrect ? "checkmark.circle.fill" : "exclamationmark.circle")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(isCorrect ? Palette.forest : Palette.warning)
                    if !isCorrect {
                        Text("Resposta correta: \(quiz.options[quiz.answer])").font(.subheadline.weight(.semibold))
                    }
                    Text(quiz.feedback).font(.subheadline).foregroundStyle(Palette.muted)
                }
                .accessibilityElement(children: .combine)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .card()
    }

    private func icon(for index: Int) -> String {
        if checked && index == quiz.answer { return "checkmark.circle.fill" }
        if checked && index == choice { return "xmark.circle.fill" }
        return index == choice ? "largecircle.fill.circle" : "circle"
    }
}

struct PresentationPage: View {
    let lesson: Lesson
    let close: () -> Void
    @State private var position = 0
    @State private var revealAnswer = false
    @ScaledMetric(relativeTo: .largeTitle) private var titleSize = 52.0
    @ScaledMetric(relativeTo: .title2) private var bodySize = 26.0

    private var slides: [Slide] {
        [
            Slide(kind: Catalog.module(lesson.module).title, title: lesson.title, detail: lesson.summary)
        ] + lesson.sections.map { Slide(kind: "Conceito", title: $0.title, detail: $0.text) } + [
            Slide(kind: "Aplicação", title: "Na prática", detail: lesson.example),
            Slide(kind: "Discussão", title: "Como explicar", detail: lesson.explain),
            Slide(kind: "Quiz", title: lesson.quiz.prompt, detail: "")
        ]
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: close) { Label("Sair", systemImage: "xmark") }
                    .buttonStyle(AtlasButtonStyle(foreground: Palette.white, background: .white.opacity(0.12)))
                    .keyboardShortcut(.cancelAction)
                    .accessibilityLabel("Sair da apresentação")
                Spacer()
                Text("\(position + 1) de \(slides.count)")
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(Palette.lime)
                    .accessibilityLabel("Tela \(position + 1) de \(slides.count)")
            }
            .padding(.horizontal, 21)
            .padding(.vertical, 12)

            ScrollView {
                let slide = slides[position]
                VStack(alignment: .leading, spacing: 18) {
                    Text(slide.kind.uppercased())
                        .font(.caption.weight(.semibold))
                        .tracking(1.5)
                        .foregroundStyle(Palette.lime)
                    Text(slide.title)
                        .font(.system(size: titleSize, design: .serif))
                        .accessibilityAddTraits(.isHeader)
                    if position == slides.count - 1 {
                        ForEach(lesson.quiz.options.indices, id: \.self) { index in
                            Text("\(index + 1). \(lesson.quiz.options[index])")
                                .font(.system(size: bodySize))
                                .foregroundStyle(revealAnswer && index == lesson.quiz.answer ? Palette.lime : Palette.white)
                        }
                        Button(revealAnswer ? "Ocultar resposta" : "Revelar resposta") { revealAnswer.toggle() }
                            .buttonStyle(AtlasButtonStyle(foreground: Palette.night, background: Palette.lime))
                        if revealAnswer {
                            Text(lesson.quiz.feedback).font(.title3).foregroundStyle(Palette.lime)
                        }
                    } else {
                        Text(slide.detail)
                            .font(.system(size: bodySize))
                            .foregroundStyle(Color(hex: 0xE1EAE2))
                            .lineSpacing(7)
                    }
                }
                .foregroundStyle(Palette.white)
                .frame(maxWidth: 850, alignment: .leading)
                .padding(.vertical, 25)
                .padding(.horizontal, 24)
                .frame(maxWidth: .infinity)
            }
            .id(position)

            HStack(spacing: 13) {
                Button { move(-1) } label: {
                    Label("Anterior", systemImage: "arrow.left")
                }
                .buttonStyle(AtlasButtonStyle(foreground: Palette.white, background: .white.opacity(position == 0 ? 0.06 : 0.14)))
                .keyboardShortcut(.leftArrow, modifiers: [])
                .disabled(position == 0)

                Spacer(minLength: 0)

                Button {
                    if position == slides.count - 1 { close() } else { move(1) }
                } label: {
                    Label(position == slides.count - 1 ? "Encerrar" : "Próxima", systemImage: "arrow.right")
                }
                .buttonStyle(AtlasButtonStyle(foreground: Palette.night, background: Palette.lime))
                .keyboardShortcut(.rightArrow, modifiers: [])
            }
            .padding(.horizontal, 21)
            .padding(.vertical, 14)
        }
        .background {
            ZStack(alignment: .bottomTrailing) {
                LinearGradient(colors: [Palette.night, Palette.forest], startPoint: .topLeading, endPoint: .bottomTrailing)
                OrbitArtwork().frame(width: 260, height: 260).offset(x: 75, y: 40).opacity(0.21)
            }
            .ignoresSafeArea()
        }
    }

    private func move(_ delta: Int) {
        position = min(max(0, position + delta), slides.count - 1)
        revealAnswer = false
    }

    private struct Slide {
        let kind: String
        let title: String
        let detail: String
    }
}
