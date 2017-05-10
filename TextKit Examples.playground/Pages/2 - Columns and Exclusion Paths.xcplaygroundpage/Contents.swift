//
//  Created by Vlas Voloshin on 8/5/17.
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit
import PlaygroundSupport

// Lorem ipsum
let lorem = try! String(contentsOf: #fileLiteral(resourceName: "lorem-ipsum.txt")) + "\n"
let longLorem = String(repeating: lorem, count: 4)
let attributedLorem = NSAttributedString(string: longLorem, attributes: [
    NSFontAttributeName : UIFont.systemFont(ofSize: 16)
])

// Text containers
let leftContainer = NSTextContainer(size: CGSize.zero)
leftContainer.lineFragmentPadding = 16
leftContainer.widthTracksTextView = true
leftContainer.heightTracksTextView = true

let rightContainer = NSTextContainer(size: CGSize.zero)
rightContainer.lineFragmentPadding = 16
rightContainer.widthTracksTextView = true
rightContainer.heightTracksTextView = true

// Layout manager
let layoutManager = NSLayoutManager()
layoutManager.hyphenationFactor = 1.0
layoutManager.addTextContainer(leftContainer)
layoutManager.addTextContainer(rightContainer)

// Text storage
let textStorage = NSTextStorage(attributedString: attributedLorem)
textStorage.addLayoutManager(layoutManager)

// Text views
let leftTextView = UITextView(frame: CGRect.zero, textContainer: leftContainer)
leftTextView.isScrollEnabled = false
leftTextView.translatesAutoresizingMaskIntoConstraints = false
leftTextView.layer.borderWidth = 2

let rightTextView = UITextView(frame: CGRect.zero, textContainer: rightContainer)
rightTextView.isScrollEnabled = false
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
let window = stackView.window!

// Shape setup
let shapeView = ShapeView(path: UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 200, height: 200)))
shapeView.center = stackView.center
shapeView.shapeLayer.fillColor = UIColor.red.cgColor
window.addSubview(shapeView)

// Exclusion paths updater
let updatePaths = { (view: ShapeView) -> Void in
    for textView in [ leftTextView, rightTextView ] {
        let pathCopy = view.path.copy() as! UIBezierPath
        let offset = textView.convertPointToTextContainer(view.convert(view.bounds.origin, to: textView))
        let offsetter = CGAffineTransform(translationX: offset.x, y: offset.y)
        pathCopy.apply(offsetter)

        textView.textContainer.exclusionPaths = [ pathCopy ]
    }
}
shapeView.dragHandler = updatePaths

// Final setup
window.backgroundColor = .lightGray
window.layoutIfNeeded()

updatePaths(shapeView)
