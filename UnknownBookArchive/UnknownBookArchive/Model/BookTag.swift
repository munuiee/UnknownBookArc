import Foundation

enum BookTag: String, CaseIterable {
    case economy = "경제"
    case society = "사회"
    case science = "과학"
    case literature = "문학"
    case essay = "에세이"
    case history = "역사"
    case art = "예술"
    case humanity = "인문학"
    case selfImprovement = "자기계발"
    case children = "어린이"
    case foreign = "해외도서"
    
    var tagName: String {
        return self.rawValue
    }
}
