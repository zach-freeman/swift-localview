import Quick
import Nimble
import Swinject

class PhotoListFetcherSpec: QuickSpec {

    override func spec() {
        var networkAccessQueue:NSOperationQueue {
            let queue = NSOperationQueue()
            queue.name = "NetworkAccessQueue"
            queue.maxConcurrentOperationCount = 1
            return queue
        }
        var container: Container!
        var fetcher: PhotoListFetcher!
        beforeEach {
            container = Container()
            container.register(Networking.self) { _ in MockNetwork() }
                .inObjectScope(.Container)
            container.register(PhotoListFetcher.self) { r in
                PhotoListFetcher.init(currentLatitude: "test", currentLongitude: "test", currentNetwork: r.resolve(Networking.self)!)
            }
            container.register(PhotoListFetcherDelegate.self) { _ in MockPhotoListFetcherDelegate() }
                .inObjectScope(.Container)
            fetcher = container.resolve(PhotoListFetcher.self)!
            fetcher.delegate = container.resolve(PhotoListFetcherDelegate.self)
            networkAccessQueue.addOperation(fetcher)
        }
        
        
        it("calls network request") {
            let network = container.resolve(Networking.self) as! MockNetwork
            expect(network.requestCount).toEventually(equal(1))
        }
        
        it("fills the flickrPhotos array") {
            expect(fetcher.flickrPhotos.count).toEventually(equal(5))
            expect(fetcher.flickrPhotos[0].title).toEventually(equal("FabLearn 0"))
            expect(fetcher.flickrPhotos[0].photoSetId).toEventually(equal("21619543780"))
        }
        
        it("calls the delegate") {
            let delegate = container.resolve(PhotoListFetcherDelegate.self) as! MockPhotoListFetcherDelegate
            expect(delegate.delegateCallCount).toEventually(equal(1))
        }
        
    }
}
