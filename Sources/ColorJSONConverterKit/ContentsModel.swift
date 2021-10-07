//
//  File.swift
//  
//
//  Created by emp-mac-yosuke-fujii on 2021/07/30.
//

import Foundation

struct Contents: Encodable {
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

    func append(_ contents: Contents) -> Contents {
        Contents(colors: (self.colors ?? []) + (contents.colors ?? []))
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

    static func map(_ contents: Contents, with color: SemanticColor) -> Contents {
        switch color.colorContext {
        case .dark:
            if let darkColor = contents.colors?.first(where: { $0.appearances != nil }) {
                return Contents(colors: [darkColor])
            } else if let darkColor = contents.colors?[0] {
                return Contents(colors: [
                    ContentsColor(color: darkColor.color, appearances: [ContentsAppearance.darkAppearance], idiom: "universal")
                ])
            } else {
                fatalError("Invalid Pallet")
            }
        case .light:
            if let lightColor = contents.colors?.first(where: {$0.appearances == nil}) {
                return Contents(colors: [lightColor])
            } else if let lightColor = contents.colors?[0] {
                return Contents(colors: [
                    ContentsColor(color: lightColor.color, appearances: nil, idiom: "universal")
                ])
            } else {
                fatalError("Invalid Pallet")
            }
        case .universal:
            return contents
        }
        return Contents(colors: [])
    }
}

struct ContentsInfo: Encodable {
    let author: String
    let version: Int

    static let standard = ContentsInfo(author: "xcode", version: 1)
}

struct ContentsColor: Encodable {
    let color: ContentsColorData
    let appearances: [ContentsAppearance]?
    let idiom: String

    static func map(_ palletColor: PalletColor) -> ContentsColor {
        let appearances: [ContentsAppearance]? = {
            switch palletColor.colorContext {
            case .universal, .light:
                return nil
            case .dark:
                return [ContentsAppearance.darkAppearance]
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

    static func map(_ customColor: String, context: ColorContext) -> ContentsColor {
        let appearances: [ContentsAppearance]? = {
            switch context {
            case .universal, .light:
                return nil
            case .dark:
                return [ContentsAppearance.darkAppearance]
            }
        }()
        let contentColor: ContentsColorData = {
            let (red, green, blue, alpha) = hexToRGBA(customColor)
            return ContentsColorData(red: red, green: green, blue: blue, alpha: alpha)
        }()
        return ContentsColor(color: contentColor, appearances: appearances, idiom: "universal")
    }
}

struct ContentsColorData: Encodable {
    struct ColorValue: Encodable {
        let alpha: String
        let blue: String
        let green: String
        let red: String
    }

    let colorSpace: String
    let components: ColorValue

    init(red: Float, green: Float, blue: Float, alpha: Float, colorSpace: String = "display-p3") {
        self.colorSpace = colorSpace
        self.components = ColorValue(
            alpha: alpha.formattedString,
            blue: blue.formattedString,
            green: green.formattedString,
            red: red.formattedString)
    }

    enum CodingKeys: String, CodingKey {
        case colorSpace = "color-space"
        case components
    }
}

struct ContentsAppearance: Encodable {
    let appearance: String
    let value: String

    static let darkAppearance = ContentsAppearance(appearance: "luminosity", value: "dark")
}

private extension Float {
    var formattedString: String {
        String(format: "%.3f", self)
    }
}
