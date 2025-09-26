import SwiftUI

// 1) Autumn palette
let autumnSet = ["🍂","🎃","🦃","☕️","🧣"]

// 2) Global array of tuples: (emoji, position, size, velocity)
var emojiItems: [(String, CGPoint, CGFloat, CGVector)] = []

// 3) Animation tick (like your example)
let animInterval = 0.06  // seconds

struct EmojiWallpaperView: View {
    @State private var count = 30
    @State private var canvasSize = CGSize.zero

    var body: some View {
        TimelineView(.animation(minimumInterval: animInterval)) { timeline in
            Canvas { context, size in
                // remember size for tap reseed
                if canvasSize != size { canvasSize = size }

                // ---- Setup helpers (same non-overlap idea) ----
                let minSize: CGFloat = 50
                let maxSize: CGFloat = 80
                let spacing: CGFloat = 10
                let maxAttempts = 50

                func hitRadius(for fontSize: CGFloat) -> CGFloat { fontSize * 0.6 }

                func findSpot(in size: CGSize,
                              r: CGFloat,
                              existing: [(String, CGPoint, CGFloat, CGVector)]) -> CGPoint? {
                    let xRange = r...(size.width - r)
                    let yRange = r...(size.height - r)
                    for _ in 0..<maxAttempts {
                        let p = CGPoint(x: .random(in: xRange), y: .random(in: yRange))
                        var ok = true
                        for e in existing {
                            let r2 = hitRadius(for: e.2)
                            let dx = p.x - e.1.x
                            let dy = p.y - e.1.y
                            if (dx*dx + dy*dy).squareRoot() < (r + r2 + spacing) {
                                ok = false; break
                            }
                        }
                        if ok { return p }
                    }
                    return nil
                }

                func randomVelocity(speedRange: ClosedRange<CGFloat>) -> CGVector {
                    // random direction, random speed
                    let angle = CGFloat.random(in: 0..<(2 * .pi))
                    let speed = CGFloat.random(in: speedRange)
                    return CGVector(dx: cos(angle) * speed, dy: sin(angle) * speed)
                }

                // ---- Initial non-overlapping placement ----
                if emojiItems.isEmpty {
                    let target = count
                    for _ in 0..<target {
                        let emoji = autumnSet.randomElement()!
                        var fontSize = CGFloat.random(in: minSize...maxSize)
                        var r = hitRadius(for: fontSize)

                        if let pos = findSpot(in: size, r: r, existing: emojiItems) {
                            let v = randomVelocity(speedRange: 20...50) // pts/sec
                            emojiItems.append((emoji, pos, fontSize, v))
                        } else {
                            // fallback: shrink once and retry
                            fontSize = max(minSize, fontSize * 0.8)
                            r = hitRadius(for: fontSize)
                            if let pos2 = findSpot(in: size, r: r, existing: emojiItems) {
                                let v = randomVelocity(speedRange: 20...50)
                                emojiItems.append((emoji, pos2, fontSize, v))
                            }
                        }
                    }
                }

                // ---- Animate: move & bounce ----
                let dt = animInterval  // fixed timestep
                for i in emojiItems.indices {
                    var (char, p, sizeFont, v) = emojiItems[i]
                    let r = hitRadius(for: sizeFont)

                    // advance
                    p.x += v.dx * dt
                    p.y += v.dy * dt

                    // bounce on edges (clamp inside bounds)
                    if p.x < r { p.x = r; v.dx = abs(v.dx) }
                    if p.x > size.width - r { p.x = size.width - r; v.dx = -abs(v.dx) }
                    if p.y < r { p.y = r; v.dy = abs(v.dy) }
                    if p.y > size.height - r { p.y = size.height - r; v.dy = -abs(v.dy) }

                    emojiItems[i] = (char, p, sizeFont, v)
                }
                
                // ---- Edge-hit bounce between emojis (treat each as a circle) ----
                let sepPadding: CGFloat = 1  // tiny extra separation to avoid jitter

                if emojiItems.count >= 2 {
                    for i in 0..<(emojiItems.count - 1) {
                        for j in (i + 1)..<emojiItems.count {
                            var (ci, pi, si, vi) = emojiItems[i]
                            var (cj, pj, sj, vj) = emojiItems[j]

                            let ri = hitRadius(for: si)
                            let rj = hitRadius(for: sj)

                            let dx = pj.x - pi.x
                            let dy = pj.y - pi.y
                            var dist = (dx*dx + dy*dy).squareRoot()
                            let minDist = ri + rj

                            if dist < minDist {
                                // normal vector from i -> j (avoid NaN if perfectly overlapped)
                                let nx: CGFloat = dist > 0 ? dx / dist : 1
                                let ny: CGFloat = dist > 0 ? dy / dist : 0

                                // push them apart so their edges just touch (+ tiny padding)
                                let overlap = (minDist - dist) / 2 + sepPadding
                                pi.x -= nx * overlap; pi.y -= ny * overlap
                                pj.x += nx * overlap; pj.y += ny * overlap

                                // simplest bounce: flip both velocities
                                vi.dx = -vi.dx; vi.dy = -vi.dy
                                vj.dx = -vj.dx; vj.dy = -vj.dy

                                // write back
                                emojiItems[i] = (ci, pi, si, vi)
                                emojiItems[j] = (cj, pj, sj, vj)
                            }
                        }
                    }
                }


                // ---- Draw ----
                for item in emojiItems {
                    let text = Text(item.0).font(.system(size: item.2))
                    context.draw(text, at: item.1, anchor: .center)
                }

                // trigger timeline read (like your example)
                _ = timeline.date
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            // reseed: clear; next frame will repopulate non-overlapping with new velocities
            emojiItems.removeAll()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EmojiWallpaperView()
}
