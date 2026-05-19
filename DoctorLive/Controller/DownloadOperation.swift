//
//  DownloadOperation.swift
//  Healthcare
//
//  Created by mobulous on 13/07/21.
//

import Foundation
import UIKit

class AsynchronousOperation: Operation {
    
    /// State for this operation.
    let imageSaver = ImageSaver()
    @objc private enum OperationState: Int {
        case ready
        case executing
        case finished
    }
    
    /// Concurrent queue for synchronizing access to `state`.
    
    private let stateQueue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".rw.state", attributes: .concurrent)
    
    /// Private backing stored property for `state`.
    
    private var rawState: OperationState = .ready
    
    /// The state of the operation
    
    @objc private dynamic var state: OperationState {
        get { return stateQueue.sync { rawState } }
        set { stateQueue.sync(flags: .barrier) { rawState = newValue } }
    }
    
    // MARK: - Various `Operation` properties
    
    open         override var isReady:        Bool { return state == .ready && super.isReady }
    public final override var isExecuting:    Bool { return state == .executing }
    public final override var isFinished:     Bool { return state == .finished }
    
    // KVO for dependent properties
    
    open override class func keyPathsForValuesAffectingValue(forKey key: String) -> Set<String> {
        if ["isReady", "isFinished", "isExecuting"].contains(key) {
            return [#keyPath(state)]
        }
        
        return super.keyPathsForValuesAffectingValue(forKey: key)
    }
    
    // Start
    
    public final override func start() {
        if isCancelled {
            finish()
            return
        }
        
        state = .executing
        
        main()
    }
    
    /// Subclasses must implement this to perform their work and they must not call `super`. The default implementation of this function throws an exception.
    
    open override func main() {
        fatalError("Subclasses must implement `main`.")
    }
    
    /// Call this function to finish an operation that is currently executing
    
    public final func finish() {
        if !isFinished { state = .finished }
    }
}

class DownloadManager: NSObject {
    
    /// Dictionary of operations, keyed by the `taskIdentifier` of the `URLSessionTask`
    
    fileprivate var operations = [Int: DownloadOperation]()
    
    /// Serial OperationQueue for downloads
    
    private let queue: OperationQueue = {
        let _queue = OperationQueue()
        _queue.name = "download"
        _queue.maxConcurrentOperationCount = 1    // I'd usually use values like 3 or 4 for performance reasons, but OP asked about downloading one at a time
        
        return _queue
    }()
    
    /// Delegate-based `URLSession` for DownloadManager
    
    lazy var session: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    /// Add download
    ///
    /// - parameter URL:  The URL of the file to be downloaded
    ///
    /// - returns:        The DownloadOperation of the operation that was queued
    
    @discardableResult
    func queueDownload(_ url: URL) -> DownloadOperation {
        let operation = DownloadOperation(session: session, url: url)
        operations[operation.task.taskIdentifier] = operation
        queue.addOperation(operation)
        return operation
    }
    
    /// Cancel all queued operations
    
    func cancelAll() {
        queue.cancelAllOperations()
    }
    
}

// MARK: URLSessionDownloadDelegate methods

extension DownloadManager: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        operations[downloadTask.taskIdentifier]?.urlSession(session, downloadTask: downloadTask, didFinishDownloadingTo: location)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        operations[downloadTask.taskIdentifier]?.urlSession(session, downloadTask: downloadTask, didWriteData: bytesWritten, totalBytesWritten: totalBytesWritten, totalBytesExpectedToWrite: totalBytesExpectedToWrite)
    }
}

// MARK: URLSessionTaskDelegate methods

extension DownloadManager: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)  {
        let key = task.taskIdentifier
        operations[key]?.urlSession(session, task: task, didCompleteWithError: error)
        operations.removeValue(forKey: key)
    }
    
}

/// Asynchronous Operation subclass for downloading

class DownloadOperation : AsynchronousOperation {
    let task: URLSessionTask
    
    init(session: URLSession, url: URL) {
        task = session.downloadTask(with: url)
        super.init()
    }
    
    override func cancel() {
        task.cancel()
        super.cancel()
    }
    
    override func main() {
        task.resume()
    }
}

// MARK: NSURLSessionDownloadDelegate methods

extension DownloadOperation: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard
            let httpResponse = downloadTask.response as? HTTPURLResponse,
            200..<300 ~= httpResponse.statusCode
        else {
            // handle invalid return codes however you'd like
            return
        }

        do {
            let manager = FileManager.default
            let destinationURL = try manager
                .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(downloadTask.originalRequest!.url!.lastPathComponent)
            
            try? manager.removeItem(at: destinationURL)
            if MyHelper.checkForImage(pathExtension: destinationURL.pathExtension){
                DispatchQueue.main.async {
                   if let urlData = NSData(contentsOf: location){
                        if let image = UIImage(data: urlData as Data){
                            self.imageSaver.writeToPhotoAlbum(image: image)
                        }
                        
                    }
                   
                }
            }else{
//                 let docData = location.dataRepresentation
                if let pdfData = try? Data.init(contentsOf: location){
                    savePdf(pdfData: pdfData, pathExtension: destinationURL.pathExtension,destinationUrl: destinationURL)
                }
                
                    
                
            }
           // try manager.moveItem(at: location, to: destinationURL)
            try manager.copyItem(at: location, to: destinationURL)
            
        } catch {
            print(error)
        }
    }
    
    func savePdf(pdfData: Data, pathExtension:String, destinationUrl:URL) {
        DispatchQueue.main.async {
          //  let resourceDocPath = destinationUrl
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
           // let pdfNameFromUrl = "healthcare-\(urlString).\(pathExtension)"
            
            let pdfNameFromUrl = "healthcare-\(destinationUrl.lastPathComponent).\(pathExtension)"
            let actualPath = resourceDocPath.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
            }
        }
    }
    

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
       // Loader.showWithMessage(percentage: progress)
       // print("\(downloadTask.originalRequest!.url!.absoluteString) \(progress)")
    }
}

// MARK: URLSessionTaskDelegate methods

extension DownloadOperation: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?)  {
        defer { finish() }
        
        if let error = error {
            print(error)
            return
        }
        
        // do whatever you want upon success
    }
}
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
    }

    @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
    }
}
class MyHelper {
    
static func checkForImage(pathExtension:String)->Bool{
       if "jpeg" == pathExtension.lowercased() || "png" == pathExtension.lowercased() ||
           "jpg" == pathExtension.lowercased(){
           return true
       }else{
           return false
       }
   
   }
   
    static func checkForPDF(pathExtension:String)->Bool{
       if "pdf" == pathExtension.lowercased() {
           return true
       }else{
           return false
       }
   
   }
   
    static func checkForDocument(pathExtension:String)->Bool{
       if "pdf" == pathExtension.lowercased() {
           return true
       }else{
           return false
       }
   
   }
}
