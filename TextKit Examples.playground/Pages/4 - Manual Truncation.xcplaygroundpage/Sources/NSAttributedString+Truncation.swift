/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit

public extension NSAttributedString {

    func truncated(toNumberOfLines numberOfLines: Int, withLineWidth lineWidth: CGFloat, lineFragmentPadding: CGFloat, lineBreakMode: NSLineBreakMode) -> (result: NSAttributedString, truncated: Bool) {
        guard self.length > 0 else {
            // Empty text cannot be truncated
            return (self, false)
        }
        guard numberOfLines > 0 else {
            // Truncating to zero lines just removes all content
            return (NSAttributedString(), true)
        }

        // Create TextKit stack for initial line count estimation
        let textContainer = NSTextContainer(size: CGSize(width: lineWidth, height: CGFloat.greatestFiniteMagnitude))
        textContainer.lineFragmentPadding = lineFragmentPadding
        textContainer.lineBreakMode = lineBreakMode
        textContainer.maximumNumberOfLines = numberOfLines

        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)

        let textStorage = NSTextStorage(attributedString: self)
        textStorage.addLayoutManager(layoutManager)

        // Determine the range of the truncated text, keeping track of the lines
        var firstTruncatedGlyphIndex = 0
        var lineFragmentFirstGlyphIndex = 0
        var linesCount = 0
        repeat {
            // Calculate the line fragment glyph range
            var lineRange = NSRange(location: NSNotFound, length: 0)
            layoutManager.lineFragmentRect(forGlyphAt: lineFragmentFirstGlyphIndex, effectiveRange: &lineRange)

            // Move glyph counter to the next line fragment
            lineFragmentFirstGlyphIndex = NSMaxRange(lineRange)

            // Check for truncation on this line fragment (range length might not be correct here, so only using the location)
            firstTruncatedGlyphIndex = layoutManager.truncatedGlyphRange(inLineFragmentForGlyphAt: lineRange.location).location

            linesCount += 1
        } while firstTruncatedGlyphIndex == NSNotFound &&
                lineFragmentFirstGlyphIndex < layoutManager.numberOfGlyphs &&
                linesCount < numberOfLines

        if firstTruncatedGlyphIndex == NSNotFound {
            // No truncation position has been found...
            if linesCount >= numberOfLines &&
                lineFragmentFirstGlyphIndex < layoutManager.numberOfGlyphs {
                // We reached the maximum number of lines without reaching the total number of glyphs, so treat the glyphs beyond the last line fragment as truncated
                firstTruncatedGlyphIndex = lineFragmentFirstGlyphIndex
            } else {
                // Otherwise, the string doesn't need to be truncated!
                return (self, false)
            }
        }

        // Truncate the string
        let firstTruncatedCharacterIndex = layoutManager.characterRange(forGlyphRange: NSRange(location: firstTruncatedGlyphIndex, length: 0), actualGlyphRange: nil).location
        let remainingTextRange = NSRange(location: 0, length: firstTruncatedCharacterIndex)

        let truncatedText = self.attributedSubstring(from: remainingTextRange).mutableCopy() as! NSMutableAttributedString

        // TODO: If the last character of the truncated text is a line break, remove it too

        // Add an ellipsis
        let ellipsisAttributes = self.attributes(at: firstTruncatedCharacterIndex, effectiveRange: nil)
        let ellipsis = NSAttributedString(string: "\u{2026}", attributes: ellipsisAttributes)
        truncatedText.append(ellipsis)

        return (truncatedText.copy() as! NSAttributedString, true)
    }

}
