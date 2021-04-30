//
//  FadeViewTransitionAnimator.swift
//  localview
//
//  Created by Zach Freeman on 10/8/15.
//  Copyright © 2021 sparkwing. All rights reserved.
//

import UIKit

class FadeViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration    = 0.35
    var presenting  = true
    var originFrame = CGRect.zero
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // fade the new view in
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext
            .viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext
            .viewController(forKey: UITransitionContextViewControllerKey.to)
        toViewController!.view.alpha = 0.0
        containerView.addSubview(toViewController!.view)
        UIView.animate(withDuration: duration, animations: {
            if !self.presenting {
                // account for case where user rotates device after transition occurred
                toViewController!.view.frame = fromViewController!.view.frame
            }
            toViewController!.view.alpha = 1.0
            }, completion: { _ in
                fromViewController!.view.removeFromSuperview()
                transitionContext.completeTransition(true)
        })
    }
}
