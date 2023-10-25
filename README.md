# MultiAttributedString

`MultiAttributedString` allows you to create `NSAttributedString` with multiple text attributes applied to different parts of a string based on user-defined symbol delimiters.

## Features

- [x] Apply different text attributes (such as font, color, link, etc.) to specific portions of a string.
- [x] Define custom symbol delimiters to specify where attributes should be applied.
- [ ] Handle escaped symbols to treat them as literals and not as attribute delimiters.
- [ ] Support nested symbol pairs, with innermost symbols taking precedence.

## Usage

### Installation

You can add `MultiAttributedString` to your project using Swift Package Manager (SPM):

1. In Xcode, go to "File" > "Swift Packages" > "Add Package Dependency..."
2. Enter `https://github.com/brunomunizaf/MultiAttributedString.git`
3. Follow the prompts to complete the installation.

### Example

Here's a basic example of how to use `MultiAttributedString`:

```swift
import MultiAttributedString

let pairs = [
    AttributeSymbolPair(attributes: [.foregroundColor: UIColor.red], symbol: "$"),
    AttributeSymbolPair(attributes: [.foregroundColor: UIColor.blue], symbol: "#")
]

let attributedString = NSAttributedString.with("This is $red$ and this is #blue# text.", attributesBetween: pairs)
```

In this example, we define symbol pairs (e.g., `$` and `#`) with associated attributes. Then, we create an attributed string using the `NSAttributedString.with(_:attributesBetween:)` method, specifying the input string and the symbol pairs.

### Escaping Symbols

You can use the backslash (`\`) as an escape character to treat symbols as literals. For example:

```swift
let inputString = "This is \\$not red\\$ text but this is $red$."
```

In the above string, \\$ and \\$ are treated as literal symbols and will not trigger attribute application.

### Unit Tests

The repository includes unit tests to ensure the correct functionality of the library. You can run these tests in Xcode to verify that everything is working as expected.

### License

`MultiAttributedString` is distributed under the [MIT license](https://github.com/brunomunizaf/MultiAttributedString/blob/master/LICENSE).

### Contributing

Contributions are welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or create a pull request.
