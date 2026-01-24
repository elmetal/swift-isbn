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
            checkDigit: "6"
        )

        let formatted = ISBN.FormatStyle.isbn.format(isbn)

        #expect(formatted == "978-4-87311-593-6")
    }

    @Test
    func formattedHelperUsesISBNFormatStyle() throws {
        let isbn = try ISBN(
            prefixElement: "979",
            registrationGroupElement: "10",
            registrantElement: "1234",
            publicationElement: "567",
            checkDigit: "9"
        )

        let formatted = isbn.formatted(.isbn)

        #expect(formatted == "979-10-1234-567-9")
    }

    @Test
    func initThrowsWhenPrefixElementIsInvalid() {
        do {
            _ = try ISBN(
                prefixElement: "",
                registrationGroupElement: "0",
                registrantElement: "12345",
                publicationElement: "678",
                checkDigit: "9"
            )

            Issue.record("Expected invalid prefixElement to throw")
        } catch let error as ISBN.ValidationError {
            #expect(error == .invalidPrefixElement(""))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
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

    @Test
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
}
