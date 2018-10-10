//
//  String.swift
//  Shared
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation

// It's often useful to just use String as an error in it's own right
extension String: Error {}

extension Optional where Wrapped == String {

    /// Sugar for asking a `String?` if both not empty and contains characters
    public var isNotEmpty: Bool {
        return !isEmptyOrNil
    }

    /// Sugar for asking a `String?` if it's empty or nil
    public var isEmptyOrNil: Bool {
        if let strongSelf = self {
            return strongSelf.isEmpty
        }
        return true
    }

    /// Sugar for changing an empty `String?` with nil
    public var nilIfEmpty: String? {
        return self.flatMap { $0.trim.isEmpty ? nil : $0.trim }
    }
}

public extension String {

    /// Sugar for asking a `String` if not empty
    public var isNotEmpty: Bool {
        return !isEmpty
    }

    /// Sugar for changing an empty `String` with nil
    public var nilIfEmpty: String? {
        return self.trim.isEmpty ? nil : self.trim
    }

    /// Removes leading and trailing whitespace and newlines
    public var trim: String {
        return trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }

    public static func random(length: Int) -> String {
        let alphabet = "-_1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let upperBound = UInt32(alphabet.count)
        return String((0..<length).map { _ -> Character in
            return alphabet[alphabet.index(alphabet.startIndex, offsetBy: Int(arc4random_uniform(upperBound)))]
        })
    }

    public var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }

    public var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}

public extension String {

    /// Is a syntactically valid email address based on http://stackoverflow.com/a/25471164/349364
    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

public extension String {

    public var fromISOToDate: Date? {
        let locale = Locale(identifier: "en_US_POSIX")
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"

        return dateFormatter.date(from: self)
    }

    public var isNumeric: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return self.rangeOfCharacter(from: characters) == nil
    }
}

/// Get the value at the index within the given array.
/// Useful for e.g. `.withLatestFrom(theArray, resultSelector: arrayValueForIndex)`
public func arrayValueForIndex<T>(index: Int, array: [T]) -> T? {
    guard index > -1, index < array.count else { return nil }
    return array[index]
}

public func indexForValueInArray<T>(array: [T], value: T) -> Int? where T: Equatable {
    return array.index(of: value)
}

extension String { /// http://nshipster.com/nsregularexpression/

    /// An `NSRange` that represents the full range of the string.
    public var nsrange: NSRange {
        return NSRange(location: 0, length: utf16.count)
    }

    /// Returns a substring with the given `NSRange`,
    /// or `nil` if the range can't be converted.
    public func substring(with nsrange: NSRange) -> String? {
        guard let range = Range(nsrange)
            else { return nil }
        let start = self.utf16.index(self.utf16.startIndex, offsetBy: range.lowerBound)
        let end = self.utf16.index(self.utf16.startIndex, offsetBy: range.upperBound)
        let substringRange = start..<end
        return String(self[substringRange])
    }

    /// Returns a range equivalent to the given `NSRange`,
    /// or `nil` if the range can't be converted.
    public func range(from nsrange: NSRange) -> Range<Index>? {
        guard let range = Range(nsrange) else { return nil }
        let utf16Start = self.utf16.index(self.utf16.startIndex, offsetBy: range.lowerBound)
        let utf16End = self.utf16.index(self.utf16.startIndex, offsetBy: range.upperBound)

        guard let start = Index(utf16Start, within: self),
            let end = Index(utf16End, within: self)
            else { return nil }
        return start..<end
    }
}

extension String {

    /// Will decode HTML entities (e.g. &euro; -> €)
    /// MUST be called from the main thread, see: https://stackoverflow.com/a/25607542
    public init?(htmlEncodedString: String) {

        guard let data = htmlEncodedString.data(using: .utf8) else {
            return nil
        }

        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]

        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return nil
        }

        self.init(attributedString.string)
    }

}

extension String {

    /// Convert the string into an array of Ints.
    /// For example, `"1234"` would return `[1,2,3,4]`
    public func toInts() -> [Int] {
        return self.compactMap {
            guard let int = Int(String($0)) else { return nil }
            return int
        }
    }
}

public extension String {
    public func withBold(prefix: String) -> NSAttributedString {
        return NSMutableAttributedString().bold("\(prefix): ").normal(self)
    }

    public func withUnderline(color: UIColor) -> NSAttributedString {
        return NSMutableAttributedString().normal(self).underlined(color: color)
    }
}
