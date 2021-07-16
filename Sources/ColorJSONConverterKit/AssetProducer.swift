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
    
    init(json: ColorJSON) {
        self.json = json
    }
    
    func produce(assetName: String = "Color") throws {
        
        // MARK: パレット部分の書き出し
        
        // MARK: セマンティクス部分の書き出し
    }
}
