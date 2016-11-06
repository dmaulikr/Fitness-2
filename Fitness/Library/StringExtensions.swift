import Foundation

extension String {
  // Description: Converts a given string to int
  // Out: (Int) The result from converting the string into an int
  func convertStringToInt() throws -> Int? {
    if !self.isNumeric() { throw ConversionError.fromStringToInt }
    guard let integer = Int(self) else { throw ConversionError.fromStringToInt }
    return integer
  }
  
  // Description: Check if a string is nummeric
  // Out: (Bool) True if the string is nummeric, false otherwise
  func isNumeric() -> Bool {
    let scanner = Scanner(string: self)
    
    scanner.locale = NSLocale.current
    
    return scanner.scanDecimal(nil) && scanner.isAtEnd
  }
}
