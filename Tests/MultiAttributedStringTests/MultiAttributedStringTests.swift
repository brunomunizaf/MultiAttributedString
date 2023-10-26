import XCTest
@testable import MultiAttributedString

final class MultiAttributedStringTests: XCTestCase {
  // Test attribute application between `$` symbols.
  func testSimpleAttribution() {
    let result = "This is $red$ text.".applying(
      attributes: [
        "$": [.foregroundColor: UIColor.red]
      ]
    )
    let range = (result.string as NSString).range(of: "red")
    let attributes = result.attributes(at: range.location, effectiveRange: nil)

    XCTAssertEqual(attributes[.foregroundColor] as! UIColor, UIColor.red)
  }

  // Test escaping of symbols using a backslash.
  func testEscapeCharacter() {
    let result = "This is \\$not red\\$ text but this is $red$.".applying(
      attributes: [
        "$": [.foregroundColor: UIColor.red]
      ]
    )
    let rangeOfNotRed = (result.string as NSString).range(of: "not red")
    let attributesOfNotRed = result.attributes(at: rangeOfNotRed.location, effectiveRange: nil)
    XCTAssertNil(attributesOfNotRed[.foregroundColor])

    let rangeOfRed = (result.string as NSString).range(of: "red", options: .backwards)
    let attributesOfRed = result.attributes(at: rangeOfRed.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfRed[.foregroundColor] as! UIColor, UIColor.red)
  }

  // Test application of multiple attributes.
  func testMultipleAttributions() {
    let result = "This is $red$ and this is #blue#.".applying(
      attributes: [
        "$": [.foregroundColor: UIColor.red],
        "#": [.foregroundColor: UIColor.blue]
      ]
    )
    let rangeOfRed = (result.string as NSString).range(of: "red")
    let attributesOfRed = result.attributes(at: rangeOfRed.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfRed[.foregroundColor] as! UIColor, UIColor.red)

    let rangeOfBlue = (result.string as NSString).range(of: "blue")
    let attributesOfBlue = result.attributes(at: rangeOfBlue.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfBlue[.foregroundColor] as! UIColor, UIColor.blue)
  }

  // Test nested symbols' attribute application.
  func testNestedSymbols() {
    let result = "This is a $#nested$# test.".applying(
      attributes: [
        "$": [.foregroundColor: UIColor.red],
        "#": [.foregroundColor: UIColor.blue]
      ]
    )
    let rangeOfNested = (result.string as NSString).range(of: "nested")
    let attributesOfNested = result.attributes(at: rangeOfNested.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfNested[.foregroundColor] as! UIColor, UIColor.red)
  }

  // Test consecutive non-overlapping attributes.
  func testConsecutiveDifferentAttributes() {
    let result = "This is $red$#blue# text.".applying(
      attributes: [
        "$": [.foregroundColor: UIColor.red],
        "#": [.foregroundColor: UIColor.blue]
      ]
    )
    let rangeOfRed = (result.string as NSString).range(of: "red")
    let attributesOfRed = result.attributes(at: rangeOfRed.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfRed[.foregroundColor] as! UIColor, UIColor.red)

    let rangeOfBlue = (result.string as NSString).range(of: "blue")
    let attributesOfBlue = result.attributes(at: rangeOfBlue.location, effectiveRange: nil)
    XCTAssertEqual(attributesOfBlue[.foregroundColor] as! UIColor, UIColor.blue)
  }

  // Test that unpaired symbols don't apply attributes.
  func testUnpairedSymbols() {
    let result = "This is $unpaired text.".applying(
      attributes: [
        "$": [.foregroundColor: UIColor.red]
      ]
    )
    let rangeOfUnpaired = (result.string as NSString).range(of: "unpaired")
    let attributesOfUnpaired = result.attributes(at: rangeOfUnpaired.location, effectiveRange: nil)
    XCTAssertNil(attributesOfUnpaired[.foregroundColor])
  }

  // Test handling of multiple escaped symbols.
  func testMultipleEscapedSymbols() {
    let result = "This is \\$not\\$ \\#colored\\# text.".applying(
      attributes: [
        "$": [.foregroundColor: UIColor.red],
        "#": [.foregroundColor: UIColor.blue]
      ]
    )
    let rangeOfNot = (result.string as NSString).range(of: "not")
    let attributesOfNot = result.attributes(at: rangeOfNot.location, effectiveRange: nil)
    XCTAssertNil(attributesOfNot[.foregroundColor])

    let rangeOfColored = (result.string as NSString).range(of: "colored")
    let attributesOfColored = result.attributes(at: rangeOfColored.location, effectiveRange: nil)
    XCTAssertNil(attributesOfColored[.foregroundColor])
  }
}
