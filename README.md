# MultiAttributedString

`MultiAttributedString` provides a convenient way to generate `NSAttributedString` with varying text attributes for different sections of a string, based on user-defined symbol delimiters.

## Features

- [x] Easily apply varied text attributes (e.g., font, color, links) to distinct parts of a string.
- [x] Use custom symbol delimiters to dictate where attributes should be applied in the string.
- [ ] Support for escaped symbols, allowing them to be interpreted as regular characters instead of attribute delimiters.
- [ ] Capability to handle nested symbol pairs, with attributes from the innermost symbols given priority.

## Usage

### Installation

To integrate `MultiAttributedString` into your project, use the Swift Package Manager (SPM):

1. In Xcode, go to "File" > "Swift Packages" > "Add Package Dependency..."
2. Enter `https://github.com/brunomunizaf/MultiAttributedString.git`
3. Follow the prompts to complete the installation.

### Example

Here's a basic example of how to use `MultiAttributedString`:

```swift
import MultiAttributedString

let attributedString = "This is $red$ text, and this is #blue small# text".applying(
  attributes: [
    "$": [.foregroundColor: UIColor.red],
    "#": [.foregroundColor: UIColor.blue, .font: UIFont.systemFont(withSize: 10.0)]
  ]
)
```

In this example, we define symbol pairs (e.g., `$` and `#`) with associated attributes. Then, we create an attributed string using the `.applying(attributes:)` method.

### Escaping Symbols (In progress ⏳)

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
