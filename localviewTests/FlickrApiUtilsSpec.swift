import Quick
import Nimble
import SwiftyJSON

class FlickrApiUtilsSpec: QuickSpec {
    override func spec() {
        var flickrResponseJson:JSON = nil
        var flickrPhotos:[FlickrPhoto] = []
        var flickrResponse: Data = Data()
        let expectedFlickrPhoto:FlickrPhoto = FlickrPhoto()
        
        describe("setupPhotoListWithJSON") {
            context("when the json is good") {
                beforeEach {
                    flickrResponse = LocalViewTestsHelpers.bundleFileContentsAsData("good-flickr-response", filetype: "json")
                    flickrResponseJson = LocalViewTestsHelpers.fileContentsAsJson(flickrResponse as NSData)
                    flickrPhotos = FlickrApiUtils.setupPhotoListWithJSON(flickrResponseJson)
                    expectedFlickrPhoto.photoSetId = "21619543780"
                    expectedFlickrPhoto.smallImageUrl = NSURL(string: "https://static.flickr.com/5730/21619543780_9263e389bc_s.jpg") as URL?
                    expectedFlickrPhoto.bigImageUrl = NSURL(string: "https://static.flickr.com/5730/21619543780_9263e389bc_b.jpg") as URL?
                    expectedFlickrPhoto.title = "FabLearn 0"
                }
                
                it("returns an array of 5 objects") {
                    expect(flickrPhotos.count).to(equal(5))
                }
                
                it("the first item's fields should equal the expected item's fields") {
                    expect(flickrPhotos[0].title).to(equal(expectedFlickrPhoto.title))
                    expect(flickrPhotos[0].photoSetId).to(equal(expectedFlickrPhoto.photoSetId))
                    expect(flickrPhotos[0].smallImageUrl).to(equal(expectedFlickrPhoto.smallImageUrl))
                    expect(flickrPhotos[0].bigImageUrl).to(equal(expectedFlickrPhoto.bigImageUrl))
                }
            }
            
            context("when the json is bad") {
                beforeEach {
                    flickrResponse = LocalViewTestsHelpers.bundleFileContentsAsData("bad-flickr-response", filetype: "json")
                    flickrResponseJson = LocalViewTestsHelpers.fileContentsAsJson(flickrResponse as NSData)
                    flickrPhotos = FlickrApiUtils.setupPhotoListWithJSON(flickrResponseJson)
                }
                
                it("returns an array of 0 objects") {
                    expect(flickrPhotos.count).to(equal(0))
                }
            }
        }
        
        describe("photoUrlForSize") {
            context("when small size is requested") {
                let expectedUrlString : String = "https://farm1.static.flickr.com/2/1418878_1e9228336_s.jpg"
                let expectedUrl = NSURL(string: expectedUrlString)
                var photoUrl: NSURL = NSURL(string: "")!
                beforeEach {
                    photoUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.SMALL_IMAGE_SIZE, photoId: "1418878", server: "2", secret: "1e9228336", farm: "1") as NSURL
                }
                
                it("should be correct url") {
                    expect(photoUrl).to(equal(expectedUrl))
                }
            }
            
            context("when big size is requested") {
                let expectedUrlString : String = "https://farm1.static.flickr.com/2/1418878_1e9228336_b.jpg"
                let expectedUrl = NSURL(string: expectedUrlString)
                var photoUrl: NSURL = NSURL(string: "")!
                beforeEach {
                    photoUrl = FlickrApiUtils.photoUrlForSize(FlickrConstants.BIG_IMAGE_SIZE, photoId: "1418878", server: "2", secret: "1e9228336", farm: "1") as NSURL
                }
                
                it("should be correct url") {
                    expect(photoUrl).to(equal(expectedUrl))
                }
            }
        }
        
        describe("the suffix for size method") {
            it("is returning the proper string for size") {
                let suffix = FlickrApiUtils.suffixForSize(FlickrApiUtils.FlickrPhotoSize.photoSizeCollectionIconLarge)
                expect(suffix).to(equal("collectionIconLarge"))
            }
        }
    }
}
