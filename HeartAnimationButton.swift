//
//  HeartAnimationButton.swift
//  Memebox
//
//  Created by mememacpro on 2017. 7. 11..
//  Copyright © 2017년 memebox. All rights reserved.
//

import UIKit

protocol HeartAnimationButtonDelegate {
    func heartAnimationDidStart()
    func heartAnimationDidStop()
}

class HeartAnimationButton: UIButton, CAAnimationDelegate {
    
    var layerFrame: CGRect!
    var lineWidth: CGFloat!
    var strokeColor: CGColor!
    
    var heartAnimationDuration: CFTimeInterval = 0.6
    var circleAnimationDuration:CFTimeInterval = 0.4
    
    var delegate: HeartAnimationButtonDelegate?
    
    override var isSelected: Bool {
        didSet {
            if isSelected == true {
                self.strokeColor = UIColor(hexString: "#ff5073")?.cgColor
            } else {
                self.strokeColor = UIColor(hexString: "#0f0f0f")?.cgColor
            }
            
            drawButton()
        }
    }
    
    init(buttonFrame: CGRect, layerFrame: CGRect, lineWidth: CGFloat) {
        super.init(frame: buttonFrame)
        
        backgroundColor = .clear
        self.layerFrame = layerFrame
        self.lineWidth = lineWidth
        self.strokeColor = UIColor.black.cgColor
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var heartLayer: CAShapeLayer {
        let heartLayer = CAShapeLayer()
        heartLayer.path = UIBezierPath(heartIn: layerFrame).cgPath
        heartLayer.strokeColor = UIColor(hexString: "#ff5073")?.cgColor
        heartLayer.fillColor = UIColor.clear.cgColor
        heartLayer.lineWidth = lineWidth
        
        let strokeAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeAnimation.fromValue = 0.0
        strokeAnimation.toValue = 1.0
        strokeAnimation.duration = heartAnimationDuration
        strokeAnimation.isRemovedOnCompletion = false
        strokeAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        strokeAnimation.delegate = self
        
        heartLayer.add(strokeAnimation, forKey: nil)
        return heartLayer
    }
    
    var disappearHeartLayer: CAShapeLayer {
        let heartLayer = CAShapeLayer()
        heartLayer.path = UIBezierPath(heartIn: layerFrame).cgPath
        heartLayer.strokeColor = UIColor(hexString: "#0f0f0f")?.cgColor
        heartLayer.fillColor = UIColor.clear.cgColor
        heartLayer.lineWidth = lineWidth
        
        let animation = CABasicAnimation(keyPath: "strokeColor")
        animation.fromValue = UIColor(hexString: "#ff5073")?.cgColor
        animation.toValue = UIColor(hexString: "#0f0f0f")?.cgColor
        animation.duration = 1
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        heartLayer.add(animation, forKey: nil)
        return heartLayer
    }

    func drawButton() {
        let initLayer = CAShapeLayer()
        initLayer.path = UIBezierPath(heartIn: layerFrame).cgPath
        initLayer.lineWidth = lineWidth
        initLayer.fillColor = UIColor.clear.cgColor
        initLayer.strokeColor = self.strokeColor
        self.layer.addSublayer(initLayer)
    }
    
    func addAnimate() {
        self.layer.sublayers = nil
        self.layer.addSublayer(heartLayer)
    }
    
    func removeAnimate() {
        self.layer.sublayers = nil
        self.layer.addSublayer(disappearHeartLayer)
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        delegate?.heartAnimationDidStart()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        delegate?.heartAnimationDidStop()
    }
}

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()
        
        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.5
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo) / 2.6
        
        self.move(to: CGPoint(x: rect.width * 0.5 + rect.origin.x,
                              y: rect.height * 0.88 + rect.origin.y))
        self.addArc(withCenter: CGPoint(x: rect.width * 0.32 + rect.origin.x, y: rect.height * 0.4 + rect.origin.y),
                    radius: arcRadius,
                    startAngle: 135.degreesToRadians,
                    endAngle: 315.degreesToRadians,
                    clockwise: true)
        self.addLine(to: CGPoint(x: rect.width/2 + rect.origin.x,
                                 y: rect.height * 0.23 + rect.origin.y))
        self.addArc(withCenter: CGPoint(x: rect.width * 0.68 + rect.origin.x, y: rect.height * 0.4 + rect.origin.y),
                    radius: arcRadius,
                    startAngle: 225.degreesToRadians,
                    endAngle: 45.degreesToRadians,
                    clockwise: true)
        self.addLine(to: CGPoint(x: rect.width * 0.5 + rect.origin.x,
                                 y: rect.height * 0.88 + rect.origin.y))
        self.close()
    }
}

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * CGFloat(Double.pi) / 180 }
}
