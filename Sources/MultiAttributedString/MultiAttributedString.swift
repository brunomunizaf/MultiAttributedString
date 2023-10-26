import UIKit

public extension NSAttributedString {

  /// Creates an `NSAttributedString` by applying the specified attributes between given symbol pairs.
  ///
  /// This method allows you to easily stylize parts of a string using symbol delimiters. For example,
  /// to make the text between '$' symbols red, you would include an attribute with the '$' symbol and a red text color.
  ///
  /// - Parameters:
  ///   - rawText: The input string containing symbol delimiters to denote areas to be stylized.
  ///   - pairs: A dictionary where each key is a symbol delimiter and the corresponding value is a set of attributes to apply.
  /// - Returns: An `NSAttributedString` with the attributes applied based on the symbol delimiters.
  static func with(
    _ rawText: String,
    attributesBetween pairs: [String: ([NSAttributedString.Key: Any])]
  ) -> NSAttributedString {

    // Replace any escaped symbols (e.g., \*) with a placeholder to prevent them from being processed.
    var preprocessedText = rawText
    for pair in pairs {
      let escapedSymbol = "\\\(pair.key)"
      let placeholder = "{\(pair.key)}" // Placeholder to replace escaped symbols.
      preprocessedText = preprocessedText.replacingOccurrences(of: escapedSymbol, with: placeholder)
    }

    let mutableAttributedString = NSMutableAttributedString(string: preprocessedText)

    // Use stacks to track the positions of opening and closing symbols.
    var symbolStack: [String] = []
    var startPositionStack: [String.Index] = []

    var currentIndex = preprocessedText.startIndex

    // Iterate through the string's characters.
    while currentIndex < preprocessedText.endIndex {
      let character = preprocessedText[currentIndex]
      let symbol = String(character)

      // If the current character matches a symbol from the pairs...
      if let pair = pairs.first(where: { $0.key == symbol }) {
        if symbolStack.contains(pair.key) {
          // If it's a closing symbol, pop from the stacks and apply the attributes.
          if let lastSymbol = symbolStack.last, lastSymbol == pair.key {
            let start = startPositionStack.removeLast()
            let range = NSRange(start..<currentIndex, in: preprocessedText)
            mutableAttributedString.addAttributes(pair.value, range: range)
            symbolStack.removeLast()
          }
        } else {
          // If it's an opening symbol, push its details to the stacks.
          symbolStack.append(pair.key)
          startPositionStack.append(currentIndex)
        }
      }
      
      currentIndex = preprocessedText.index(after: currentIndex)
    }

    // Remove the delimiter symbols from the final string.
    for pair in pairs {
      mutableAttributedString.mutableString.replaceOccurrences(
        of: pair.key,
        with: "",
        options: [],
        range: NSRange(location: 0, length: mutableAttributedString.length)
      )
    }

    // Replace placeholders with their original symbols (e.g., replace "{*}" with "*").
    for pair in pairs {
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
