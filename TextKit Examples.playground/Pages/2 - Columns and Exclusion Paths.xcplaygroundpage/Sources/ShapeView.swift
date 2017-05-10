/**
 Available under the MIT License
 Copyright (c) 2017 Vlas Voloshin
 */

import UIKit

public class ShapeView: UIView {

    override public class var layerClass: AnyClass {
        return CAShapeLayer.self
    }

    public var shapeLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }

    public let path: UIBezierPath
    public var dragHandler: ((ShapeView) -> Void)?

    public init(path: UIBezierPath) {
        self.path = path

        super.init(frame: path.bounds)

        self.shapeLayer.path = path.cgPath

        self.dragRecognizer.addTarget(self, action: #selector(recognizerDragged(_:)))
        self.addGestureRecognizer(self.dragRecognizer)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override public func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return self.path.contains(point) ? self : nil
    }

    private let dragRecognizer = UIPanGestureRecognizer()
    private var dragStartOrigin: CGPoint?

    @objc private func recognizerDragged(_ sender: UIPanGestureRecognizer!) {
        switch sender.state {
        case .began:
            self.dragStartOrigin = self.frame.origin

        case .changed, .ended:
            if let startOrigin = self.dragStartOrigin, let view = sender.view {
                let newOrigin = startOrigin + sender.translation(in: view)
                self.frame.origin = newOrigin
                self.dragHandler?(self)
            }

        default:
            break
        }

        switch sender.state {
        case .ended, .failed:
            self.dragStartOrigin = nil
            
        default:
            break
        }
    }

}

public func +(lho: CGPoint, rho: CGPoint) -> CGPoint {
    return CGPoint(x: lho.x + rho.x, y: lho.y + rho.y)
}

public prefix func -(op: CGPoint) -> CGPoint {
    return CGPoint(x: -op.x, y: -op.y)
}
