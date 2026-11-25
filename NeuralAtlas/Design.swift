import SwiftUI

extension Color {
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 255) / 255,
                  green: Double((hex >> 8) & 255) / 255,
                  blue: Double(hex & 255) / 255)
    }
}

enum Palette {
    static let paper = Color(hex: 0xF6F6EE)
    static let sidebar = Color(hex: 0xF0F1E7)
    static let white = Color(hex: 0xFFFFFB)
    static let ink = Color(hex: 0x15251E)
    static let muted = Color(hex: 0x516258)
    static let line = Color(hex: 0xDEE3D5)
    static let forest = Color(hex: 0x12392C)
    static let night = Color(hex: 0x102820)
    static let lime = Color(hex: 0xD9F582)
    static let softGreen = Color(hex: 0xE9F0DB)
    static let warning = Color(hex: 0x8B3A24)
}

extension Module {
    var tint: Color {
        switch id {
        case "ml": Color(hex: 0xE6EFD4)
        case "neural": Color(hex: 0xEAE3F8)
        case "deep": Color(hex: 0xDAEDDF)
        case "llm": Color(hex: 0xF7EACD)
        default: Color(hex: 0xDFEAF6)
        }
    }

    var accent: Color {
        switch id {
        case "ml": Color(hex: 0x395A24)
        case "neural": Color(hex: 0x5C4389)
        case "deep": Color(hex: 0x205D45)
        case "llm": Color(hex: 0x765017)
        default: Color(hex: 0x31597D)
        }
    }
}

extension Catalog {
    static func module(_ id: String) -> Module {
        modules.first { $0.id == id } ?? modules[0]
    }
}

struct AtlasButtonStyle: ButtonStyle {
    var foreground: Color = .white
    var background: Color = Palette.forest

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.subheadline.weight(.semibold))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 17)
            .padding(.vertical, 11)
            .frame(minHeight: 44)
            .foregroundStyle(foreground)
            .background(background.opacity(configuration.isPressed ? 0.82 : 1), in: RoundedRectangle(cornerRadius: 12))
            .contentShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct IconTile: View {
    let icon: String
    let tint: Color
    let accent: Color
    var size: CGFloat = 45

    var body: some View {
        Image(systemName: icon)
            .font(.system(size: size * 0.4, weight: .medium))
            .foregroundStyle(accent)
            .frame(width: size, height: size)
            .background(tint, in: RoundedRectangle(cornerRadius: size * 0.26))
            .accessibilityHidden(true)
    }
}

struct CardSurface: ViewModifier {
    var color = Palette.white
    var radius: CGFloat = 20

    func body(content: Content) -> some View {
        content
            .background(color, in: RoundedRectangle(cornerRadius: radius))
            .overlay {
                RoundedRectangle(cornerRadius: radius)
                    .strokeBorder(Palette.line, lineWidth: 1)
                    .allowsHitTesting(false)
            }
    }
}

extension View {
    func card(color: Color = Palette.white, radius: CGFloat = 20) -> some View {
        modifier(CardSurface(color: color, radius: radius))
    }
}

struct PageHeading: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title)
                .font(.system(.largeTitle, design: .serif))
                .foregroundStyle(Palette.ink)
                .accessibilityAddTraits(.isHeader)
            Text(subtitle)
                .font(.body)
                .foregroundStyle(Palette.muted)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct OrbitArtwork: View {
    private let points: [CGPoint] = [
        .init(x: -0.88, y: -0.36), .init(x: -0.79, y: 0.60),
        .init(x: -0.53, y: -0.80), .init(x: -0.50, y: 0.06),
        .init(x: -0.31, y: 0.80), .init(x: -0.05, y: -0.61),
        .init(x: 0.04, y: 0.06), .init(x: 0.13, y: 0.49),
        .init(x: 0.42, y: -0.87), .init(x: 0.38, y: -0.33),
        .init(x: 0.55, y: 0.10), .init(x: 0.69, y: 0.67),
        .init(x: 0.86, y: -0.47), .init(x: 0.92, y: 0.11)
    ]
    private let edges = [[0,2],[0,3],[0,5],[1,3],[1,4],[1,6],[2,5],[2,6],[3,4],[3,5],[3,6],
                         [4,7],[4,11],[5,6],[5,8],[5,9],[6,7],[6,9],[6,10],[7,10],[7,11],
                         [8,9],[8,12],[9,10],[9,12],[9,13],[10,11],[10,13],[11,13],[12,13]]

    var body: some View {
        Canvas { context, size in
            let unit = min(size.width, size.height)
            let center = CGPoint(x: size.width * 0.50, y: size.height * 0.5)
            let spread = unit * 0.42
            let nodes = points.map { CGPoint(x: center.x + $0.x * spread, y: center.y + $0.y * spread) }
            for ring in 1...6 {
                let radius = spread * CGFloat(ring) / 5
                let rect = CGRect(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2)
                context.stroke(Path(ellipseIn: rect), with: .color(Palette.lime.opacity(0.15)),
                               style: StrokeStyle(lineWidth: 0.6, dash: ring == 6 ? [2, 5] : []))
            }
            for edge in edges {
                var line = Path()
                line.move(to: nodes[edge[0]])
                line.addLine(to: nodes[edge[1]])
                let bright = edge.contains(6)
                context.stroke(line, with: .color(Palette.lime.opacity(bright ? 0.64 : 0.27)), lineWidth: bright ? 1.15 : 0.7)
            }
            for (index, node) in nodes.enumerated() {
                let leading = index == 6 || index == 2 || index == 10
                let radius: CGFloat = index == 6 ? 7 : leading ? 4.5 : 2.5
                if leading {
                    let glow = CGRect(x: node.x - radius * 2.2, y: node.y - radius * 2.2, width: radius * 4.4, height: radius * 4.4)
                    context.fill(Path(ellipseIn: glow), with: .color(Palette.lime.opacity(0.16)))
                }
                let bead = CGRect(x: node.x - radius, y: node.y - radius, width: radius * 2, height: radius * 2)
                context.fill(Path(ellipseIn: bead), with: .color(Palette.lime.opacity(leading ? 1 : 0.63)))
            }
        }
        .accessibilityHidden(true)
        .allowsHitTesting(false)
    }
}
