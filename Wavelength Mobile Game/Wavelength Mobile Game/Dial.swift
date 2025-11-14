import SwiftUI
import Combine

// MARK: - Dial (auto-oscillating pointer with Pause on tap/space)
struct Dial: View {
    @Binding var guessDeg: Double
    // use (180, 360) for top half or (0, 180) for bottom half
    private let minDeg: Double = 180
    private let maxDeg: Double = 360
    private let degPerSec: Double = 60
    
    // Band config
    private let segWDeg: Double = 7.2
    private let bandColors: [Color] = [
        .cyan.opacity(0.7), .blue, .purple, .blue, .cyan.opacity(0.7)
    ]
    private var halfSpanDeg: Double { Double(bandColors.count) * segWDeg / 2 }
    private var safeMin: Double { minDeg + halfSpanDeg }
    private var safeMax: Double { maxDeg - halfSpanDeg }
    
    @State private var direction: Double = 1
    @State private var isPaused: Bool = false
    
    private let ticker = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let center = CGPoint(x: w/2, y: h*4/5)
            let radius = min(w, h) * 0.45
            
            ZStack {
                // bottom semicircle
                Semicircle(center: center, radius: radius, startDeg: minDeg, endDeg: maxDeg, clockwise: false)
                    .fill(Color.black.opacity(0.2))
                    .overlay(
                        Semicircle(center: center, radius: radius, startDeg: minDeg, endDeg: maxDeg, clockwise: false)
                            .stroke(Color.black.opacity(0.25), lineWidth: 2)
                    )
                
                ScoringBand(center: center,
                            radius: radius,
                            anchorDeg: guessDeg,     // <-- center angle of the band
                            segWDeg: segWDeg,
                            colors: bandColors)
                
                // Pause badge
                if isPaused {
                    Text("Paused")
                        .font(.caption).bold()
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .offset(y: h*0.7)
                }
                
                // Spacebar support (also clickable)
                Button(isPaused ? "Resume (Space)" : "Pause (Space)") {
                    isPaused.toggle()
                }
                .buttonStyle(.bordered)
                .keyboardShortcut(.space)    // Spacebar toggles pause (macOS / iPad keyboard)
                .offset(y: h*0.5)
            }
            // Tap/click anywhere on dial to toggle pause
            .contentShape(Rectangle())
            .onTapGesture { isPaused.toggle() }
            .onAppear {
                guessDeg = min(max(guessDeg, safeMin), safeMax)
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
        
        if guessDeg >= safeMax {
            guessDeg = safeMax
            direction = -1
        } else if guessDeg <= safeMin {
            guessDeg = safeMin
            direction = +1
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
    
    /// A filled wedge from startDeg → endDeg (center → arc → close)
    struct Wedge: Shape {
        let center: CGPoint
        let radius: CGFloat
        let startDeg: Double
        let endDeg: Double
        
        func path(in rect: CGRect) -> Path {
            var p = Path()
            p.move(to: center)
            p.addArc(center: center,
                     radius: radius,
                     startAngle: .degrees(startDeg),
                     endAngle: .degrees(endDeg),
                     clockwise: false)
            p.closeSubpath()
            return p
        }
    }
    
    /// Five small wedges centered at `anchorDeg`, laid side-by-side.
    struct ScoringBand: View {
        let center: CGPoint
        let radius: CGFloat
        let anchorDeg: Double         // center angle of the whole band
        let segWDeg: Double           // width of each mini-slice
        let colors: [Color]           // e.g. [light, dark, purple, dark, light]
        
        private var halfSpanDeg: Double { Double(colors.count) * segWDeg / 2 }
        
        var body: some View {
            let start0 = anchorDeg - halfSpanDeg
            ZStack {
                ForEach(0..<colors.count, id: \.self) { i in
                    let a0 = start0 + Double(i) * segWDeg
                    let a1 = a0 + segWDeg
                    Wedge(center: center, radius: radius, startDeg: a0, endDeg: a1)
                        .fill(colors[i])
                        .overlay(
                            Wedge(center: center, radius: radius, startDeg: a0, endDeg: a1)
                                .stroke(.black.opacity(0.4), lineWidth: 0.6)
                        )
                }
            }
        }
    }
    
    
    //struct Pointer: Shape {
    //    let center: CGPoint
    //    let radius: CGFloat
    //    let angleDeg: Double
    //
    //    func path(in rect: CGRect) -> Path {
    //        let r = angleDeg * .pi / 180
    //        let end = CGPoint(x: center.x + radius * CGFloat(cos(r)),
    //                          y: center.y + radius * CGFloat(sin(r)))
    //        var p = Path()
    //        p.move(to: center)
    //        p.addLine(to: end)
    //        return p
    //    }
    //}
}
