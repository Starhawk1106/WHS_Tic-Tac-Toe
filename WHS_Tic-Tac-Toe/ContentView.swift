//
//  ContentView.swift
//  WHS_Tic-Tac-Toe
//
//  Created by William Stanley on 11/11/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {

        NavigationView {
            Home()
                .navigationTitle("Tic Tac Toe")
                .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    //Amount of Moves
    @State var moves : [String] = Array(repeating: "", count: 9)
    
    //To Identify which player
    @State var isPlaying = true
    
    @State var gameOver = false
    
    @State var msg = ""
    
    var body: some View{
        
        VStack{
            
            //Grid for playing!
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 15), count: 3), spacing: 15)
            {
                ForEach(0..<9,id: \.self){index in
                    
                    ZStack {
                        
                        //Flip Animation!
                        
                        Color.blue
                        
                        Color.white
                            .opacity(moves[index] == "" ? 1 : 0)
                        
                        Text(moves[index])
                            .font(.system(size: 55))
                            .fontWeight(.heavy)
                            .foregroundColor(.white)
                            .opacity(moves[index] != "" ? 1 : 0)
                    }
                    .frame(width: getWidth(), height: getWidth())
                    .cornerRadius(15)
                    .rotation3DEffect(
                        .init(degrees: moves[index] != "" ? 180 : 0),
                        axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/,
                        anchor: .center,
                        anchorZ: 0.0,
                        perspective: 1.0
                    )
                    // Whenever screen is tapped!
                    .onTapGesture(perform: {
                                
                        withAnimation(Animation.easeIn(duration: 0.5)){
                                    
                            if moves[index] == ""{
                                moves[index] = isPlaying ? "X" : "O"
                                        
                                //Player Update
                                isPlaying.toggle()
                            }
                        }
                    })
                }
            }
            .padding(15)
        }
        
        //Whenever Moves Are Updated it'll check for a winner
        
        .onChange(of: moves, perform: { value in
            
            checkWinner()
        })
        .alert(isPresented: $gameOver, content: {
            
            Alert(title: Text("Winner"), message: Text(msg), dismissButton: .destructive(Text("Play Again?"), action:{
                
                //Resetting All Of The Game Data
                withAnimation(Animation/*@START_MENU_TOKEN@*/.easeIn/*@END_MENU_TOKEN@*/(duration: 0.5))
                {
                    moves.removeAll()
                    moves = Array(repeating: "", count: 9)
                    isPlaying = true
                }
            }))
        })
    }
    
    func getWidth()->CGFloat{
        
        let width = UIScreen.main.bounds.width - (30 + 30)
        
        return width / 3
    }
    
    // Checking For Winner!
    
    func checkWinner()
    {
        if checkMoves(player: "X")
        {
            //Promoting Alert View
            
            msg = "Player 1 Wins!"
            gameOver.toggle()
        }
        if checkMoves(player: "O")
        {
            msg = "Player 2 Wins!"
            gameOver.toggle()
        }
    }
    
    func checkMoves(player: String)->Bool{
        
        // Horizontal Moves
        
        for i in stride(from: 0, to: 9, by: 3)
        {
        
            if moves[i] == player && moves[i+1] == player && moves [i+2] ==
                player{
                
                return true
            }
        }
        return false
    }
}
