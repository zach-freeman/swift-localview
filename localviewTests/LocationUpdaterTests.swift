//
//  LocationUpdaterTests.swift
//  localview
//
//  Created by Zach Freeman on 10/12/15.
//  Copyright © 2015 sparkwing. All rights reserved.
//

import XCTest
import CoreLocation
import MapKit
import AddressBook

class LocationUpdaterTests: XCTestCase {
    
    var locationUpdater:LocationUpdater?
    
    override func setUp() {
        super.setUp()
        self.locationUpdater = LocationUpdater()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testFormatPlacemark_NewYorkPlacemark_returnsNewYorkNYUnitedStates() {
        let expectedResult:String = "New York, NY, United States"
        let coordinate = CLLocationCoordinate2DMake(40.7590686, -73.98496110000001)
        let addressDictionary = [kABPersonAddressStreetKey as String: "200 W 47th St",
            kABPersonAddressCityKey as String: "New York",
            kABPersonAddressStateKey as String: "NY",
            kABPersonAddressZIPKey as String: "10036",
            kABPersonAddressCountryKey as String: "United States",
            kABPersonAddressCountryCodeKey as String: "US"]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let formattedPlacemark = self.locationUpdater?.formatPlacemark(placemark)
        XCTAssertEqual(expectedResult, formattedPlacemark, "pass")
        
    }
    
    func testFormatPlacemark_LondonPlacemark_returnsLondonEngland() {
        let expectedResult:String = "London, United Kingdom"
        let coordinate = CLLocationCoordinate2DMake(51.51006860112236, -0.1337113133153556)
        let addressDictionary = [kABPersonAddressStreetKey as String: "Coventry Street",
            kABPersonAddressCityKey as String: "London",
            kABPersonAddressZIPKey as String: "W1J",
            kABPersonAddressCountryKey as String: "United Kingdom",
            kABPersonAddressCountryCodeKey as String: "GB"]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDictionary)
        let formattedPlacemark = self.locationUpdater?.formatPlacemark(placemark)
        XCTAssertEqual(expectedResult, formattedPlacemark, "pass")
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
