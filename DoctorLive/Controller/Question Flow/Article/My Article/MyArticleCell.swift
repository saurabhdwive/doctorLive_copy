//
//  MyArticleCell.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import UIKit

class MyArticleCell: UITableViewCell {

    @IBOutlet weak var articleTitleLbl, descriptionLbl, experienceLbl, specialityNameLbl, doctorNameLbl: UILabel!
    @IBOutlet weak var deleteBtn, editBtn: UIButton!
    @IBOutlet weak var doctorImage: UIImageView!
    @IBOutlet weak var myArticleCollectionVw: UICollectionView!{
        didSet{
            self.myArticleCollectionVw.delegate = self
            self.myArticleCollectionVw.dataSource = self
        }
    }

    var photoUri: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpViews()
        self.registerXib()
    }
    
    private func setUpViews(){
        GlobalMethods.shared.provideCornerRadius(view: self.doctorImage, cornerRadius: 4, borderColor: UIColor.clear.cgColor, borderWidth: 0)
    }
    
    private func registerXib(){
        self.myArticleCollectionVw.register(UINib(nibName: PhotoCell.className, bundle: nil), forCellWithReuseIdentifier: PhotoCell.className)
    }
    
}

extension MyArticleCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photoUri?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
}

extension MyArticleCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.myArticleCollectionVw.dequeueReusableCell(withReuseIdentifier: PhotoCell.className, for: indexPath)as! PhotoCell
        let mystring = self.photoUri?[indexPath.row] ?? EMPTY
        let urlNew:String = mystring.replacingOccurrences(of: " ", with: "%20")
        cell.photoImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(systemName: "person.fill"))
        return cell
    }
}
