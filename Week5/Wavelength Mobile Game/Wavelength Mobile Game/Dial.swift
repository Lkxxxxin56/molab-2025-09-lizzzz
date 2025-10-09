import SwiftUI
import Combine

// MARK: - Dial (auto-oscillating pointer with Pause on tap/space)
struct Dial: View {
    @Binding var guessDeg: Double

    private let minDeg: Double = 0       // use (180, 360) for top half
    private let maxDeg: Double = 180
    private let degPerSec: Double = 60

    @State private var direction: Double = 1
    @State private var isPaused: Bool = false

    private let ticker = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let center = CGPoint(x: w/2, y: h*0.75)
            let radius = min(w, h) * 0.45

            ZStack {
                // bottom semicircle
                Semicircle(center: center, radius: radius, startDeg: 0, endDeg: 180, clockwise: false)
                    .fill(Color.red.opacity(0.5))
                    .overlay(
                        Semicircle(center: center, radius: radius, startDeg: 0, endDeg: 180, clockwise: false)
                            .stroke(Color.black.opacity(0.25), lineWidth: 2)
                    )

                Pointer(center: center, radius: radius, angleDeg: guessDeg)
                    .stroke(isPaused ? .gray : .blue, lineWidth: 4)

                // Pause badge
                if isPaused {
                    Text("Paused")
                        .font(.caption).bold()
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .offset(y: -h*0.28)
                }

                // Spacebar support (also clickable)
                Button(isPaused ? "Resume (Space)" : "Pause (Space)") {
                    isPaused.toggle()
                }
                .buttonStyle(.bordered)
                .keyboardShortcut(.space)    // Spacebar toggles pause (macOS / iPad keyboard)
                .offset(y: h*0.20)
            }
            // Tap/click anywhere on dial to toggle pause
            .contentShape(Rectangle())
            .onTapGesture { isPaused.toggle() }
            .onAppear {
                guessDeg = min(max(guessDeg, minDeg), maxDeg)
                direction = 1
            }
            .onReceive(ticker) { _ in
                guard !isPaused else { return }
                stepAngle(dt: 1/60)
            }
        }
    }

    private func stepAngle(dt: Double) {
        guessDeg += direction * degPerSec * dt
        if guessDeg >= maxDeg {
            guessDeg = maxDeg; direction = -1
        } else if guessDeg <= minDeg {
            guessDeg = minDeg; direction = 1
        }
    }
}

// MARK: - Shapes
struct Semicircle: Shape {
    let center: CGPoint
    let radius: CGFloat
    let startDeg: Double
    let endDeg: Double
    let clockwise: Bool

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: center)
        p.addArc(center: center,
                 radius: radius,
                 startAngle: .degrees(startDeg),
                 endAngle: .degrees(endDeg),
                 clockwise: clockwise)
        p.closeSubpath()
        return p
    }
}

struct Pointer: Shape {
    let center: CGPoint
    let radius: CGFloat
    let angleDeg: Double

    func path(in rect: CGRect) -> Path {
        let r = angleDeg * .pi / 180
        let end = CGPoint(x: center.x + radius * CGFloat(cos(r)),
                          y: center.y + radius * CGFloat(sin(r)))
        var p = Path()
        p.move(to: center)
        p.addLine(to: end)
        return p
    }
}
