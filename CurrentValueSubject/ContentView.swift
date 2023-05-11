//
//  ContentView.swift
//  CurrentValueSubject
//
//  Created by sss on 11.05.2023.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    
    @StateObject private var viewModel = CurrentValueSubjectViewModel()
    
    var body: some View {
        VStack {
            Text("\(viewModel.selectionSame.value ? "Selected twice": "") \(viewModel.selection.value)")
                .foregroundColor(viewModel.selectionSame.value ? .red : .green)
                .padding()
            
            Button("Selected coffee") {
                viewModel.selection.value = "Raf coffee"
            }
            .padding()
            
            Button("Selected tea") {
                viewModel.selection.send("Green tea")
            }
            .padding()
        }
    }
}

class CurrentValueSubjectViewModel: ObservableObject {
    
    var selection = CurrentValueSubject<String, Never>("")
    var selectionSame = CurrentValueSubject<Bool, Never>(false)
    
    var cancellable: Set<AnyCancellable> = []
    
    init() {
        selection
            .map {[unowned self] newValue -> Bool in
                if newValue == selection.value {
                    return true
                } else {
                    return false
                }
            }
            .sink { [unowned self] value in
                self.selectionSame.value = value
                objectWillChange.send()
            }
            .store(in: &cancellable)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
