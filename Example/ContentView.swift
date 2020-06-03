//
//  ContentView.swift
//  Example
//
//  Created by Satoshi Watanabe on 2020/05/28.
//  Copyright © 2020 Satoshi Watanabe. All rights reserved.
//

import SwiftUI
import Feeding

struct ContentView: View {
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        List {
            ForEach(viewModel.entries, id: \.self) { section in
                Text(section.title!)
            }
        }.onAppear(perform: {self.viewModel.fetch()})

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
