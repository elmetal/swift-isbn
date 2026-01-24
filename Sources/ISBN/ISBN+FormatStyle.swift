//
//  ISBN+FormatStyle.swift
//  swift-isbn
//  
//  Created by elmetal on 2026/01/24
//  
//

import Foundation

extension ISBN {
    public struct FormatStyle: Foundation.FormatStyle {
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
    public static var isbn: Self { .init() }
}

extension ISBN {
    public func formatted(_ format: ISBN.FormatStyle) -> String {
        format.format(self)
    }
}
