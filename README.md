# ColorJSONConverter α版

独自のフォーマットからXcodeのカラーアセットを作成できるCLIツールです。

## 使い方

```sh
$ make install
$ cjc convert color.json
```

### 注意

- 現在は書き出しファイルはColor.xcassets固定になっています
- コマンドを実行した場所に作成されます
- `cjc help`で簡易的なヘルプを表示できます

## JSONの書き方

- 必ず`pallets`を用意してください
- 色の指定は16進数表記、もしくはRGB指定で行えます（RGBは0から255の整数、alpha値は0.0kara1.0で指定）
- パレットの色名は baseName + label で表されます。

```json:sample.json
{
  "pallets": [
    {
      "baseName": "blue",
      "colors": [
        {
          "label": "50",
          "colorContext": "universal",
          "red": 177,
          "green": 210,
          "blue": 237
        },
        {
          "label": "100",
          "colorContext": "light",
          "hex": "0B6FCA"
        },
        {
          "label": "100",
          "colorContext": "dark",
          "hex": "#76B7ED"
        },
        {
          "label": "500",
          "colorContext": "universal",
          "hex": "3097ED"
        },
      ]
    }
  ],
  "colorFolders": [
    {
      "name": "Goodpatch",
      "folders": [],
      "colors": [
        {
          "name": "appKey",
          "colorContext": "universal",
          "value": "blue500"
        },
        {
          "name": "base",
          "colorContext": "light",
          "value": "blue100"
        },
        {
          "name": "base",
          "colorContext": "dark",
          "value": "blue100"
        }
      ]
    }
  ]
}

```

このファイルを実際にかけると以下のようなカラーアセットが生成されます

![sample.png](Assets/sample.png)

## ライセンス
[MIT License.](LICENSE)


