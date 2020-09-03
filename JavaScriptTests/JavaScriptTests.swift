//
//  JavaScriptTests.swift
//  JavaScriptTests
//
//  Created by Saurabh Gupta on 03/09/20.
//  Copyright © 2020 Saurabh Gupta. All rights reserved.
//

import XCTest

class JavaScriptTests: XCTestCase {
    
    func testNoOperationID() {
        let exp = expectation(description: "Executing Javascript")
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "VaccineTrialViewController") as? VaccineTrialViewController
        viewController?.setupWebView()
        
        viewController?.webView.evaluateJavaScript("startOperation()") { result, error in
            exp.fulfill()
            if error != nil, let errorMessage = (error! as NSError).userInfo["WKJavaScriptExceptionMessage"] as? String {
                XCTAssertTrue(errorMessage == "Error: Expected id", "No Operation Id passed to startOperation")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testEmptyOperationId() throws {
        let exp = expectation(description: "Executing Javascript")
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "VaccineTrialViewController") as? VaccineTrialViewController
        viewController?.setupWebView()
        
        viewController?.webView.evaluateJavaScript("startOperation('')") { result, error in
            exp.fulfill()
            if error != nil, let errorMessage = (error! as NSError).userInfo["WKJavaScriptExceptionMessage"] as? String {
                XCTAssertTrue(errorMessage == "Error: Expected id", "Empty Operation Id passed to startOperation")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testDuplicateOperationId() throws {
        let exp = expectation(description: "Executing Javascript")
        let operations: [VaccineTrialViewController.Operation] = [.vaccineTypeAHumanTrial, .vaccineTypeAHumanTrial]
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "VaccineTrialViewController") as? VaccineTrialViewController
        viewController?.setupWebView()
        
        viewController?.webView.evaluateJavaScript("startOperation('\(operations[0].rawValue)')") { result, error in
            exp.fulfill()
            XCTAssertNil(error)
        }
        viewController?.webView.evaluateJavaScript("startOperation('\(operations[1].rawValue)')") { result, error in
            if error != nil, let errorMessage = (error! as NSError).userInfo["WKJavaScriptExceptionMessage"] as? String {
                XCTAssertTrue(errorMessage == "Error: Expected unique id", "Duplicate Operation Id passed to startOperation")
            }
        }
        
        waitForExpectations(timeout: 5)
    }
    
    func testUniqueOperationIds() throws {
        let exp = expectation(description: "Executing Javascript")
        let operations: [VaccineTrialViewController.Operation] = [.vaccineTypeAHumanTrial, .vaccineTypeBHumanTrial]
        let viewController = UIStoryboard.init(name: "Main", bundle: Bundle(for: type(of: self))).instantiateViewController(withIdentifier: "VaccineTrialViewController") as? VaccineTrialViewController
        viewController?.setupWebView()
        
        viewController?.webView.evaluateJavaScript("startOperation('\(operations[0].rawValue)')") { result, error in
            exp.fulfill()
            XCTAssertNil(error)
        }
        viewController?.webView.evaluateJavaScript("startOperation('\(operations[1].rawValue)')") { result, error in
            XCTAssertNil(error)
        }
        
        waitForExpectations(timeout: 5)
    }
}
