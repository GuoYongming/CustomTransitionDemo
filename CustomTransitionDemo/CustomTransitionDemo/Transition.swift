//
//  Transition.swift
//  CustomTransitionDemo
//
//  Created by GuoYongming on 2021/1/31.
//

import UIKit

// 自定义的行为方式。
public enum TransitionOperation: Int {
    case push
    case pop
    case present
    case dismiss
}

// 动画类型枚举
public enum TransitionType: Int {
    case none = 0           // 系统默认
    case circle             // 圆形效果
    case boom               // 爆炸效果
    case spreadFromRight    // 从右侧展开进入
    case spreadFromLeft     // 从左侧展开进入
    case spreadFromTop      // 从上面展开进入
    case spreadFromBottom   // 从底部展开进入
    
    var index: Int {
        return self.rawValue
    }
    
    var text: String {
        switch self {
        case .circle:
            return "Circle"
        case .boom:
            return "Boom"
        case .spreadFromRight:
            return "SpreadFromRight"
        case .spreadFromLeft:
            return "SpreadFromLeft"
        case .spreadFromTop:
            return "SpreadFromTop"
        case .spreadFromBottom:
            return "SpreadFromBottom"
        default:
            return "default"
        }
    }
}

public class Transition: NSObject {
    public var operation: TransitionOperation = .push
    public var context: UIViewControllerContextTransitioning?
    
    // 当是Push或者Present的时候执行该方法
    func executePushOrPresentTransition() { }
    
    // 当是Pop或者Dismiss的时候执行该方法
    func executePopOrDismissTransition() { }
}

extension Transition: UIViewControllerAnimatedTransitioning {
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        context = transitionContext
        if operation == .push || operation == .present {
            executePushOrPresentTransition()
        }else if operation == .pop || operation == .dismiss {
            executePopOrDismissTransition()
        }
    }
}

extension Transition: CAAnimationDelegate {
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        context?.completeTransition(true)
        if operation == .push || operation == .present {
            // 动画结束后，移除mask。
            let toVC = context?.viewController(forKey: .to)
            toVC?.view.mask = nil
        }else if operation == .pop || operation == .dismiss {
            // 动画结束后，移除mask。
            let fromVC = context?.viewController(forKey: .from)
            fromVC?.view.mask = nil
        }
    }
}
