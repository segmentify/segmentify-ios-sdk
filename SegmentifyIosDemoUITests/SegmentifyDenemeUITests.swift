//
//  SegmentifyDenemeUITests.swift
//  SegmentifyDenemeUITests
//
//  Created by Ata Anıl Turgay on 7.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import XCTest


class SegmentifyDenemeUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func testHome() {
        
        let app = XCUIApplication()
        Thread.sleep(forTimeInterval: 5)
        app.launch()
        
        
        /*let app = XCUIApplication()
        NSThread.sleepForTimeInterval(10)
        app.tabBars.buttons["Mağazalar"].tap()
        app.buttons["Daha sonra izin verin"].tap()
        
        app.scrollViews.staticTexts["BEYMEN MAĞAZALARI"].swipeUp()
        app.scrollViews.childrenMatchingType(.TextField).element.tap()
        app.pickers.pickerWheels["Ankara"].tap()
        app.buttons["Tamam"].tap()
        app.scrollViews.tables.cells.staticTexts["Armada AVM Eskişehir Yolu No:6 Söğütözü"].tap()*/
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
}
