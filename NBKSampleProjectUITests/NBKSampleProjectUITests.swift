//
//  NBKSampleProjectUITests.swift
//  NBKSampleProjectUITests
//
//  Created by Mazhar HUSAIN on 09/08/2023.
//

import Foundation
import Cucumberish

class CucumberishInitializer: NSObject {
    @objc class func setupCucumberish() {
        before({ _ in
            XCUIApplication().launch()
        })
        Given("I navigate to the Dashboard screen") { (args, userInfo) -> Void in            self.waitForElementToAppear(XCUIApplication().otherElements["dashboardvc"])
            print("we are here")
        }
        Then("I should see the tableview with loaded data") { (args, userInfo) -> Void in
            let tableView = XCUIApplication().tables["newsTableView"]
            XCTAssertTrue(tableView.exists && tableView.cells.count > 0)
        }
        Given("TableView is loaded") { (args, userInfo) -> Void in
            let tableView = XCUIApplication().tables["newsTableView"]
            XCTAssertTrue(tableView.exists && tableView.cells.count > 0)
        }
        Then("I tap on a tableview row") { (args, userInfo) -> Void in
            let tableView = XCUIApplication().tables["newsTableView"]
            XCTAssertTrue(tableView.exists && tableView.cells.count > 0)
            print("Number of cells: \(tableView.cells.count)")
            // Tap on the first cell (index 0) for demonstration purposes
            tableView.cells.element(boundBy: 0).tap()
            print("Tapped on cell")
        }
        Then("I should be redirected to the details screen") { (args, userInfo) -> Void in
            XCTAssertTrue(XCUIApplication().otherElements["newsDescriptionScreen"].exists)
        }
        Given("DashBoard screen is visible") { (args, userInfo) -> Void in            self.waitForElementToAppear(XCUIApplication().otherElements["dashboardvc"])
            print("we are here")
        }
        When("I tap on the filter button") { (args, userInfo) -> Void in             XCUIApplication().navigationBars.buttons["filterButton"].tap()
        }
        Then("I should see the filter popup") { (args, userInfo) -> Void in
            XCTAssertTrue(XCUIApplication().otherElements["filterPopup"].exists)
        }
        let bundle = Bundle(for: CucumberishInitializer.self)
        Cucumberish.executeFeatures(inDirectory: "Features", from: bundle, includeTags: self.getTags(), excludeTags: nil)
    }
    class func waitForElementToAppear(_ element: XCUIElement){
        let result = element.waitForExistence(timeout: 5)
        guard result else {
            XCTFail("Element does not appear")
            return
        }
    }
    fileprivate class func getTags() -> [String]? {
        var itemsTags: [String]? = nil
        for item in ProcessInfo.processInfo.arguments {
            if item.hasPrefix("-Tags:") {
                let newItems = item.replacingOccurrences(of: "-Tags:", with: "")
                itemsTags = newItems.components(separatedBy: ",")
            }
        }
        return itemsTags
    }
}
