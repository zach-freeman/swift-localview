//
//  PopViewTransitionAnimator.swift
//  localview
//
//  Created by Zach Freeman on 10/8/15.
//  Copyright © 2015 sparkwing. All rights reserved.
//

import UIKit

class PopViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration    = 0.75
    var presenting  = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?)-> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        toViewController!.view.frame = fromViewController!.view.frame
        if(self.presenting == true) {
            toViewController!.view.alpha = 0;
            toViewController!.view.transform = CGAffineTransform(scaleX: 0, y: 0);
            
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
                toViewController!.view.alpha = 1;
                toViewController!.view.transform = CGAffineTransform(scaleX: 1, y: 1);
                containerView.addSubview(toViewController!.view)
                }, completion: { (completed) -> Void in
                    transitionContext.completeTransition(completed)
            })
            
        } else {
            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
                fromViewController!.view.alpha = 0;
                fromViewController!.view.transform = CGAffineTransform(scaleX: 0.001, y: 0.0001);
                }, completion: { (completed) -> Void in
                    fromViewController?.view.removeFromSuperview()
                    transitionContext.completeTransition(completed)
                    
                    
            })
        }
    }
    
    
}
