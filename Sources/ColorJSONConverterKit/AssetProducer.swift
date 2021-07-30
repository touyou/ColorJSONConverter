//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/16.
//

import Foundation

internal class AssetProducer {
    
    private let fileManager = FileManager.default
    private let json: ColorJSON
    private let encoder = JSONEncoder()

    private var colorDict: [String: Contents] = [:]
    
    init(json: ColorJSON) {
        self.json = json
    }
    
    func produce(assetName: String = "Color") throws {
        let assetFolderName = assetName + ".xcassets"
        guard let assetFolderPath = try createAssetFolder(folderPath: assetFolderName) else { return }

        // MARK: パレット部分の書き出し
        guard let palletFolderPath = try createAssetFolder(folderPath: "Pallet", in: assetFolderPath) else { return }

        for pallet in json.pallets {
            let colors = Contents.map(pallet)
            for (name, contents) in colors {
                guard let colorFolderPath = try createAssetFolder(folderPath: name, in: palletFolderPath) else { return }
                try writeFile(with: contents, folderPath: colorFolderPath, fileName: "Contents.json")
                colorDict[name] = contents
            }
        }
        
        // MARK: セマンティクス部分の書き出し
        guard let semanticsFolderPath = try createAssetFolder(folderPath: "Semantics", in: assetFolderPath) else { return }

        try writeColorFolders(json.colorFolders, basePath: semanticsFolderPath)
    }

    private func writeColorFolders(_ folders: [ColorFolder], basePath: String) throws {
        for colorFolder in folders {
            guard let colorSetFolderPath = try createAssetFolder(folderPath: colorFolder.name, in: basePath) else { fatalError("Invalid Format") }
            if colorFolder.folders.count > 0 {
                try writeColorFolders(colorFolder.folders, basePath: colorSetFolderPath)
            }
            for color in colorFolder.colors {
                let palletContents = colorDict[color.value]
                // TODO: こっちもColorContextごとに何かやらなきゃだ
            }
        }
    }

    private func createAssetFolder(folderPath: String, in parent: String? = nil) throws -> String? {
        guard let folderPath = createFolder(folderName: folderPath, in: parent) else { return nil }
        try writeFile(with: Contents(info: ContentsInfo.standard), folderPath: folderPath, fileName: "Contents.json")
        return folderPath
    }

    /// フォルダを作る関数（private）
    private func createFolder(folderName: String, in parent: String? = nil) -> String? {
        let currentDir = fileManager.currentDirectoryPath
        let newFolderPath = { () -> String in
            guard let parent = parent else {
                return currentDir + "/" + folderName
            }
            return parent + "/" + folderName
        }()

        guard let url = URL(string: newFolderPath) else { return nil }

        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return newFolderPath
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    /// ファイルを書き込む関数（private）
    private func writeFile(with content: Contents, folderPath: String, fileName: String) throws {
        let filePath = folderPath + "/" + fileName
        try fileManager.createFile(atPath: filePath, contents: encoder.encode(content), attributes: nil)
    }
}
