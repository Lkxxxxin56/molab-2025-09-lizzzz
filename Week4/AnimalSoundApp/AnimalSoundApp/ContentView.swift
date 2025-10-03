import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 10) {
                Text("Animal Sounds")
                    .font(.largeTitle.bold())
                    .padding(.top, 50)

                // Two big navigation buttons
                NavigationLink {
                    SeeHearView()
                } label: {
                    HomeCard(title: "See → Hear",
                             subtitle: "Tap an animal to play its sound",
                             systemImage: "square.grid.3x3.fill")
                }

                NavigationLink {
                    HearGuessView()
                } label: {
                    HomeCard(title: "Hear → Guess",
                             subtitle: "Play a sound and choose the right animal",
                             systemImage: "questionmark.circle.fill")
                }

                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
}

private struct HomeCard: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: systemImage)
                .resizable()
                .scaledToFit()
                .frame(width: 36, height: 36)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.headline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ContentView()
}
