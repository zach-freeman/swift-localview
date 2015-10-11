//
//  PhotosViewController.swift
//  localview
//
//  Created by Zach Freeman on 10/5/15.
//  Copyright © 2015 sparkwing. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController, PhotoListManagerDelegate {
  
    private let reuseIdentifier = "PhotoCell";
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    var flickrPhotoList : [FlickrPhoto] = []
    var photoListManager:PhotoListManager!
    var photoLoadViewController:PhotoLoadViewController!
    var photoFetchState:FlickrApiUtils.PhotoFetchState?
    var selectedImage: UIImageView?
    let transition = FadeViewTransitionAnimator()
    var fullViewIsLandscape:Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.photoFetchState = .PhotoListNotFetched
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.photoLoadViewController = storyboard.instantiateViewControllerWithIdentifier("PhotoLoadViewController") as! PhotoLoadViewController
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func viewDidAppear(animated: Bool) {
        if (self.photoFetchState == .PhotoListNotFetched) {
            self.startPhotoListManager()
        }
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        self.photoFetchState = .PhotoListNotFetched
        self.collectionView?.hidden = true
        self.startPhotoListManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func photoForIndexPath(indexPath: NSIndexPath) -> FlickrPhoto {
        return flickrPhotoList[indexPath.row]
    }
    

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.flickrPhotoList.count
    }
    
    override func collectionView(collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                    withReuseIdentifier: "PhotosHeaderView",
                    forIndexPath: indexPath)
                    as! PhotosHeaderView
                if let currentPlacemark = self.photoListManager?.currentPlacemark {
                    headerView.locationLabel.text = currentPlacemark
                }
                return headerView
            default:
                assert(false, "Unexpected element kind")
            }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        let flickrPhoto = photoForIndexPath(indexPath)
        let previewImageLayer = cell.smallImageView.layer
        Utils.setupRoundedCornersForLayer(previewImageLayer)
        let placeholder:UIImage = UIImage(named: "placeholder")!
        cell.smallImageView?.sd_setImageWithURL(flickrPhoto.smallImageUrl!, placeholderImage: placeholder)
        cell.backgroundColor = UIColor.blackColor()
    
    
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! PhotoCell
        self.selectedImage = cell.smallImageView
        let photoFullScreenViewController = storyboard!.instantiateViewControllerWithIdentifier("PhotoFullScreenViewController") as! PhotoFullScreenViewController
        photoFullScreenViewController.flickrPhoto = photoForIndexPath(indexPath)
        photoFullScreenViewController.transitioningDelegate = self
        presentViewController(photoFullScreenViewController, animated: true, completion: nil)
    }
    
    // MARK: - Photo List Manager
    func startPhotoListManager() {
        self.navigationController?.presentViewController(self.photoLoadViewController, animated: true, completion: nil)
        self.photoListManager = PhotoListManager()
        self.photoListManager.delegate = self
    }
    
    func photoListManagerDidFinish(photoListManager : PhotoListManager) {
        self.photoFetchState = .PhotoListFetched
        self.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        self.collectionView?.hidden = false
        if photoListManager.flickrPhotoList.count > 0 {
            self.flickrPhotoList = photoListManager.flickrPhotoList
            self.collectionView?.reloadData()
        } else {
            Utils.showAlert("Error", message: "No photos retrieved. Is your Flickr key correct?")
        }
        
    }

}

extension PhotosViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
            return CGSize(width: 75, height: 75)
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
    
}

extension PhotosViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(
        presented: UIViewController,
        presentingController presenting: UIViewController,
        sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
            transition.presenting = true
            
            return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
