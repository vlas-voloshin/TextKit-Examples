//
//  Created by Vlas Voloshin on 8/5/17.
//  Copyright © 2017 Vlas Voloshin. All rights reserved.
//

import UIKit

public extension UITextView {

    @objc(vv_convertPointToTextContainer:)
    func convertPointToTextContainer(_ point: CGPoint) -> CGPoint {
        let insets = self.textContainerInset
        return CGPoint(x: point.x - insets.left, y: point.y - insets.top)
    }

    @objc(vv_convertPointFromTextContainer:)
    func convertPointFromTextContainer(_ point: CGPoint) -> CGPoint {
        let insets = self.textContainerInset
        return CGPoint(x: point.x + insets.left, y: point.y + insets.top)
    }

    @objc(vv_convertRectToTextContainer:)
    func convertRectToTextContainer(_ rect: CGRect) -> CGRect {
        let insets = self.textContainerInset
        return rect.offsetBy(dx: -insets.left, dy: -insets.top)
    }

    @objc(vv_convertRectFromTextContainer:)
    func convertRectFromTextContainer(_ rect: CGRect) -> CGRect {
        let insets = self.textContainerInset
        return rect.offsetBy(dx: insets.left, dy: insets.top)
    }

}
