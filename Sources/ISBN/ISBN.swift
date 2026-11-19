//
//  ISBN.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

/// A value that represents a validated ISBN.
///
/// An ``ISBN`` always stores the 13-digit form. Create one by providing each
/// element of the ISBN:
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
///
/// A 10-digit ISBN is another notation for an ISBN with the prefix element
/// "978". Create one with
/// ``init(registrationGroupElement:registrantElement:publicationElement:isbn10CheckDigit:)``
/// and write one out with the `isbn10` format style.
///
/// Two ``ISBN`` values are equal when their 13 digits are equal. Hyphens carry
/// no meaning in an ISBN, so values that divide the same digits into elements
/// differently are equal, even though their elements and formatted output
/// differ. An ISBN created from its 10-digit form is equal to the same ISBN
/// created from its 13-digit form.
public struct ISBN: Equatable, Hashable, Sendable {
    /// Validation failures that can occur while initializing an ``ISBN``.
    public enum ValidationError: Error, Equatable {
        /// The prefix element is not "978" or "979".
        case invalidPrefixElement(String)
        /// The registration group, registrant, or publication element is empty.
        /// Each of them consists of at least one digit.
        case emptyElement
        /// The registration group, registrant, or publication element has more
        /// digits than an ISBN allows: 5, 7, and 6 respectively. The associated
        /// value is the offending element.
        case elementTooLong(String)
        /// The registration group, registrant, or publication element contains
        /// a character other than the ASCII digits 0–9. The associated value is
        /// the offending element.
        case invalidCharacters(String)
        /// The overall digit count is not 13, or not 10 when creating an ISBN
        /// from its 10-digit form.
        case invalidTotalDigitCount(Int)
        /// The check digit is invalid for the provided digits.
        case invalidCheckDigit(String)
    }

    /// The prefix element: "978" or "979".
    public let prefixElement: String
    /// The registration group element.
    public let registrationGroupElement: String
    /// The registrant element.
    public let registrantElement: String
    /// The publication element.
    public let publicationElement: String
    /// The check digit of the 13-digit form: a digit from "0" to "9".
    public let checkDigit: String

    /// Creates a validated ISBN value from the elements of its 13-digit form.
    ///
    /// - Parameters:
    ///   - prefixElement: The prefix element: "978" or "979".
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
        guard Self.validPrefixElements.contains(prefixElement) else {
            throw ValidationError.invalidPrefixElement(prefixElement)
        }

        try Self.validateStructure(
            prefixDigitCount: prefixElement.count,
            registrationGroupElement: registrationGroupElement,
            registrantElement: registrantElement,
            publicationElement: publicationElement,
            checkDigit: checkDigit
        )

        let expectedCheckDigit = Self.isbn13CheckDigit(
            for: prefixElement + registrationGroupElement + registrantElement + publicationElement
        )
        guard checkDigit == expectedCheckDigit else {
            throw ValidationError.invalidCheckDigit(checkDigit)
        }

        self.prefixElement = prefixElement
        self.registrationGroupElement = registrationGroupElement
        self.registrantElement = registrantElement
        self.publicationElement = publicationElement
        self.checkDigit = checkDigit
    }
}

extension ISBN {
    /// The 13 digits of the ISBN without separators. This is the identity of
    /// the value: equality and hashing use nothing else.
    var digits: String {
        prefixElement
            + registrationGroupElement
            + registrantElement
            + publicationElement
            + checkDigit
    }

    public static func == (lhs: ISBN, rhs: ISBN) -> Bool {
        lhs.digits == rhs.digits
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(digits)
    }
}

extension ISBN {
    /// The number of digits that follow the prefix element, including the
    /// check digit. This is also the length of the 10-digit form.
    private static let digitCountAfterPrefix = 10

    /// Performs the checks that the 13-digit and 10-digit forms share: the
    /// length of the check digit, the three variable-length elements, and the
    /// total digit count. The value of the check digit is not checked.
    ///
    /// - Parameter prefixDigitCount: The number of digits before the
    ///   registration group element: 3 for the 13-digit form and 0 for the
    ///   10-digit form.
    static func validateStructure(
        prefixDigitCount: Int,
        registrationGroupElement: String,
        registrantElement: String,
        publicationElement: String,
        checkDigit: String
    ) throws {
        guard checkDigit.count == 1 else {
            throw ValidationError.invalidCheckDigit(checkDigit)
        }

        let elements = [
            (value: registrationGroupElement, maximumDigitCount: 5),
            (value: registrantElement, maximumDigitCount: 7),
            (value: publicationElement, maximumDigitCount: 6)
        ]
        for element in elements {
            guard !element.value.isEmpty else {
                throw ValidationError.emptyElement
            }
            guard element.value.allSatisfy({ $0.isASCII && $0.isWholeNumber }) else {
                throw ValidationError.invalidCharacters(element.value)
            }
            guard element.value.count <= element.maximumDigitCount else {
                throw ValidationError.elementTooLong(element.value)
            }
        }

        let totalDigitCount = prefixDigitCount
            + registrationGroupElement.count
            + registrantElement.count
            + publicationElement.count
            + checkDigit.count
        guard totalDigitCount == prefixDigitCount + digitCountAfterPrefix else {
            throw ValidationError.invalidTotalDigitCount(totalDigitCount)
        }
    }
}
