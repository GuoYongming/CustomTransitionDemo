//
//  SpreadTransition.swift
//  CustomTransitionDemo
//
//  Created by GuoYongming on 2021/2/1.
//

import UIKit

enum SpreadDirection {
    case fromRight
    case fromLeft
    case fromTop
    case fromBottom
}

class SpreadTransition: Transition {
    public var direction: SpreadDirection = .fromRight
    
    override func executePushOrPresentTransition() {
        
        guard let containerView = context?.containerView else { return }
        guard let toVC = context?.viewController(forKey: .to) else { return }
        
        containerView.addSubview(toVC.view)
        
        let screenWidth = containerView.bounds.size.width
        let screenHeight = containerView.bounds.size.height
        
        var rect0: CGRect = .zero
        let rect1 = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        switch direction {
        case .fromRight:
            rect0 = CGRect(x: screenWidth, y: 0, width: 2, height: screenHeight)
        case .fromLeft:
            rect0 = CGRect(x: 0, y: 0, width: 2, height: screenHeight)
        case .fromTop:
            rect0 = CGRect(x: 0, y: 0, width: screenWidth, height: 2)
        default:
            rect0 = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 2)
        }
        
        let startPath = UIBezierPath(rect: rect0)
        let endPath = UIBezierPath(rect: rect1)
        
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        toVC.view.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = self.transitionDuration(using: context)
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        
        maskLayer.add(animation, forKey: "maskLayerAnimation")
    }
    
    override func executePopOrDismissTransition() {
        guard let containerView = context?.containerView else { return }
        guard let toVC = context?.viewController(forKey: .to) else { return }
        containerView.addSubview(toVC.view)
        
        let screenWidth = containerView.bounds.size.width
        let screenHeight = containerView.bounds.size.height
        
        var rect0: CGRect = .zero
        let rect1 = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight)
        
        switch direction {
        case .fromRight:
            rect0 = CGRect(x: screenWidth, y: 0, width: 2, height: screenHeight)
        case .fromLeft:
            rect0 = CGRect(x: 0, y: 0, width: 2, height: screenHeight)
        case .fromTop:
            rect0 = CGRect(x: 0, y: 0, width: screenWidth, height: 2)
        default:
            rect0 = CGRect(x: 0, y: screenHeight, width: screenWidth, height: 2)
        }
        
        let startPath = UIBezierPath(rect: rect0)
        let endPath = UIBezierPath(rect: rect1)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = endPath.cgPath
        toVC.view.layer.mask = maskLayer
        
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = self.transitionDuration(using: context)
        animation.fromValue = startPath.cgPath
        animation.toValue = endPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        
        maskLayer.add(animation, forKey: "maskLayerAnimation")
    }
}
