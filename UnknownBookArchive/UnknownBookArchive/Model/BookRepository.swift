import Foundation
import RxSwift

// 임시 테스용
enum APIError: Error {
    case invalidURL
}

class BookRepository {
    
    let apiKey: String
    let networkManager = NetworkManager.shared
    
    init() {
        self.apiKey = Bundle.main.infoDictionary?["APIKey"] as? String ?? ""
        
        if self.apiKey.isEmpty {
        }
    }
    func searchBooks(query: String) -> Single<[BookItem]> {
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx?ttbkey=\(apiKey)&Query=\(encodedQuery)&QueryType=Title&MaxResults=10&start=1&SearchTarget=Book&output=js&Version=20131101")
        else {
            return Single.error(APIError.invalidURL)
        }
        return networkManager.fetch(url: url)
            .map { (response: BookResponse) in
                return response.item
            }
    }
}
