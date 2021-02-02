//
//  CircleTransition.swift
//  CustomTransitionDemo
//
//  Created by GuoYongming on 2021/1/31.
//

import UIKit

// 圆形放大缩小动画
public class CircleTransition: Transition {
    // 外界传入的点击视图
    public var clickView: UIView?
    
    // Push和Present执行的动画
    override func executePushOrPresentTransition() {
        // 通过UIViewControllerContextTransitioning获取视图容器
        guard let containerView = context?.containerView else { return }
        // 获取当前Controller和将要跳转的Controller
        guard let fromVC = context?.viewController(forKey: .from), let toVC = context?.viewController(forKey: .to) else { return }
        
        // 将讲个VC的view添加到容器中，默认容器中会有一个当前的VC视图。重复添加也没关系，只会改变层级关系。
        containerView.addSubview(fromVC.view)
        containerView.addSubview(toVC.view)
        
        // 计算点击视图的在容器视图中的位置。
        var clickPoint: CGPoint = .zero
        if let startView = clickView {
            clickPoint = startView.convert(startView.center, to: containerView)
        }

        // 画小圆路径，先设置小圆半径为1.
        let smallPath = UIBezierPath(arcCenter: clickPoint, radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        // 画大圆，大圆的半径取点击点到屏幕四个角距离的最大值。
        let topLeftDistance = sqrtf(Float(pow(clickPoint.x, 2) + pow(clickPoint.y, 2)))
        let topRightDistance = sqrtf(Float(pow(containerView.bounds.size.width - clickPoint.x, 2) + pow(clickPoint.y, 2)))
        let bottomLeftDistance = sqrtf(Float(pow(clickPoint.x, 2) + pow(containerView.bounds.size.height - clickPoint.y, 2)))
        let bottomRightDistance = sqrtf(Float(pow(containerView.bounds.size.width - clickPoint.x, 2) + pow(containerView.bounds.size.height - clickPoint.y, 2)))
        
        let bigCircleRadius = max(max(topLeftDistance, topRightDistance), max(bottomLeftDistance, bottomRightDistance))
        
        // 画大圆路径
        let bigPath = UIBezierPath(arcCenter: clickPoint, radius: CGFloat(bigCircleRadius), startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        // 画圆
        let maskLayer = CAShapeLayer()
        maskLayer.path = bigPath.cgPath
        toVC.view.layer.mask = maskLayer
        // 创建动画，从小圆变化到大圆。
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = self.transitionDuration(using: context)
        animation.fromValue = smallPath.cgPath
        animation.toValue = bigPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        
        maskLayer.add(animation, forKey: "maskLayerAnimation")
    }
    
    override func executePopOrDismissTransition() {
        guard let containerView = context?.containerView else { return }
        guard let fromVC = context?.viewController(forKey: .from), let toVC = context?.viewController(forKey: .to) else { return }
        
        containerView.addSubview(toVC.view)
        containerView.addSubview(fromVC.view)
        
        var clickPoint: CGPoint = .zero
        if let startView = clickView {
            clickPoint = startView.convert(startView.center, to: containerView)
        }
        
        let smallPath = UIBezierPath(arcCenter: clickPoint, radius: 1, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let topLeftDistance = sqrtf(Float(pow(clickPoint.x, 2) + pow(clickPoint.y, 2)))
        let topRightDistance = sqrtf(Float(pow(containerView.bounds.size.width - clickPoint.x, 2) + pow(clickPoint.y, 2)))
        let bottomLeftDistance = sqrtf(Float(pow(clickPoint.x, 2) + pow(containerView.bounds.size.height - clickPoint.y, 2)))
        let bottomRightDistance = sqrtf(Float(pow(containerView.bounds.size.width - clickPoint.x, 2) + pow(containerView.bounds.size.height - clickPoint.y, 2)))
        
        let bigCircleRadius = max(max(topLeftDistance, topRightDistance), max(bottomLeftDistance, bottomRightDistance))
        
        let bigPath = UIBezierPath(arcCenter: clickPoint, radius: CGFloat(bigCircleRadius), startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = smallPath.cgPath
        fromVC.view.layer.mask = maskLayer
        
        // 创建动画，从大圆变化到小圆。
        let animation = CABasicAnimation(keyPath: "path")
        animation.duration = self.transitionDuration(using: context)
        animation.fromValue = bigPath.cgPath
        animation.toValue = smallPath.cgPath
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.delegate = self
        
        maskLayer.add(animation, forKey: "maskLayerAnimation")
    }
    
}
