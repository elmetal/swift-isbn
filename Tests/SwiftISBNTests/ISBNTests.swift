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
    func initFromISBN10StoresThe13DigitForm() throws {
        let isbn = try Self.makeISBN10()

        #expect(isbn.prefixElement == "978")
        #expect(isbn.registrationGroupElement == "0")
        #expect(isbn.registrantElement == "306")
        #expect(isbn.publicationElement == "40615")
        #expect(isbn.checkDigit == "7")
    }

    @Test(.tags(.validation, .isbn10))
    func isbnCreatedFromISBN10EqualsThe13DigitForm() throws {
        let fromISBN10 = try Self.makeISBN10()
        let fromISBN13 = try ISBN(
            prefixElement: "978",
            registrationGroupElement: "0",
            registrantElement: "306",
            publicationElement: "40615",
            checkDigit: "7"
        )

        #expect(fromISBN10 == fromISBN13)
    }

    @Test(.tags(.validation, .isbn10))
    func initThrowsWhenISBN10CheckDigitDoesNotMatchRule() {
        #expect(throws: ISBN.ValidationError.invalidCheckDigit("3")) {
            try ISBN(
                registrationGroupElement: "0",
                registrantElement: "306",
                publicationElement: "40615",
                isbn10CheckDigit: "3"
            )
        }
    }

    @Test(.tags(.validation, .isbn10))
    func initThrowsWhenISBN10TotalDigitCountIsNot10() {
        #expect(throws: ISBN.ValidationError.invalidTotalDigitCount(9)) {
            try ISBN(
                registrationGroupElement: "0",
                registrantElement: "306",
                publicationElement: "4061",
                isbn10CheckDigit: "2"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenPrefixElementIsEmpty() {
        #expect(throws: ISBN.ValidationError.invalidPrefixElement("")) {
            try ISBN(
                prefixElement: "",
                registrationGroupElement: "0",
                registrantElement: "306",
                publicationElement: "40615",
                checkDigit: "2"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenISBN13ContainsNonASCIIDigit() {
        #expect(throws: ISBN.ValidationError.invalidCharacters("４")) {
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
        #expect(throws: ISBN.ValidationError.invalidCharacters("０")) {
            try ISBN(
                registrationGroupElement: "０",
                registrantElement: "306",
                publicationElement: "40615",
                isbn10CheckDigit: "2"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenISBN13ElementContainsNonDigit() {
        #expect(throws: ISBN.ValidationError.invalidCharacters("8731A")) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "8731A",
                publicationElement: "593",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation, .isbn10))
    func initThrowsWhenISBN10ElementContainsNonDigit() {
        #expect(throws: ISBN.ValidationError.invalidCharacters("4061X")) {
            try ISBN(
                registrationGroupElement: "0",
                registrantElement: "306",
                publicationElement: "4061X",
                isbn10CheckDigit: "2"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initReportsNonDigitBeforeTotalDigitCount() {
        #expect(throws: ISBN.ValidationError.invalidCharacters("873-11")) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "873-11",
                publicationElement: "593",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsInvalidCheckDigitWhenCheckDigitIsNotDigit() {
        #expect(throws: ISBN.ValidationError.invalidCheckDigit("A")) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "87311",
                publicationElement: "593",
                checkDigit: "A"
            )
        }
    }

    @Test(.tags(.validation, .isbn10))
    func initAcceptsISBN10WithCheckDigitX() throws {
        _ = try ISBN(
            registrationGroupElement: "0",
            registrantElement: "8044",
            publicationElement: "2957",
            isbn10CheckDigit: "X"
        )
    }

    @Test(.tags(.validation, .isbn10))
    func initNormalizesLowercaseXCheckDigitForISBN10() throws {
        let lowercase = try ISBN(
            registrationGroupElement: "0",
            registrantElement: "8044",
            publicationElement: "2957",
            isbn10CheckDigit: "x"
        )
        let uppercase = try ISBN(
            registrationGroupElement: "0",
            registrantElement: "8044",
            publicationElement: "2957",
            isbn10CheckDigit: "X"
        )

        #expect(lowercase == uppercase)
        #expect(lowercase.formatted(.isbn10) == "0-8044-2957-X")
        #expect(lowercase.formatted(.isbn) == "978-0-8044-2957-3")
    }

    @Test(.tags(.validation, .isbn10))
    func initThrowsWhenLowercaseXIsNotTheExpectedISBN10CheckDigit() {
        #expect(throws: ISBN.ValidationError.invalidCheckDigit("x")) {
            try ISBN(
                registrationGroupElement: "0",
                registrantElement: "306",
                publicationElement: "40615",
                isbn10CheckDigit: "x"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenISBN13CheckDigitIsLowercaseX() {
        #expect(throws: ISBN.ValidationError.invalidCheckDigit("x")) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "87311",
                publicationElement: "593",
                checkDigit: "x"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenISBN13RegistrationGroupElementIsEmpty() {
        #expect(throws: ISBN.ValidationError.emptyElement) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "",
                registrantElement: "487311",
                publicationElement: "593",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenISBN13RegistrantElementIsEmpty() {
        #expect(throws: ISBN.ValidationError.emptyElement) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4873",
                registrantElement: "",
                publicationElement: "11593",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation, .isbn10))
    func initThrowsWhenISBN10PublicationElementIsEmpty() {
        #expect(throws: ISBN.ValidationError.emptyElement) {
            try ISBN(
                registrationGroupElement: "03",
                registrantElement: "0640615",
                publicationElement: "",
                isbn10CheckDigit: "2"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initReportsEmptyElementBeforeTotalDigitCount() {
        #expect(throws: ISBN.ValidationError.emptyElement) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "",
                registrantElement: "87311",
                publicationElement: "593",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenRegistrationGroupElementExceeds5Digits() {
        #expect(throws: ISBN.ValidationError.elementTooLong("123456")) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "123456",
                registrantElement: "1",
                publicationElement: "12",
                checkDigit: "0"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initThrowsWhenISBN13PublicationElementExceeds6Digits() {
        #expect(throws: ISBN.ValidationError.elementTooLong("7311593")) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "8",
                publicationElement: "7311593",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation, .isbn10))
    func initThrowsWhenISBN10PublicationElementExceeds6Digits() {
        #expect(throws: ISBN.ValidationError.elementTooLong("0640615")) {
            try ISBN(
                registrationGroupElement: "0",
                registrantElement: "3",
                publicationElement: "0640615",
                isbn10CheckDigit: "2"
            )
        }
    }

    @Test(.tags(.validation, .isbn13))
    func initReportsRegistrantElementExceeding7DigitsBeforeTotalDigitCount() {
        #expect(throws: ISBN.ValidationError.elementTooLong("87311593")) {
            try ISBN(
                prefixElement: "978",
                registrationGroupElement: "4",
                registrantElement: "87311593",
                publicationElement: "1",
                checkDigit: "1"
            )
        }
    }

    @Test(.tags(.validation))
    func initAcceptsElementsAtMaximumLength() throws {
        // 5-digit registration group element.
        _ = try ISBN(
            registrationGroupElement: "99921",
            registrantElement: "58",
            publicationElement: "10",
            isbn10CheckDigit: "7"
        )
        // 7-digit registrant element.
        _ = try ISBN(
            prefixElement: "978",
            registrationGroupElement: "1",
            registrantElement: "9160000",
            publicationElement: "0",
            checkDigit: "1"
        )
        // 6-digit publication element.
        _ = try ISBN(
            registrationGroupElement: "0",
            registrantElement: "00",
            publicationElement: "123456",
            isbn10CheckDigit: "0"
        )
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
            registrationGroupElement: "0",
            registrantElement: "306",
            publicationElement: "40615",
            isbn10CheckDigit: "2"
        )
    }
}
