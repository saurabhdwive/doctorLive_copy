//
//  ImagePopPrieViewC.swift
//  Dr.Live
//
//  Created by Apple on 31/08/22.
//

import UIKit

class ImagePopPrieViewC: UIViewController {

    @IBOutlet weak var imaegShow: UIImageView!
    var imageUrl : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imaegShow.sd_setImage(with: URL(string: imageUrl ?? ""),placeholderImage: UIImage(named: "user_dummy"))
    }
    
    @IBAction func backBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func downloadImageBtn_Action(_ sender: Any) {
        self.saveImageToDisk(from: URL(string: self.imageUrl ?? EMPTY)!)
    }
}

extension ImagePopPrieViewC{
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download Image"
        content.body = "Image has been downloaded"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 2, repeats: false)

        let request = UNNotificationRequest(identifier: "reminderNotification", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    func saveImageToDisk(from url: URL) {
        print("Download Started")
        self.showToast(message: "Download started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async {
                self.showToast(message: "Image has been downloaded")
                if let image = UIImage(data: data) {
                    self.scheduleNotification()
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
