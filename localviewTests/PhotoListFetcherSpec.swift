import Quick
import Nimble
// import Swinject
@testable import localview
class PhotoListFetcherSpec: QuickSpec {

    override func spec() {
        var networkAccessQueue: OperationQueue {
            let queue = OperationQueue()
            queue.name = "NetworkAccessQueue"
            queue.maxConcurrentOperationCount = 1
            return queue
        }
        let container: Container = Container()
        var fetcher: PhotoListFetcher!
        var mockNetwork: MockNetwork = MockNetwork()
        var mockPhotoListFetcherDelegate: MockPhotoListFetcherDelegate = MockPhotoListFetcherDelegate()
        beforeEach {
            container.register(Networking.self) { _ in mockNetwork }
            container.register(PhotoListFetcher.self) { result in
                PhotoListFetcher.init(currentLatitude: "test",
                                      currentLongitude: "test",
                                      currentNetwork: result.resolve(Networking.self)!)
            }
                .initCompleted { result, child in
                    let thefetch = child as PhotoListFetcher?
                    thefetch?.network = result.resolve(Networking.self)!
            }
            container.register(PhotoListFetcherDelegate.self) { _ in mockPhotoListFetcherDelegate }
            fetcher = container.resolve(PhotoListFetcher.self)!
            fetcher.delegate = container.resolve(PhotoListFetcherDelegate.self)
            networkAccessQueue.addOperation(fetcher)
        }
        it("calls network request") {
            let optionalNetwork = container.resolve(Networking.self)
            guard let network = optionalNetwork as? MockNetwork else {
                print("can't get mock network")
                return
            }
            expect(network.requestCount).toEventually(equal(1))
        }
        it("fills the flickrPhotos array") {
            expect(fetcher.flickrPhotos.count).toEventually(equal(5))
            expect(fetcher.flickrPhotos[0].title).toEventually(equal("FabLearn 0"))
            expect(fetcher.flickrPhotos[0].photoSetId).toEventually(equal("21619543780"))
        }
        it("calls the delegate") {
            let optionalDelegate = container.resolve(PhotoListFetcherDelegate.self)
            guard let delegate = optionalDelegate as? MockPhotoListFetcherDelegate else {
                print("couldn't get MockPhotoListFetcherDelegate")
                return
            }
            expect(delegate.delegateCallCount).toEventually(equal(1))
        }
        afterEach {
            mockNetwork = MockNetwork()
            mockPhotoListFetcherDelegate = MockPhotoListFetcherDelegate()
        }
    }
}
