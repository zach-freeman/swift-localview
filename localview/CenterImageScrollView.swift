//
//  CenterImageScrollView.swift
//  localview
//
//  Created by Zach Freeman on 8/29/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import Foundation

class CenterImageScrollView:UIScrollView {

  override func setContentOffset(contentOffset: CGPoint, animated: Bool) -> Void
  {
    let contentSize:CGSize = self.contentSize
    let scrollViewSize:CGSize = self.bounds.size
    var newContentOffsetX:CGFloat = contentOffset.x
    var newContentOffsetY:CGFloat = contentOffset.y
    if contentSize.width < scrollViewSize.width {
      newContentOffsetX = -(scrollViewSize.width - contentSize.width) / 2.0
    }
    
    if contentSize.height < scrollViewSize.height
    {
      newContentOffsetY = -(scrollViewSize.height - contentSize.height) / 2.0
    }
    super.setContentOffset(CGPointMake(newContentOffsetX, newContentOffsetY), animated: animated)
  }
}