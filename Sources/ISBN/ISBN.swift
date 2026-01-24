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
    }

    public let prefixElement: String
    public let registrationGroupElement: String
    public let registrantElement: String
    public let publicationElement: String
    public let checkDigit: String

    private static let validPrefixElements: Set<String> = ["978", "979"]

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

        self.prefixElement = prefixElement
        self.registrationGroupElement = registrationGroupElement
        self.registrantElement = registrantElement
        self.publicationElement = publicationElement
        self.checkDigit = checkDigit
    }
}
