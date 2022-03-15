//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Peter Fischer on 3/9/22.
//

import SwiftUI

struct ComputerView : View {
    
    var computerChoice : String
    var winOrLose : Bool
    
    var body : some View {
        VStack(spacing: 15) {
            Text("Computer Chooses")
            HStack() {
                Text("\(computerChoice)")
                Text(" && ")
                Text("\(winOrLose == true ? "WIN" : "LOSE")")
                    .foregroundColor(winOrLose == true ? Color.green : Color.red)
            }
        }
        .font(.title)
    }
}

class GameStatistics : ObservableObject {
    
    let maxGames = 3
    var numGamesPlayed = 0
    var correctAnswers = 0
    
    var gameOver : Bool  {
        numGamesPlayed == maxGames
    }
    
    func questionAnswered(correct: Bool)
    {
        if correct == true {
            correctAnswers += 1
        } else {
            correctAnswers = correctAnswers - 1 >= 0 ? correctAnswers - 1 : 0
        }
        
        numGamesPlayed += 1
        
        print("Answered \(correctAnswers) : \(numGamesPlayed)")
    }
    
    func resetStats() {
        numGamesPlayed = 0
        correctAnswers = 0
    }
    
    func printScore() -> String {
        "You scored  at \(correctAnswers)"
    }
    
    func getScore() -> Int {
        correctAnswers
    }
    
}


struct ContentView: View {
    
    private var choices = ["🪨", "📄", "✂️"]
    
    @State private var computerChoice = Int.random(in: 0...2)
    @State private var userWins = Bool.random()
    @State private var gameOver = false
    
    private let maxQuestions = 10

    @StateObject private var gameStats = GameStatistics()
    
    
    
    var body: some View {
        ZStack {
            RadialGradient(colors: [.red, .orange], center: .center, startRadius: 0, endRadius: 250)
            VStack {
                Spacer()
                Text("Play a classic")
                    .font(.title)
                VStack(spacing: 60) {
                    ComputerView(computerChoice: choices[computerChoice], winOrLose: userWins)
                    HStack(spacing: 25) {
                        ForEach(choices.indices) { choice in
                            Button(choices[choice]) {
                                print("Clicked \(choice)")
                                checkAnswer(choice)
                            }
                            .font(.system(size: 75))
                            .shadow(radius: 25)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 100)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                
                Spacer()
                Spacer()
                Text("Score : \(gameStats.getScore())")
                    .font(.title)
            }
            .padding()
            .alert("Game Over", isPresented: $gameOver) {
                Button("Ok") {
                    gameStats.resetStats()
                }
            } message: {
                Text("Final Score \(gameStats.getScore())")
            }
            .foregroundColor(Color.white)
        }
        .ignoresSafeArea()
    }
    
    func restart() {
        computerChoice = Int.random(in: 0...2)
        userWins = Bool.random()
    }
    
    func checkAnswer(_ answer : Int) {
        
        var didUserWin = false
        
        switch computerChoice {
        case 0:
            didUserWin =
            userWins && answer == 1 ? true :
            userWins == false && answer == 2 ? true : false
        case 1:
            didUserWin =
            userWins && answer == 2 ? true :
            userWins == false && answer == 0 ? true : false
        case 2:
            didUserWin =
            userWins && answer == 0 ? true :
            userWins == false && answer == 1 ? true : false
        default:
            print("Default hit")
            userWins = false
        }
        
        print(didUserWin == true ? "Correct" : "Incorrect")
        
        gameStats.questionAnswered(correct: didUserWin)

        if gameStats.gameOver {
            gameOver = true
        }
        
        restart()
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ContentView()
        }
    }
}
