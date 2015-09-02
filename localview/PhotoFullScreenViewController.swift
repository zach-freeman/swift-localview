//
//  PhotoFullScreenViewController.swift
//  localview
//
//  Created by Zach Freeman on 8/14/15.
//  Copyright (c) 2015 sparkwing. All rights reserved.
//

import UIKit

class PhotoFullScreenViewController: UIViewController, UIScrollViewDelegate {
  
  var containerScrollView: UIScrollView!
  @IBOutlet var fullImageView: UIImageView!
  @IBOutlet weak var commentTextView: UITextView!
  @IBOutlet weak var imageDownloadProgressView: UIProgressView!
  var fullImage:UIImage?
  var flickrPhoto:FlickrPhoto?
  var photoFetchState: FlickrPhoto.PhotoFetchState?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.photoFetchState = .PhotosNotFetched
    if (Utils.isPhone()) {
      UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
      NSNotificationCenter.defaultCenter().addObserver(
        self,
        selector: "orientationChanged:",
        name: UIDeviceOrientationDidChangeNotification,
        object: UIDevice.currentDevice())
      self.createViews()
    }
    
    // Do any additional setup after loading the view.
  }
  
  func orientationChanged(note: NSNotification)
  {
    // we have to remove the image and scroll views and re-add them because the
    // navigation bar size changes when the orientation changes
    self.fullImageView.removeFromSuperview()
    self.containerScrollView.removeFromSuperview()
    self.createViews()
    self.setupImageInScrollView()
    
  }
  
  func createViews() -> Void {
    let viewBounds:CGRect = self.viewBounds()
    self.createScrollView(viewBounds)
    self.createImageView(viewBounds)
  }
  
  func viewBounds() -> CGRect {
    var viewFrame:CGRect = CGRectZero;
    if self.navigationController!.navigationBarHidden == false {
      let navigationBarXOrigin:CGFloat = self.navigationController!.navigationBar.frame.origin.x
      let navigationBarHeight:CGFloat = self.navigationController!.navigationBar.frame.size.height
      viewFrame = CGRectMake(navigationBarXOrigin, navigationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height - navigationBarHeight)
    } else {
      viewFrame = self.view.bounds
    }
    return viewFrame;
  }
  
  func createScrollView(viewBounds:CGRect) {
    // Create the scroll view
    self.containerScrollView = UIScrollView(frame: viewBounds)
    self.containerScrollView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    self.containerScrollView.showsHorizontalScrollIndicator = false
    self.containerScrollView.showsVerticalScrollIndicator = false
    self.containerScrollView.delegate = self
    let MaxScale:CGFloat = 1.5
    self.containerScrollView.maximumZoomScale = MaxScale
    self.view.addSubview(self.containerScrollView)
  }
  
  func createImageView(viewBounds:CGRect) {
    self.fullImageView = UIImageView(frame:viewBounds)
    
    self.fullImageView.contentMode = UIViewContentMode.ScaleAspectFill
    self.fullImageView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
    self.fullImageView.clipsToBounds = true
    self.containerScrollView.addSubview(self.fullImageView)
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if (self.photoFetchState == .PhotosNotFetched) {
      self.showPhotoAfterDownload()
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Scroll View Delegate
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return self.fullImageView;
  }
  
  func scrollViewDidZoom(scrollView: UIScrollView) {
    self.centerScrollViewContent()
  }
  
  func showPhotoAfterDownload() {
    let sdWebImageManager:SDWebImageManager = SDWebImageManager.sharedManager()
    let progressBlock:SDWebImageDownloaderProgressBlock! = {(receivedSize:Int, expectedSize:Int) -> Void in
      self.imageDownloadProgressView.hidden = false;
      let receivedSizeFloat:Float = NSNumber(integer:receivedSize).floatValue
      let expectedSizeFloat:Float = NSNumber(integer:expectedSize).floatValue
      let progress:Float = receivedSizeFloat/expectedSizeFloat;
      self.imageDownloadProgressView.setProgress(progress, animated: true)
    }
    let completionBlock:SDWebImageCompletionWithFinishedBlock! = {(image: UIImage!, error: NSError!, cacheType: SDImageCacheType, finished:Bool, url:NSURL!) -> Void in
      dispatch_async(dispatch_get_main_queue()) {
        self.photoFetchState = .PhotosFetched
        if (Utils.isPad()) {
          self.fullImageView.image = image;
        } else if (Utils.isPhone()) {
          self.fullImage = UIImage()
          self.fullImage = image
          self.setupImageInScrollView()
        }
        self.slideAnimateImage()
        self.imageDownloadProgressView.hidden = true;
      }
      
    }
    sdWebImageManager.downloadImageWithURL(self.flickrPhoto?.bigImageUrl, options: nil, progress: progressBlock, completed: completionBlock)
    var photoTitle : String = self.flickrPhoto!.title!
    if photoTitle.isEmpty {
      self.commentTextView.text = "Title not available"
      self.commentTextView.textColor = UIColor.grayColor()
    } else {
      self.commentTextView.text = photoTitle
    }
    self.commentTextView.text = photoTitle
    self.commentTextView.textAlignment = .Center
    self.commentTextView.font = UIFont(name: "Helvetica Neue", size: 22)
  }
  
  
  func setupImageInScrollView() {
    self.containerScrollView.minimumZoomScale = 1;
    self.containerScrollView.zoomScale = 1;
    
    self.fullImageView.frame = CGRectMake(0, 0, self.fullImage!.size.width, self.fullImage!.size.height);
    self.fullImageView.image = self.fullImage;
    self.containerScrollView.contentSize = self.fullImage!.size;
    
    // Calculate Min
    let viewSize:CGSize = self.containerScrollView.bounds.size;
    let xScale:CGFloat = viewSize.width / self.fullImage!.size.width;
    let yScale:CGFloat = viewSize.height / self.fullImage!.size.height;
    let minScale:CGFloat = min(xScale, yScale);
    
    self.containerScrollView.minimumZoomScale = min(minScale, 1);
    
    self.containerScrollView.zoomScale = self.containerScrollView.minimumZoomScale;
    
    self.centerScrollViewContent()
    
  }
  
  func centerScrollViewContent() {
    let boundsSize = self.containerScrollView.bounds.size
    var contentsFrame = self.fullImageView.frame
    
    if contentsFrame.size.width < boundsSize.width {
      contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
    } else {
      contentsFrame.origin.x = 0.0
    }
    
    if contentsFrame.size.height < boundsSize.height {
      contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
    } else {
      contentsFrame.origin.y = 0.0
    }
    
    self.fullImageView.frame = contentsFrame
  }
  
  func slideAnimateImage() {
    let animation = CATransition()
    animation.duration = CFTimeInterval(2.0)
    animation.type = kCATransitionPush
    animation.subtype = kCATransitionFromRight
    animation.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseOut)
    self.fullImageView.layer.addAnimation(animation, forKey: nil)
  }
  
}
