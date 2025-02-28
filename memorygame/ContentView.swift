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

                        Themes(emojis: ["🍎", "🍌", "🍉", "🫐", "🥝", "🍊", "🍒", "🍋", "🍎", "🍌", "🍉", "🫐", "🥝", "🍊", "🍒", "🍋"], themeColor: .yellow)

                            .tabItem() { 

                                    Label("Fruits", systemImage: "pawprint")

                                }

                            .tag(1)

                        Themes(emojis:["📚", "🎈", "🧸", "⏰", "🔑", "🛍️", "☎️", "🔫", "📚", "🎈", "🧸", "⏰", "🔑", "🛍️", "☎️", "🔫"], themeColor: .mint)

                            .tabItem() { 

                                Label("Objects", systemImage: "pawprint")

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


        var body: some View {

                VStack {

                        ScrollView{

                                Text("Memorize!")

                                    .font(.system(size: 40, weight: .bold, design: .default))

                                    .foregroundColor(themeColor)

                                    .padding(.bottom, 10)

                                cards

                            }

                    }

                .padding()

                .onAppear{

                        if firstShuffle {

                                emojis.shuffle()

                                firstShuffle = false

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

                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]) {

                        ForEach(0..<cardCount, id: \.self) { index in

                                cardViews[index]

                                    .aspectRatio(2/3, contentMode: .fit)

                        }

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

                }

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

                                    .fill(.white)

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