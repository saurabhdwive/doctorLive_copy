//
//  ImagePicker.swift
//  Helper Class
//
//  Created by Krishanvir on 29/03/22.
//

import Foundation
import UIKit
import MobileCoreServices
import AVKit
import UniformTypeIdentifiers
import PhotosUI

class ImagePickerManagerSwift: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var picker = UIImagePickerController();
    var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage) -> ())?;
    var closeGallery: Bool = true
    
    override init(){
        super.init()
       
    }
    
    func initFunction(){
        let cameraAction = UIAlertAction(title: "Camera", style: .default){
            UIAlertAction in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery", style: .default){
            UIAlertAction in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
            UIAlertAction in
        }

        // Add the actions
        picker.delegate = self
        self.picker.allowsEditing = true
        alert.addAction(cameraAction)
        if self.closeGallery {
            alert.addAction(galleryAction)
        }
        alert.addAction(cancelAction)
    }
    
    func pickImageFromCamera(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.closeGallery = false
        self.viewController = viewController
        self.initFunction()
        alert.popoverPresentationController?.sourceView = self.viewController!.view
        viewController.present(alert, animated: true, completion: nil)
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback;
        self.viewController = viewController;
        self.initFunction()
        alert.popoverPresentationController?.sourceView = self.viewController!.view

        viewController.present(alert, animated: true, completion: nil)
    }
    func openCamera(){
        alert.dismiss(animated: true, completion: nil)
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.allowsEditing = true
            picker.sourceType = .camera
            self.viewController!.present(picker, animated: true, completion: nil)
        } else {
            let alertController: UIAlertController = {
                let controller = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default)
                controller.addAction(action)
                return controller
            }()
            viewController?.present(alertController, animated: true)
        }
    }
    func openGallery(){
        alert.dismiss(animated: true, completion: nil)
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.viewController!.present(picker, animated: true, completion: nil)
    }

    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
   
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

      picker.dismiss(animated: true, completion: nil)
//        guard let image = info[.originalImage] as? UIImage else {
//            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
//        }
//       print(image)
       var image : UIImage!

       if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
               {
                   image = img

               }
       else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
               {
                   image = img
               }
   
        pickImageCallback?(image)
    }
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//
//        if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//            image1 = img
//            self.addImageOnServer()
//            self.pickerController?.dismiss(animated: true, completion: nil)
//
//            //self.dismiss(animated: true, completion: nil)
//        } else if (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) != nil {
//
//        }
//    }
    @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
    }

}

struct ProgressDialogSwift {
    static var alert = UIAlertController()
    static var progressView = UIProgressView()
    static var progressPoint : Float = 0{
        didSet{
            if(progressPoint == 1){
                ProgressDialogSwift.alert.dismiss(animated: true, completion: nil)
            }
        }
    }
}
extension UIViewController{
   func LoadingStartSwift(){
       ProgressDialogSwift.alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
    
    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.gray
    loadingIndicator.startAnimating();

       ProgressDialogSwift.alert.view.addSubview(loadingIndicator)
    present(ProgressDialogSwift.alert, animated: true, completion: nil)
  }

  func LoadingStopSwift(){
      ProgressDialogSwift.alert.dismiss(animated: true, completion: nil)
  }
}

class VideoPickerManagerSwift: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate, PHPickerViewControllerDelegate {
    var picker = UIImagePickerController()
    var viewController: UIViewController?
    var pickImageCallback : ((UIImage, URL) -> ())?
    var pickMultipleImagesCallback: (([UIImage]) -> ())?
    let alert: UIAlertController = UIAlertController(title: "Choose Option", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
    static var currentPicker: VideoPickerManagerSwift?
    
    override init(){
        
    }
    
    func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage, URL) -> ()), multiImageCallback: (([UIImage]) -> ())? = nil) {
        VideoPickerManagerSwift.currentPicker = self
        self.pickImageCallback = callback
        self.pickMultipleImagesCallback = multiImageCallback
        self.viewController = viewController
        self.openAttachmentSheet()
        alert.popoverPresentationController?.sourceView = self.viewController!.view
    }
    
    func pickMultipleImages(from viewController: UIViewController, maxSelection: Int = 5, completion: @escaping ([UIImage]) -> Void) {
        VideoPickerManagerSwift.currentPicker = self
        self.viewController = viewController
        self.pickMultipleImagesCallback = completion
        
        if #available(iOS 14.0, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = maxSelection
            config.filter = .images
            let phPicker = PHPickerViewController(configuration: config)
            phPicker.delegate = self
            viewController.present(phPicker, animated: true, completion: nil)
        } else {
            picker.sourceType = .photoLibrary
            picker.delegate = self
            viewController.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        var image : UIImage? = nil
        var media: URL?
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            image = img
        }else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            image = img
        }else if let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            media = mediaURL
        }
        if let img = image, let multiCallback = self.pickMultipleImagesCallback {
            multiCallback([img])
        } else {
            pickImageCallback?(image ?? UIImage(), media ?? URL(fileURLWithPath: EMPTY))
        }
        VideoPickerManagerSwift.currentPicker = nil
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        VideoPickerManagerSwift.currentPicker = nil
    }
    
    func openAttachmentSheet()
    {
        
        let cameraAction = UIAlertAction(title:  "Upload Photo", style: UIAlertAction.Style.default){ UIAlertAction in
            self.openPhoto()
        }
        let vedioAction = UIAlertAction(title: "Upload video", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openVedio()
        }
        let documentAction = UIAlertAction(title: "Upload Document", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openDocument()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(vedioAction)
        alert.addAction(documentAction)
        alert.addAction(cancelAction)
        
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    func openPhoto() {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image" , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title:  "Camera", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openCamera()
        }
        let GalleryAction = UIAlertAction(title:  "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openPhotoGallery()
            
        }
        let cancelAction = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(GalleryAction)
        alert.addAction(cancelAction)
        
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func openVedio() {
        
        let alert:UIAlertController=UIAlertController(title: "Choose video" , message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let cameraAction = UIAlertAction(title:  "Recorder", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.recordVideo()
        }
        let GalleryAction = UIAlertAction(title:  "Gallery", style: UIAlertAction.Style.default){
            UIAlertAction in
            self.openVideoGalllery()
        }
        let cancelAction = UIAlertAction(title: "Cancel" , style: UIAlertAction.Style.cancel){
            UIAlertAction in
        }
        picker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(GalleryAction)
        alert.addAction(cancelAction)
        
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            picker.sourceType = UIImagePickerController.SourceType.camera
            
            viewController?.present(picker, animated: true, completion: nil)
            
        }else {
            
            let alert = UIAlertController(title: "camera", message:  "You don't have camera", preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title:  "OK" , style: UIAlertAction.Style.default, handler: nil))
            
            viewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func openPhotoGallery() {
        if #available(iOS 14.0, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            // Allow up to 5 photos if multi-image callback is present, otherwise 1
            config.selectionLimit = (self.pickMultipleImagesCallback != nil) ? 5 : 1
            config.filter = .images
            let phPicker = PHPickerViewController(configuration: config)
            phPicker.delegate = self
            viewController?.present(phPicker, animated: true, completion: nil)
        } else {
            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
            viewController?.present(picker, animated: true, completion: nil)
        }
    }
    
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        guard !results.isEmpty else {
            VideoPickerManagerSwift.currentPicker = nil
            return
        }
        
        let limit = self.pickMultipleImagesCallback != nil ? 5 : 1
        let resultsToLoad = Array(results.prefix(limit))
        let group = DispatchGroup()
        let serialQueue = DispatchQueue(label: "com.drlive.imagepicker")
        var orderedImages = [Int: UIImage]()
        
        for (index, result) in resultsToLoad.enumerated() {
            if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (object, error) in
                    if let image = object as? UIImage {
                        serialQueue.sync {
                            orderedImages[index] = image
                        }
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            var loadedImages: [UIImage] = []
            for i in 0..<resultsToLoad.count {
                if let img = orderedImages[i] {
                    loadedImages.append(img)
                    if loadedImages.count >= limit {
                        break
                    }
                }
            }
            if !loadedImages.isEmpty {
                if let multiCallback = self.pickMultipleImagesCallback {
                    multiCallback(loadedImages)
                } else if let firstImg = loadedImages.first {
                    self.pickImageCallback?(firstImg, URL(fileURLWithPath: EMPTY))
                }
            }
            VideoPickerManagerSwift.currentPicker = nil
        }
    }
    
    func openVideoGalllery(){
        
        let  picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .savedPhotosAlbum
        picker.mediaTypes = [kUTTypeMovie as String]
        picker.allowsEditing = false
        viewController?.present(picker, animated: true, completion: nil)
    }
    
    func recordVideo(){
        
        let imag = UIImagePickerController()
        imag.delegate = self
        imag.sourceType = UIImagePickerController.SourceType.camera;
        imag.cameraDevice = UIImagePickerController.CameraDevice.rear //or Front
        imag.mediaTypes = [kUTTypeMovie as String]
        viewController?.present(imag, animated: true, completion: nil)
    }
    
    
    func createVideoThumbnail(from url: URL) -> UIImage? {
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: 100 , height: 100)
        
        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        }
        catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func generateThumbnailForVideo(at videoURL: URL) -> UIImage {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        let time = CMTime(seconds: 0.0, preferredTimescale: 1)
        var thumbnailImage: UIImage?
        
        do {
            let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
            thumbnailImage = UIImage(cgImage: cgImage)
        } catch {
            print("Failed to generate thumbnail image: \(error.localizedDescription)")
        }
        // Use the thumbnailImage here
        if let thumbnailImage = thumbnailImage {
            return thumbnailImage
        }
        return UIImage()
    }
    
    func openDocument() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        viewController?.present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        pickImageCallback?(UIImage(), url)
    }
}
