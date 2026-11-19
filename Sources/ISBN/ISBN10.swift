//
//  ISBN10.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

extension ISBN {
    /// The prefix element that every 10-digit ISBN implicitly belongs to.
    static let isbn10PrefixElement = "978"

    /// Creates a validated ISBN value from the elements of its 10-digit form.
    ///
    /// The value is stored in the 13-digit form: ``prefixElement`` is "978" and
    /// ``checkDigit`` is recalculated.
    ///
    /// ```swift
    /// let isbn = try ISBN(
    ///     registrationGroupElement: "0",
    ///     registrantElement: "306",
    ///     publicationElement: "40615",
    ///     isbn10CheckDigit: "2"
    /// )
    /// isbn.formatted(.isbn) // "978-0-306-40615-7"
    /// ```
    ///
    /// - Parameters:
    ///   - registrationGroupElement: The registration group element.
    ///   - registrantElement: The registrant element.
    ///   - publicationElement: The publication element.
    ///   - isbn10CheckDigit: The check digit of the 10-digit form: a digit or
    ///     "X". A lowercase "x" is also accepted.
    /// - Throws: ``ISBN/ValidationError`` when the digits are invalid or the
    ///   check digit does not match.
    public init(
        registrationGroupElement: String,
        registrantElement: String,
        publicationElement: String,
        isbn10CheckDigit: String
    ) throws {
        try Self.validateStructure(
            prefixDigitCount: 0,
            registrationGroupElement: registrationGroupElement,
            registrantElement: registrantElement,
            publicationElement: publicationElement,
            checkDigit: isbn10CheckDigit
        )

        let digits = registrationGroupElement + registrantElement + publicationElement
        // A lowercase "x" is accepted as input for the standard form "X".
        let normalizedCheckDigit = isbn10CheckDigit == "x" ? "X" : isbn10CheckDigit
        guard normalizedCheckDigit == Self.isbn10CheckDigit(for: digits) else {
            throw ValidationError.invalidCheckDigit(isbn10CheckDigit)
        }

        self.prefixElement = Self.isbn10PrefixElement
        self.registrationGroupElement = registrationGroupElement
        self.registrantElement = registrantElement
        self.publicationElement = publicationElement
        self.checkDigit = Self.isbn13CheckDigit(for: Self.isbn10PrefixElement + digits)
    }

    /// Returns the check digit of the 10-digit form for the 9 digits that
    /// precede it: a digit, or "X" for the value 10.
    ///
    /// - Parameter digits: The registration group, registrant, and publication
    ///   elements, already validated to contain only ASCII digits.
    static func isbn10CheckDigit(for digits: String) -> String {
        let weights = stride(from: 10, through: 2, by: -1)
        let sum = zip(digits.compactMap(\.wholeNumberValue), weights)
            .reduce(0) { sum, pair in sum + pair.0 * pair.1 }
        let value = (11 - (sum % 11)) % 11
        return value == 10 ? "X" : String(value)
    }
}
