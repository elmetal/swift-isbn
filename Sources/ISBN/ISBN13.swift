//
//  ISBN13.swift
//  swift-isbn
//
//  Created by elmetal on 2026/01/24
//
//

extension ISBN {
    static let validPrefixElements: Set<String> = ["978", "979"]

    /// Returns the check digit of the 13-digit form for the 12 digits that
    /// precede it.
    ///
    /// - Parameter digits: The prefix, registration group, registrant, and
    ///   publication elements, already validated to contain only ASCII digits.
    static func isbn13CheckDigit(for digits: String) -> String {
        let sum = digits
            .compactMap(\.wholeNumberValue)
            .enumerated()
            .reduce(0) { sum, digit in
                sum + digit.element * (digit.offset.isMultiple(of: 2) ? 1 : 3)
            }
        return String((10 - (sum % 10)) % 10)
    }
}
