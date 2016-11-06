import Foundation

enum DataBaseError: String, Error {
  case notCreated = "The data base couldn't be created properly"
  case notOpened = "The data base cannot be opened"
  case notClosed = "The data base cannot be closed"
  case tableNotCreated = "The table cannot be created"
  case exerciseNotAdded = "The exercise cannot be added"
  case execisesCannotBeRead = "The list of exercises is empty or cannot be read"
}

enum ConversionError: String, Error {
  case fromStringToInt = "Cannot convert tis string into an Int"
}

enum NetworkErrors: String, Error {
  case noError = "Any Error available, things went so wrong..."
}
