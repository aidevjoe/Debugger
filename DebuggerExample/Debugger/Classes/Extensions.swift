import Foundation
import UIKit

extension String {
    public func appendingPathComponent(_ path: String) -> String {
        return NSString(string: self).appendingPathComponent(path)
    }
    
    public func appendingPathExtension(_ ext: String) -> String? {
        return NSString(string: self).appendingPathExtension(ext)
    }
    
    public var deletingPathExtension: String {
        return NSString(string: self).deletingPathExtension
    }
    
    public var lastPathComponent: String {
        return NSString(string: self).lastPathComponent
    }
    
    public var deletingLastPathComponent: String {
        return NSString(string: self).deletingLastPathComponent
    }
}

extension FileManager {
    public class var document: String {
        get {
            return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        }
    }
    
    public class var debugger: String {
        get {
            return document.appendingPathComponent("debugger")
        }
    }
    
    public class var logger: String {
        get {
            return debugger.appendingPathComponent("Logs")
        }
    }
    
    @discardableResult public class func save(content: String, savePath: String) -> Error? {
        if FileManager.default.fileExists(atPath: savePath) {
            do {
                try FileManager.default.removeItem(atPath: savePath)
            } catch {
                return error
            }
        }
        do {
            try content.write(to: URL(fileURLWithPath: savePath), atomically: true, encoding: .utf8)
        } catch {
            return error
        }
        return nil
    }
    
    @discardableResult public class func create(at path: String) -> Error? {
        if (!FileManager.default.fileExists(atPath: path)) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                Logger.error("error:\(error)")
                return error
            }
        }
        return nil
    }
}

extension Date {
    
    public var YYYYMMDDDateString : String {
        let dateFormatter: DateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func isGreaterThanDate(_ dateToCompare: Date) -> Bool {
        return compare(dateToCompare) == ComparisonResult.orderedDescending
    }
    
    public func description(dateSeparator: String = "/", usFormat: Bool = false, nanosecond: Bool = false) -> String {
        var description: String
        
        let components = Calendar.autoupdatingCurrent.dateComponents([.year, .month, .day, .hour, .minute, .second, .nanosecond], from: self)
        let year = components.year ?? 0
        let month = components.month ?? 0
        let day = components.day ?? 0
        let hour = components.hour ?? 0
        let minute = components.minute ?? 0
        let second = components.second ?? 0
        let nanoseconds = components.second ?? 1
        
        if usFormat {
            description = String(format: "%04li%@%02li%@%02li %02li:%02li:%02li", year, dateSeparator, month, dateSeparator, day, hour, minute, second)
        } else {
            description = String(format: "%02li%@%02li%@%04li %02li:%02li:%02li", month, dateSeparator, day, dateSeparator, year, hour, minute, second)
        }
        
        if nanosecond {
            description += String(format: ":%03li", nanoseconds / 1000000)
        }
        return description
    }
}

extension UIImage {
    static func make(name: String) -> UIImage? {
        let bundle = Bundle(for: DebuggerView.self)
        let path = bundle.resourcePath?.appendingPathComponent(name + ".png")
        return UIImage(contentsOfFile: path!)
    }
}

extension String {
    func appendToFile(filePath: String) {
        let contentToAppend = self
        
        if let fileHandle = FileHandle(forWritingAtPath: filePath) {
            /* Append to file */
            fileHandle.seekToEndOfFile()
            fileHandle.write(contentToAppend.data(using: String.Encoding.utf8)!)
        } else {
            /* Create new file */
            do {
                try contentToAppend.write(toFile: filePath, atomically: true, encoding: .utf8)
            } catch {
                Logger.error("Error creating \(filePath)")
            }
        }
    }
}
