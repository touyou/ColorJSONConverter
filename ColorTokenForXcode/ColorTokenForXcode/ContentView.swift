//
//  ContentView.swift
//  ColorTokenForXcode
//
//  Created by emp-mac-yosuke-fujii on 2021/10/08.
//

import SwiftUI
import ColorJSONConverterKit

struct ContentView: View {
    @State var baseFolder = ""
    @State var fileName = ""
    @State var outputName = ""
    @State var showFileChooser = false
    @State var showAlert = false
    @State var alertTitle: String = ""
    @State var alertMessage: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Text("Color Token for Xcode")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("jsonファイルからカラーアセットを書き出すツール")
                .font(.body)
                .padding(.bottom, 16)
            VStack(alignment: .trailing) {
                TextField("JSONファイルのあるフォルダ名", text: $baseFolder)
                    .disabled(true)
                Button("選択する") {
                    let panel = NSOpenPanel()
                    panel.message = "JSONファイルが含まれるフォルダを選んでください"
                    panel.allowedContentTypes = [.folder]
                    panel.allowsOtherFileTypes = false
                    panel.allowsMultipleSelection = false
                    panel.canChooseDirectories = true
                    if panel.runModal() == .OK {
                        baseFolder = panel.url?.path ?? ""
                    }
                }
                .padding(.bottom)
                TextField("JSONファイル名", text: $fileName)
                TextField("書き出し名（デフォルト：Color）", text: $outputName)
            }
            .padding(.bottom, 16)
            HStack {
                Spacer()
                Button("クリア") {
                    baseFolder = ""
                    outputName = ""
                }
                .disabled(baseFolder.isEmpty || fileName.isEmpty)
                .keyboardShortcut(.cancelAction)
                Button("書き出し") {
                    let target = Target.init(path: baseFolder + "/" + fileName)
                    do {
                        let output = outputName.isEmpty ? "Color" : outputName
                        try target.convert(name: output, basePath: baseFolder)
                        alertTitle = "書き出し成功しました"
                        alertMessage = "\(output).xcassetsを生成しました。"
                        NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: baseFolder)
                    } catch let error {
                        alertTitle = "書き出しエラーが起きました"
                        alertMessage = "\(error.localizedDescription)"
                    }
                    showAlert = true
                }
                .disabled(baseFolder.isEmpty || fileName.isEmpty)
                .keyboardShortcut(.defaultAction)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
        }
        .padding()
        .padding(.bottom, 16)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
