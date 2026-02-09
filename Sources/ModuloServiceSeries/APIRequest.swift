import Foundation

struct APIRequest {
    let path: RouterSeries
    let method: HTTPMethod
    let body: Data?

    init(path: RouterSeries, method: HTTPMethod, body: Data? = nil) {
        self.path = path
        self.method = method
        self.body = body
    }
}
