/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit
import PlaygroundSupport

// Lorem ipsum
let lorem = try! String(contentsOf: #fileLiteral(resourceName: "lorem-ipsum.txt")) + "\n"
let attributedLorem = NSAttributedString(string: lorem, attributes: [
    .font : UIFont.systemFont(ofSize: 16)
])

// Text views
let leftTextView = UITextView(frame: .zero)
leftTextView.attributedText = attributedLorem
leftTextView.translatesAutoresizingMaskIntoConstraints = false
leftTextView.layer.borderWidth = 2

let rightTextView = UITextView(frame: CGRect.zero)
rightTextView.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
rightTextView.isEditable = false
rightTextView.translatesAutoresizingMaskIntoConstraints = false
rightTextView.layer.borderWidth = 2

// Stack view
let stackView = UIStackView(arrangedSubviews: [ leftTextView, rightTextView ])
stackView.axis = .horizontal
stackView.alignment = .fill
stackView.distribution = .fillEqually
stackView.spacing = 16
stackView.frame = CGRect(origin: .zero, size: CGSize(width: 640, height: 480))

PlaygroundPage.current.liveView = stackView
stackView.window?.backgroundColor = .lightGray

// Manual truncation updates (right text view to left text view)
let updateTruncatedText = {
    let lineWidth = rightTextView.textContainer.size.width
    let padding = rightTextView.textContainer.lineFragmentPadding

    let (truncatedText, hasTruncated) = leftTextView.textStorage.truncated(toNumberOfLines: 5, withLineWidth: lineWidth, lineFragmentPadding: padding, lineBreakMode: .byTruncatingTail)
    rightTextView.attributedText = truncatedText

    if hasTruncated && truncatedText.length > 0 {
        var lastCharacterAttributes = truncatedText.attributes(at: truncatedText.length - 1, effectiveRange: nil)
        lastCharacterAttributes[.foregroundColor] = UIColor.blue
        let extraText = NSAttributedString(string: "\n(there's more)", attributes: lastCharacterAttributes)

        rightTextView.textStorage.append(extraText)
    }
}

// Handle changes in the left text view's text storage by updating truncated text
class TextUpdatesHandler: NSObject, NSTextStorageDelegate {

    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorageEditActions, range editedRange: NSRange, changeInLength delta: Int) {
        updateTruncatedText()
    }

}

let handler = TextUpdatesHandler()
leftTextView.textStorage.delegate = handler

// Perform the first update manually after laying out the window (that's to know the text view width)
stackView.window?.layoutIfNeeded()
updateTruncatedText()
