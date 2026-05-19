//
//  PhotoCell.swift
//  DoctorLive
//
//  Created by Kv on 26/09/24.
//

import UIKit

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var photoImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        GlobalMethods.shared.provideCornerRadius(view: self.photoImage, cornerRadius: 4, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }

}
