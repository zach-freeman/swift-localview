import Quick
import Nimble
import CoreLocation
import MapKit
import Contacts

class LocationUpdaterSpec: QuickSpec {
    override func spec() {
        let locationUpdater: LocationUpdater = LocationUpdater()
        describe("formatPlacemark") {
            context("NewYorkPlacemark") {
                let expectedResult: String = "New York, NY, United States"
                var formattedPlacemark: String = ""
                beforeEach {
                    let coordinate = CLLocationCoordinate2DMake(40.7590686, -73.98496110000001)
                    let address = CNMutablePostalAddress()
                    address.street = "200 W 47th St"
                    address.city = "New York"
                    address.state = "NY"
                    address.postalCode = "10036"
                    address.country = "United States"
                    address.isoCountryCode = "US"
                    let placemark = MKPlacemark(coordinate: coordinate, postalAddress: address)
                    formattedPlacemark = locationUpdater.formatPlacemark(placemark)
                }
                it("returns NewYorkNYUnitedStates") {
                    expect(formattedPlacemark).to(equal(expectedResult))
                }
            }
            context("LondonPlacemark") {
                let expectedResult: String = "London, United Kingdom"
                var formattedPlacemark: String = ""
                beforeEach {
                    let coordinate = CLLocationCoordinate2DMake(51.51006860112236, -0.1337113133153556)
                    let address = CNMutablePostalAddress()
                    address.street = "Coventry Street"
                    address.city = "London"
                    address.postalCode = "W1J"
                    address.country = "United Kingdom"
                    address.isoCountryCode = "GB"
                    let placemark = MKPlacemark(coordinate: coordinate, postalAddress: address)
                    formattedPlacemark = locationUpdater.formatPlacemark(placemark)
                }
                it("returns London, United Kindgom") {
                    expect(formattedPlacemark).to(equal(expectedResult))
                }
            }
        }
    }
}
