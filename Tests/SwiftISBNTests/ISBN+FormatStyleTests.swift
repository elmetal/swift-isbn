//
//  ISBN+FormatStyleTests.swift
//  swift-isbn
//  
//  Created by elmetal on 2026/01/24
//  
//

import Testing
import ISBN

struct ISBNFormatStyleTests {
    @Test
    func formatStyleProducesHyphenSeparatedISBN() throws {
        let isbn = try ISBN(
            prefixElement: "978",
            registrationGroupElement: "4",
            registrantElement: "87311",
            publicationElement: "593",
            checkDigit: "1"
        )

        let formatted = ISBN.FormatStyle.isbn.format(isbn)

        #expect(formatted == "978-4-87311-593-1")
    }

    @Test
    func formattedHelperUsesISBNFormatStyle() throws {
        let isbn = try ISBN(
            prefixElement: "979",
            registrationGroupElement: "10",
            registrantElement: "1234",
            publicationElement: "567",
            checkDigit: "8"
        )

        let formatted = isbn.formatted(.isbn)

        #expect(formatted == "979-10-1234-567-8")
    }

    @Test
    func isbnStyleRenders13DigitFormForISBNCreatedFromISBN10() throws {
        let isbn = try ISBN(
            registrationGroupElement: "0",
            registrantElement: "306",
            publicationElement: "40615",
            isbn10CheckDigit: "2"
        )

        #expect(isbn.formatted(.isbn) == "978-0-306-40615-7")
    }

    @Test
    func isbn10StyleRendersISBNCreatedFromISBN10() throws {
        let isbn = try ISBN(
            registrationGroupElement: "0",
            registrantElement: "306",
            publicationElement: "40615",
            isbn10CheckDigit: "2"
        )

        let formatted: String? = isbn.formatted(.isbn10)

        #expect(formatted == "0-306-40615-2")
    }

    @Test
    func isbn10StyleRecalculatesCheckDigitForISBNCreatedFrom13DigitForm() throws {
        let isbn = try ISBN(
            prefixElement: "978",
            registrationGroupElement: "4",
            registrantElement: "87311",
            publicationElement: "593",
            checkDigit: "1"
        )

        #expect(isbn.formatted(.isbn10) == "4-87311-593-0")
    }

    @Test
    func isbn10StyleReturnsNilForPrefixElement979() throws {
        let isbn = try ISBN(
            prefixElement: "979",
            registrationGroupElement: "10",
            registrantElement: "1234",
            publicationElement: "567",
            checkDigit: "8"
        )

        #expect(isbn.formatted(.isbn10) == nil)
    }
}
