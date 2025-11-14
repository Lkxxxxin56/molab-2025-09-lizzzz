//
//  ContentView.swift
//  Wavelength Mobile Game
//
//  Created by Kexin Liu on 10/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showRules = false
    
    var body : some View {
        NavigationStack{
            VStack(spacing: 16){
                // TOP: Title block
                VStack{
                    Text("Welcome to the...")
                        .font(.title3).bold()
                    Text("Wavelength Mobile Game")
                        .font(.largeTitle).bold()
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                        .padding(.horizontal, 30)
                }
                .padding(.top, 24)
                
                // MIDDLE: some graphics
                
                Image("wavelength-icon.png")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                
                // BOTTOM: 3 buttons
                
                // Button1: Start game
                NavigationLink {
                    GameView()
                } label: {
                    Text("Start Game")
                        .font(.title2.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                // Button2: Rules
                Button {
                    showRules = true
                } label: {
                    Text("Rules")
                        .font(.title2.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                
                // Button3: Game archives
                Button {
                    // TODO: wire later
                } label: {
                    Text("Archives")
                        .font(.title2.weight(.semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.gray.opacity(0.25))
                        .foregroundColor(.primary)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
            .padding()
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $showRules) {
            RulesView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
