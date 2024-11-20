//
//  String+HM+Extension.swift
//  stick_ios
//
//  Created by lisl on 2024/1/15.
//

import Foundation

extension String: HMPrefixable { }

extension HMPrefixableWrapper where Base == String {
    
    public func versionCompare(_ otherVersion: String) -> ComparisonResult {
        return base.compare(otherVersion, options: String.CompareOptions.numeric)
    }
    
    public func versionGreaterThan(_ otherVersion: String) -> Bool {
        return versionCompare(otherVersion) == .orderedDescending
    }
    
    public func versionLessThan(_ otherVersion: String) -> Bool {
        return versionCompare(otherVersion) == .orderedAscending
    }
    
    public func versionSame(_ otherVersion: String) -> Bool {
        return versionCompare(otherVersion) == .orderedSame
    }
}
