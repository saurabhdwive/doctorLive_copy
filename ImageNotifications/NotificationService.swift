//
//  NotificationService.swift
//  ImageNotifications
//
//  Created by apple on 07/06/22.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {
    
    private var contentHandler: ((UNNotificationContent) -> Void)?
    private var bestAttemptContent: UNMutableNotificationContent?
     override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {

            print("NotificationService: dide receive called")
            self.contentHandler = contentHandler
            bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

            if let bestAttemptContent = bestAttemptContent {
                if let urlString = bestAttemptContent.userInfo["image"] as? String,
                    let data = NSData(contentsOf: URL(string:urlString)!) as Data? {
                    let path = NSTemporaryDirectory() + "attachment"
                    _ = FileManager.default.createFile(atPath: path, contents: data, attributes: nil)

                    do {
                        let file = URL(fileURLWithPath: path)
                        let attachment = try UNNotificationAttachment(identifier: "attachment", url: file,options:[UNNotificationAttachmentOptionsTypeHintKey : "public.jpeg"])
                        bestAttemptContent.attachments = [attachment]

                    } catch {
                        print(error)

                    }
                }

                contentHandler(bestAttemptContent)
            }
    }
    override func serviceExtensionTimeWillExpire() {
        print("service time Expire")
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
}
extension UNNotificationAttachment {
    
    /// Save the image to disk
    static func create(imageFileIdentifier: String, data: NSData, options: [NSObject : AnyObject]?)
        -> UNNotificationAttachment? {
            
            let fileManager = FileManager.default
            let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
            let fileURLPath      = NSURL(fileURLWithPath: NSTemporaryDirectory())
            let tmpSubFolderURL  = fileURLPath.appendingPathComponent(tmpSubFolderName, isDirectory: true)
            
            do {
                try fileManager.createDirectory(at: tmpSubFolderURL!,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
                let fileURL = tmpSubFolderURL?.appendingPathComponent(imageFileIdentifier)
                try data.write(to: fileURL!, options: [])
                let imageAttachment = try UNNotificationAttachment.init(identifier: imageFileIdentifier,
                                                                        url: fileURL!,
                                                                        options: options)
                return imageAttachment
            } catch let error {
                print("error \(error)")
            }
            
        return nil
    }
}
extension UNNotificationRequest {
    var attachment: UNNotificationAttachment? {
        guard let attachmentURL = content.userInfo["image"] as? String, let imageData = try? Data(contentsOf: URL(string: attachmentURL)!) else {
            return nil
        }
        return try? UNNotificationAttachment(data: imageData, options: nil)
    }
}

extension UNNotificationAttachment {

    convenience init(data: Data, options: [NSObject: AnyObject]?) throws {
        let fileManager = FileManager.default
        let temporaryFolderName = ProcessInfo.processInfo.globallyUniqueString
        let temporaryFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(temporaryFolderName, isDirectory: true)

        try fileManager.createDirectory(at: temporaryFolderURL, withIntermediateDirectories: true, attributes: nil)
        let imageFileIdentifier = UUID().uuidString + ".png"
        let fileURL = temporaryFolderURL.appendingPathComponent(imageFileIdentifier)
        try data.write(to: fileURL)
        try self.init(identifier: imageFileIdentifier, url: fileURL, options: options)
    }
}
