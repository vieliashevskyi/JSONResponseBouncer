//
//  JSONResponseBouncerTests.swift
//
//  Created by Vladyslav Ieliashevskyi on 09.02.2021.
//

import XCTest
@testable import JSONResponseBouncer

//MARK: Test Model
/*
	For example we would like to test model, called Player
	Imagine it contain all information provided by server after successful login attempt

	It will contain following fields:
	name is a string
	level is an integer
	type is a boolean
*/

class TestPlayerResourcesModelKeys: NSObject {
	static let name 	= "name"
	static let level 	= "level"
	static let type 	= "type"
}

class TestPlayerModel: Verifiable {
	static let _description = "TestPlayerModel";

	static let _keys: Array<ValidationTuple> = [
		ValidationTuple(keyName:TestPlayerResourcesModelKeys.name, valueType:.JSONString),
		ValidationTuple(keyName:TestPlayerResourcesModelKeys.level, valueType:.JSONNumber),
		ValidationTuple(keyName:TestPlayerResourcesModelKeys.type, valueType:.JSONBoolean)
	]

	func description() -> String {
		return TestPlayerModel._description
	}

	func keys() -> Array<ValidationTuple> {
		return TestPlayerModel._keys
	}

	func keysOnly() -> Array<String> {
		var returnKeys: Array<String> = Array<String>();
		for tuple:ValidationTuple in TestPlayerModel._keys {
			returnKeys.append(tuple.keyName)
		}

		return returnKeys
	}
}

//MARK: Test Model that is not Verifiable
class InvalidTestModel {}

//MARK: JSONResponsseBouncer Tests
class JSONResponsseBouncer: XCTestCase {

	override func setUp() {
		super.setUp()
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDown() {
		// Put teardown code here. This method is called after the invocation of each test method in the class.
		super.tearDown()
	}

	func test_ValidJSONResponse_stateValid() {
		let dictionary: Dictionary<String, Any> = [ "name" : "vladyslav", "level" : 1, "type" : true ]
		let state: JSONResponseState = JSONResponseBouncer.validate(dictionary:dictionary, model:TestPlayerModel())

		XCTAssert(state == JSONResponseState.Valid)
	}

	func test_NotDefinedKeyInJSONResponse_stateQuestionable() {
		let dictionary: Dictionary<String, Any> = [ "name_" : "vladyslav", "level" : 1, "type" : true ]
		let state: JSONResponseState = JSONResponseBouncer.validate(dictionary: dictionary, model:TestPlayerModel())

		XCTAssert(state == .Questionable)
	}

	func test_InvalidValueInJSONResponse_stateMalformed() {
		let dictionary: Dictionary<String, Any> = [ "name" : [], "level" : 1, "type" : true ]
		let state: JSONResponseState = JSONResponseBouncer.validate(dictionary: dictionary, model:TestPlayerModel())

		XCTAssert(state == .Malformed)
	}

	func test_EmptyDictionarySpecified_stateMalformed() {
		let dictionary: Dictionary<String, Any> = [:]
		let state: JSONResponseState = JSONResponseBouncer.validate(dictionary: dictionary, model:TestPlayerModel())

		XCTAssert(state == .Malformed)
	}

	func test_NotVerifiableModelSpecified_stateMalformed() {
		let dictionary: Dictionary<String, Any> = [ "name" : "vladyslav", "level" : 1, "type" : true ]
		let state: JSONResponseState = JSONResponseBouncer.validate(dictionary: dictionary, model: InvalidTestModel())

		XCTAssert(state == .Malformed)
	}
}
