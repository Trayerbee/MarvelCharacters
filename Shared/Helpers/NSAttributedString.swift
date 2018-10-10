//
//  NSAttributedString.swift
//  Shared
//
//  Created by Karshigabekov, Ilyas on 10/10/2018.
//  Copyright © 2018 Karshigabekov, Ilyas. All rights reserved.
//

import Foundation

extension String {
    public var attributed: NSAttributedString {
        return NSAttributedString(string: self)
    }
}

extension NSMutableAttributedString {
    public var attributed: NSAttributedString {
        return NSAttributedString(attributedString: self)
    }
}

extension NSAttributedString {
    public var mutable: NSMutableAttributedString {
        return NSMutableAttributedString(attributedString: self)
    }
}

/// Append two `NSAttributedString`s
public func + (left: NSAttributedString, right: NSAttributedString) -> NSAttributedString {
    let leftMutable = left.mutable
    let rightMutable = right.mutable

    // Appended:
    leftMutable.append(rightMutable)

    return leftMutable.attributed
}

extension NSMutableAttributedString {

    /// MARK: Bold functions

    public func bold(_ text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        return boldWithSize(text: text, fontSize: 15, color: color)
    }

    public func boldWithSize(text: String, fontSize: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        let attributes = defaultAttributes(withSize: fontSize, weight: .medium, color: color)
        return appendText(text: text, withAttributes: attributes)
    }

    /// MARK: Normal functions

    public func normal(_ text: String, color: UIColor? = nil) -> NSMutableAttributedString {
        return normalWithSize(text: text, fontSize: 15, color: color)
    }

    public func normalWithSize(text: String, fontSize: CGFloat, color: UIColor? = nil) -> NSMutableAttributedString {
        let attributes = defaultAttributes(withSize: fontSize, weight: .regular, color: color)
        return appendText(text: text, withAttributes: attributes)
    }

    /// MARK: Helpers

    private func appendText(text: String, withAttributes attributes: [NSAttributedString.Key: Any]) -> NSMutableAttributedString {
        let string = NSAttributedString(string: text, attributes: attributes)
        append(string)
        return self
    }

    private func defaultAttributes(withSize fontSize: CGFloat, weight: UIFont.Weight, color: UIColor? = nil) -> [NSAttributedString.Key: Any] {
        let font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        var attributes: [NSAttributedString.Key: Any] = [.font: font, .kern: -0.2]

        guard let color = color else {
            return attributes
        }
        attributes[.foregroundColor] = color
        return attributes
    }

    /// Searches for a substring and attaches a URL as its link
    /// - Parameters:
    ///   - text: The text to search for
    ///   - link: The URL for the link
    public func addLink(text: String, URL: URL) {
        let range = mutableString.range(of: text)
        if range.location != NSNotFound {
            addAttribute(.link, value: URL, range: range)
        }
    }

    public func underlined(color: UIColor? = nil) -> NSMutableAttributedString {
        var underlineAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 15),
            .underlineStyle: NSUnderlineStyle.single.rawValue]

        if color != nil { underlineAttributes[.foregroundColor] = color }

        let mutableAttributedString = NSMutableAttributedString(attributedString: self)
        mutableAttributedString.addAttributes(underlineAttributes, range: (self.string as NSString).range(of: self.string))

        return mutableAttributedString
    }
}
