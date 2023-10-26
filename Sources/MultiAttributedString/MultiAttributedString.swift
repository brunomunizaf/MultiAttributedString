import UIKit

public extension String {

  /// Creates an `NSAttributedString` by applying specified attributes to portions of the string surrounded by specified delimiters.
  ///
  /// This method offers a convenient way to stylize certain parts of a string by using symbol delimiters. For instance,
  /// if you want the text between two '$' symbols to appear in red, provide an attribute with the '$' delimiter and a red text color.
  ///
  /// - Parameters:
  ///   - rawText: The string containing delimiters that specify which sections should be stylized.
  ///   - pairs: A dictionary where the key represents a symbol delimiter and its corresponding value denotes the set of attributes to be applied.
  /// - Returns: An `NSAttributedString` with attributes applied as per the specified delimiters.
  func applying(attributes: [String: ([NSAttributedString.Key: Any])]) -> NSAttributedString {
    let mutableAttributedString = NSMutableAttributedString(string: self)

    // Stacks to track the positions of starting and ending delimiters.
    var symbolStack: [String] = []
    var startPositionStack: [String.Index] = []

    var currentIndex = self.startIndex

    // Traverse each character in the string.
    while currentIndex < self.endIndex {
      let character = self[currentIndex]
      let symbol = String(character)

      // If the current character is a delimiter defined in the attributes...
      if let pair = attributes.first(where: { $0.key == symbol }) {
        if symbolStack.contains(pair.key) {
          // If the symbol is a closing delimiter, retrieve the positions from the stacks and apply the attributes.
          if let lastSymbol = symbolStack.last, lastSymbol == pair.key {
            let start = startPositionStack.removeLast()
            let range = NSRange(start..<currentIndex, in: self)
            mutableAttributedString.addAttributes(pair.value, range: range)
            symbolStack.removeLast()
          }
        } else {
          // If the symbol is an opening delimiter, store its details onto the stacks.
          symbolStack.append(pair.key)
          startPositionStack.append(currentIndex)
        }
      }

      currentIndex = self.index(after: currentIndex)
    }

    // Eliminate the delimiter symbols from the resulting string.
    for pair in attributes {
      mutableAttributedString.mutableString.replaceOccurrences(
        of: pair.key,
        with: "",
        options: [],
        range: NSRange(location: 0, length: mutableAttributedString.length)
      )
    }

    // Substitute placeholders with the actual delimiters (e.g., replacing "{*}" with "*").
    for pair in attributes {
      let placeholder = "{\(pair.key)}"
      mutableAttributedString.mutableString.replaceOccurrences(
        of: placeholder,
        with: pair.key,
        options: [],
        range: NSRange(location: 0, length: mutableAttributedString.length)
      )
    }

    return mutableAttributedString
  }
}
