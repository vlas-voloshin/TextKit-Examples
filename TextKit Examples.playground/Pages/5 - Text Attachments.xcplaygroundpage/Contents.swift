/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit
import PlaygroundSupport

// Lorem ipsum
let lorem = try! String(contentsOf: #fileLiteral(resourceName: "lorem-ipsum.txt")) + "\n"
let longLorem = String(repeating: lorem, count: 2)
let attributedLorem = NSAttributedString(string: longLorem, attributes: [
    NSFontAttributeName : UIFont.systemFont(ofSize: 16)
    ])

// Static text view
let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
PlaygroundPage.current.liveView = textView

// Add attachments
let trollfaceAttachment = NSTextAttachment(image: #imageLiteral(resourceName: "trollface.png"), size: CGSize(width: 32, height: 32))
let lennaAttachment = NSTextAttachment(image: #imageLiteral(resourceName: "lenna.png"), size: CGSize(width: 128, height: 128))

let centeredParagraphStyle = NSMutableParagraphStyle()
centeredParagraphStyle.alignment = .center

textView.attributedText = attributedLorem
    .insertingAttachment(trollfaceAttachment, at: 50)
    .insertingAttachment(lennaAttachment, at: 250, with: centeredParagraphStyle)
