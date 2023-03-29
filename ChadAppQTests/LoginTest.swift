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
    }
//   If the TextFields are Empty - A special case of Invalid Username and Password
    func test_EmptyTextFields() throws {
        let result = loginVM?.loginUser(settings: UserSettings())
        let expected = LoginFocusStates.username
        XCTAssertEqual(result, expected)
    }

    // If the Textfield doesnt follow the given format
    func test_InvalidUSernameFormat() throws {
        loginVM?.usernameTF = "wally-ryan"
        let result = loginVM?.loginUser(settings: UserSettings())
        let expected = LoginFocusStates.username
        XCTAssertEqual(result, expected)
    }
    
//    If the password doesnt follow the given format
    func test_InvalidPasswordFormat() throws {
        loginVM?.usernameTF = "wallly_ryan"
        loginVM?.secretTF = "parda433"
        let result = loginVM?.loginUser(settings: UserSettings())
        let expected = LoginFocusStates.secret
        XCTAssertEqual(result, expected)
    }
    
// If the entered credentials are invalid
    func test_InvalidCredentials() throws {
        let expectation = XCTestExpectation(description: #function)
        self.loginVM?.usernameTF = "wallly_aryan"
        self.loginVM?.secretTF = "parda@433"
        self.loginVM?.loginUser(settings: UserSettings())
        print("waiting started")
        wait(for: [expectation], timeout: 5)
        print("waiting ended")
        XCTAssertTrue(self.loginVM!.showLoginAlert)
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//        }
    }
    
//    If the entered credentials are valid
    func test_ValidCredentials() throws {
        loginVM?.usernameTF = "wallly_aryan"
        loginVM?.secretTF = "parda@433"
        let setting = UserSettings()
        loginVM?.loginUser(settings: setting)
        print(setting.user.username)
    }
}

//extension XCTestCase {
//    func runAsyncTest(
//        named testName: String = #function,
//        in file: StaticString = #file,
//        at line: UInt = #line,
//        withTimeout timeout: TimeInterval = 10,
//        test: @escaping () async throws -> Void
//    ) {
//        var thrownError: Error?
//        let errorHandler = { thrownError = $0 }
//        let expectation = expectation(description: testName)
//
//        Task {
//            do {
//                try await test()
//            } catch {
//                errorHandler(error)
//            }
//
//            expectation.fulfill()
//        }
//
//        waitForExpectations(timeout: timeout)
//
//        if let error = thrownError {
//            XCTFail(
//                "Async error thrown: \(error)",
//                file: file,
//                line: line
//            )
//        }
//    }
//}
