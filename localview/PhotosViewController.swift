//
//  PhotosViewController.swift
//  localview
//
//  Created by Zach Freeman on 10/5/15.
//  Copyright © 2015 sparkwing. All rights reserved.
//

import UIKit

class PhotosViewController: UICollectionViewController,
PhotoListManagerDelegate,
UIViewControllerPreviewingDelegate {
    fileprivate let reuseIdentifier = "PhotoCell"
    fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
    var flickrPhotoList: [FlickrPhoto] = []
    var photoListManager: PhotoListManager!
    var photoLoadViewController: PhotoLoadViewController!
    var photoFetchState: FlickrApiUtils.PhotoFetchState?
    var selectedImage: UIImageView?
    let transition = FadeViewTransitionAnimator()
    var fullViewIsLandscape: Bool?
    var refreshControl: UIRefreshControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView!.alwaysBounceVertical = true
        if #available(iOS 9.0, *) {
            if traitCollection.forceTouchCapability == .available {
                registerForPreviewing(with: self, sourceView: view)
            }
        } else {
            // Fallback on earlier versions
        }

        self.photoFetchState = .photoListNotFetched
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: type(of: self)))
        let aPhotoLoadViewController = storyboard.instantiateViewController(withIdentifier: "PhotoLoadViewController")
        guard let viewController = aPhotoLoadViewController as? PhotoLoadViewController else {
            print("couldn't load the PhotoLoadViewController")
            return
        }
        self.photoLoadViewController = viewController
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.tintColor = UIColor.gray
        self.refreshControl!.addTarget(self,
                                       action: #selector(PhotosViewController.refresh),
                                       for: .valueChanged)
        collectionView!.addSubview(self.refreshControl!)
        collectionView!.alwaysBounceVertical = true
    }
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func viewDidAppear(_ animated: Bool) {
        if self.photoFetchState == .photoListNotFetched {
            self.startPhotoListManager()
        }
    }
    @objc func refresh() {
        self.photoFetchState = .photoListNotFetched
        self.collectionView?.isHidden = true
        self.startPhotoListManager()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func photoForIndexPath(_ indexPath: IndexPath) -> FlickrPhoto {
        return flickrPhotoList[(indexPath as NSIndexPath).row]
    }
    func photoForPhotoSetId(_ photoSetId: Int) -> FlickrPhoto {
        let foundValue: FlickrPhoto = flickrPhotoList.index {
            $0.photoSetId == String(photoSetId) }.map { flickrPhotoList[$0]
        }!
        return foundValue
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return self.flickrPhotoList.count
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                let optionalHeaderView = collectionView
                    .dequeueReusableSupplementaryView(ofKind: kind,
                                                      withReuseIdentifier: "PhotosHeaderView",
                                                      for: indexPath)
                guard let headerView = optionalHeaderView as? PhotosHeaderView else {
                    print("couldn't load PhotosHeaderView")
                    return optionalHeaderView
                }
                let photosHeaderView = headerView
                if let currentPlacemark = self.photoListManager?.currentPlacemark {
                    photosHeaderView.locationLabel.text = currentPlacemark
                }
                return photosHeaderView
            default:
                assert(false, "Unexpected element kind")
            }
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let optionalCell = collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier,
                                                              for: indexPath)
        guard let cell = optionalCell as? PhotoCell else {
            print("couldn't load PhotoCell")
            return optionalCell
        }
        let photoCell = cell
        let flickrPhoto = photoForIndexPath(indexPath)
        photoCell.tag = Int(flickrPhoto.photoSetId!)!
        let previewImageLayer = photoCell.smallImageView.layer
        Utils.setupRoundedCornersForLayer(previewImageLayer)
        let placeholder: UIImage = UIImage(named: "placeholder")!
        photoCell.smallImageView?.sd_setImage(with: flickrPhoto.smallImageUrl! as URL,
                                         placeholderImage: placeholder)
        photoCell.backgroundColor = UIColor.black
        return photoCell
    }
    override func collectionView(_ collectionView: UICollectionView,
                                 didSelectItemAt indexPath: IndexPath) {
        let optionalCell = collectionView.cellForItem(at: indexPath)
        guard let cell = optionalCell as? PhotoCell else {
            print("couldn't load PhotoCell")
            return
        }
        let photoCell = cell
        self.selectedImage = photoCell.smallImageView
        let viewController = storyboard!
            .instantiateViewController(withIdentifier: "PhotoFullScreenViewController")
        guard let photoFullScreenViewController = viewController as? PhotoFullScreenViewController else {
            print("couldn't load PhotoFullScreenViewController")
            return
        }
        photoFullScreenViewController.flickrPhoto = photoForIndexPath(indexPath)
        photoFullScreenViewController.transitioningDelegate = self
        present(photoFullScreenViewController, animated: true, completion: nil)
    }
    // MARK: - Photo List Manager
    func startPhotoListManager() {
        self.navigationController?
            .present(self.photoLoadViewController, animated: true, completion: nil)
        self.photoListManager = PhotoListManager()
        self.photoListManager.delegate = self
    }
    func photoListManagerDidFinish(_ photoListManager: PhotoListManager, alert: UIAlertController?) {
        if alert == nil {
            self.photoFetchState = .photoListFetched
            self.navigationController?.dismiss(animated: true, completion: nil)
            self.collectionView?.isHidden = false
            self.collectionView?.reloadData()
            self.refreshControl!.endRefreshing()
            if photoListManager.flickrPhotoList.count > 0 {
                self.flickrPhotoList = photoListManager.flickrPhotoList
            } else {
                let alert: UIAlertController = Utils
                    .buildAlert("Error",
                                message: "No photos retrieved. Is your Flickr key correct?")
                self.present(alert, animated: true)
            }
        } else {
            self.present(alert!, animated: true)
        }
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = self.collectionView?.indexPathForItem(at: location)
            else { return nil }
        guard let cell = self.collectionView?.cellForItem(at: indexPath) else { return nil }
        guard let photoFullScreenViewController = storyboard?
            .instantiateViewController(withIdentifier: "PhotoFullScreenViewController")
            as? PhotoFullScreenViewController else { return nil }
        let flickrPhoto = photoForPhotoSetId(cell.tag)
        photoFullScreenViewController.flickrPhoto = flickrPhoto
        photoFullScreenViewController.preferredContentSize = CGSize(width: 0.0, height: 300)
        if #available(iOS 9.0, *) {
            previewingContext.sourceRect = cell.frame
        } else {
            // Fallback on earlier versions
        }
        return photoFullScreenViewController
    }
    func previewingContext(_ previewingContext: UIViewControllerPreviewing,
                           commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }

}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 75, height: 75)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}

extension PhotosViewController: UIViewControllerTransitioningDelegate {
    func animationController(
        forPresented presented: UIViewController,
        presenting: UIViewController,
        source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            transition.originFrame = selectedImage!.superview!.convert(selectedImage!.frame, to: nil)
            transition.presenting = true
            return transition
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
