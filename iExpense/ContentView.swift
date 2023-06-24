
import SwiftUI

struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items.map({ $0.type }).removingDuplicates(), id: \.self) { type in
                    Section(header: Text(type)) {
                        ForEach(expenses.items.filter { $0.type == type }) { item in
                            Text(item.name)
                        }
                        .onDelete(perform: { indexSet in
                            removeItems(at: indexSet, ofType: type)
                        })
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("iExpense")
            .toolbar {
                Button {
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses, showingAddExpense: $showingAddExpense)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet, ofType type: String) {
        let filteredItems = expenses.items.filter { $0.type == type }
        let indicesToRemove = offsets.map { expenses.items.firstIndex(of: filteredItems[$0]) }.compactMap { $0 }
        expenses.items.remove(atOffsets: IndexSet(indicesToRemove))
    }
}

#Preview {
    ContentView()
}
