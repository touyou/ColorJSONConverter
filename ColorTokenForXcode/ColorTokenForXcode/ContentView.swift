//
//  ContentView.swift
//  ColorTokenForXcode
//
//  Created by emp-mac-yosuke-fujii on 2021/10/08.
//

import SwiftUI
import ColorJSONConverterKit

struct ContentView: View {
    @State var filename = "Filename"
    @State var showFileChooser = false

    var body: some View {
        HStack {
            Text(filename)
            Button("select File") {
                let panel = NSOpenPanel()
                panel.allowsMultipleSelection = false
                panel.canChooseDirectories = false
                if panel.runModal() == .OK {
                    self.filename = panel.url?.path ?? "<none>"
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
