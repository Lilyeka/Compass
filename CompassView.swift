//
//  CompassView.swift
//  Compass
//
//  Created by Лилия Левина on 26/06/2019.
//  Copyright © 2019 Лилия Левина. All rights reserved.
//

import UIKit

class CompassView: UIView {

    override class var layerClass : AnyClass {
        return CompassLayer.self
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.addGestureRecognizer(tapGesture)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {}
    
    @objc func tapped(_ t:UITapGestureRecognizer) {
        let p = t.location(ofTouch:0, in: self.superview)
        let hitLayer = self.layer.hitTest(p)
        if let arrow = (self.layer as? CompassLayer)?.arrow {
            if hitLayer == arrow { // respond to touch
                arrow.transform = CATransform3DRotate(
                    arrow.transform, .pi/4.0, 0, 0, 1)
            }
        }
    }
}

class CompassLayer : CALayer {
    var arrow: CALayer!
    override func draw(in ctx: CGContext) {
        //the gradient
        let g = CAGradientLayer()
        g.contentsScale = UIScreen.main.scale
        g.frame = self.bounds
        g.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        g.locations = [0.0, 1.0]
        self.addSublayer(g)
        
        // the circle
        let circle = CAShapeLayer()
        circle.contentsScale = UIScreen.main.scale
        circle.lineWidth = 2.0
        circle.fillColor = UIColor(red:0.9, green:0.95, blue:0.93, alpha:0.9).cgColor
        circle.strokeColor = UIColor.gray.cgColor
        let p = CGMutablePath()
        p.addEllipse(in: self.bounds.insetBy(dx: 3, dy: 3))
        circle.path = p
        g.addSublayer(circle)
        circle.bounds = self.bounds
        circle.position = self.bounds.center
        // the four cardinal points
        let pts = "NESW"
        for (ix,c) in pts.enumerated() {
            let t = CATextLayer()
            t.contentsScale = UIScreen.main.scale
            t.string = String(c)
            t.bounds = CGRect(0,0,40,40)
            t.position = circle.bounds.center
            let vert = circle.bounds.midY / t.bounds.height
            t.anchorPoint = CGPoint(0.5, vert)
            t.alignmentMode = .center
            t.foregroundColor = UIColor.black.cgColor
            t.setAffineTransform(
                CGAffineTransform(rotationAngle:CGFloat(ix) * .pi/2.0))
            circle.addSublayer(t)
        }
        // the arrow
        arrow = CALayer()
        arrow.contentsScale = UIScreen.main.scale
        arrow.bounds = CGRect(0, 0, 40, 100)
        arrow.position = self.bounds.center
        arrow.anchorPoint = CGPoint(0.5, 0.8)
        arrow.delegate = self as CALayerDelegate// we will draw the arrow in the delegate method
        arrow.setAffineTransform(CGAffineTransform(rotationAngle:.pi/5.0))
        g.addSublayer(arrow)
        
        arrow.setNeedsDisplay() // draw, please
        
        //g.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        
        let mask = CAShapeLayer()
        mask.frame = arrow.bounds
        let path = CGMutablePath()
        path.addEllipse(in: mask.bounds.insetBy(dx: 10, dy: 10))
        mask.strokeColor = UIColor(white: 0.0, alpha: 0.5).cgColor
        mask.lineWidth = 20
        mask.path = path
        arrow.mask = mask
        
        let anim = CABasicAnimation(keyPath:#keyPath(CALayer.transform))
        anim.duration = 0.05
        anim.timingFunction = CAMediaTimingFunction(name:.linear)
        anim.repeatCount = 3
        anim.autoreverses = true
        anim.isAdditive = true
        anim.valueFunction = CAValueFunction(name:.rotateZ)
        anim.fromValue = Float.pi/40
        anim.toValue = -Float.pi/40
        arrow.add(anim, forKey:nil)
        
    }
}

extension CompassLayer: CALayerDelegate {
    func draw(_ layer: CALayer, in ctx: CGContext) {
        UIGraphicsPushContext(ctx)
        ctx.move(to: CGPoint(x: 10, y: 100))
        ctx.addLine(to: CGPoint(x: 20, y: 90))
        ctx.addLine(to: CGPoint(x: 30, y: 100))
        ctx.closePath()
        ctx.addRect(ctx.boundingBoxOfClipPath)
        ctx.clip(using: .evenOdd)
        
        ctx.move(to: CGPoint(x: 20, y: 100))
        ctx.addLine(to: CGPoint(x: 20, y: 19))
        ctx.setLineWidth(20)
        ctx.strokePath()
        
        ctx.setFillColor(UIColor.cyan.cgColor)
        ctx.move(to: CGPoint(x: 0, y: 25))
        ctx.addLine(to: CGPoint(x: 20, y: 0))
        ctx.addLine(to: CGPoint(x: 40, y: 25))
        ctx.fillPath()
        UIGraphicsPopContext()
    }
}

extension CGRect {
    var center : CGPoint {
        return CGPoint(self.midX, self.midY)
    }
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}

extension CGSize {
    init(_ width:CGFloat, _ height:CGFloat) {
        self.init(width:width, height:height)
    }
}
extension CGPoint {
    init(_ x:CGFloat, _ y:CGFloat) {
        self.init(x:x, y:y)
    }
}
