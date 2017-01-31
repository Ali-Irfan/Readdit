import Alamofire
import Foundation

class NetworkManager {
    
    var manager: SessionManager!
    
    init() {
        let bundleIdentifier = Bundle.main.bundleIdentifier
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Accept-Encoding"] = "gzip"
        headers["UserAgent"] = "ios:com.dev.readdit:v1.0.0(by/u/thisbeali)"
        //let config = URLSessionConfiguration.background(withIdentifier: bundleIdentifier! + ".background")
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = headers
        config.timeoutIntervalForResource = 10 // seconds
        manager = Alamofire.SessionManager(configuration: config)
    }
}
