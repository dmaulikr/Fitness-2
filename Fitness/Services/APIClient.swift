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

extension APIClient {
  func JSONTaskWithRequest(request: NSURLRequest, completion: @escaping JSONTaskCompletion) -> JSONTask {
    
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      
      guard let HTTPResponse = response as? HTTPURLResponse else {
        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("Missing HTTP Response", comment: "")
        ]
        
        let error = NSError(domain: JBJNetworkingErrorDomain, code: MissingHTTPResponseError, userInfo: userInfo)
        completion(nil, nil, error)
        return
      }
      
      if data == nil {
        if let error = error {
          completion(nil, HTTPResponse, error as NSError?)
        }
      } else {
        switch HTTPResponse.statusCode {
        case 200:
          do {
            let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject]
            completion(json, HTTPResponse, nil)
          } catch let error as NSError {
            completion(nil, HTTPResponse, error)
          }
        default: print("Received HTTP Response: \(HTTPResponse.statusCode) - not handled")
        }
      }
    }
    
    return task
  }
  
  func fetch<T: JSONDecodable>(endpoint: Endpoint, parse: @escaping (JSON) -> [T]?, completion: @escaping (APIResult<[T]>) -> Void) {
    let request: URLRequest = endpoint.request
    
    let task = JSONTaskWithRequest(request: request as NSURLRequest) { json, response, error in
      
      DispatchQueue.main.async {
        guard let json = json else {
          if let error = error {
            completion(.Failure(error))
          } else {
            // TODO: Implement Error Handling
          }
          return
        }
        
        if let value = parse(json) {
          completion(.Success(value))
        } else {
          let error = NSError(domain: JBJNetworkingErrorDomain, code: UnexpectedResponseError, userInfo: nil)
          completion(.Failure(error))
        }
      }
    }
    
    task.resume()
  }
}

extension Endpoint {
  
  var request: URLRequest {
    let components = NSURLComponents(string: baseURL)!
    components.path = path
    
    let url = components.url!
    return URLRequest(url: url)
  }
  
}
