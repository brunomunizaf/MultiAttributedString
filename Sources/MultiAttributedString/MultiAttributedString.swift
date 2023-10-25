import UIKit

/// Represents a combination of text attributes and a unique symbol to apply those attributes.
/// The symbol acts as a delimiter, indicating where to start and stop applying the given attributes.
public struct AttributeSymbolPair {

  /// The set of attributes to be applied to the text enclosed by the associated symbol.
  let attributes: [NSAttributedString.Key: Any]

  /// The unique symbol used as a delimiter to signal where the attributes should be applied.
  let symbol: String
}

public extension NSAttributedString {

  /// Creates an attributed string by applying the specified attributes between given symbol pairs.
  ///
  /// This method allows for easy creation of attributed strings using simple symbol delimiters
  /// to specify where certain attributes should be applied. For instance, if you wanted to make
  /// text between '$' symbols red, you would include an `AttributeSymbolPair` with the '$' symbol
  /// and a red text color attribute.
  ///
  /// - Parameters:
  ///   - rawText: The original string containing symbol delimiters.
  ///   - pairs: An array of `AttributeSymbolPair` objects defining which attributes to apply and where.
  /// - Returns: An `NSAttributedString` with the specified attributes applied.
  static func with(
    _ rawText: String,
    attributesBetween pairs: [AttributeSymbolPair]
  ) -> NSAttributedString {

    // Replace any escaped symbols with a placeholder to ensure they are not processed.
    var preprocessedText = rawText
    for pair in pairs {
      let escapedSymbol = "\\\(pair.symbol)"
      let placeholder = "{\(pair.symbol)}" // Placeholder to replace escaped symbols.
      preprocessedText = preprocessedText.replacingOccurrences(of: escapedSymbol, with: placeholder)
    }

    let mutableAttributedString = NSMutableAttributedString(string: preprocessedText)

    // Stacks to manage the opening and closing of symbols.
    var symbolStack: [String] = []
    var startPositionStack: [String.Index] = []

    var currentIndex = preprocessedText.startIndex

    // Process each character in the string.
    while currentIndex < preprocessedText.endIndex {
      let character = preprocessedText[currentIndex]
      let symbol = String(character)

      // Check if the current character matches any of the symbols from the pairs.
      if let pair = pairs.first(where: { $0.symbol == symbol }) {
        if symbolStack.contains(pair.symbol) {
          if let lastSymbol = symbolStack.last, lastSymbol == pair.symbol {
            let start = startPositionStack.removeLast()
            let range = NSRange(start..<currentIndex, in: preprocessedText)
            mutableAttributedString.addAttributes(pair.attributes, range: range)
            symbolStack.removeLast()
          }
        } else {
          // If it's an opening symbol, push to the stacks.
          symbolStack.append(pair.symbol)
          startPositionStack.append(currentIndex)
        }
      }

      currentIndex = preprocessedText.index(after: currentIndex)
    }

    // Remove the symbols from the final string.
    for pair in pairs {
      mutableAttributedString.mutableString.replaceOccurrences(
        of: pair.symbol,
        with: "",
        options: [],
        range: NSRange(location: 0, length: mutableAttributedString.length)
      )
    }

    // Replace placeholders with their original symbols.
    for pair in pairs {
      let placeholder = "{\(pair.symbol)}"
      mutableAttributedString.mutableString.replaceOccurrences(
        of: placeholder,
        with: pair.symbol,
        options: [],
        range: NSRange(location: 0, length: mutableAttributedString.length)
      )
    }

    return mutableAttributedString
  }
}
