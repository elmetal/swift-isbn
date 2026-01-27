//
//  ISBN13.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

struct ISBN13 {
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
