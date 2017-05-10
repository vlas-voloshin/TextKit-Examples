/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit

public class TextWireframeOverlay: UIView, NSLayoutManagerDelegate {

    override public class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    public var shapeLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }

    public weak var textView: UITextView? {
        didSet {
            if let textView = self.textView {
                textView.layoutManager.delegate = self
            }
            self.updateWireframe()
        }
    }

    public enum Mode {
        case lineFragments
        case glyphs
        case rangeRect(range: NSRange)
    }

    public var mode = Mode.lineFragments {
        didSet {
            self.updateWireframe()
        }
    }

    // This is a pretty performance-heavy operation! Had to place this whole class in a separate file so that Playgrounds doesn't evaluate the results of it.
    private func updateWireframe() {
        guard let textView = self.textView else {
            self.shapeLayer.path = nil
            return
        }

        let layoutManager = textView.layoutManager
        let textContainer = textView.textContainer
        let path = UIBezierPath()
        let wholeRange = NSRange(location: 0, length: Int(layoutManager.numberOfGlyphs))

        let addContainerRect = { (rect: CGRect) -> Void in
            guard rect.width > 0 && rect.height > 0 else {
                return
            }

            let convertedRect = self.convert(textView.convertRectFromTextContainer(rect), from: textView)
            path.append(UIBezierPath(rect: convertedRect))
        }

        switch self.mode {
        case .lineFragments:
            layoutManager.enumerateLineFragments(forGlyphRange: wholeRange) { rect, _, _, _, _ in
                addContainerRect(rect)
            }

        case .glyphs:
            for glyph in (0..<NSMaxRange(wholeRange)) {
                let rect = layoutManager.boundingRect(forGlyphRange: NSRange(location: glyph, length: 1), in: textContainer)
                addContainerRect(rect)
            }

        case .rangeRect(range: let highlightedRange):
            let emptyRange = NSRange(location: NSNotFound, length: 0)
            layoutManager.enumerateEnclosingRects(forGlyphRange: highlightedRange, withinSelectedGlyphRange: emptyRange, in: textContainer) { rect, _ in
                addContainerRect(rect)
            }
            break
        }

        self.shapeLayer.path = path.cgPath
    }

    public func layoutManager(_ layoutManager: NSLayoutManager, didCompleteLayoutFor textContainer: NSTextContainer?, atEnd layoutFinishedFlag: Bool) {
        if layoutFinishedFlag {
            self.updateWireframe()
        }
    }
    
}
