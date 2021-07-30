//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/30.
//

import Foundation

struct Contents: Codable {
    let info: ContentsInfo
    let colors: [ContentsColor]?

    init(info: ContentsInfo) {
        self.info = info
        self.colors = nil
    }

    init(colors: [ContentsColor]) {
        self.info = ContentsInfo.standard
        self.colors = colors
    }

    static func map(_ pallet: Pallet) -> [(String, Contents)] {
        let baseName = pallet.baseName
        var colorDict: [String: [PalletColor]] = [:]
        for color in pallet.colors {
            let name = baseName + color.label
            if colorDict[name] != nil {
                colorDict[name]!.append(color)
            } else {
                colorDict[name] = [color]
            }
        }

        var contentWithNames: [(String, Contents)] = []
        for (name, colors) in colorDict {
            let contentColors: [ContentsColor] = colors.map { ContentsColor.map($0) }
            contentWithNames.append((name, Contents(colors: contentColors)))
        }
        return contentWithNames
    }
}

struct ContentsInfo: Codable {
    let author: String
    let version: Int

    static let standard = ContentsInfo(author: "xcode", version: 1)
}

struct ContentsColor: Codable {
    let color: ContentsColorData
    let appearances: ContentsAppearance?
    let idiom: String

    static func map(_ palletColor: PalletColor) -> ContentsColor {
        let appearances: ContentsAppearance? = {
            switch palletColor.colorContext {
            case .universal, .light:
                return nil
            case .dark:
                return ContentsAppearance(appearance: "luminosity", value: "dark")
            }
        }()
        let contentColor: ContentsColorData = {
            if let hex = palletColor.hex {
                let (red, green, blue, alpha) = hexToRGBA(hex)
                return ContentsColorData(red: red, green: green, blue: blue, alpha: alpha)
            } else {
                guard let red = palletColor.red,
                      let green = palletColor.green,
                      let blue = palletColor.blue else {
                    fatalError("Wrong format: color must have rgb value or hex value")
                }
                let alpha = palletColor.alpha ?? 1.0
                return ContentsColorData(red: Float(red) / 255.0, green: Float(green) / 255.0, blue: Float(blue) / 255.0, alpha: alpha)
            }
        }()
        return ContentsColor(color: contentColor, appearances: appearances, idiom: "universal")
    }
}

struct ContentsColorData: Codable {
    struct ColorValue: Codable {
        let alpha: Float
        let blue: Float
        let green: Float
        let red: Float
    }

    let colorSpace: String
    let components: ColorValue

    init(red: Float, green: Float, blue: Float, alpha: Float, colorSpace: String = "display-p3") {
        self.colorSpace = colorSpace
        self.components = ColorValue(alpha: alpha, blue: blue, green: green, red: red)
    }
}

struct ContentsAppearance: Codable {
    let appearance: String
    let value: String
}
