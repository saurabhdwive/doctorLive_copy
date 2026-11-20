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
        let trimmed = plainOrFormattedText.trimmingCharacters(in: .whitespacesAndNewlines)
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
