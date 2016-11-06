import UIKit

struct Exercise: JSONDecodable {
  let id: Int
  let name: String
  let imageURL: String
 
  init?(JSON: [String: AnyObject]) {
    guard let id = JSON["id"] as? Int else { return nil }
    guard let name = JSON["name"] as? String else { return nil }
    guard let imageURL = JSON["image_url"] as? String else { return nil }
    
    self.id = id
    self.name = name
    self.imageURL = imageURL
  }
}
