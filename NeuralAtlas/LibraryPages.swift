import SwiftUI

struct HomePage: View {
    let progress: LearningProgress
    let roomy: Bool
    let showBrand: Bool
    let open: (AtlasRoute) -> Void
    let select: (AtlasTab) -> Void
    let filter: (String?) -> Void
    @ScaledMetric(relativeTo: .largeTitle) private var heroFont = 46.0

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            if showBrand {
                HStack(spacing: 10) {
                    IconTile(icon: "point.3.connected.trianglepath.dotted",
                             tint: Palette.forest, accent: Palette.lime, size: 35)
                    Text("Atlas Neural")
                        .font(.system(.title2, design: .serif).weight(.semibold))
                        .accessibilityAddTraits(.isHeader)
                }
            }

            hero
            if roomy {
                HStack(alignment: .top, spacing: 21) {
                    modules.frame(maxWidth: .infinity, alignment: .leading)
                    VStack(spacing: 15) {
                        progressCard
                        practiceCard
                    }
                    .frame(width: 270)
                }
            } else {
                modules
                progressCard
                practiceCard
            }
        }
    }

    private var hero: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 7) {
                Circle().fill(Palette.lime).frame(width: 7, height: 7).accessibilityHidden(true)
                Text("DO BÁSICO AOS AGENTES")
                    .font(.caption2.weight(.semibold))
                    .tracking(1.15)
            }
            .foregroundStyle(Palette.lime)

            Text("Entenda a\ninteligência artificial.")
                .font(.system(size: heroFont, design: .serif))
                .foregroundStyle(Palette.white)
                .accessibilityAddTraits(.isHeader)
                .fixedSize(horizontal: false, vertical: true)

            Text("Aprenda como modelos fazem previsões, redes aprendem e agentes colaboram.")
                .font(.subheadline)
                .foregroundStyle(Color(hex: 0xD5E4D9))
                .fixedSize(horizontal: false, vertical: true)

            Button {
                if let lesson = progress.resumeLesson {
                    open(.lesson(lesson.id))
                } else {
                    select(.trail)
                }
            } label: {
                Label(progress.resumeLesson == nil ? "Revisar trilha" :
                    progress.lastLesson == nil ? "Começar a trilha" : "Continuar aprendendo",
                      systemImage: "arrow.right")
            }
            .buttonStyle(AtlasButtonStyle(foreground: Palette.night, background: Palette.lime))
            .padding(.top, 2)
        }
        .frame(maxWidth: roomy ? 495 : 420, alignment: .leading)
        .padding(roomy ? 32 : 22)
        .frame(maxWidth: .infinity, minHeight: roomy ? 306 : 278, alignment: .leading)
        .background {
            ZStack(alignment: .trailing) {
                LinearGradient(colors: [Palette.night, Color(hex: 0x174732)], startPoint: .leading, endPoint: .trailing)
                if roomy {
                    OrbitArtwork().frame(width: 353).padding(.trailing, 10)
                } else {
                    OrbitArtwork().frame(width: 184, height: 184).offset(x: 72, y: -47).opacity(0.33)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 23))
    }

    private var modules: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("Trilha de aprendizado")
                    .font(.system(.title2, design: .serif).weight(.semibold))
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 8)
                Button("Ver trilha") {
                    filter(nil)
                }
                .font(.caption.weight(.semibold))
                .buttonStyle(.plain)
                .foregroundStyle(Palette.forest)
            }
            ForEach(Catalog.modules) { module in
                let lessons = Catalog.lessons(in: module.id)
                Button { filter(module.id) } label: {
                    HStack(spacing: 12) {
                        IconTile(icon: module.icon, tint: module.tint, accent: module.accent)
                        VStack(alignment: .leading, spacing: 4) {
                            Text(module.title).font(.subheadline.weight(.semibold)).foregroundStyle(Palette.ink)
                            Text(module.subtitle).font(.caption).foregroundStyle(Palette.muted)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(lessons.count) lições")
                            .font(.caption2.weight(.medium))
                            .foregroundStyle(Palette.muted)
                        Image(systemName: "chevron.right")
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(Palette.forest)
                            .accessibilityHidden(true)
                    }
                    .padding(10)
                    .card(radius: 15)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var progressCard: some View {
        let count = progress.completedCount
        let total = Catalog.lessons.count
        return VStack(alignment: .leading, spacing: 12) {
            Label("Seu progresso", systemImage: "chart.bar.xaxis")
                .font(.subheadline.weight(.semibold))
                .accessibilityAddTraits(.isHeader)
            HStack(alignment: .firstTextBaseline, spacing: 5) {
                Text("\(count)/\(total)").font(.system(.largeTitle, design: .serif).monospacedDigit())
                Text("lições concluídas").font(.caption).foregroundStyle(Palette.muted)
            }
            .accessibilityElement(children: .combine)
            ProgressView(value: Double(count), total: Double(total))
                .tint(Palette.forest)
                .accessibilityLabel("Progresso da trilha")
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .card()
    }

    private var practiceCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            IconTile(icon: "flask", tint: Palette.white, accent: Palette.forest, size: 38)
            Text("Aprenda na prática")
                .font(.system(.title3, design: .serif).weight(.semibold))
                .accessibilityAddTraits(.isHeader)
            Text("Da primeira previsão ao ciclo completo de um agente.")
                .font(.subheadline)
                .foregroundStyle(Palette.muted)
            Button { select(.lab) } label: {
                Label("Abrir laboratório", systemImage: "arrow.up.right")
            }
            .buttonStyle(.plain)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Palette.forest)
            .frame(minHeight: 34, alignment: .leading)
        }
        .padding(17)
        .frame(maxWidth: .infinity, alignment: .leading)
        .card(color: Palette.softGreen)
    }
}

struct TrailPage: View {
    let progress: LearningProgress
    @Binding var module: String?
    @Binding var savedOnly: Bool
    let open: (AtlasRoute) -> Void

    private var visibleModules: [Module] {
        Catalog.modules.filter { selected in
            (module == nil || module == selected.id) && !lessons(for: selected.id).isEmpty
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 23) {
            PageHeading(title: "Trilha de aprendizado", subtitle: "Estude em sequência ou escolha um tema para explorar e apresentar.")
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 13) { filters }
                VStack(alignment: .leading, spacing: 8) { filters }
            }

            if visibleModules.isEmpty {
                ContentUnavailableView("Nenhuma lição salva", systemImage: "bookmark",
                                       description: Text("Salve uma lição para reencontrá-la aqui."))
                    .frame(maxWidth: .infinity, minHeight: 220)
            }
            ForEach(visibleModules) { group in
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 11) {
                        IconTile(icon: group.icon, tint: group.tint, accent: group.accent)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(group.title)
                                .font(.system(.title2, design: .serif).weight(.semibold))
                                .accessibilityAddTraits(.isHeader)
                            Text(group.subtitle).font(.caption).foregroundStyle(Palette.muted)
                        }
                    }
                    ForEach(lessons(for: group.id)) { lesson in
                        Button { open(.lesson(lesson.id)) } label: {
                            HStack(spacing: 14) {
                                Image(systemName: progress.completed.contains(lesson.id) ? "checkmark.circle.fill" : "circle")
                                    .font(.title3)
                                    .foregroundStyle(group.accent)
                                    .accessibilityLabel(progress.completed.contains(lesson.id) ? "Concluída" : "Pendente")
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(lesson.title).font(.headline).foregroundStyle(Palette.ink)
                                    Text(lesson.summary).font(.subheadline).foregroundStyle(Palette.muted)
                                    Text("\(lesson.minutes) min")
                                        .font(.caption.weight(.medium))
                                        .foregroundStyle(group.accent)
                                        .accessibilityLabel("\(lesson.minutes) minutos")
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                if progress.saved.contains(lesson.id) {
                                    Image(systemName: "bookmark.fill").foregroundStyle(group.accent)
                                        .accessibilityLabel("Salva")
                                }
                                Image(systemName: "chevron.right").font(.caption.weight(.semibold))
                                    .foregroundStyle(Palette.muted).accessibilityHidden(true)
                            }
                            .padding(15).card(radius: 15)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    @ViewBuilder private var filters: some View {
        Menu {
            Button("Todos os módulos") { module = nil }
            ForEach(Catalog.modules) { group in
                Button(group.title) { module = group.id }
            }
        } label: {
            Label(module.map { Catalog.module($0).title } ?? "Todos os módulos", systemImage: "line.3.horizontal.decrease")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 12)
                .frame(minHeight: 43)
                .card(radius: 12)
        }
        .fixedSize(horizontal: true, vertical: false)

        Button {
            savedOnly.toggle()
        } label: {
            Label("Salvas", systemImage: savedOnly ? "bookmark.fill" : "bookmark")
        }
        .buttonStyle(AtlasButtonStyle(foreground: Palette.forest, background: savedOnly ? Palette.lime : Palette.softGreen))
        .accessibilityAddTraits(savedOnly ? .isSelected : [])
    }

    private func lessons(for id: String) -> [Lesson] {
        Catalog.lessons(in: id).filter { !savedOnly || progress.saved.contains($0.id) }
    }
}

struct LabDirectory: View {
    let open: (AtlasRoute) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 21) {
            PageHeading(title: "Laboratório", subtitle: "Mude parâmetros, teste decisões e observe o resultado em cinco simulações.")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 265), spacing: 15, alignment: .top)], spacing: 15) {
                ForEach(Lab.allCases) { lab in
                    let module = Catalog.module(lab.module)
                    Button { open(.lab(lab)) } label: {
                        VStack(alignment: .leading, spacing: 11) {
                            HStack {
                                IconTile(icon: lab.icon, tint: module.tint, accent: module.accent)
                                Spacer()
                                Image(systemName: "arrow.up.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(Palette.muted)
                                    .accessibilityHidden(true)
                            }
                            Text(lab.title).font(.headline).foregroundStyle(Palette.ink)
                            Text(lab.blurb).font(.subheadline).foregroundStyle(Palette.muted)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(16)
                        .frame(maxWidth: .infinity, minHeight: 157, alignment: .topLeading)
                        .card()
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct GlossaryPage: View {
    @Binding var query: String
    let open: (AtlasRoute) -> Void

    var body: some View {
        let results = Catalog.searchGlossary(query)
        VStack(alignment: .leading, spacing: 17) {
            PageHeading(title: "Glossário", subtitle: "Busque termos e abra a lição associada para aprofundar.")
            HStack(spacing: 11) {
                Image(systemName: "magnifyingglass").foregroundStyle(Palette.muted).accessibilityHidden(true)
                TextField("Buscar por termo ou definição", text: $query)
                    .textFieldStyle(.plain)
                    .accessibilityLabel("Buscar no glossário")
                if !query.isEmpty {
                    Button { query = "" } label: {
                        Image(systemName: "xmark.circle.fill")
                            .frame(minWidth: 32, minHeight: 32)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Limpar busca")
                }
            }
            .padding(.horizontal, 14)
            .frame(minHeight: 48)
            .card(radius: 13)

            if results.isEmpty {
                ContentUnavailableView("Nenhum termo encontrado", systemImage: "magnifyingglass",
                                       description: Text("Tente uma sigla, um tema ou uma palavra da definição."))
                    .frame(maxWidth: .infinity, minHeight: 220)
            } else {
                LazyVStack(spacing: 9) {
                    ForEach(results) { entry in
                        Button { open(.lesson(entry.lesson)) } label: {
                            HStack(spacing: 17) {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(entry.term).font(.headline).foregroundStyle(Palette.ink)
                                    Text(entry.definition).font(.subheadline).foregroundStyle(Palette.muted)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "arrow.up.right").font(.caption.weight(.semibold))
                                    .foregroundStyle(Palette.forest).accessibilityHidden(true)
                            }
                            .padding(15).card(radius: 15)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Abre a lição associada")
                    }
                }
            }
        }
    }
}
