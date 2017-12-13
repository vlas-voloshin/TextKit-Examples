/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit
import PlaygroundSupport

// Lorem ipsum
let lorem = try! String(contentsOf: #fileLiteral(resourceName: "lorem-ipsum.txt"))
let attributedLorem = NSAttributedString(string: lorem, attributes: [
    .font : UIFont.systemFont(ofSize: 16)
])

// Text containers
let leftContainer = NSTextContainer(size: .zero)
leftContainer.widthTracksTextView = true
leftContainer.heightTracksTextView = true

let rightContainer = NSTextContainer(size: .zero)
rightContainer.lineFragmentPadding = 32
rightContainer.widthTracksTextView = true
rightContainer.heightTracksTextView = true

// Layout managers
let leftLayoutManager = NSLayoutManager()
leftLayoutManager.addTextContainer(leftContainer)

let rightLayoutManager = NSLayoutManager()
rightLayoutManager.hyphenationFactor = 1.0
rightLayoutManager.addTextContainer(rightContainer)

// Shared text storage
let textStorage = NSTextStorage(attributedString: attributedLorem)
textStorage.addLayoutManager(leftLayoutManager)
textStorage.addLayoutManager(rightLayoutManager)

// Text views
let leftTextView = UITextView(frame: .zero, textContainer: leftContainer)
leftTextView.translatesAutoresizingMaskIntoConstraints = false
leftTextView.layer.borderWidth = 2

let rightTextView = UITextView(frame: .zero, textContainer: rightContainer)
rightTextView.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
rightTextView.textContainerInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
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
