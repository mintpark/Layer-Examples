//
//  BounceAnimationHeartLayer.swift
//  Memebox
//
//  Created by mememacpro on 2017. 7. 13..
//  Copyright © 2017년 memebox. All rights reserved.
//

import UIKit

protocol BounceAnimationHeartLayerDelegate {
    func bounceAnimationDidStart()
    func bounceAnimationDidStop()
}

class BounceAnimationHeartLayer: CAShapeLayer, CAAnimationDelegate {
    
    let heartAspect: CGFloat = 100
    let wobbleDuration: CFTimeInterval = 0.3
    let offsetY: CGFloat = 100
    
    var bigHeartPath: CGPath!
    var smallHeartPath: CGPath!
    var initHeartPath: CGPath!
    
    var animationDelegate: BounceAnimationHeartLayerDelegate?
    
    override init() {
        super.init()
        
        bigHeartPath = UIBezierPath(heartIn: CGRect(x: MainScreen().width * 0.5 - self.heartAspect * 0.5,
                                                    y: MainScreen().height * 0.5 - self.heartAspect * 0.5 - offsetY,
                                                    width: heartAspect,
                                                    height: heartAspect)).cgPath
        smallHeartPath = UIBezierPath(heartIn: CGRect(x: MainScreen().width * 0.5 - self.heartAspect * 0.4,
                                                      y: MainScreen().height * 0.5 - self.heartAspect * 0.4 - offsetY,
                                                      width: heartAspect * 0.8,
                                                      height: heartAspect * 0.8)).cgPath
        initHeartPath = UIBezierPath(heartIn: CGRect(x: MainScreen().width * 0.5,
                                                     y: MainScreen().height * 0.5 - offsetY,
                                                     width: 0,
                                                     height: 0)).cgPath
        
        path = initHeartPath
        borderColor = UIColor.clear.cgColor
        fillColor = UIColor(hexString: "#ff5073")?.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        
        let wobbleAnimation1 = CABasicAnimation(keyPath: "path")
        wobbleAnimation1.fromValue = initHeartPath
        wobbleAnimation1.toValue = bigHeartPath
        wobbleAnimation1.beginTime = 0.0
        wobbleAnimation1.duration = wobbleDuration
        wobbleAnimation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        let wobbleAnimation2 = CABasicAnimation(keyPath: "path")
        wobbleAnimation2.fromValue = bigHeartPath
        wobbleAnimation2.toValue = smallHeartPath
        wobbleAnimation2.beginTime = wobbleAnimation1.beginTime + wobbleAnimation1.duration
        wobbleAnimation2.duration = wobbleDuration
        wobbleAnimation2.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        let wobbleAnimation3 = CABasicAnimation(keyPath: "path")
        wobbleAnimation3.fromValue = smallHeartPath
        wobbleAnimation3.toValue = bigHeartPath
        wobbleAnimation3.beginTime = wobbleAnimation2.beginTime + wobbleAnimation2.duration
        wobbleAnimation3.duration = wobbleDuration + 0.1
        wobbleAnimation3.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        let wobbleAnimation4 = CABasicAnimation(keyPath: "path")
        wobbleAnimation4.fromValue = bigHeartPath
        wobbleAnimation4.toValue = initHeartPath
        wobbleAnimation4.beginTime = wobbleAnimation3.beginTime + wobbleAnimation3.duration
        wobbleAnimation4.duration = wobbleDuration + 0.1
        wobbleAnimation4.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        let disappearAnimation = CABasicAnimation(keyPath: "opacity")
        disappearAnimation.fromValue = 1
        disappearAnimation.toValue = 0
        disappearAnimation.beginTime = wobbleAnimation3.beginTime + wobbleAnimation3.duration
        disappearAnimation.duration = wobbleAnimation4.duration
        disappearAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        let wobbleAnimationGroup = CAAnimationGroup()
        wobbleAnimationGroup.animations = [wobbleAnimation1, wobbleAnimation2, wobbleAnimation3, wobbleAnimation4, disappearAnimation]
        wobbleAnimationGroup.duration = wobbleAnimation4.beginTime + wobbleAnimation4.duration * 2
        wobbleAnimationGroup.delegate = self
        
        self.add(wobbleAnimationGroup, forKey: nil)
    }
    
    func animationDidStart(_ anim: CAAnimation) {
        animationDelegate?.bounceAnimationDidStart()
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        animationDelegate?.bounceAnimationDidStop()
    }
}
