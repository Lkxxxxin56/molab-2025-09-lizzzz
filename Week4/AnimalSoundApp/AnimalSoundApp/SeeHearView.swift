import SwiftUI
import AVFoundation

struct SeeHearView: View {
    @State private var player: AVAudioPlayer? = nil
    private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var body: some View {
        VStack(spacing: 16) {
            Text("See → Hear")
                .font(.title.bold())

            ScrollView {
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(pets) { animal in
                        Button {
                            playSound(animal.soundFile)
                        } label: {
                            VStack(spacing: 8) {
                                Image(systemName: animal.symbol)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 56, height: 56)
                                Text(animal.name).font(.footnote)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(.ultraThinMaterial,
                                        in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 10)
            }
        }
        .padding(.top, 16)
    }

    private func playSound(_ file: String) {
        guard let url = Bundle.main.url(forResource: file, withExtension: nil) else {
            print("⚠️ Missing audio file:", file)
            return
        }
        do {
            let p = try AVAudioPlayer(contentsOf: url)
            p.prepareToPlay()
            p.play()
            player = p
        } catch {
            print("Audio error:", error)
        }
    }
}
