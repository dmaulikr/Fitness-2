import Foundation

enum FitnessEndpoint: Endpoint {
  case exercises
  
  var baseURL: String {
    return "https://s3-us-west-1.amazonaws.com"
  }
  
  var path: String {
    return "/fizzup/files/public/sample.json"
  }
}

final class FitnessClient: APIClient {
  let configuration: URLSessionConfiguration
  
  lazy var session: URLSession = {
    return URLSession(configuration: self.configuration)
  }()
  
  init(configuration: URLSessionConfiguration) {
    self.configuration = configuration
  }
  
  convenience init() {
    self.init(configuration: .default)
  }
  
  func fetchExercises(completion: @escaping (APIResult<[Exercise]>) -> Void) {
    let endpoint = FitnessEndpoint.exercises
    
    fetch(endpoint: endpoint, parse: { (json) -> [Exercise]? in
      guard let exercises = json["data"] as? [[String: AnyObject]] else { return nil }
      
      return exercises.flatMap { exercisesDict in
        return Exercise(JSON: exercisesDict)
      }
    }, completion: completion)
  }


}
