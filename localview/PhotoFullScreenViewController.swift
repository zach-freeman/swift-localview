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
    @IBOutlet weak var doneButton: UIButton!
    var fullImage: UIImage?
    var flickrPhoto: FlickrPhoto?
    var photoFetchState: FlickrApiUtils.PhotoFetchState?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoFetchState = .photosNotFetched
        if Utils.isPhone() {
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(PhotoFullScreenViewController.orientationChanged(_:)),
                name: UIDevice.orientationDidChangeNotification,
                object: UIDevice.current)
            self.createViews()
        }
        // Do any additional setup after loading the view.
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    @objc func orientationChanged(_ note: Notification) {
        // we have to remove the image and scroll views and re-add them because the
        // navigation bar size changes when the orientation changes
        self.fullImageView.removeFromSuperview()
        self.containerScrollView.removeFromSuperview()
        self.createViews()
        self.setupImageInScrollView()
    }
    func createViews() {
        let viewBounds: CGRect = self.viewBounds()
        self.createScrollView(viewBounds)
        self.createImageView(viewBounds)
        self.view.bringSubviewToFront(doneButton)
    }
    func viewBounds() -> CGRect {
        var viewFrame: CGRect = CGRect.zero
        viewFrame = self.view.bounds
        return viewFrame
    }
    func createScrollView(_ viewBounds: CGRect) {
        // Create the scroll view
        self.containerScrollView = UIScrollView(frame: viewBounds)
        self.containerScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.containerScrollView.showsHorizontalScrollIndicator = false
        self.containerScrollView.showsVerticalScrollIndicator = false
        self.containerScrollView.delegate = self
        let maxScale: CGFloat = 1.5
        self.containerScrollView.maximumZoomScale = maxScale
        self.view.addSubview(self.containerScrollView)
    }
    func createImageView(_ viewBounds: CGRect) {
        self.fullImageView = UIImageView(frame: viewBounds)
        self.fullImageView.contentMode = UIView.ContentMode.scaleAspectFill
        self.fullImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.fullImageView.clipsToBounds = true
        self.containerScrollView.addSubview(self.fullImageView)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.photoFetchState == .photosNotFetched {
            self.showPhotoAfterDownload()
        }
    }
    @IBAction func doneButtonTapped(_ sender: AnyObject) {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.imageDownloadProgressView.isHidden = true
        self.doneButton.isHidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Scroll View Delegate
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.fullImageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerScrollViewContent()
    }
    func showPhotoAfterDownload() {
        let sdWebImageManager: SDWebImageManager = SDWebImageManager.shared()
        let progress: SDWebImageDownloaderProgressBlock = { [weak self] (receivedSize, expectedSize, _) in
            guard self != nil else {
                return
            }
            DispatchQueue.main.async {
                self?.imageDownloadProgressView.isHidden = false
                let receivedSizeFloat: Float = NSNumber(value: receivedSize as Int).floatValue
                let expectedSizeFloat: Float = NSNumber(value: expectedSize as Int).floatValue
                let progress: Float = receivedSizeFloat/expectedSizeFloat
                self?.imageDownloadProgressView.setProgress(progress, animated: true)
            }
        }

        let completion: SDInternalCompletionBlock = { [weak self] (image, _, _, _, _, _) in
            guard self != nil else {
                return
            }
            DispatchQueue.main.async {
                self?.photoFetchState = .photosFetched
                if Utils.isPad() {
                    self?.fullImageView.image = image
                } else if Utils.isPhone() {
                    self?.fullImage = UIImage()
                    self?.fullImage = image
                    self?.setupImageInScrollView()
                }
                self?.imageDownloadProgressView.isHidden = true
                self?.doneButton.isHidden = false
            }

        }
        sdWebImageManager.loadImage(with: self.flickrPhoto?.bigImageUrl as URL?,
                                    options: [],
                                    progress: progress,
                                    completed: completion)
        var photoTitle: String = self.flickrPhoto!.title!
        if photoTitle.isEmpty {
            photoTitle = FlickrConstants.kTitleNotAvailable
        }
        self.commentTextView.text = photoTitle
        self.commentTextView.textAlignment = .center
    }
    func setupImageInScrollView() {
        self.containerScrollView.minimumZoomScale = 1
        self.containerScrollView.zoomScale = 1

        self.fullImageView.frame = CGRect(x: 0,
                                          y: 0,
                                          width: self.fullImage!.size.width,
                                          height: self.fullImage!.size.height)
        self.fullImageView.image = self.fullImage
        self.containerScrollView.contentSize = self.fullImage!.size
        // Calculate Min
        let viewSize: CGSize = self.containerScrollView.bounds.size
        let xScale: CGFloat = viewSize.width / self.fullImage!.size.width
        let yScale: CGFloat = viewSize.height / self.fullImage!.size.height
        let minScale: CGFloat = min(xScale, yScale)
        self.containerScrollView.minimumZoomScale = min(minScale, 1)
        self.containerScrollView.zoomScale = self.containerScrollView.minimumZoomScale
        self.centerScrollViewContent()
    }
    func centerScrollViewContent() {
        let scrollViewSize = self.containerScrollView.bounds.size
        var imageFrame = self.fullImageView.frame
        if imageFrame.size.width < scrollViewSize.width {
            imageFrame.origin.x = (scrollViewSize.width - imageFrame.size.width) / 2.0
        } else {
            imageFrame.origin.x = 0.0
        }
        if imageFrame.size.height < scrollViewSize.height {
            imageFrame.origin.y = (scrollViewSize.height - imageFrame.size.height) / 2.0
        } else {
            imageFrame.origin.y = 0.0
        }
        self.fullImageView.frame = imageFrame
    }
}
