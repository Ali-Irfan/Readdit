import Alamofire
import Foundation

class NetworkManager {
    
    var manager: SessionManager!
    
    init() {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Accept-Encoding"] = "gzip"
        headers["UserAgent"] = "ios:com.dev.readdit:v1.0.0(by/u/thisbeali)"
        let config = URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background")
        config.httpAdditionalHeaders = headers
        config.timeoutIntervalForResource = 2 // seconds
        manager = Alamofire.SessionManager(configuration: config)
    }
}
