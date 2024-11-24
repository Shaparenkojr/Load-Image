

import Foundation
import UIKit

class Response {
    static let shared = Response()
    
    private init () {}
    
    func getUrlData(from url: URL, completion: @escaping ((Data?) -> Void)) {
        DispatchQueue.global().async {
            let imageDataTask = URLSession.shared.dataTask(with: url) { data, _, _ in
                if let dataImage = data {
                    DispatchQueue.main.async {
                        completion(dataImage)
                    }
                }
            }
            imageDataTask.resume()
        }
    }
}
