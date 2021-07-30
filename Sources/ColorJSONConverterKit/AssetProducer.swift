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

    private var pallets = Dictionary<String, AssetColors>()
    
    init(json: ColorJSON) {
        self.json = json
    }
    
    func produce(assetName: String = "Color") throws {
        let assetFolderName = assetName + ".xcassets"
        guard let assetFolderPath = try createAssetFolder(folderPath: assetFolderName) else { return }

        // MARK: パレット部分の書き出し
        guard let palletFolderPath = try createAssetFolder(folderPath: "Pallet", in: assetFolderPath) else { return }

        // TODO: まずはContextだけ違うものをまとめないと...
        for pallet in json.pallets {
            guard let colorFolderPath = try createFolder(folderName: pallet.baseName + ".colorset", in: palletFolderPath) else { return }

        }

        
        // MARK: セマンティクス部分の書き出し
    }

    private func createPallet() {
        for pallet in json.pallets {
            for color in pallet.colors {
                let colorName = pallet.baseName + "-" + color.label
                if let currentPallet = pallets[colorName] {
                    pallets[colorName] = AssetColors(colors: currentPallet.colors + [AssetColor.map(color: color)])
                } else {
                    pallets[colorName] = AssetColors(colors: [AssetColor.map(color: color)])
                }
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
