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
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        let fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)
        let toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)
        toViewController!.view.frame = fromViewController!.view.frame
        if(self.presenting == true) {
            toViewController!.view.alpha = 0;
            toViewController!.view.transform = CGAffineTransformMakeScale(0, 0);
            
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
                toViewController!.view.alpha = 1;
                toViewController!.view.transform = CGAffineTransformMakeScale(1, 1);
                containerView.addSubview(toViewController!.view)
                }, completion: { (completed) -> Void in
                    transitionContext.completeTransition(completed)
            })
            
        } else {
            UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.3, options: [], animations: { () -> Void in
                fromViewController!.view.alpha = 0;
                fromViewController!.view.transform = CGAffineTransformMakeScale(0.001, 0.0001);
                }, completion: { (completed) -> Void in
                    fromViewController?.view.removeFromSuperview()
                    transitionContext.completeTransition(completed)
                    
                    
            })
        }
    }
    
    
}
