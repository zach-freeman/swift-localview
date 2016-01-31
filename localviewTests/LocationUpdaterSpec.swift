import Quick
import Nimble
import CoreLocation
import MapKit
import AddressBook

class LocationUpdaterSpec: QuickSpec {
    override func spec() {
        let locationUpdater:LocationUpdater = LocationUpdater()
        describe("formatPlacemark") {
            context("NewYorkPlacemark") {
                let expectedResult:String = "New York, NY, United States"
                var formattedPlacemark:String = ""
                beforeEach {
                    let coordinate = CLLocationCoordinate2DMake(40.7590686, -73.98496110000001)
                    let addressDictionary = [kABPersonAddressStreetKey as String: "200 W 47th St",
                        kABPersonAddressCityKey as String: "New York",
                        kABPersonAddressStateKey as String: "NY",
                        kABPersonAddressZIPKey as String: "10036",
                        kABPersonAddressCountryKey as String: "United States",
                        kABPersonAddressCountryCodeKey as String: "US"]
                    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
                    formattedPlacemark = locationUpdater.formatPlacemark(placemark)
                }
                it("returns NewYorkNYUnitedStates") {
                    expect(formattedPlacemark).to(equal(expectedResult))
                }
            }
            context("LondonPlacemark") {
                let expectedResult:String = "London, United Kingdom"
                var formattedPlacemark:String = ""
                beforeEach {
                    let coordinate = CLLocationCoordinate2DMake(51.51006860112236, -0.1337113133153556)
                    let addressDictionary = [kABPersonAddressStreetKey as String: "Coventry Street",
                        kABPersonAddressCityKey as String: "London",
                        kABPersonAddressZIPKey as String: "W1J",
                        kABPersonAddressCountryKey as String: "United Kingdom",
                        kABPersonAddressCountryCodeKey as String: "GB"]
                    let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
                    formattedPlacemark = locationUpdater.formatPlacemark(placemark)
                }
                it("returns London, United Kindgom") {
                    expect(formattedPlacemark).to(equal(expectedResult))
                }
            }
        }
    }
}
