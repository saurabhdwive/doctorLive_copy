//
//  MyRatingViewC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 14/11/24.
//

import Foundation
import UIKit

extension MyRatingViewC: UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewmodel.myRatingListData.first?.rating?.count ?? INTZERO
    }
}

extension MyRatingViewC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.ratingTblVw.dequeueReusableCell(withIdentifier: MyRatingCell.className)as! MyRatingCell
        let rating = self.viewmodel.myRatingListData.first?.rating?[indexPath.row]
        cell.patientNameLbl.text = rating?.userName ?? EMPTY
        cell.descriptionLbl.text = rating?.comment ?? EMPTY
        cell.dateLbl.text = String((rating?.createdDate ?? EMPTY).dropLast(3))
        
        cell.firstStarImg.tintColor = UIColor.lightGray
        cell.secondStarImg.tintColor = UIColor.lightGray
        cell.thirdStarImg.tintColor = UIColor.lightGray
        cell.fourthStarImg.tintColor = UIColor.lightGray
        cell.fivthStarImg.tintColor = UIColor.lightGray
        
        let ratingCount = Int(ceil(Double(rating?.rating ?? "0.0") ?? 0.0))
        switch ratingCount{
        case 0:
            print("huihui")
        case 1:
            cell.firstStarImg.tintColor = UIColor.systemYellow
        case 2:
            cell.firstStarImg.tintColor = UIColor.systemYellow
            cell.secondStarImg.tintColor = UIColor.systemYellow
        case 3:
            cell.firstStarImg.tintColor = UIColor.systemYellow
            cell.secondStarImg.tintColor = UIColor.systemYellow
            cell.thirdStarImg.tintColor = UIColor.systemYellow
        case 4:
            cell.firstStarImg.tintColor = UIColor.systemYellow
            cell.secondStarImg.tintColor = UIColor.systemYellow
            cell.thirdStarImg.tintColor = UIColor.systemYellow
            cell.fourthStarImg.tintColor = UIColor.systemYellow
        default:
            cell.firstStarImg.tintColor = UIColor.systemYellow
            cell.secondStarImg.tintColor = UIColor.systemYellow
            cell.thirdStarImg.tintColor = UIColor.systemYellow
            cell.fourthStarImg.tintColor = UIColor.systemYellow
            cell.fivthStarImg.tintColor = UIColor.systemYellow
        }
        return cell
    }
}
