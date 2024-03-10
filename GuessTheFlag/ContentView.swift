//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Margarita Mayer on 01/12/23.
//

import SwiftUI

struct ContentView: View {
    
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 1...2)
    @State private var showingScore = false
    @State private var tappedButtonIndex: Int?
    @State private var animationAmount = 0.0
    
    
    @State private var scoreTitle = ""
    @State private var currentScore = 0 
    @State private var showFinalScore = false
    @State private var quantityOfQuestions = 0
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, bottom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
   

    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.blue, .indigo, .purple], center: .center, startRadius: 100, endRadius: 450)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                        
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                        
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                            calculate()
                        } label: {
                            FlagImage(image: countries[number])
                                .rotation3DEffect(.degrees(number == tappedButtonIndex ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                                .opacity((tappedButtonIndex != nil) && (number != tappedButtonIndex) ? 0.25 : 1)
                                .scaleEffect((tappedButtonIndex != nil) && (number != tappedButtonIndex) ? 1.3 : 1)
                        }
                        .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        
                    }
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
//                .onAppear {
//                    animationAmount = 0
//                }
                
                
                Spacer()
                Spacer()
                
                Text("Score: \(currentScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
            
            .alert(scoreTitle, isPresented: $showingScore) {
                Button("Continue", action: askQuestion)
            } message: {
                Text("Your score is \(currentScore)")
            }
            
            .alert("Game over!", isPresented: $showFinalScore) {
                Button("Start a new game", action: reset)
            } message: {
                Text("Your final score is \(currentScore)")
            }
            
            
        }
        
    }
    
    func flagTapped(_ number: Int) {
        tappedButtonIndex = number
        
        if number == correctAnswer {
            scoreTitle = "Correct"
            currentScore += 1
        } else {
            scoreTitle = "Wrong! This is a flag of \(countries[number])"
            currentScore -= 1
        }
        withAnimation {
            animationAmount += 360
        }
        
        showingScore = true

    }
   
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        tappedButtonIndex = nil
    }
    
    func reset() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        currentScore = 0
        quantityOfQuestions = 0
    }
    
    func calculate() {
        quantityOfQuestions += 1
        
        if quantityOfQuestions == 8 {
            showFinalScore = true
        }
        
    }
    
//    func showFinalResult() {
//        if quantityOfQuestions == 8 {
//            showFinalScore = true
//        }
//    }
}

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .clipShape(.capsule)
            .shadow(radius: 5)
        
    }
}
    
    #Preview {
        ContentView()
    }
