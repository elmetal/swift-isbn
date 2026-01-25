//
//  ISBN13TagTests.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

import Testing
import ISBN

extension Tag {
    static let isbn13 = Tag("isbn13")
}

struct ISBN13TagTests {
    @Test(.tags(.isbn13))
    func isbn13TagIsAvailable() throws {
        let isbn = try ISBN(
            prefixElement: "978",
            registrationGroupElement: "4",
            registrantElement: "87311",
            publicationElement: "593",
            checkDigit: "1"
        )

        let combinedDigits = isbn.prefixElement
            + isbn.registrationGroupElement
            + isbn.registrantElement
            + isbn.publicationElement
            + isbn.checkDigit

        #expect(combinedDigits.count == 13)
    }
}
