//
//  RubyfullUITests.swift
//  RubyfullUITests
//
//  Created by 伏貫祐樹 on 2019/12/26.
//  Copyright © 2019 yuki fushinuki. All rights reserved.
//

import XCTest

class RubyfullUITests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - TextViewが普通に入力できる
    /***************************************************************/
    func testTextView() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let textView = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .textView).element

        textView.tap()
        let key = app/*@START_MENU_TOKEN@*/.keys["た"]/*[[".keyboards.keys[\"た\"]",".keys[\"た\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        key.tap()
        key.tap()
        app/*@START_MENU_TOKEN@*/.keys["さ"]/*[[".keyboards.keys[\"さ\"]",".keys[\"さ\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        key.tap()
        key.tap()
        app.toolbars["Toolbar"].buttons["Done"].tap()

        XCTAssertEqual(textView.value as! String, "ちすち")
    }
    
    // MARK: - TextViewが空のままいきなりOKボタンを押すとエラーが出る
    /***************************************************************/
    func testOKButton() {
        
        let app = XCUIApplication()
//        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.tap()
        
        app.buttons["OK"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["入力が空です"].exists)
        
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
