//
//  WriteArticleViewC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import Foundation
import UIKit

extension WriteArticleViewC: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (self.photoUri.count + 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
}

extension WriteArticleViewC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.articleCollectionVw.dequeueReusableCell(withReuseIdentifier: WriteArticleCell.className, for: indexPath)as! WriteArticleCell
        if indexPath.row == self.photoUri.count {
            cell.writeArticleImage.isHidden = true
            cell.crossBtn.isHidden = true
            cell.uploadBtn.isHidden = false
            cell.uploadBtn.tag = indexPath.row
            cell.uploadBtn.addTarget(self, action: #selector(uploadBtnTap), for: .touchUpInside)
        }else{
            let mystring = self.photoUri[indexPath.row]
            let urlNew:String = mystring.replacingOccurrences(of: " ", with: "%20")
            cell.writeArticleImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(systemName: "person.fill"))
            cell.writeArticleImage.isHidden = false
            cell.crossBtn.isHidden = false
            cell.uploadBtn.isHidden = true
            cell.crossBtn.tag = indexPath.row
            cell.crossBtn.addTarget(self, action: #selector(crossBtnTap), for: .touchUpInside)
        }
        return cell
    }
}
