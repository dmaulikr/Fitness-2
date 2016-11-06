import Foundation

public let JBJNetworkingErrorDomain = "com.josepbordes.apiawakens"
public let MissingHTTPResponseError: Int = 10
public let UnexpectedResponseError: Int = 20

typealias JSON = [String : AnyObject]
typealias JSONTaskCompletion = (JSON?, HTTPURLResponse?, NSError?) -> Void
typealias JSONTask = URLSessionDataTask

enum APIResult<T> {
  case Success(T)
  case Failure(Error)
}

protocol JSONDecodable {
  init?(JSON: [String : AnyObject])
}

protocol Endpoint {
  var baseURL: String { get }
  var path: String { get }
}

protocol APIClient {
  var configuration: URLSessionConfiguration { get }
  var session: URLSession { get }
}
