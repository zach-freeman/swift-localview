import UIKit
import Quick
import Nimble
import Swinject

class PhotosViewControllerSpec: QuickSpec {
    override func spec() {

        var subjectViewController: PhotosViewController!
        var expectedPhotoFetchState : FlickrApiUtils.PhotoFetchState!
        var fakeCollectionView : UICollectionView!
        var fakePhotoFetchState :FlickrApiUtils.PhotoFetchState?
        var container: Container!
        beforeEach {
            container = Container()
            container.register(PhotoListManager.self) { _ in MockPhotoListManager() }
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            let size = CGRect(x: 0, y: 0, width: 100, height: 100)
            fakeCollectionView = UICollectionView(frame: size, collectionViewLayout: layout)
            subjectViewController = PhotosViewController()
            subjectViewController.photoListManager = container.resolve(PhotoListManager.self)
            subjectViewController.collectionView = fakeCollectionView
            subjectViewController.photoFetchState = fakePhotoFetchState
            
            let storyboard = UIStoryboard(name: "Main",
                bundle: Bundle(for: type(of: self)))
            let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
            subjectViewController = navigationController.topViewController as! PhotosViewController
            
            UIApplication.shared.keyWindow!.rootViewController = navigationController
            let _ = navigationController.view
            let _ = subjectViewController.view
            subjectViewController.loadView()
           
        }
        
        describe("viewDidLoad") {
            beforeEach {
                expectedPhotoFetchState = FlickrApiUtils.PhotoFetchState.photoListNotFetched
                subjectViewController.viewDidLoad()
            }
            it("should set PhotoFetchState to PhotoListNotFetched") {
                expect(subjectViewController.photoFetchState).to(equal(expectedPhotoFetchState))
            }
        }
        
        describe("viewDidAppear") {
            beforeEach {
                subjectViewController.viewDidAppear(true)
            }
            
            context("when PhotoFetchState is PhotoListNotFetched") {
                beforeEach {
                    subjectViewController.photoFetchState = FlickrApiUtils.PhotoFetchState.photoListNotFetched
                }
                it("should initialize the photoListManager") {
                    expect(subjectViewController.photoListManager).toNot(beNil())
                }
            }
            
            context("when PhotoFetchState is PhotoListFetched") {
                beforeEach {
                    subjectViewController.photoListManager = nil
                    fakePhotoFetchState = FlickrApiUtils.PhotoFetchState.photoListNotFetched
                    subjectViewController.photoFetchState = fakePhotoFetchState
                }
                
                it("should not initialize the photoListManager") {
                    expect(subjectViewController.photoListManager).to(beNil());
                }
            }
            
            afterEach {
                subjectViewController.photoListManager = nil
            }
        }
        
        describe("refresh") {
            beforeEach {
                subjectViewController.photoFetchState = FlickrApiUtils.PhotoFetchState.photoListFetched
                expectedPhotoFetchState = FlickrApiUtils.PhotoFetchState.photoListNotFetched
                subjectViewController.refresh()
            }
            
            it("should hide the collection view") {
                expect(subjectViewController.collectionView?.isHidden).to(beTruthy())
            }
            
            it("should set the photo state to PhotoListNotFetched") {
                expect(subjectViewController.photoFetchState).to(equal(expectedPhotoFetchState))
            }
            
            it("should start the photo manager") {
                expect(subjectViewController.photoListManager).toNot(beNil())
            }
            
            it("should call the photo manager network status method") {
                let mockPhotoListManager = container.resolve(PhotoListManager.self) as! MockPhotoListManager
                expect(mockPhotoListManager.startNetworkStatusRequestCount).to(equal(1))
            }
            
        }
        

    }
}
