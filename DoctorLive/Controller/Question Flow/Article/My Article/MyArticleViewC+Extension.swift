//
//  MyArticleViewC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 18/09/24.
//

import Foundation
import UIKit

extension MyArticleViewC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.dataList.count - 1 && !isFetching && !isLastPage {
            self.currentPage += 1
            self.myArticleApi()
        }
    }
}

extension MyArticleViewC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.articleTblVw.dequeueReusableCell(withIdentifier: MyArticleCell.className)as! MyArticleCell
        let myArticle = self.dataList[indexPath.row]
        cell.doctorNameLbl.text = myArticle.doctorName ?? EMPTY
        cell.specialityNameLbl.text = myArticle.doctorSpecialty ?? EMPTY
        cell.experienceLbl.text = "Experience: \(myArticle.doctorYear ?? EMPTY) Year"
        cell.articleTitleLbl.text = myArticle.title ?? EMPTY
        cell.descriptionLbl.text = myArticle.description ?? EMPTY
        let mystring = myArticle.doctorImage ?? EMPTY
        let urlNew:String = mystring.replacingOccurrences(of: " ", with: "%20")
        cell.doctorImage.sd_setImage(with: URL(string: urlNew), placeholderImage: UIImage(systemName: "person.fill"))
        cell.photoUri = myArticle.articleImagePaths ?? [EMPTY]
        cell.myArticleCollectionVw.reloadData()
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnTap), for: .touchUpInside)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTap), for: .touchUpInside)
        return cell
    }
}
