//
//  BoomTransition.swift
//  CustomTransitionDemo
//
//  Created by GuoYongming on 2021/2/1.
//

import UIKit

class BoomTransition: Transition {
    
    override func executePushOrPresentTransition() {
        
        guard let containerView = context?.containerView else { return }
        guard let toVC = context?.viewController(forKey: .to) else { return }
        
        containerView.addSubview(toVC.view)
        
        toVC.view.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        UIView.animate(withDuration: transitionDuration(using: context), delay: 0.0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1/0.4, options: [], animations: {
            toVC.view.layer.transform = CATransform3DIdentity
        }) { [weak self] (finished) in
            self?.context?.completeTransition(true)
        }
    }
    
    override func executePopOrDismissTransition() {
        guard let containerView = context?.containerView else { return }
        guard let fromVC = context?.viewController(forKey: .from) else { return }
        guard let toVC = context?.viewController(forKey: .to) else { return }
        
        containerView.insertSubview(toVC.view, at: 0)
        
        fromVC.view.layer.transform = CATransform3DIdentity
        
        UIView.animate(withDuration: transitionDuration(using: context), animations: {
            fromVC.view.layer.transform = CATransform3DMakeScale(0.01, 0.01, 1)
        }) { [weak self] (finished) in
            self?.context?.completeTransition(true)
            fromVC.view.layer.transform = CATransform3DIdentity
        }
    }
}
