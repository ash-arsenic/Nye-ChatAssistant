//
//  SingupTest.swift
//  ChadAppQTests
//
//  Created by Rapipay Macintoshn on 30/03/23.
//

import XCTest
@testable import ChadAppQ

final class SignupTest: XCTestCase {
    
    var signupVM: SignupViewModel?
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        signupVM = SignupViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        signupVM = nil
    }
//   If the TextFields are Empty - A special case of Invalid Username and Password
    func test_EmptyTextFields() throws {
        let result = signupVM?.signupUser()
        let expected = FocusStates.username
        XCTAssertEqual(result, expected)
    }

    // If the Textfield doesnt follow the given format
    func test_InvalidUSernameFormat() throws {
        signupVM?.usernameTF = "wally-ryan"
        let result = FocusStates.username
        let expected = FocusStates.username
        XCTAssertEqual(result, expected)
    }
    
//    If the password doesnt follow the given format
    func test_InvalidNameFormat() throws {
        signupVM?.usernameTF = "wallly_ryan"
        signupVM?.firstNameTF = "Walter Ryan"
        signupVM?.lastNameTF = "Ryan"
        let result = signupVM?.signupUser()
        let expected = FocusStates.firstName
        XCTAssertEqual(result, expected)
    }
    
//    If the password doesnt follow the given format
    func test_InvalidPasswordFormat() throws {
        signupVM?.usernameTF = "wallly_ryan"
        signupVM?.firstNameTF = "Walter"
        signupVM?.lastNameTF = "Ryan"
        signupVM?.secretTF = "parda433"
        let result = signupVM?.signupUser()
        let expected = FocusStates.secret
        XCTAssertEqual(result, expected)
    }
    
// If the entered credentials are invalid
    func test_UserExist() throws {
        let expectation = self.expectation(description: "Invalid Credentials")
        self.signupVM?.usernameTF = "wally_ryan"
        self.signupVM?.firstNameTF = "Walter"
        self.signupVM?.lastNameTF = "Ryan"
        self.signupVM?.secretTF = "Parda@433"
        var exist = false
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "POST",
            "domain": "users/",
            "createUser": true,
            "httpBody": [ "username": self.signupVM?.usernameTF, "first_name": self.signupVM?.firstNameTF, "last_name": self.signupVM?.lastNameTF, "secret": self.signupVM?.secretTF]],
            completionHandler: { data in
            guard let data = data as? [String: Any] else {return}
            if let data = data["first_name"] as? String {
                
            } else {
                exist = true
            }
            XCTAssertTrue(exist)
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
        self.signupVM?.usernameTF = "wally_ryan9"
        self.signupVM?.firstNameTF = "Walter"
        self.signupVM?.lastNameTF = "Ryan"
        self.signupVM?.secretTF = "Parda@433"
        var done = false
        NetworkManager.shared.requestForApi(requestInfo: [
            "httpMethod": "POST",
            "domain": "users/",
            "createUser": true,
            "httpBody": [ "username": self.signupVM?.usernameTF, "first_name": self.signupVM?.firstNameTF, "last_name": self.signupVM?.lastNameTF, "secret": self.signupVM?.secretTF]],
            completionHandler: { data in
            guard let data = data as? [String: Any] else {return}
            if let data = data["first_name"] as? String {
                done = true
            } else {
            }
            XCTAssertTrue(done)
            expectation.fulfill()
        },
        errorHandler: { err in
            XCTFail()
            expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
}
