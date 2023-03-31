//
//  LoginTest.swift
//  ChadAppQTests
//
//  Created by Rapipay Macintoshn on 27/03/23.
//

import XCTest
@testable import ChadAppQ

final class LoginTest: XCTestCase {
    
    var loginVM: LoginViewModel?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        loginVM = LoginViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        loginVM = nil
    }
//   If the TextFields are Empty - A special case of Invalid Username and Password
    func test_EmptyTextFields() throws {
        let result = loginVM?.loginUser(settings: UserSettings(), state: "true")
        let expected = LoginFocusStates.username
        XCTAssertEqual(result, expected)
    }

    // If the Textfield doesnt follow the given format
    func test_InvalidUSernameFormat() throws {
        loginVM?.usernameTF = "wally-ryan"
        let result = loginVM?.loginUser(settings: UserSettings(), state: "true")
        let expected = LoginFocusStates.username
        XCTAssertEqual(result, expected)
    }
    
//    If the password doesnt follow the given format
    func test_InvalidPasswordFormat() throws {
        loginVM?.usernameTF = "wallly_ryan"
        loginVM?.secretTF = "parda433"
        let result = loginVM?.loginUser(settings: UserSettings(), state: "true")
        let expected = LoginFocusStates.secret
        XCTAssertEqual(result, expected)
    }
    
// If the entered credentials are invalid
    func test_InvalidCredentials() throws {
        let expectation = self.expectation(description: "Invalid Credentials")
        self.loginVM?.usernameTF = "wally_ryan"
        self.loginVM?.secretTF = "parda@433"
        var invalid = false
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "users/me/",
            "requestType": .loginUser as RequestType,
            "username": self.loginVM?.usernameTF,
            "userSecret": self.loginVM?.secretTF,],
            completionHandler: { data in
                guard let data = data as? [String: Any] else {return}
                
                if let suc = data["first_name"] as? String {
                    
                } else {
                    invalid = true
                }
                XCTAssertTrue(invalid)
                expectation.fulfill()
            },
            errorHandler: { err in
                XCTFail()
                expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
//    If the entered credentials are valid
    func test_ValidCredentials() throws {
        let expectation = self.expectation(description: "Valid Credentials")
        self.loginVM?.usernameTF = "wally_ryan"
        self.loginVM?.secretTF = "Parda@433"
        var valid = false
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "GET",
            "domain": "users/me/",
            "requestType": .loginUser as RequestType,
            "username": self.loginVM?.usernameTF,
            "userSecret": self.loginVM?.secretTF,],
            completionHandler: { data in
                guard let data = data as? [String: Any] else {return}
                
                if let suc = data["first_name"] as? String {
                    valid = true
                } else {
                }
                XCTAssertTrue(valid)
                expectation.fulfill()
            },
            errorHandler: { err in
                XCTFail()
                expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}

