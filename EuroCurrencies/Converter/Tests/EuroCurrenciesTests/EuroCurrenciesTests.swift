import XCTest
@testable import EuroCurrencies

final class EuroCurrenciesTests: XCTestCase {
    var converter: EuroCurrencies!
    let userDefaults = UserDefaults.standard
    
    override func setUp() {
        super.setUp()
        converter = EuroCurrencies(currency: "USD")
        // Clean up any existing values
        userDefaults.removeObject(forKey: "USD")
        userDefaults.removeObject(forKey: "DATE")
    }
    
    override func tearDown() {
        converter = nil
        userDefaults.removeObject(forKey: "USD")
        userDefaults.removeObject(forKey: "DATE")
        super.tearDown()
    }
    
    func testInitialization() {
        XCTAssertNotNil(converter)
    }
    
    func testConvertToEuro() async throws {
        // Set a known conversion rate through UserDefaults
        userDefaults.set(1.1, forKey: "USD")
        userDefaults.set(Date(), forKey: "DATE")
        
        let result = await converter.convertToEuro(110.0)
        XCTAssertEqual(result, 100.0, accuracy: 0.001)
    }
    
    func testConvertToEuroWithZeroAmount() async throws {
        let result = await converter.convertToEuro(0.0)
        XCTAssertEqual(result, 0.0)
    }
    
    func testConvertToEuroWithZeroRate() async throws {
        // Set zero rate through UserDefaults
        userDefaults.set(0.0, forKey: "USD")
        userDefaults.set(Date(), forKey: "DATE")
        
        let result = await converter.convertToEuro(100.0)
        XCTAssertEqual(result, 0.0)
    }
    
    func testFetchConversionRate() async throws {
        do {
            let rate = try await converter.fetchConversionRate()
            XCTAssertGreaterThan(rate, 0.0)
            
            // Verify that the rate was stored
            let storedRate = await converter.conversionRate
            XCTAssertEqual(rate, storedRate)
        } catch {
            XCTFail("Failed to fetch conversion rate: \(error)")
        }
    }
    
    func testLastUpdateDate() async throws {
        // Initially should be nil
        var lastUpdate = await converter.lastUpdateDate
        XCTAssertNil(lastUpdate)
        
        // After fetching rate, should have a date
        let rate = try await converter.fetchConversionRate()
        XCTAssertGreaterThan(rate, 0.0)
        lastUpdate = await converter.lastUpdateDate
        XCTAssertNotNil(lastUpdate)
    }
    
    func testInvalidCurrency() {
        let invalidConverter = EuroCurrencies(currency: "INVALID")
        XCTAssertNotNil(invalidConverter)
    }
} 