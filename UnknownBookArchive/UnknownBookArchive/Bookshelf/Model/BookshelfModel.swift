//
//  BookshelfModel.swift
//  UnknownBookArchive
//
//  Created by 김리하 on 11/24/25.
//

import Foundation

struct BookshelfBook {
    let title: String
    let author: String?
    let categoryIndex: Int   // 카테고리 인덱스 (0 = 전체, 1부터 각 카테고리)
}

// 샘플 데이터입니다. 추후에 변경 예정입니다.
enum SampleData {
    static let books: [BookshelfBook] = [
        BookshelfBook(title: "아몬드", author: "손원평", categoryIndex: 0),
        BookshelfBook(title: "부자아빠 가난한 아빠", author: "로버트 기요사키", categoryIndex: 1),
        BookshelfBook(title: "정의란 무엇인가", author: "마이클 샌델", categoryIndex: 2),
        BookshelfBook(title: "코스모스", author: "칼 세이건", categoryIndex: 3),
        BookshelfBook(title: "1984", author: "조지 오웰", categoryIndex: 4),
        BookshelfBook(title: "무도가", author: "김연수", categoryIndex: 5),
        BookshelfBook(title: "사피엔스", author: "유발 하라리", categoryIndex: 6),
        BookshelfBook(title: "반 고흐, 영혼의 편지", author: "빈센트 반 고흐", categoryIndex: 7),
        BookshelfBook(title: "죽음의 수용소에서", author: "빅터 프랭클", categoryIndex: 8),
        BookshelfBook(title: "아주 작은 습관의 힘", author: "제임스 클리어", categoryIndex: 9),
        BookshelfBook(title: "나의 라임 오렌지나무", author: "J.M. 바스콘셀로스", categoryIndex: 10),
        BookshelfBook(title: "해리 포터와 마법사의 돌", author: "J.K. 롤링", categoryIndex: 11)
    ]
}

