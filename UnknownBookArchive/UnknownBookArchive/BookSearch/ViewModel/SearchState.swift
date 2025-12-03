// MARK: 책 검색 페이지 분기

// 검색 페이지 상태 확인
enum SearchState {
    case initial
    case loading
    case success
    case error(Error)
}
