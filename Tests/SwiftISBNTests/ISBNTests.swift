//
//  ISBNTests.swift
//  swift-isbn
//  
//  Created by elmetal on 2026/01/25
//  
//

import Testing
import ISBN

struct ISBNTests {
    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenPrefixElementIsInvalid() {
        do {
            _ = try ISBN(
                prefixElement: "123",
                registrationGroupElement: "0",
                registrantElement: "12345",
                publicationElement: "678",
                checkDigit: "9"
            )

            Issue.record("Expected invalid prefixElement to throw")
        } catch let error as ISBN.ValidationError {
            #expect(error == .invalidPrefixElement("123"))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenTotalDigitCountIsNot13() {
        do {
            _ = try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "87311",
                publicationElement: "5933",
                checkDigit: "6"
            )

            Issue.record("Expected invalid totalDigitCount to throw")
        } catch let error as ISBN.ValidationError {
            #expect(error == .invalidTotalDigitCount(14))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenCheckDigitIsNotSingleDigit() {
        do {
            _ = try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "87311",
                publicationElement: "593",
                checkDigit: "67"
            )

            Issue.record("Expected invalid checkDigit to throw")
        } catch let error as ISBN.ValidationError {
            #expect(error == .invalidCheckDigit("67"))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenCheckDigitDoesNotMatchRule() {
        do {
            _ = try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "87311",
                publicationElement: "593",
                checkDigit: "6"
            )

            Issue.record("Expected invalid checkDigit rule to throw")
        } catch let error as ISBN.ValidationError {
            #expect(error == .invalidCheckDigit("6"))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test(.tags(.validation, .isbn10))
    func initAcceptsISBN10WhenPrefixElementIsEmpty() throws {
        _ = try ISBN(
            prefixElement: "",
            registrationGroupElement: "0",
            registrantElement: "306",
            publicationElement: "40615",
            checkDigit: "2"
        )
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenISBN13ContainsNonASCIIDigit() {
        #expect(throws: ISBN.ValidationError.self) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "４",
                registrantElement: "87311",
                publicationElement: "593",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation, .isbn10))
    func initThrowsWhenISBN10ContainsNonASCIIDigit() {
        #expect(throws: ISBN.ValidationError.self) {
            try ISBN(
                prefixElement: "",
                registrationGroupElement: "０",
                registrantElement: "306",
                publicationElement: "40615",
                checkDigit: "2"
            )
        }
    }

    @Test
    func isbnsWithSameElementsAreEqualAndHashEqually() throws {
        let lhs = try Self.makeISBN13()
        let rhs = try Self.makeISBN13()

        #expect(lhs == rhs)
        #expect(lhs.hashValue == rhs.hashValue)
    }

    @Test
    func isbnsWithDifferentElementsAreNotEqual() throws {
        let isbn13 = try Self.makeISBN13()
        let isbn10 = try Self.makeISBN10()

        #expect(isbn13 != isbn10)
    }

    @Test
    func isbnCanBeUsedAsSetElement() throws {
        let isbns: Set<ISBN> = [
            try Self.makeISBN13(),
            try Self.makeISBN13(),
            try Self.makeISBN10()
        ]

        #expect(isbns.count == 2)
    }

    @Test
    func isbnIsSendable() throws {
        // Fails to compile if `ISBN` stops being `Sendable`.
        let isbn: any Sendable = try Self.makeISBN13()

        #expect(isbn is ISBN)
    }

    private static func makeISBN13() throws -> ISBN {
        try ISBN(
            prefixElement: "978",
            registrationGroupElement: "4",
            registrantElement: "87311",
            publicationElement: "593",
            checkDigit: "1"
        )
    }

    private static func makeISBN10() throws -> ISBN {
        try ISBN(
            prefixElement: "",
            registrationGroupElement: "0",
            registrantElement: "306",
            publicationElement: "40615",
            checkDigit: "2"
        )
    }
}
