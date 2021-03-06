//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/16.
//

import Foundation

internal class AssetProducer {
    private enum ConverterError: Error {
        case unknown
    }

    private let fileManager = FileManager.default
    private let json: ColorJSON
    private let encoder = JSONEncoder()

    private var basePath: String?

    private var colorPallet: [String: Contents] = [:]
    
    init(json: ColorJSON, basePath: String? = nil) {
        self.json = json
        self.basePath = basePath
    }
    
    func produce(assetName: String) throws {
        print("---produce start---")
        let assetFolderName = assetName + ".xcassets"
        guard let assetFolderPath = try createAssetFolder(folderPath: assetFolderName) else { return }
        print("๐ Asset Folder created")

        // MARK: ใใฌใใ้จๅใฎๆธใๅบใ
        guard let palletFolderPath = try createAssetFolder(folderPath: "Pallet", in: assetFolderPath) else { return }
        print("๐ Pallet Folder created")

        for pallet in json.pallets {
            let colors = Contents.map(pallet)
            for (name, contents) in colors {
                guard let colorFolderPath = try createAssetFolder(folderPath: name + ".colorset", in: palletFolderPath) else { return }
                try writeFile(with: contents, folderPath: colorFolderPath, fileName: "Contents.json")
                colorPallet[name] = contents
            }
        }
        
        // MARK: ใปใใณใใฃใฏใน้จๅใฎๆธใๅบใ
        guard let semanticsFolderPath = try createAssetFolder(folderPath: "Semantics", in: assetFolderPath) else { return }
        print("๐ Semantics Folder created")

        try writeColorFolders(json.colorFolders, basePath: semanticsFolderPath)
        if let colors = json.colors {
            try writeColors(colors, colorSetFolderPath: semanticsFolderPath)
        }
        print("---produce completed---")
    }

    private func writeColorFolders(_ folders: [ColorFolder], basePath: String) throws {
        for colorFolder in folders {
            guard let colorSetFolderPath = try createAssetFolder(folderPath: colorFolder.name, in: basePath) else { fatalError("Invalid Format") }
            if colorFolder.folders.count > 0 {
                try writeColorFolders(colorFolder.folders, basePath: colorSetFolderPath)
            }
            try writeColors(colorFolder.colors, colorSetFolderPath: colorSetFolderPath)
        }
    }

    private func writeColors(_ colors: [SemanticColor], colorSetFolderPath: String) throws {
        var semanticColor: [String: Contents] = [:]
        for color in colors {
            if let pallet = colorPallet[color.value] {
                let contents = Contents.map(pallet, with: color)
                if semanticColor[color.name] != nil {
                    semanticColor[color.name] = semanticColor[color.name]!.append(contents)
                } else {
                    semanticColor[color.name] = contents
                }
            } else if let customColorHex = color.customColorHex {
                let contents = Contents.map(Contents(colors: [ContentsColor.map(customColorHex, context: color.colorContext)]), with: color)
                if semanticColor[color.name] != nil {
                    semanticColor[color.name] = semanticColor[color.name]!.append(contents)
                } else {
                    semanticColor[color.name] = contents
                }
            } else {
                fatalError("\(color.value) is Not Found in Pallet")
            }
        }
        for (name, colorContents) in semanticColor {
            guard let colorFolderPath = try createAssetFolder(folderPath: name + ".colorset", in: colorSetFolderPath) else { fatalError("Invalid Format") }
            try writeFile(with: colorContents, folderPath: colorFolderPath, fileName: "Contents.json")
        }
    }

    private func createAssetFolder(folderPath: String, in parent: String? = nil) throws -> String? {
        guard let folderPath = createFolder(folderName: folderPath, in: parent) else { return nil }
        try writeFile(with: Contents(info: ContentsInfo.standard), folderPath: folderPath, fileName: "Contents.json")
        return folderPath
    }

    /// ใใฉใซใใไฝใ้ขๆฐ๏ผprivate๏ผ
    private func createFolder(folderName: String, in parent: String? = nil) -> String? {
        let currentDir = basePath ?? fileManager.currentDirectoryPath
        let newFolderPath = { () -> String in
            guard let parent = parent else {
                return currentDir + "/" + folderName
            }
            return parent + "/" + folderName
        }()

        let url = URL(fileURLWithPath: newFolderPath)

        print("๐ create folder: \(url.absoluteString)")
        do {
            try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            return newFolderPath
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    /// ใใกใคใซใๆธใ่พผใ้ขๆฐ๏ผprivate๏ผ
    private func writeFile(with content: Contents, folderPath: String, fileName: String) throws {
        let filePath = folderPath + "/" + fileName
        print("๐ write file: \(filePath)")
        try fileManager.createFile(atPath: filePath, contents: encoder.encode(content), attributes: nil)
    }
}
