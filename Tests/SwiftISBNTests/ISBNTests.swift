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
}
