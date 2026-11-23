//
//  AdviceHTMLHelper.swift
//  DoctorLive
//
//  Created for formatting General Advice to HTML for API requests.
//

import Foundation
import UIKit

struct AdviceHTMLHelper {
    
    /// Converts plain or rich formatted advice into clean, standard HTML for API payloads
    static func convertToHTML(plainOrFormattedText: String) -> String {
        // Normalize any escaped closing tags like <\/strong> -> </strong>
        let sanitized = plainOrFormattedText.replacingOccurrences(of: "<\\/", with: "</")
        let trimmed = sanitized.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return "" }
        
        // If already full HTML with tags, return as is
        if trimmed.contains("<p>") || trimmed.contains("<br") || trimmed.contains("<ul>") || trimmed.contains("<ol>") || trimmed.contains("<div>") {
            return trimmed
        }
        
        let lines = trimmed.components(separatedBy: "\n")
        var html = ""
        var inBulletList = false
        var inNumberedList = false
        
        for rawLine in lines {
            let line = rawLine.trimmingCharacters(in: .whitespaces)
            if line.isEmpty {
                if inBulletList {
                    html += "</ul>\n"
                    inBulletList = false
                }
                if inNumberedList {
                    html += "</ol>\n"
                    inNumberedList = false
                }
                continue
            }
            
            // Bullet item (e.g. "• ", "- ", "* ")
            if line.starts(with: "• ") || line.starts(with: "- ") || line.starts(with: "* ") {
                if inNumberedList {
                    html += "</ol>\n"
                    inNumberedList = false
                }
                if !inBulletList {
                    html += "<ul>\n"
                    inBulletList = true
                }
                let content = String(line.dropFirst(2)).trimmingCharacters(in: .whitespaces)
                html += "  <li>\(formatInline(content))</li>\n"
                continue
            }
            
            // Numbered item (e.g. "1. ", "1) ", "2. ")
            if let match = line.range(of: "^[0-9]+[.)]\\s*", options: .regularExpression) {
                if inBulletList {
                    html += "</ul>\n"
                    inBulletList = false
                }
                if !inNumberedList {
                    html += "<ol>\n"
                    inNumberedList = true
                }
                let content = String(line[match.upperBound...]).trimmingCharacters(in: .whitespaces)
                html += "  <li>\(formatInline(content))</li>\n"
                continue
            }
            
            // Regular line / Heading: close any open list first
            if inBulletList {
                html += "</ul>\n"
                inBulletList = false
            }
            if inNumberedList {
                html += "</ol>\n"
                inNumberedList = false
            }
            
            // Detect heading line (e.g. contains colon at end or short title)
            let isHeading = line.hasSuffix(":") || line.contains("ঘরোয়া যত্ন") || line.contains("যোগাযোগ করবেন") || line.contains("সতর্কতা") || (line.count < 30 && !line.hasSuffix("."))
            if isHeading {
                html += "<p><strong>\(formatInline(line))</strong></p>\n"
            } else {
                html += "<p>\(formatInline(line))</p>\n"
            }
        }
        
        if inBulletList {
            html += "</ul>\n"
        }
        if inNumberedList {
            html += "</ol>\n"
        }
        
        return html.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private static func formatInline(_ text: String) -> String {
        var result = text
        // Bold: **text** -> <b>text</b>
        result = result.replacingOccurrences(of: "\\*\\*(.*?)\\*\\*", with: "<b>$1</b>", options: .regularExpression)
        // Italic: *text* -> <i>text</i>
        result = result.replacingOccurrences(of: "(?<!\\*)\\*(?!\\*)(.*?)(?<!\\*)\\*(?!\\*)", with: "<i>$1</i>", options: .regularExpression)
        return result
    }
    
    private static func escapeHTML(_ str: String) -> String {
        return str
            .replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
    
    /// Converts an NSAttributedString with bold, italic, underline, lists into clean HTML tags for API and persistence
    static func attributedStringToHTML(_ attrText: NSAttributedString) -> String {
        let string = attrText.string
        guard !string.isEmpty else { return "" }
        
        let lines = string.components(separatedBy: "\n")
        var html = ""
        var inBulletList = false
        var inNumberedList = false
        var currentLocation = 0
        
        for rawLine in lines {
            let lineLength = (rawLine as NSString).length
            let lineRange = NSRange(location: currentLocation, length: lineLength)
            currentLocation += lineLength + 1 // +1 for \n delimiter
            
            let trimmed = rawLine.trimmingCharacters(in: .whitespaces)
            if trimmed.isEmpty {
                if inBulletList { html += "</ul>\n"; inBulletList = false }
                if inNumberedList { html += "</ol>\n"; inNumberedList = false }
                continue
            }
            
            // Check list prefixes
            var prefixLen = 0
            var isBullet = false
            var isNumbered = false
            
            if trimmed.starts(with: "• ") || trimmed.starts(with: "- ") || trimmed.starts(with: "* ") {
                isBullet = true
                prefixLen = 2
            } else if let match = trimmed.range(of: "^[0-9]+[.)]\\s*", options: .regularExpression) {
                isNumbered = true
                prefixLen = NSRange(match, in: trimmed).length
            }
            
            if isBullet {
                if inNumberedList { html += "</ol>\n"; inNumberedList = false }
                if !inBulletList { html += "<ul>\n"; inBulletList = true }
            } else if isNumbered {
                if inBulletList { html += "</ul>\n"; inBulletList = false }
                if !inNumberedList { html += "<ol>\n"; inNumberedList = true }
            } else {
                if inBulletList { html += "</ul>\n"; inBulletList = false }
                if inNumberedList { html += "</ol>\n"; inNumberedList = false }
            }
            
            // Build the content HTML from attributed runs
            var lineHTML = ""
            let contentStart = lineRange.location + prefixLen
            let contentEnd = lineRange.location + lineLength
            let contentRange = NSRange(location: contentStart, length: max(0, contentEnd - contentStart))
            
            if contentRange.length > 0 {
                attrText.enumerateAttributes(in: contentRange, options: []) { attrs, range, _ in
                    let substring = (string as NSString).substring(with: range)
                    if substring.isEmpty { return }
                    
                    var piece = escapeHTML(substring)
                    let font = attrs[.font] as? UIFont
                    let traits = font?.fontDescriptor.symbolicTraits ?? []
                    let fontName = font?.fontName.lowercased() ?? ""
                    
                    let isBold = traits.contains(.traitBold) || fontName.contains("bold") || fontName.contains("semibold")
                    let isItalic = traits.contains(.traitItalic) || fontName.contains("italic")
                    let isUnderline = (attrs[.underlineStyle] as? Int ?? 0) != 0
                    
                    if isUnderline { piece = "<u>\(piece)</u>" }
                    if isItalic { piece = "<em>\(piece)</em>" }
                    if isBold { piece = "<strong>\(piece)</strong>" }
                    
                    lineHTML += piece
                }
            } else {
                lineHTML = escapeHTML(trimmed)
            }
            
            if isBullet || isNumbered {
                html += "  <li>\(lineHTML)</li>\n"
            } else {
                html += "<p>\(lineHTML)</p>\n"
            }
        }
        
        if inBulletList { html += "</ul>\n" }
        if inNumberedList { html += "</ol>\n" }
        
        return html.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Converts clean HTML or plain text into a styled NSAttributedString for UIKit text views
    static func htmlToAttributedString(_ htmlOrPlainText: String, font: UIFont? = nil, textColor: UIColor? = nil) -> NSAttributedString {
        let trimmed = htmlOrPlainText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return NSAttributedString() }
        
        let baseFont = font ?? UIFont(name: "Poppins-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14)
        let baseColor = textColor ?? UIColor(red: 30/255, green: 41/255, blue: 59/255, alpha: 1.0)
        
        // If it's plain text without HTML tags, return plain styled attributed string
        if !trimmed.contains("<") || !trimmed.contains(">") {
            return NSAttributedString(string: trimmed, attributes: [
                .font: baseFont,
                .foregroundColor: baseColor
            ])
        }
        
        let styledHTML = """
        <style>
            body {
                font-family: '-apple-system', 'Helvetica Neue', Arial;
                font-size: \(baseFont.pointSize)px;
                color: #1E293B;
                margin: 0;
                padding: 0;
            }
            p { margin: 0 0 6px 0; }
            ul, ol { margin: 0 0 6px 18px; padding: 0; }
            li { margin: 0 0 3px 0; }
            strong, b { font-weight: bold; }
            em, i { font-style: italic; }
            u { text-decoration: underline; }
        </style>
        \(trimmed)
        """
        
        guard let data = styledHTML.data(using: .utf8),
              let attr = try? NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
              ) else {
            return NSAttributedString(string: trimmed, attributes: [.font: baseFont, .foregroundColor: baseColor])
        }
        
        // Normalize fonts and colors to match app typography while preserving bold/italic/underline traits
        let fullRange = NSRange(location: 0, length: attr.length)
        attr.enumerateAttributes(in: fullRange, options: []) { attrs, range, _ in
            let existingFont = attrs[.font] as? UIFont ?? baseFont
            let traits = existingFont.fontDescriptor.symbolicTraits
            let fontName = existingFont.fontName.lowercased()
            let isBold = traits.contains(.traitBold) || fontName.contains("bold") || fontName.contains("semibold")
            let isItalic = traits.contains(.traitItalic) || fontName.contains("italic")
            
            var targetFont: UIFont
            if isBold && isItalic {
                let boldFont = UIFont(name: "Poppins-Bold", size: baseFont.pointSize) ?? UIFont.boldSystemFont(ofSize: baseFont.pointSize)
                if let desc = boldFont.fontDescriptor.withSymbolicTraits([.traitBold, .traitItalic]) {
                    targetFont = UIFont(descriptor: desc, size: baseFont.pointSize)
                } else {
                    targetFont = boldFont
                }
            } else if isBold {
                targetFont = UIFont(name: "Poppins-SemiBold", size: baseFont.pointSize) ?? UIFont.boldSystemFont(ofSize: baseFont.pointSize)
            } else if isItalic {
                targetFont = UIFont(name: "Poppins-Italic", size: baseFont.pointSize) ?? UIFont.italicSystemFont(ofSize: baseFont.pointSize)
            } else {
                targetFont = baseFont
            }
            
            attr.addAttribute(.font, value: targetFont, range: range)
            attr.addAttribute(.foregroundColor, value: baseColor, range: range)
        }
        
        // Trim trailing newline added by WebKit HTML rendering
        while attr.string.hasSuffix("\n") {
            attr.deleteCharacters(in: NSRange(location: attr.length - 1, length: 1))
        }
        
        return attr
    }
    
    /// Converts an HTML string back to clean plain text for UI presentation
    static func htmlToPlainText(_ html: String) -> String {
        guard !html.isEmpty else { return "" }
        if !html.contains("<") && !html.contains(">") {
            return html
        }
        guard let data = html.data(using: .utf8) else { return html }
        if let attr = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil) {
            return attr.string.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return html
    }
}
