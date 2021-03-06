// CountryKit

import XCTest
@testable import CountryKit

final class CountryKitTests: XCTestCase {

  let sut = CountryKit()

  // tests if all iOS regions code are mapped in CountryKit.
  func testRegionCodes() {
    for regionCode in  Locale.isoRegionCodes {
      let match = sut.countries.filter { $0.iso == regionCode }
      XCTAssertTrue(match.count == 1, "\(regionCode) hasn't a match in the CountryKit library.")
    }
  }

  // tests if all CountryKit's countries are mapped in iOS regions code.
  func testCountries() {
    let regionCodes = Locale.isoRegionCodes

    for country in sut.countries {
      let match = regionCodes.filter { $0 == country.iso }
      XCTAssertTrue(match.count == 1, "\(country) is not available.")
    }
  }

  func testSequence() {
    let iterator = sut.makeIterator()

    var count = 0
    while iterator.next() != nil { count += 1 }
    XCTAssert(sut.countries.count == count)
  }

  func testDescription() {
    // nothing to test here...
    for country in sut.countries {
      print("\(country)\n")
    }
  }

  func testCurrentCountry() {
    // In schemas settings for tests, the Application Region is set to Italy
    let currentCountry = sut.current
    XCTAssertNotNil(currentCountry)
    XCTAssertTrue(currentCountry?.name == "Italy")
  }

  func testLocalizedName() {
    for country in sut.countries {
      XCTAssertTrue(country.localizedName != "", "\(country) shouldn't have an empty localized name image.")
    }
  }

  func testInitializer() {
    let country = Country(name: "Italy", iso: "IT", phoneCode: 39, countryCode: 380)

    XCTAssertTrue(country.name == "Italy")
    XCTAssertTrue(country.iso == "IT")
    XCTAssertTrue(country.phoneCode == 39)
    XCTAssertTrue(country.countryCode == 380)
    XCTAssertTrue(country.emoji == "🇮🇹")
  }

  func testSearchByIsoCode() {
    let italy = sut.searchByIsoCode("IT")
    XCTAssertNotNil(italy)
    XCTAssertTrue(italy?.emoji == "🇮🇹")

    let japan = sut.searchByIsoCode("jp")
    XCTAssertNotNil(japan)
    XCTAssertTrue(japan?.emoji == "🇯🇵")

    let unknown1 = sut.searchByIsoCode("xYz")
    XCTAssertNil(unknown1)

    let unknown2 = sut.searchByIsoCode("")
    XCTAssertNil(unknown2)
  }

  func testEmoji() {
    for country in sut.countries {
      XCTAssertFalse(country.emoji == "")
      XCTAssertTrue(country.emoji.isEmojiFlag)
    }
  }

}
