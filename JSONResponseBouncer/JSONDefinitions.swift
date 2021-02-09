//
//  JSONDefinitions.swift
//
//  Created by Vladyslav Ieliashevskyi on 8/7/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

@objc enum JSONResponseState: Int {
	/*
		Questionable state resides at the beginning of parsing through JSON.
		JSONs that have fields that are not defined by a model will have a Questionable state as well.
	*/
	case Questionable = 0

	/*
		Will be returned only in case if parsing succeded and json fully conforms to specified model.
	*/
	case Valid = 1

	/*
		In case if we will get a value of a type that differs from expected type
		(E.G: Bool instead of String) we will break further validation.

		Also applies for Models that do not conform to Verifiable protocol, or when json is empty.
	*/
	case Malformed = 2
}

/*
	As seen from basic JSON from Objective-C.
	In swift they will be a bit different.
*/
enum JSONResponseValueClasses: String {
	case JSONBoolean	= "__NSCFBoolean"
	case JSONString		= "__NSCFConstantString"
	case JSONNumber		= "__NSCFNumber"
	case JSONArray		= "Array<AnyObject>"
	case JSONDictionary = "Dictionary<NSObject, AnyObject>"
}

/*
	Tuple that will represent key-type coding for model values.
*/
typealias ValidationTuple = (keyName: String, valueType: JSONResponseValueClasses)
