import Quick
import Nimble

class FlickrApiUtilsSpec: QuickSpec {
    override func spec() {
        describe("the suffix for size method") {
            it("is returning the proper string for size") {
                let suffix = FlickrApiUtils.suffixForSize(FlickrApiUtils.FlickrPhotoSize.PhotoSizeCollectionIconLarge)
                expect(suffix).to(equal("collectionIconLarge"))
            }
        }
    }
}
