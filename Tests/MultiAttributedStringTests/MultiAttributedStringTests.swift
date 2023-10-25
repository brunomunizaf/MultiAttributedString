import XCTest
@testable import MultiAttributedString

final class MultiAttributedStringTests: XCTestCase {
  var pairs: [AttributeSymbolPair]!

  override func tearDown() {
    pairs = nil
    super.tearDown()
  }

  override func setUp() {
    super.setUp()

    let attachment = NSTextAttachment()
    attachment.image = UIImage(named: "sampleImage")
    attachment.bounds = CGRect(x: 0, y: 0, width: 50, height: 50)

    pairs = [
      AttributeSymbolPair(attributes: [.foregroundColor: UIColor.red], symbol: "$"),
      AttributeSymbolPair(attributes: [.foregroundColor: UIColor.blue], symbol: "#"),
      AttributeSymbolPair(attributes: [.foregroundColor: UIColor.purple], symbol: "@"),
      AttributeSymbolPair(attributes: [.link: URL(string: "https://www.example.com")!], symbol: "^"),
      AttributeSymbolPair(attributes: [.attachment: attachment], symbol: "*")
    ]
  }

  // This test checks the basic functionality of the extension by ensuring that text between `$` symbols is colored red.
  func testSimpleAttribution() {
    let result = NSAttributedString.with("This is $red$ text.", attributesBetween: pairs)
    let range = (result.string as NSString).range(of: "red")
    let attributes = result.attributes(at: range.location, effectiveRange: nil)

    XCTAssertEqual(attributes[.foregroundColor] as! UIColor, UIColor.red)
  }

  // This test ensures that symbols preceded by a backslash (`\`) are treated as literals and not as attribute delimiters.
  func testEscapeCharacter() {
    let result = NSAttributedString.with("This is \\$not red\\$ text but this is $red$.", attributesBetween: pairs)

    let rangeOfNotRed = (result.string as NSString).range(of: "not red")
    let attributesOfNotRed = result.attributes(at: rangeOfNotRed.location, effectiveRange: nil)
    XCTAssertNil(attributesOfNotRed[.foregroundColor])

    let rangeOfRed = (result.string as NSString).range(of: "red", options: .backwards)
    let attributesOfRed = result.attributes(at: rangeOfRed.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfRed[.foregroundColor] as! UIColor, UIColor.red)
  }

  // This test checks that multiple attribute pairs can be applied correctly within the same string.
  func testMultipleAttributions() {
    let result = NSAttributedString.with("This is $red$ and this is #blue#.", attributesBetween: pairs)

    let rangeOfRed = (result.string as NSString).range(of: "red")
    let attributesOfRed = result.attributes(at: rangeOfRed.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfRed[.foregroundColor] as! UIColor, UIColor.red)

    let rangeOfBlue = (result.string as NSString).range(of: "blue")
    let attributesOfBlue = result.attributes(at: rangeOfBlue.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfBlue[.foregroundColor] as! UIColor, UIColor.blue)
  }

  // This test evaluates how nested symbols are handled, ensuring that the innermost symbols are processed first.
  func testNestedSymbols() {
    let result = NSAttributedString.with("This is a $#nested$# test.", attributesBetween: pairs)

    let rangeOfNested = (result.string as NSString).range(of: "nested")
    let attributesOfNested = result.attributes(at: rangeOfNested.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfNested[.foregroundColor] as! UIColor, UIColor.red)

    let rangeOfFullNestedText = (result.string as NSString).range(of: "nested", options: .backwards)
    let attributesOfFullNestedText = result.attributes(at: rangeOfFullNestedText.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfFullNestedText[.foregroundColor] as! UIColor, UIColor.blue)
  }

  // This test checks how consecutive different attributes are applied without overlapping.
  func testConsecutiveDifferentAttributes() {
    let result = NSAttributedString.with("This is $red$#blue# text.", attributesBetween: pairs)

    let rangeOfRed = (result.string as NSString).range(of: "red")
    let attributesOfRed = result.attributes(at: rangeOfRed.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfRed[.foregroundColor] as! UIColor, UIColor.red)

    let rangeOfBlue = (result.string as NSString).range(of: "blue")
    let attributesOfBlue = result.attributes(at: rangeOfBlue.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfBlue[.foregroundColor] as! UIColor, UIColor.blue)
  }

  // This test ensures that unpaired symbols are ignored and don't apply any attributes.
  func testUnpairedSymbols() {
    let result = NSAttributedString.with("This is $unpaired text.", attributesBetween: pairs)

    let rangeOfUnpaired = (result.string as NSString).range(of: "unpaired")
    let attributesOfUnpaired = result.attributes(at: rangeOfUnpaired.location, effectiveRange: nil)
    XCTAssertNil(attributesOfUnpaired[.foregroundColor])
  }

  // This test checks how adjacent symbols are processed, ensuring that each symbol pair applies its respective attributes correctly.
  func testAdjacentSymbols() {
    let result = NSAttributedString.with("This is $red$#blue# text.", attributesBetween: pairs)

    let rangeOfRed = (result.string as NSString).range(of: "red")
    let attributesOfRed = result.attributes(at: rangeOfRed.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfRed[.foregroundColor] as! UIColor, UIColor.red)

    let rangeOfBlue = (result.string as NSString).range(of: "blue")
    let attributesOfBlue = result.attributes(at: rangeOfBlue.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfBlue[.foregroundColor] as! UIColor, UIColor.blue)
  }

  // This test ensures that multiple escaped symbols within a string are correctly treated as literals.
  func testMultipleEscapedSymbols() {
    let result = NSAttributedString.with("This is \\$not\\$ \\#colored\\# text.", attributesBetween: pairs)

    let rangeOfNot = (result.string as NSString).range(of: "not")
    let attributesOfNot = result.attributes(at: rangeOfNot.location, effectiveRange: nil)
    XCTAssertNil(attributesOfNot[.foregroundColor])

    let rangeOfColored = (result.string as NSString).range(of: "colored")
    let attributesOfColored = result.attributes(at: rangeOfColored.location, effectiveRange: nil)
    XCTAssertNil(attributesOfColored[.foregroundColor])
  }
}

