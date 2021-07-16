//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/16.
//

import Foundation

struct AssetColors {
    let colors: [AssetColor]
}

struct AssetColor {
    static func map(color: PalletColor) -> AssetColor {
        // TODO
        AssetColor(colorContext: color.colorContext, red: 1.0, blue: 1.0, green: 1.0, alpha: 1.0)
    }

    let colorContext: ColorContext
    let red: Float
    let blue: Float
    let green: Float
    let alpha: Float
}

/// ファイル書き出し用の構造体
struct AssetColorJSON {
    static func map(name: String, colors: AssetColors) -> AssetColorJSON {
        AssetColorJSON()
    }
}
