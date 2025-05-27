import XCTest
@testable import ModuloServiceSeries

final class ModuloServiceSeriesTests: XCTestCase {

    var networkService: NetworkServiceProtocol!
    
    override func setUp() {
        super.setUp()
        networkService = NetworkService.shared
    }
    
    func testRequestSuccess() async {
        
        let request = APIRequest(path: "top_rated", method: .get)
        
        do {
            let series: Cover =  try await networkService.request(request)
            XCTAssertNotNil(series)
        } catch {
            XCTFail("Request failed with error: \(error)")
        }
    }
}
