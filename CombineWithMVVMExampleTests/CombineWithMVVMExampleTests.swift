//
//  CombineWithMVVMExampleTests.swift
//  CombineWithMVVMExampleTests
//
//  Created by James Kong on 18/7/2022.
//

import XCTest
@testable import CombineWithMVVMExample

class CombineWithMVVMExampleTests: XCTestCase {
    var sut: MainViewModelType!
    override func setUpWithError() throws {
        sut = MainViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        sut.inputs.viewDidLoad()
        sut.inputs.setText(text: "Hello")
        
        var publisher = sut.outputs.switch1Enabled
            .collect(2)
            .first()
        sut.inputs.setText(text: "Hello")
//        var switch2Enabled = try awaitPublisher(sut.outputs.switch2Enabled)
//        var switch3Enabled = try awaitPublisher(sut.outputs.switch3Enabled)
//        XCTAssertFalse(switch1Enabled.count())
//        XCTAssertFalse(switch2Enabled)
//        XCTAssertFalse(switch3Enabled)
        
        sut.inputs.enable1(value: true)
        
        var switch1Enabled = try awaitPublisher(publisher)
//        switch2Enabled = try awaitPublisher(sut.outputs.switch2Enabled)
//        switch3Enabled = try awaitPublisher(sut.outputs.switch3Enabled)
        print("switch1Enabled \(switch1Enabled)")
//        XCTAssertTrue(switch1Enabled)
//        XCTAssertFalse(switch2Enabled)
//        XCTAssertFalse(switch3Enabled)
        
        
        
    }

}
