//
//  JSONResponseBouncer.swift
//
//  Created by Vladyslav Ieliashevskyi on 7/27/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

@objc class SRJSONValidationMapper : NSObject {
	public static func validate(_ route: String, json: Dictionary<String, Any>) -> JSONResponseState {
		// TODO: Map your API endpoints
		switch route {
			/*
				I find it handy to have endpoints listed in a following way
				@objc class APIRouter: NSObject {
					static let userLogin = "/user/login"
				}
			*/
			//case APIRouter.<YOUR ENDPOINT>:
			//VILog.success(message: "Validator found for API route -> \(route)")
			//return JSONResponseBouncer.validate(dictionary: json, model: <YOUR MODEL>)
			default:
				VILog.error(message: "No mapped validator found for current route -> \(route)")
				return .Malformed
		}
	}
}

class JSONResponseBouncer {
	static func validate(dictionary: Dictionary<String, Any>, model: Any) -> JSONResponseState {
		guard 0 != dictionary.count else {
			VILog.error(message: "Response object is empty");
			return .Malformed
		}

		guard model is Verifiable else {
			VILog.error(message: "Specified Model does not conform to Verifiable protocol")
			return .Malformed
		}

		var result: JSONResponseState = .Questionable

		/*
			Validate keys. Raise error if JSON contains keys that are not defined by model
		*/

		let conformingKeys:Array<String> = (model as! Verifiable).keysOnly()
		for (key, _) in dictionary {
			guard conformingKeys.contains(key) else {
				VILog.error(message: "Key \"\(key)\" is not defined in scope of \((model as! Verifiable).description()) model")
				return .Questionable
			}
		}

		/*
			Validate values associated with Keys according to defined tuples.
		*/
		let modelKeyValues = (model as! Verifiable).keys()
		for (key, value) in dictionary {
			for iterativeTuple:ValidationTuple in modelKeyValues {
				if iterativeTuple.keyName == key {
					result = JSONGuardian.validate(value: value, tuple: iterativeTuple)

					guard result == .Valid else {
						return result
					}
					break;
				}
			}
		}

		return result
	}
}

class JSONGuardian {
	class func validate(value: Any, tuple: ValidationTuple) -> JSONResponseState {
		var status:JSONResponseState = .Valid

		switch tuple.valueType.rawValue {
			case JSONResponseValueClasses.JSONString.rawValue:
				guard value is String else {
					status = .Malformed
					break
				}
			case JSONResponseValueClasses.JSONNumber.rawValue:
				guard value is NSNumber else {
					status = .Malformed
					break
				}
			case JSONResponseValueClasses.JSONArray.rawValue:
				guard value is Array<Any> else {
					status = .Malformed
					break
				}
			case JSONResponseValueClasses.JSONDictionary.rawValue:
				guard value is Dictionary<String, Any> else {
					status = .Malformed
					break
				}
			case JSONResponseValueClasses.JSONBoolean.rawValue:
				guard value is Bool else {
					status = .Malformed
					break
				}
			default:
				status = .Questionable
				break
		}

		if (status == .Malformed) {
			let valueMirror:Mirror = Mirror.init(reflecting: value)
			VILog.error(message: "Value \"\(value)\" for Key: \"\(tuple.keyName)\" is of unexpected type")
			VILog.information(message: "Value is of type -> \(valueMirror.subjectType) but expected to be \(tuple.valueType.rawValue)")
		}

		if (status == .Questionable) {
			VILog.warning(message: "This may be dangerous to unwrap received JSON")
		}

		return status
	}
}
