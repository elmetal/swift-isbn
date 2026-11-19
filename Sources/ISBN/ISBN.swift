//
//  ISBN.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

/// A value that represents a validated ISBN-10 or ISBN-13.
///
/// Create an ``ISBN`` by providing each element of the ISBN. The initializer
/// validates the digits and check digit as ISBN-10 when the prefix element is
/// empty, and as ISBN-13 otherwise.
///
/// ```swift
/// let isbn = try ISBN(
///     prefixElement: "978",
///     registrationGroupElement: "4",
///     registrantElement: "87311",
///     publicationElement: "593",
///     checkDigit: "1"
/// )
/// ```
public struct ISBN {
    /// Validation failures that can occur while initializing an ``ISBN``.
    public enum ValidationError: Error, Equatable {
        /// The prefix element is not a valid ISBN-13 prefix.
        case invalidPrefixElement(String)
        /// The overall digit count does not match ISBN-10 or ISBN-13.
        case invalidTotalDigitCount(Int)
        /// The check digit is invalid for the provided digits.
        case invalidCheckDigit(String)
    }

    private enum InternalISBN {
        case isbn13(ISBN13)
        case isbn10(ISBN10)
    }

    /// The ISBN prefix element, or an empty string for ISBN-10.
    public let prefixElement: String
    /// The registration group element.
    public let registrationGroupElement: String
    /// The registrant element.
    public let registrantElement: String
    /// The publication element.
    public let publicationElement: String
    /// The check digit.
    public let checkDigit: String

    /// Creates a validated ISBN value from its components.
    ///
    /// - Parameters:
    ///   - prefixElement: The ISBN-13 prefix. Pass an empty string for ISBN-10.
    ///   - registrationGroupElement: The registration group element.
    ///   - registrantElement: The registrant element.
    ///   - publicationElement: The publication element.
    ///   - checkDigit: The check digit.
    /// - Throws: ``ISBN/ValidationError`` when the digits are invalid or the
    ///   check digit does not match.
    public init(
        prefixElement: String,
        registrationGroupElement: String,
        registrantElement: String,
        publicationElement: String,
        checkDigit: String
    ) throws {
        let internalISBN: InternalISBN
        if prefixElement.isEmpty {
            internalISBN = .isbn10(
                try ISBN10(
                    registrationGroupElement: registrationGroupElement,
                    registrantElement: registrantElement,
                    publicationElement: publicationElement,
                    checkDigit: checkDigit
                )
            )
        } else {
            internalISBN = .isbn13(
                try ISBN13(
                    prefixElement: prefixElement,
                    registrationGroupElement: registrationGroupElement,
                    registrantElement: registrantElement,
                    publicationElement: publicationElement,
                    checkDigit: checkDigit
                )
            )
        }

        switch internalISBN {
        case .isbn13(let isbn13):
            self.prefixElement = isbn13.prefixElement
            self.registrationGroupElement = isbn13.registrationGroupElement
            self.registrantElement = isbn13.registrantElement
            self.publicationElement = isbn13.publicationElement
            self.checkDigit = isbn13.checkDigit
        case .isbn10(let isbn10):
            self.prefixElement = isbn10.prefixElement
            self.registrationGroupElement = isbn10.registrationGroupElement
            self.registrantElement = isbn10.registrantElement
            self.publicationElement = isbn10.publicationElement
            self.checkDigit = isbn10.checkDigit
        }
    }
}
