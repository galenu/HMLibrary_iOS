//
//  Data+HM+Extension.swift
//  stick_ios
//
//  Created by lisl on 2024/1/8.
//

import Foundation
import CommonCrypto

extension Data: HMPrefixable { }
extension HMPrefixableWrapper where Base == Data {
    
    public var md5String: String {
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        let md5Buffer = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5((base as NSData).bytes, CC_LONG(base.count), md5Buffer)
        let output = NSMutableString(capacity: Int(CC_MD5_DIGEST_LENGTH * 2))
        for i in 0 ..< digestLength {
            output.appendFormat("%02x", md5Buffer[i])
        }
        return String(output)
    }
    
    public var uint8: UInt8 {
        get {
            var number: UInt8 = 0
            base.copyBytes(to: &number, count: MemoryLayout<UInt8>.size)
            return number
        }
    }
    
    public var uint16: UInt16 {
        get {
            let i16array = base.withUnsafeBytes { $0.load(as: UInt16.self) }
            return i16array
        }
    }
    
    public var uint32: UInt32 {
        get {
            let i32array = base.withUnsafeBytes { $0.load(as: UInt32.self) }
            return i32array
        }
    }
    
    public var float: Float {
        get {
            let i32array = base.withUnsafeBytes { $0.load(as: Float.self) }
            return i32array
        }
    }
    
    public func readUInt8(index: Data.Index) -> UInt8? {
        var value: UInt8? = nil
        if index >= 0 && index < base.count {
            value = base[index]
        }
        return value
    }
    
    public func readInt8(index: Data.Index) -> Int8? {
        var value: Int8? = nil
        if index >= 0 && index < base.count {
            value = Int8(base[index])
        }
        return value
    }
    
    public func readUInt16(index: Data.Index) -> UInt16? {
        var value: UInt16? = nil
        if index >= 0 && index < base.count - 1 {
            value = Data(base[index..<index+2]).hm.uint16
        }
        return value
    }
    
    public func readUInt32(index: Data.Index) -> UInt32? {
        var value: UInt32? = nil
        if index >= 0 && index < base.count - 1 {
            value = Data(base[index ..< index+4]).hm.uint32
        }
        return value
    }
    
    public var stringUTF8: String? {
        get {
            return NSString(data: base, encoding: String.Encoding.utf8.rawValue) as String?
        }
    }
    
    public func readLittleEndianUInt32(index: Data.Index) -> UInt32? {
        var value: UInt32? = nil
        if index >= 0 && index < base.count - 1 {
            value = Data(base[index ..< index + 4]).hm.uint32.littleEndian
        }
        return value
    }

    
    public func readBigEndianUInt16(index: Data.Index) -> UInt16? {
        var value: UInt16? = nil
        if index >= 0 && index < base.count - 1 {
            value = Data(base[index ..< index + 2]).hm.uint16.bigEndian
        }
        return value
    }
    
    
    /// 获取某个cmd的index处往后length位Data  eg: 460100  cmd: 0x46 1bytes;  length: 0x01 1bytes
    /// - Parameter index: 当前响应指令的开始下标
    /// - Parameter cmdSize: 响应指令的size，默认1bytes
    /// - Parameter lengthSize: 响应指令的数据长度的size, 默认1bytes
    /// - Returns: index处往后cmdSize + lengthSize位的数据Data
    public func lenghtData(for index: Int, cmdSize: Int = 1, lengthSize: Int = 1) -> (value: Data, endIndex: Int)? {
        let lengthIndex = index + cmdSize
        let startIndex = index + cmdSize + lengthSize
        guard let length = self.readUInt8(index: lengthIndex) else { return nil }
        let endIndex = startIndex + Int(length)
        guard let value = self.subdata(in: startIndex  ..< endIndex) else { return nil }
        return (value, endIndex)
    }
    
    public func subdata(in range: Range<Data.Index>) -> Data? {
        if range.lowerBound >= 0 && range.upperBound <= base.count {
            return base.subdata(in: range)
        } else {
            return nil
        }
    }
    
    /// 十六进制String 大写
    public var stringRadix16: String {
        return base.map { String(format: "%02hhX", $0) }.joined(separator: "")
    }
}

extension HMPrefixableWrapper where Base == String {
    /// 十六进制Data
    public var dataRadix16: Data {
        var data = Data(capacity: base.count / 2)
        guard let regex = try? NSRegularExpression(pattern: "[0-9a-f]{1,2}", options: .caseInsensitive) else { return data }
        regex.enumerateMatches(in: base, range: NSRange(base.startIndex..., in: base)) { match, _, _ in
                guard let match = match else { return }
                let byteString = (base as NSString).substring(with: match.range)
                guard let num = UInt8(byteString, radix: 16) else { return }
                data.append(num)
        }
        return data
    }
}

public enum HMBit: UInt8, CustomStringConvertible {
    
    /// 0
    case zero = 0x00
    
    /// 1
    case one = 0x01
    
    public var description: String {
        switch self {
        case .zero:
            return "0"
        case .one:
            return "1"
        }
    }
}

extension UInt8: HMPrefixable { }
extension HMPrefixableWrapper where Base == UInt8 {
    public var data: Data {
        var int = base
        return Data(bytes: &int, count: MemoryLayout<UInt8>.size)
    }
    
    public func bits() -> [HMBit] {
        var byte = base
        var bits = [HMBit](repeating: .zero, count: 8)
        for i in 0 ..< 8 {
            let currentBit = byte & 0x01
            if currentBit != 0 {
                bits[i] = .one
            }
            byte >>= 1
        }
        return bits
    }
}

extension UInt16: HMPrefixable { }
extension HMPrefixableWrapper where Base == UInt16 {
    public var data: Data {
        var int = base
        return Data(bytes: &int, count: MemoryLayout<UInt16>.size)
    }
    
}

extension UInt32: HMPrefixable { }
extension HMPrefixableWrapper where Base == UInt32 {
    public var data: Data {
        var int = base
        return Data(bytes: &int, count: MemoryLayout<UInt32>.size)
    }
    
}

extension Int: HMPrefixable { }
extension HMPrefixableWrapper where Base == Int {
    public var data: Data {
        var int = base
        return Data(bytes: &int, count: MemoryLayout<Int>.size)
    }
}

extension Float: HMPrefixable { }
extension HMPrefixableWrapper where Base == Float {
    public var data: Data {
        var int = base
        return Data(bytes: &int, count: MemoryLayout<Float>.size)
    }
}
