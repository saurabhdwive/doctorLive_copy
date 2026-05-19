//
//  WriteArticleCell.swift
//  DoctorLive
//
//  Created by Kv on 21/10/24.
//

import UIKit

class WriteArticleCell: UICollectionViewCell {

    @IBOutlet weak var crossBtn, uploadBtn: UIButton!
    @IBOutlet weak var writeArticleImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.writeArticleImage, cornerRadius: 4, borderColor: UIColor.clear.cgColor, borderWidth: 0)
        GlobalMethods.shared.provideCornerRadius(view: self.uploadBtn, cornerRadius: 4, borderColor: UIColor.lightGray.cgColor, borderWidth: 0.5)
    }

}
