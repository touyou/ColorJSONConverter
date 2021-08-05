import ColorJSONConverterKit

let arguments = CommandLine.arguments

guard let subcommand = arguments.dropFirst().first else {
    fatalError("Error: Indeclear arguments")
}

let path = arguments.dropFirst().dropFirst().first

switch subcommand {
case "help":
    let documents = """
    ColorJSONConverter.

    $ [command] help: Dump this help
    $ [command] convert \\(path): Convert file to assets
    """
    print(documents)
case "convert":
    guard let path = path else {
        fatalError("Error: Indeclear file path")
    }
    let target = Target(path: path)
    try target.convert()
default:
    fatalError("Error: Indeclear arguments")
}
