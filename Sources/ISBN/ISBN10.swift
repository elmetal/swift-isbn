//
//  ISBN10.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

struct ISBN10 {
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

        try ISBN.validateDigitsOnly(
            registrationGroupElement,
            registrantElement,
            publicationElement
        )

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
            // `wholeNumberValue` alone also accepts non-ASCII digits such as "４".
            guard character.isASCII, let digit = character.wholeNumberValue else {
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
