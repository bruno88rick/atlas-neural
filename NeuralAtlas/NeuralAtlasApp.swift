import SwiftUI
import Observation

@main
struct NeuralAtlasApp: App {
    @State private var store = ProgressStore()

    var body: some Scene {
        WindowGroup {
            AtlasRoot(store: store)
                .preferredColorScheme(.light)
        }
        #if os(macOS)
        .defaultSize(width: 1200, height: 850)
        #endif
    }
}

@Observable
final class ProgressStore {
    private let defaults: UserDefaults
    private let key = "neural-atlas.progress.v1"
    var progress: LearningProgress {
        didSet {
            if let data = try? JSONEncoder().encode(progress) { defaults.set(data, forKey: key) }
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let data = defaults.data(forKey: "neural-atlas.progress.v1")
        progress = data.flatMap { try? JSONDecoder().decode(LearningProgress.self, from: $0) } ?? LearningProgress()
    }
}

enum AtlasTab: String, CaseIterable, Identifiable {
    case home = "Início", trail = "Trilha", lab = "Laboratório", glossary = "Glossário"
    var id: Self { self }

    var icon: String {
        switch self {
        case .home: "house"
        case .trail: "books.vertical"
        case .lab: "flask"
        case .glossary: "character.book.closed"
        }
    }
}

enum AtlasRoute: Hashable {
    case lesson(String), lab(Lab), present(String)
}

struct AtlasRoot: View {
    let store: ProgressStore
    @Environment(\.dynamicTypeSize) private var typeSize
    @State private var tab: AtlasTab = .home
    @State private var path: [AtlasRoute] = []
    @State private var moduleFilter: String?
    @State private var savedOnly = false
    @State private var glossaryQuery = ""

    private var presenting: Bool {
        if case .present = path.last { return true }
        return false
    }

    var body: some View {
        GeometryReader { geometry in
            let wide = geometry.size.width >= 820
            let sidebarWidth: CGFloat = 209
            let available = geometry.size.width - (wide && !presenting ? sidebarWidth : 0)
            let padding: CGFloat = available >= 600 ? 29 : 18
            HStack(spacing: 0) {
                if wide && !presenting {
                    sidebar.frame(width: sidebarWidth)
                    Rectangle().fill(Palette.line).frame(width: 1)
                }
                NavigationStack(path: $path) {
                    scrollPage(padding: padding) {
                        tabContent(roomy: available >= 780 && !typeSize.isAccessibilitySize, showBrand: !wide)
                    }
                    .atlasNavigationHidden()
                    .navigationDestination(for: AtlasRoute.self) { route in
                        switch route {
                        case .lesson(let id):
                            if let lesson = Catalog.lessons.first(where: { $0.id == id }) {
                                scrollPage(padding: padding) {
                                    LessonPage(lesson: lesson, store: store, back: goBack, open: open)
                                }
                                .atlasNavigationHidden()
                            }
                        case .lab(let lab):
                            scrollPage(padding: padding) { LabPage(lab: lab, back: goBack) }
                                .atlasNavigationHidden()
                        case .present(let id):
                            if let lesson = Catalog.lessons.first(where: { $0.id == id }) {
                                PresentationPage(lesson: lesson, close: goBack)
                                    .atlasNavigationHidden()
                            }
                        }
                    }
                }
                .safeAreaInset(edge: .bottom, spacing: 0) {
                    if !wide && !presenting && path.isEmpty { bottomBar }
                }
            }
        }
        .background(Palette.paper.ignoresSafeArea())
        .foregroundStyle(Palette.ink)
        .tint(Palette.forest)
    }

    private var sidebar: some View {
        VStack(alignment: .leading, spacing: 25) {
            brand
                .padding(.horizontal, 9)
            VStack(spacing: 5) {
                ForEach(AtlasTab.allCases) { item in
                    Button { select(item) } label: {
                        Label(item.rawValue, systemImage: item.icon)
                            .font(.subheadline.weight(tab == item ? .semibold : .medium))
                            .foregroundStyle(tab == item ? Palette.forest : Palette.muted)
                            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                            .padding(.horizontal, 12)
                            .background(tab == item ? Palette.softGreen : .clear, in: RoundedRectangle(cornerRadius: 12))
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(tab == item ? .isSelected : [])
                }
            }
            Spacer(minLength: 0)
            VStack(alignment: .leading, spacing: 9) {
                Text("Seu progresso").font(.subheadline.weight(.semibold))
                ProgressView(value: Double(store.progress.completedCount), total: Double(Catalog.lessons.count))
                    .tint(Palette.forest)
                    .accessibilityLabel("Progresso da trilha")
                Text("\(store.progress.completedCount) de \(Catalog.lessons.count) lições")
                    .font(.caption)
                    .foregroundStyle(Palette.muted)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .card(radius: 14)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 24)
        .frame(maxHeight: .infinity, alignment: .topLeading)
        .background(Palette.sidebar.ignoresSafeArea())
    }

    private var brand: some View {
        HStack(spacing: 10) {
            IconTile(icon: "point.3.connected.trianglepath.dotted", tint: Palette.forest, accent: Palette.lime, size: 38)
            VStack(alignment: .leading, spacing: 1) {
                Text("Atlas Neural").font(.system(.title3, design: .serif).weight(.semibold))
                Text("Aprendizado de IA").font(.caption).foregroundStyle(Palette.muted)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var bottomBar: some View {
        VStack(spacing: 0) {
            Rectangle().fill(Palette.line).frame(height: 1)
            HStack(spacing: 1) {
                ForEach(AtlasTab.allCases) { item in
                    Button { select(item) } label: {
                        VStack(spacing: 4) {
                            Image(systemName: item.icon).font(.system(size: 17, weight: .medium))
                            Text(item.rawValue)
                                .font(.caption2.weight(tab == item ? .bold : .medium))
                                .lineLimit(1)
                                .minimumScaleFactor(0.7)
                        }
                        .frame(maxWidth: .infinity, minHeight: 49)
                        .foregroundStyle(tab == item ? Palette.forest : Palette.muted)
                        .background(tab == item ? Palette.softGreen : .clear, in: RoundedRectangle(cornerRadius: 12))
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(tab == item ? .isSelected : [])
                }
            }
            .padding(.horizontal, 9)
            .padding(.top, 5)
        }
        .background(Palette.white.ignoresSafeArea(edges: .bottom))
    }

    private func scrollPage<Content: View>(padding: CGFloat, @ViewBuilder content: () -> Content) -> some View {
        ScrollView {
            content()
                .frame(maxWidth: 1100, alignment: .leading)
                .padding(.horizontal, padding)
                .padding(.vertical, padding)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .background(Palette.paper.ignoresSafeArea())
    }

    @ViewBuilder private func tabContent(roomy: Bool, showBrand: Bool) -> some View {
        switch tab {
        case .home:
            HomePage(progress: store.progress, roomy: roomy, showBrand: showBrand, open: open, select: select) { module in
                moduleFilter = module
                savedOnly = false
                select(.trail)
            }
        case .trail:
            TrailPage(progress: store.progress, module: $moduleFilter, savedOnly: $savedOnly, open: open)
        case .lab:
            LabDirectory(open: open)
        case .glossary:
            GlossaryPage(query: $glossaryQuery, open: open)
        }
    }

    private func select(_ destination: AtlasTab) {
        path.removeAll()
        tab = destination
    }

    private func open(_ route: AtlasRoute) {
        if case .lesson(let id) = route { store.progress.lastLesson = id }
        path.append(route)
    }

    private func goBack() {
        if !path.isEmpty { path.removeLast() }
    }
}

extension View {
    @ViewBuilder func atlasNavigationHidden() -> some View {
        #if os(iOS)
        toolbar(.hidden, for: .navigationBar)
        #else
        self
        #endif
    }
}
