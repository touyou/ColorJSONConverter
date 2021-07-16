//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/16.
//

import Foundation

/// 該当ファイルを取得し、変換結果を返す
public struct Target {
    
    private let fileManager = FileManager.default
    private let path: String
    
    public init(path: String) {
        guard fileManager.fileExists(atPath: path) else {
            fatalError("Error: File does not exist")
        }
        self.path = path
    }
    
    public func convert() throws {
        // NOTE: init時にファイルが存在していることを確認済みのため
        let data = fileManager.contents(atPath: path)!
        
        let decoder = JSONDecoder()
        let json = try decoder.decode(ColorJSON.self, from: data)
        
        let producer = AssetProducer(json: json)
        try producer.produce()
    }
}
