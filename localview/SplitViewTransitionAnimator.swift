//
//  SplitViewTransititionAnimator.swift
//  localview
//
//  Created by Zach Freeman on 10/7/15.
//  Copyright © 2015 sparkwing. All rights reserved.
//

import UIKit

class SplitViewTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration    = 0.75
    var presenting  = true
    var originFrame = CGRect.zero
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        //get rects that represent the top and bottom halves of the screen
        let viewSize = fromViewController!.view.bounds.size
        let topFrame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height/2)
        let bottomFrame = CGRect(x: 0, y: viewSize.height/2, width: viewSize.width, height: viewSize.height/2)
        //create snapshots
        let snapshotTop: UIView = fromViewController!.view
            .resizableSnapshotView(from: topFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
        let snapshotBottom: UIView = fromViewController!.view
            .resizableSnapshotView(from: bottomFrame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)!
        snapshotTop.frame = topFrame
        snapshotBottom.frame = bottomFrame
        //remove the original view from the container
        fromViewController!.view.removeFromSuperview()
        //add our destination view
        containerView.addSubview(toViewController!.view)
        //add our snapshots on top
        containerView.addSubview(snapshotTop)
        containerView.addSubview(snapshotBottom)
        UIView.animate(withDuration: duration, animations: {
            //adjust the new frames
            var newTopFrame:CGRect = topFrame
            var newBottomFrame:CGRect = bottomFrame
            newTopFrame.origin.y -= topFrame.size.height
            newBottomFrame.origin.y += bottomFrame.size.height
            //set the frames to animate them
            snapshotTop.frame = newTopFrame
            snapshotBottom.frame = newBottomFrame
            }, completion: {_ in
                //don't forget to clean up
                snapshotTop.removeFromSuperview()
                snapshotBottom.removeFromSuperview()
                transitionContext.completeTransition(true)
        })

    }
}
