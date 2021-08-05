//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/30.
//

import Foundation

func hexToRGBA(_ hex: String) -> (red: Float, green: Float, blue: Float, alpha: Float) {
    let r, g, b, a: Float
    var hexColor: String
    if hex.hasPrefix("#") {
        let start = hex.index(hex.startIndex, offsetBy: 1)
        hexColor = String(hex[start...])
    } else {
        hexColor = hex
    }
    if hexColor.count == 6 {
        hexColor += "FF"
    }

    if hexColor.count == 8 {
        let scanner = Scanner(string: hexColor)
        var hexNumber: UInt64 = 0
        if scanner.scanHexInt64(&hexNumber) {
            r = Float((hexNumber & 0xff000000) >> 24) / 255
            g = Float((hexNumber & 0x00ff0000) >> 16) / 255
            b = Float((hexNumber & 0x0000ff00) >> 8) / 255
            a = Float(hexNumber & 0x000000ff) / 255
            return (r, g, b, a)
        }
    }
    fatalError("Wrong format: wrong hex color format: \(hex)")
}
