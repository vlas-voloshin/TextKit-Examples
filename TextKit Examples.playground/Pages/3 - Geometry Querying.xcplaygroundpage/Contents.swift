/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit
import PlaygroundSupport

// Lorem ipsum
let lorem = try! String(contentsOf: #fileLiteral(resourceName: "lorem-ipsum.txt")) + "\n"
let longLorem = String(repeating: lorem, count: 4)
let attributedLorem = NSAttributedString(string: longLorem, attributes: [
    NSFontAttributeName : UIFont.systemFont(ofSize: 16)
])

// Static text view
let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 320, height: 480))
textView.attributedText = attributedLorem
textView.isEditable = false
textView.isSelectable = false
textView.isScrollEnabled = false

// Add fancier fonts to spice things up a bit
textView.textStorage.addAttribute(NSFontAttributeName, value: UIFont.boldSystemFont(ofSize: 24), range: NSRange(location: 50, length: 50))
textView.textStorage.addAttribute(NSFontAttributeName, value: UIFont(name: "Zapfino", size: 18)!, range: NSRange(location: 149, length: 50))
textView.textStorage.addAttribute(NSFontAttributeName, value: UIFont(name: "Copperplate", size: 30)!, range: NSRange(location: 301, length: 49))

// Add a "text painter" for the text view
let painter = TextPainter()
painter.textView = textView

// Add an overlay rendering view
let linesOverlay = TextWireframeOverlay(frame: textView.bounds)
textView.addSubview(linesOverlay)
linesOverlay.shapeLayer.strokeColor = UIColor.blue.cgColor
linesOverlay.shapeLayer.fillColor = nil
linesOverlay.textView = textView

// Run a counter timer that automatically switches between overlay modes
var counter = 0
let timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { _ in
    counter += 1

    switch counter % 3 {
    case 0:
        linesOverlay.mode = .lineFragments
    case 1:
        linesOverlay.mode = .glyphs
    case 2:
        linesOverlay.mode = .rangeRect(range: NSRange(location: 180, length: 150))
    default:
        break
    }
}

// Enable live view
PlaygroundPage.current.liveView = textView
