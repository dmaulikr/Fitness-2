import Foundation

enum DataBaseError: String, Error {
  case notCreated = "The data base couldn't be created properly"
  case notOpened = "The data base cannot be opened"
  case notClosed = "The data base cannot be closed"
  case tableNotCreated = "The table cannot be created"
  case exerciseNotAdded = "The exercise cannot be added"
  case execisesCannotBeRead = "The list of exercises is empty or cannot be read"
}