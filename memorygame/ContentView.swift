import SwiftUI
struct ContentView: View {

        @State var selectedTab = 0

        var body: some View {

                TabView(selection: $selectedTab) {

                        Themes(emojis: ["🐶", "🐱", "🐻", "🐰", "🐹", "🐯", "🐬", "🦊", "🐶", "🐱", "🐻", "🐰", "🐹", "🐯", "🐬", "🦊"], themeColor: .orange)

                            .tabItem() {

                                    Label("Animals", systemImage: "pawprint")

                                }

                            .tag(0)

                        Themes(emojis: ["🍫", "🍰", "🍣", "🍿", "🍟", "🍱", "🍜","🥨","🍫", "🍰", "🍣", "🍿", "🍟", "🍱", "🍜", "🥨"], themeColor: .yellow)

                            .tabItem() {

                                    Label("Foods", systemImage: "birthday.cake.fill")

                                }

                            .tag(1)

                        Themes(emojis:["📚", "🎈", "🧸", "⏰", "🔑", "🛍️", "☎️", "🔫", "📚", "🎈", "🧸", "⏰", "🔑", "🛍️", "☎️", "🔫"], themeColor: .mint)

                            .tabItem() {

                                Label("Objects", systemImage: "shippingbox.fill")

                            }

                            .tag(2)

                }

        }

}

struct Themes: View {

        @State var emojis: [String]

        @State var cardCount = 16

        @State var firstShuffle = true

        @State var selectedCard: Set<Int> = []

        @State var matchedCards: Set<Int> = []

        @State var isFaceUp: [Bool] = Array(repeating: false, count: 16)

        @State var themeColor: Color
    
        @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
        @Environment(\.verticalSizeClass) var verticalSizeClass



        var body: some View {
            
            GeometryReader { geometry in
                
                VStack(spacing: 0) {
                    
                    Text("Memorize!")
                    .font(.largeTitle.bold())
                    .foregroundColor(themeColor)
                    .padding(.top, 10)
                    
                cards
                    
                    .frame(maxHeight: .infinity)
            }
                
            .padding(.horizontal)
                
            .onAppear {
                
                if firstShuffle {
                    emojis.shuffle()
                    firstShuffle = false
                }
            }
        }
    }

        func filterSet(firstSet: Set<Int>, secondSet: Set<Int>) -> Set<Int> {
            return firstSet.subtracting(secondSet)
        }

        func addSelectedCard(_ selectedIndex : Int) {

            if selectedCard.count < 2{

                selectedCard.insert(selectedIndex)
                var filterCardSet = filterSet(firstSet: selectedCard, secondSet: matchedCards)
                selectedCard = filterCardSet
                print("selected card")
                print(selectedCard)}
                print("match card")
                print(matchedCards)

        }


        var cardViews: [CardView] {

                (0..<cardCount).map { index in

                        CardView(isFaceUp: $isFaceUp[index], content: emojis[index], emojiIndex: index, onTap: {

                                addSelectedCard(index)

                                changeIsFaceUp(at: index)

                                checkMatchingCards(at: index)

                        })

                }

        }

    var cards: some View {
        
        GeometryReader { geometry in
            
            let screenWidth = UIScreen.main.bounds.width
            let screenHeight = UIScreen.main.bounds.height
            let isLandscape = screenWidth > screenHeight

            let isPad = UIDevice.current.userInterfaceIdiom == .pad
            let cardsPerRow = (isPad && !isLandscape) ? 6 : (isLandscape ? 8 : 4)

            let horizontalSpacing: CGFloat = 10
            let verticalSpacing: CGFloat = 30
            
            let totalSpacing = horizontalSpacing * CGFloat(cardsPerRow - 1)
            let cardWidth = (geometry.size.width - totalSpacing) / CGFloat(cardsPerRow)
            
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: horizontalSpacing), count: cardsPerRow),
                spacing: verticalSpacing
            ) {
                ForEach(0..<cardCount, id: \.self) { index in
                    cardViews[index]
                        .aspectRatio(2/3, contentMode: .fit)
                        .frame(width: cardWidth)
                }
            }
            .frame(minHeight: geometry.size.height)
        }
        .foregroundColor(themeColor)
    }

        func checkMatchingCards(at index: Int) {

                if selectedCard.count == 2 {

                        let newArray = Array(selectedCard)

                        if emojis[newArray[0]] == emojis[newArray[1]]{

                                addMatchedCards(at: newArray[0])

                                addMatchedCards(at: newArray[1])

                                isFaceUp[newArray[0]] = true

                                isFaceUp[newArray[1]] = true

                                print("match!")

                                print(matchedCards)

                        }else {

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){

                                        isFaceUp[newArray[0]] = false

                                        isFaceUp[newArray[1]] = false

                                    }

                        }

                    selectedCard.removeAll()
                    
                    if matchedCards.count == cardCount {
                               DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                   resetGame()
                               }
                    }

                }

        }
        
    func resetGame () {
        isFaceUp = Array(repeating: false, count: cardCount)
        selectedCard.removeAll()
        matchedCards.removeAll()
        
        emojis.shuffle()
        firstShuffle = false
        
    }

        func addMatchedCards(at index: Int){
            matchedCards.insert(index)
        }

        func changeIsFaceUp(at index: Int) {

            if !matchedCards.contains(index){
                        isFaceUp[index].toggle()
            }
        }

}

struct CardView: View {

        @Binding var isFaceUp: Bool

        var content: String

        var emojiIndex: Int

        var onTap:() -> Void

        var body: some View {

                ZStack {

                        let base = RoundedRectangle(cornerRadius: 12)

                        Group {

                                base

                                    .fill(Color(uiColor: .systemBackground))

                                    .strokeBorder(lineWidth: 2)

                                Text(content).font(.largeTitle)

                        }

                        .opacity(isFaceUp ? 1 : 0)

                        base.fill().opacity(isFaceUp ? 0 : 1)

                }

                .onTapGesture {

                        onTap()

                }

        }

}

#Preview {

        ContentView()

}
