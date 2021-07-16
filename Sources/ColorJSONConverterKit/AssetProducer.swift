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

    private var pallets = Dictionary<String, AssetColors>()
    
    init(json: ColorJSON) {
        self.json = json
    }
    
    func produce(assetName: String = "Color") throws {
        
        // MARK: パレット部分の書き出し
        
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

    // TODO: フォルダを作る関数（private）
    // TODO: ファイルを書き込む関数（private）
}
