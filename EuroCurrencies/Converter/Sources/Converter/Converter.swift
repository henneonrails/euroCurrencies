// EuroCurrencies/Sources/EuroCurrencies/EuroCurrencies.swift

import Foundation

public actor EuroCurrencies {
  // MARK: - Types
  
  public enum EuroCurrenciesError: Error {
    case invalidResponse
    case networkError(Error)
    case parsingError
  }
  
  // MARK: - Properties
  
  private let isoCurrencySymbol: String
  private let ecbURL = URL(string: "http://www.ecb.europa.eu/stats/eurofxref/eurofxref-daily.xml")!
  @MainActor private let userDefaults = UserDefaults.standard
  
  @MainActor private(set) public var conversionRate: Double {
    get {
      userDefaults.double(forKey: isoCurrencySymbol)
    }
    set {
      userDefaults.set(newValue, forKey: isoCurrencySymbol)
      userDefaults.set(Date(), forKey: "DATE")
    }
  }
  
  @MainActor public var lastUpdateDate: Date? {
    get {
      userDefaults.object(forKey: "DATE") as? Date
    }
  }
  
  // MARK: - Initialization
  
  public init(currency: String) {
    self.isoCurrencySymbol = currency
  }
  
  // MARK: - Public Methods
  
  public func fetchConversionRate() async throws -> Double {
    let (data, response) = try await URLSession.shared.data(from: ecbURL)
    
    guard let httpResponse = response as? HTTPURLResponse,
          httpResponse.statusCode == 200 else {
      throw EuroCurrenciesError.invalidResponse
    }
    
    guard let xmlString = String(data: data, encoding: .utf8),
          let rate = parseXML(xmlString) else {
      throw EuroCurrenciesError.parsingError
    }
    
    await MainActor.run {
      self.conversionRate = rate
    }
    
    return rate
  }
  
  @MainActor
  public func convertToEuro(_ amount: Double) -> Double {
    guard amount != 0, conversionRate > 0 else { return 0 }
    return amount / conversionRate
  }
  
  // MARK: - Private Methods
  
  private func parseXML(_ xmlString: String) -> Double? {
    let components = xmlString.components(separatedBy: "<")
    
    for component in components where component.contains(isoCurrencySymbol) {
      guard let rateRange = component.range(of: "rate='"),
            let endQuoteRange = component[rateRange.upperBound...].firstIndex(of: "'") else {
        continue
      }
      
      let rateString = String(component[rateRange.upperBound..<endQuoteRange])
      return Double(rateString)
    }
    
    return nil
  }
}
