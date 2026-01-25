//
//  ISBN.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

public struct ISBN {
    public enum ValidationError: Error, Equatable {
        case invalidPrefixElement(String)
        case invalidTotalDigitCount(Int)
        case invalidCheckDigit(String)
    }

    private enum InternalISBN {
        case isbn13(ISBN13)
        case isbn10(ISBN10)
    }

    public let prefixElement: String
    public let registrationGroupElement: String
    public let registrantElement: String
    public let publicationElement: String
    public let checkDigit: String

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

private struct ISBN13 {
    let prefixElement: String
    let registrationGroupElement: String
    let registrantElement: String
    let publicationElement: String
    let checkDigit: String

    private static let validPrefixElements: Set<String> = ["978", "979"]
    private static let expectedTotalDigitCount = 13

    init(
        prefixElement: String,
        registrationGroupElement: String,
        registrantElement: String,
        publicationElement: String,
        checkDigit: String
    ) throws {
        guard Self.validPrefixElements.contains(prefixElement) else {
            throw ISBN.ValidationError.invalidPrefixElement(prefixElement)
        }

        guard checkDigit.count == 1 else {
            throw ISBN.ValidationError.invalidCheckDigit(checkDigit)
        }

        let totalDigitCount = prefixElement.count
            + registrationGroupElement.count
            + registrantElement.count
            + publicationElement.count
            + checkDigit.count
        guard totalDigitCount == Self.expectedTotalDigitCount else {
            throw ISBN.ValidationError.invalidTotalDigitCount(totalDigitCount)
        }

        let digitsWithoutCheckDigit = prefixElement
            + registrationGroupElement
            + registrantElement
            + publicationElement
        guard let expectedCheckDigit = Self.expectedCheckDigit(for: digitsWithoutCheckDigit) else {
            throw ISBN.ValidationError.invalidCheckDigit(checkDigit)
        }

        guard checkDigit == expectedCheckDigit else {
            throw ISBN.ValidationError.invalidCheckDigit(checkDigit)
        }

        self.prefixElement = prefixElement
        self.registrationGroupElement = registrationGroupElement
        self.registrantElement = registrantElement
        self.publicationElement = publicationElement
        self.checkDigit = checkDigit
    }

    static func expectedCheckDigit(for digitsWithoutCheckDigit: String) -> String? {
        guard digitsWithoutCheckDigit.count == expectedTotalDigitCount - 1 else {
            return nil
        }

        var sum = 0
        for (index, character) in digitsWithoutCheckDigit.enumerated() {
            guard let digit = character.wholeNumberValue else {
                return nil
            }

            let weight = index.isMultiple(of: 2) ? 1 : 3
            sum += digit * weight
        }

        let checkDigitValue = (10 - (sum % 10)) % 10
        return String(checkDigitValue)
    }
}

private struct ISBN10 {
    let prefixElement: String
    let registrationGroupElement: String
    let registrantElement: String
    let publicationElement: String
    let checkDigit: String

    private static let expectedTotalDigitCount = 10

    init(
        registrationGroupElement: String,
        registrantElement: String,
        publicationElement: String,
        checkDigit: String
    ) throws {
        guard checkDigit.count == 1 else {
            throw ISBN.ValidationError.invalidCheckDigit(checkDigit)
        }

        let totalDigitCount = registrationGroupElement.count
            + registrantElement.count
            + publicationElement.count
            + checkDigit.count
        guard totalDigitCount == Self.expectedTotalDigitCount else {
            throw ISBN.ValidationError.invalidTotalDigitCount(totalDigitCount)
        }

        let digitsWithoutCheckDigit = registrationGroupElement
            + registrantElement
            + publicationElement
        guard let expectedCheckDigit = Self.expectedCheckDigit(for: digitsWithoutCheckDigit) else {
            throw ISBN.ValidationError.invalidCheckDigit(checkDigit)
        }

        guard checkDigit == expectedCheckDigit else {
            throw ISBN.ValidationError.invalidCheckDigit(checkDigit)
        }

        self.prefixElement = ""
        self.registrationGroupElement = registrationGroupElement
        self.registrantElement = registrantElement
        self.publicationElement = publicationElement
        self.checkDigit = checkDigit
    }

    static func expectedCheckDigit(for digitsWithoutCheckDigit: String) -> String? {
        guard digitsWithoutCheckDigit.count == expectedTotalDigitCount - 1 else {
            return nil
        }

        var sum = 0
        let weights = stride(from: 10, through: 2, by: -1)
        for (weight, character) in zip(weights, digitsWithoutCheckDigit) {
            guard let digit = character.wholeNumberValue else {
                return nil
            }
            sum += digit * weight
        }

        let checkDigitValue = (11 - (sum % 11)) % 11
        if checkDigitValue == 10 {
            return "X"
        }
        return String(checkDigitValue)
    }
}
