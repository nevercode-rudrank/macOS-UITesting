//
//  macOS_UITestingUITests.swift
//  macOS UITestingUITests
//
//  Created by Rudrank Riyam on 31/10/21.
//

import XCTest

class macOS_UITestingUITests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testShowButtonDisplaysWelcomeLabel() {
    // 1
    let app = XCUIApplication()
    app.launch()
    
    // 2
    let window = app.windows
    
    // 3
    let showButton = window.buttons["Show Button"]
    
    // 4
    XCTAssertFalse(window.staticTexts["Welcome to Codemagic!"].exists)
    
    // 5
    showButton.click()
    
    // 6
    XCTAssertTrue(window.staticTexts["Welcome to Codemagic!"].exists)
  }
}
