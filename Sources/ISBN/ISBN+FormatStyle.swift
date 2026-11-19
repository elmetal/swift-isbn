//
//  ISBN+FormatStyle.swift
//  swift-isbn
//  
//  Created by elmetal on 2026/01/24
//  
//

import Foundation

extension ISBN {
    /// A format style that renders an ISBN in its 13-digit form with
    /// hyphenated elements.
    public struct FormatStyle: Foundation.FormatStyle {
        /// Formats the provided ISBN as a hyphen-separated string.
        /// - Parameter value: The ISBN value to format.
        /// - Returns: A hyphen-separated ISBN string.
        public func format(_ value: ISBN) -> String {
            [
                value.prefixElement,
                value.registrationGroupElement,
                value.registrantElement,
                value.publicationElement,
                value.checkDigit
            ]
                .joined(separator: "-")
        }
    }

    /// A format style that renders an ISBN in its 10-digit form with
    /// hyphenated elements.
    ///
    /// Only an ISBN with the prefix element "978" has a 10-digit form.
    public struct ISBN10FormatStyle: Foundation.FormatStyle {
        /// Formats the provided ISBN as a hyphen-separated 10-digit string.
        /// - Parameter value: The ISBN value to format.
        /// - Returns: A hyphen-separated ISBN string, or `nil` when the ISBN
        ///   has no 10-digit form.
        public func format(_ value: ISBN) -> String? {
            guard value.prefixElement == ISBN.isbn10PrefixElement else {
                return nil
            }

            let digits = value.registrationGroupElement
                + value.registrantElement
                + value.publicationElement
            return [
                value.registrationGroupElement,
                value.registrantElement,
                value.publicationElement,
                ISBN.isbn10CheckDigit(for: digits)
            ]
                .joined(separator: "-")
        }
    }
}

extension FormatStyle where Self == ISBN.FormatStyle {
    /// A format style that renders ISBN values in the 13-digit form with
    /// hyphens.
    public static var isbn: Self { .init() }
}

extension FormatStyle where Self == ISBN.ISBN10FormatStyle {
    /// A format style that renders ISBN values in the 10-digit form with
    /// hyphens, or `nil` for an ISBN that has no 10-digit form.
    public static var isbn10: Self { .init() }
}

extension ISBN {
    /// Returns a representation of the ISBN in the given format style.
    ///
    /// ```swift
    /// isbn.formatted(.isbn)   // "978-0-306-40615-7"
    /// isbn.formatted(.isbn10) // Optional("0-306-40615-2")
    /// ```
    ///
    /// - Parameter style: The format style to apply.
    /// - Returns: The formatted ISBN.
    public func formatted<Style: Foundation.FormatStyle>(
        _ style: Style
    ) -> Style.FormatOutput where Style.FormatInput == ISBN {
        style.format(self)
    }
}
