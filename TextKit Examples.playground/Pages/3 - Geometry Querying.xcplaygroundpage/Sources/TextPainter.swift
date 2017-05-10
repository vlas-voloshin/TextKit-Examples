/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit

public class TextPainter: NSObject {

    public var paintColor = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)

    public weak var textView: UITextView? {
        willSet {
            self.textView?.removeGestureRecognizer(self.recognizer)
        }
        didSet {
            self.textView?.addGestureRecognizer(self.recognizer)
        }
    }

    public override init() {
        super.init()

        self.recognizer.addTarget(self, action: #selector(handleGesture(_:)))
    }

    private let recognizer = UIPanGestureRecognizer()

    @objc private func handleGesture(_ sender: UIGestureRecognizer!) {
        guard
            sender.state == .changed || sender.state == .began,
            let textView = self.textView
        else {
            return
        }

        textView.vv_highlightCharacter(at: sender.location(in: textView), with: self.paintColor)
    }
    
}

extension UITextView {

    func vv_highlightCharacter(at point: CGPoint, with color: UIColor) {
        let convertedPoint = self.convertPointToTextContainer(point)
        let characterIndex = self.layoutManager.characterIndex(for: convertedPoint, in: self.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        guard characterIndex < self.textStorage.length else {
            return
        }

        self.textStorage.addAttribute(NSBackgroundColorAttributeName, value: color, range: NSRange(location: Int(characterIndex), length: 1))
    }
    
}
