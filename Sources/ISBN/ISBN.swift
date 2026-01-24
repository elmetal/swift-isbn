//
//  ISBN.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

public struct ISBN {
    public let prefixElement: String
    public let registrationGroupElement: String
    public let registrantElement: String
    public let publicationElement: String
    public let checkDigit: String
    
    public init(prefixElement: String, registrationGroupElement: String, registrantElement: String, publicationElement: String, checkDigit: String) {
        self.prefixElement = prefixElement
        self.registrationGroupElement = registrationGroupElement
        self.registrantElement = registrantElement
        self.publicationElement = publicationElement
        self.checkDigit = checkDigit
    }
}
