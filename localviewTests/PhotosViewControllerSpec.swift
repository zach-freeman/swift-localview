import UIKit
import Quick
import Nimble
import Swinject

class PhotosViewControllerSpec: QuickSpec {
    override func spec() {
        var viewController: PhotosViewController!
        var expectedPhotoFetchState : FlickrApiUtils.PhotoFetchState!
        beforeEach {
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            let size = CGRect(x: 0, y: 0, width: 100, height: 100)
            let fakeCollectionView = UICollectionView(frame: size, collectionViewLayout: layout)
            viewController = PhotosViewController()
            viewController.collectionView = fakeCollectionView
            
            let storyboard = UIStoryboard(name: "Main",
                bundle: NSBundle(forClass: self.dynamicType))
            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            viewController = navigationController.topViewController as! PhotosViewController
            
            UIApplication.sharedApplication().keyWindow!.rootViewController = navigationController
            let _ = navigationController.view
            let _ = viewController.view
            viewController.loadView()
           
        }
        
        describe("viewDidLoad") {
            beforeEach {
                expectedPhotoFetchState = FlickrApiUtils.PhotoFetchState.PhotoListNotFetched
                viewController.viewDidLoad()
            }
            it("should set PhotoFetchState to PhotoListNotFetched") {
                expect(viewController.photoFetchState).to(equal(expectedPhotoFetchState))
            }
        }
        
        describe("viewDidAppear") {
            beforeEach {
                expectedPhotoFetchState = FlickrApiUtils.PhotoFetchState.PhotoListNotFetched
                viewController.viewDidAppear(true)
            }
            context("when PhotoFetchState is PhotoListNotFetched") {
                it("should initialize the photoListManager") {
                    expect(viewController.photoListManager).toNotEventually(beNil())
                }
            }
        }
        
        describe("refreshButtonTapped") {
            beforeEach {
                expectedPhotoFetchState = FlickrApiUtils.PhotoFetchState.PhotoListNotFetched
                
            }
        }
        

    }
}
