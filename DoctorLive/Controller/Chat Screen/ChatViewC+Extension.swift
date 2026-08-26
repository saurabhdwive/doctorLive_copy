//
//  ChatViewC+Extension.swift
//  Dr.Live
//
//  Created by Kv on 23/12/24.
//

import Foundation
import AVKit
import UIKit
import SafariServices

extension ChatViewC: UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.groupByCategoryChat?[self.keys[section]]?.count ?? INTZERO
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ChatViewC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = self.chatTblVw.dequeueReusableHeaderFooterView(withIdentifier: ChatHeaderCell.className)as! ChatHeaderCell
        header.DateLbl.text = self.keys[section]
        GlobalMethods.shared.provideCornerRadius(view: header.DateLbl, cornerRadius: 8, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = self.groupByCategoryChat?[self.keys[indexPath.section]]?[indexPath.row]
        if chat?.recieverType == "sender"{
            if chat?.msgType == "text"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightTextCell.className)as! ChatRightTextCell
                cell.chatTxt.text = chat?.message ?? EMPTY
                cell.timeLbl.text = chat?.time ?? EMPTY
                cell.chatBtn.tag = indexPath.row
                
                let labelText = chat?.message ?? EMPTY
                // Detect and add links for phone numbers
                let attributedText = NSMutableAttributedString(string: chat?.message ?? EMPTY)
                let phoneNumberDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                
                if let phoneMatches = phoneNumberDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                    for match in phoneMatches {
                        if let range = Range(match.range, in: labelText) {
                            let phoneNumber = String(labelText[range])
                            attributedText.addAttribute(.link, value: "tel:\(phoneNumber)", range: match.range)
                        }
                    }
                }
                
                // Detect and add links for web URLs
                let urlDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                
                if let urlMatches = urlDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                    for match in urlMatches {
                        if let range = Range(match.range, in: labelText),
                           let url = match.url {
                            attributedText.addAttribute(.link, value: url, range: match.range)
                        }
                    }
                }
                
                cell.chatTxt.attributedText = attributedText
                cell.chatTxt.isUserInteractionEnabled = true
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
                longPress.minimumPressDuration = 0.5
                cell.chatBtn.addGestureRecognizer(longPress)
                return cell
            }else if chat?.msgType == "image"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightImageCell.className)as! ChatRightImageCell
                let mystring1 = chat?.message ?? EMPTY
                let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "my_profile"))
                cell.timeLbl.text = chat?.time ?? EMPTY
                cell.imageBtnTapped = {
                    let viewC = DIConfigurator.sharedInst().getImagePopPrieViewC()
                    viewC.imageUrl = chat?.message ?? EMPTY
                    self.navigationController?.pushViewController(viewC, animated: true)
                }
                return cell
            }else if chat?.msgType == "audio"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightAudioCell.className)as! ChatRightAudioCell
//                cell.configureAlignment(isSender: true)
//                cell.timeLbl.text = chat?.time ?? EMPTY
                
                if let urlString = chat?.message, let audioURL = URL(string: urlString) {
                    cell.configureAudio(url: audioURL)
                }
                
                return cell
            }else if chat?.msgType == "pdf"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatRightPdfCell") as! ChatRightPdfCell
                cell.timeLbl.text = chat?.time ?? EMPTY
                if let urlString = chat?.message, let url = URL(string: urlString) {
                    cell.fileNameLbl.text = url.lastPathComponent
                }
                cell.pdfBtnTapped = {
                    if let urlString = chat?.message, let url = URL(string: urlString) {
                        let safariVC = SFSafariViewController(url: url)
                        self.present(safariVC, animated: true, completion: nil)
                    }
                }
                return cell
            }else{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightImageCell.className)as! ChatRightImageCell
                let mystring1 = chat?.message ?? EMPTY
                let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "blurVideoIcon"))
                cell.timeLbl.text = chat?.time ?? EMPTY
                cell.imageBtnTapped = {
                    let videoURL = URL(string: chat?.message ?? EMPTY)
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.allowsPictureInPicturePlayback = false

                       if #available(iOS 14.2, *) {
                           playerViewController.canStartPictureInPictureAutomaticallyFromInline = false
                       }
                    self.navigationController?.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
                cell.imageBtn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                return cell
            }
        }else{
            if chat?.msgType == "text"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatLeftTextCell.className)as! ChatLeftTextCell
                cell.chatTxt.text = chat?.message ?? EMPTY
                cell.timeLbl.text = chat?.time ?? EMPTY
                cell.chatBtn.tag = indexPath.row
                
                let labelText = chat?.message ?? EMPTY
                
                // Detect and add links for phone numbers
                let attributedText = NSMutableAttributedString(string: chat?.message ?? EMPTY)
                let phoneNumberDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
                
                if let phoneMatches = phoneNumberDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                    for match in phoneMatches {
                        if let range = Range(match.range, in: labelText) {
                            let phoneNumber = String(labelText[range])
                            attributedText.addAttribute(.link, value: "tel:\(phoneNumber)", range: match.range)
                        }
                    }
                }
                
                // Detect and add links for web URLs
                let urlDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                
                if let urlMatches = urlDetector?.matches(in: labelText, options: [], range: NSRange(location: 0, length: labelText.utf16.count)) {
                    for match in urlMatches {
                        if let range = Range(match.range, in: labelText),
                           let url = match.url {
                            attributedText.addAttribute(.link, value: url, range: match.range)
                        }
                    }
                }
                cell.chatTxt.attributedText = attributedText
                cell.chatTxt.isUserInteractionEnabled = true
                let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPress(gesture:)))
                longPress.minimumPressDuration = 0.5
                cell.chatBtn.addGestureRecognizer(longPress)
                return cell
            }else if chat?.msgType == "image"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatLeftImageCell.className)as! ChatLeftImageCell
                let mystring1 = chat?.message ?? EMPTY
                let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "my_profile"))
                cell.timeLbl.text = chat?.time ?? EMPTY
                cell.imageBtnTapped = {
                    let viewC = DIConfigurator.sharedInst().getImagePopPrieViewC()
                    viewC.imageUrl = chat?.message ?? EMPTY
                    self.navigationController?.pushViewController(viewC, animated: true)
                }
                return cell
            }else if chat?.msgType == "audio"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatRightAudioCell.className)as! ChatRightAudioCell
                cell.configureAlignment(isSender: false)
                cell.timeLbl.text = chat?.time ?? EMPTY
                
                if let urlString = chat?.message, let audioURL = URL(string: urlString) {
                    cell.configureAudio(url: audioURL)
                }
                
                return cell
            }else if chat?.msgType == "pdf"{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: "ChatLeftPdfCell") as! ChatLeftPdfCell
                cell.timeLbl.text = chat?.time ?? EMPTY
                if let urlString = chat?.message, let url = URL(string: urlString) {
                    cell.fileNameLbl.text = url.lastPathComponent
                }
                cell.pdfBtnTapped = {
                    if let urlString = chat?.message, let url = URL(string: urlString) {
                        let safariVC = SFSafariViewController(url: url)
                        self.present(safariVC, animated: true, completion: nil)
                    }
                }
                return cell
            }else{
                let cell = self.chatTblVw.dequeueReusableCell(withIdentifier: ChatLeftImageCell.className)as! ChatLeftImageCell
                let mystring1 = chat?.message ?? EMPTY
                let urlNew1:String = mystring1.replacingOccurrences(of: " ", with: "%20")
                cell.chatImage.sd_setImage(with: URL(string: urlNew1), placeholderImage: UIImage(named: "blurVideoIcon"))
                cell.timeLbl.text = chat?.time ?? EMPTY
                cell.imageBtnTapped = {
                    let videoURL = URL(string: chat?.message ?? EMPTY)
                    let player = AVPlayer(url: videoURL!)
                    let playerViewController = AVPlayerViewController()
                    playerViewController.player = player
                    playerViewController.allowsPictureInPicturePlayback = false

                       if #available(iOS 14.2, *) {
                           playerViewController.canStartPictureInPictureAutomaticallyFromInline = false
                       }
                    self.navigationController?.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
                cell.imageBtn.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
                return cell
            }
        }
    }
}
