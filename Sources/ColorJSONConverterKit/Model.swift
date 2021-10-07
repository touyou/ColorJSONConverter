//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/16.
//

import Foundation

struct ColorJSON: Decodable {
    let pallets: [Pallet]
    let colorFolders: [ColorFolder]
}

enum ColorContext: String, Codable {
    case light
    case dark
    case universal
}

struct Pallet: Decodable {
    let baseName: String
    let colors: [PalletColor]
}

struct PalletColor: Decodable {
    let label: String
    let colorContext: ColorContext
    
    let red: Int?
    let blue: Int?
    let green: Int?
    let alpha: Float?
    
    let hex: String?
}

struct ColorFolder: Decodable {
    let name: String
    let folders: [ColorFolder]
    let colors: [SemanticColor]
}

struct SemanticColor: Decodable {
    let name: String
    let colorContext: ColorContext
    let value: String
    let customColorHex: String?
}
