//
//  JSONVerifiableProtocol.swift
//
//  Created by Vladyslav Ieliashevskyi on 8/7/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

/*
	Model should conform to this protocol in order to be testable by bouncer.
*/
protocol Verifiable {
	func keys() -> Array<ValidationTuple>
}

extension Verifiable {
	/*
		Swift mirroring is not very comprehensive.
		Basically this function states model name.
	*/
	func description() -> String {
		guard let returnString = Mirror.init(reflecting: self).description.components(separatedBy: " ").last else {
			return ""
		}

		return returnString
	}

	func keysOnly() -> Array<String> {
		var returnKeys: Array<String> = Array<String>();
		for tuple:ValidationTuple in self.keys() {
			returnKeys.append(tuple.keyName)
		}

		return returnKeys
	}
}
