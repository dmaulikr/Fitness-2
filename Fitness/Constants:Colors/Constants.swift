import UIKit

struct Constants {
  static let height = UIScreen.main.bounds.height
  static let width = UIScreen.main.bounds.width
  static let numberOfCardsPerRow = 2
  static let cardHeight = CGFloat(200)
  static let cardWidth = (width - leftMargin + rightMargin - 18)/CGFloat(numberOfCardsPerRow)
  static let userIconHeight = CGFloat(45)
  static let userIconWidth = CGFloat(45)
  static let leftMargin = CGFloat(10)
  static let rightMargin = CGFloat(-10)
  static let topMargin = CGFloat(30)
}
