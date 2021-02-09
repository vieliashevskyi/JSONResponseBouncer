//
//  VILog.swift
//
//  Created by Vladyslav Ieliashevskyi on 8/4/17.
//  Copyright © 2017. All rights reserved.
//

import Foundation

@objc final class VILog: NSObject {
	static func information(message: String) {
		print("\(VILog.generateTimestamp()) [💬 INFO] \(message)");
	}

	static func debug(message: String) {
		print("\(VILog.generateTimestamp()) [🛠️ DEBUG] \(message)");
	}

	static func warning(message: String) {
		print("\(VILog.generateTimestamp()) [⚠️ WARNING] \(message)");
	}

	static func error(message: String) {
		print("\(VILog.generateTimestamp()) [⛔ ERROR] \(message)");
	}

	static func success(message: String) {
		print("\(VILog.generateTimestamp()) [✅ SUCCESS] \(message)");
	}

	private static func generateTimestamp() -> String {
		return DateFormatter.localizedString(from: Date(),
		                                     dateStyle: DateFormatter.Style.medium,
		                                     timeStyle: DateFormatter.Style.short)
	}
}
