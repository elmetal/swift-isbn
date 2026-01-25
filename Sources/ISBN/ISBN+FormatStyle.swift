//
//  ISBN+FormatStyle.swift
//  swift-isbn
//  
//  Created by elmetal on 2026/01/24
//  
//

import Foundation

extension ISBN {
    /// A format style that renders an ISBN with hyphenated elements.
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
                .filter { !$0.isEmpty }
                .joined(separator: "-")
        }
    }
}

@available(macOS 12.0, *)
extension FormatStyle where Self == ISBN.FormatStyle {
    /// A format style that renders ISBN values with hyphens.
    public static var isbn: Self { .init() }
}

extension ISBN {
    /// Returns a hyphenated string representation of the ISBN.
    /// - Parameter format: The format style to apply.
    /// - Returns: A formatted ISBN string.
    public func formatted(_ format: ISBN.FormatStyle) -> String {
        format.format(self)
    }
}
