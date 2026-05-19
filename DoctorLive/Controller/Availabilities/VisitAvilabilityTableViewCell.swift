//
//  VisitAvilabilityTableViewCell.swift
//  DoctorLive
//
//  Created by call soft on 30/09/21.
//

import UIKit
import PromiseKit

class VisitAvilabilityTableViewCell: UITableViewCell {
    var parent1 = DayAvilabilityVC()
    @IBOutlet weak var contentsView: UIView!
    @IBOutlet weak var visitView: UIView!{
        didSet{
            visitView.dropShadow(scale: true)
            visitView.layer.cornerRadius = 11
        }
    }
    @IBOutlet weak var mainView: UIView! {
        didSet{
            mainView.layer.cornerRadius = 11
            mainView.layer.masksToBounds = true
            mainView.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMinXMinYCorner]
        }
    }
    @IBOutlet weak var btnview: UIView!{
        didSet{
            btnview.layer.cornerRadius = 11
            btnview.layer.masksToBounds = true
            btnview.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMaxXMaxYCorner]
        }
    }
    
    @IBOutlet weak var dayName: UILabel!
    @IBOutlet weak var setVisibilityTxt: UILabel!
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var tableHeight: NSLayoutConstraint!
    @IBOutlet weak var visitTableBtn: UIButton!
    var slotType = String()
    
    var fetchData: [Slots]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setVisibilityTxt.isHidden = true
        
    }
    
    func setupTableView() {
        tableView.register(UINib(nibName: "MultipleVisitTableViewCell", bundle: nil), forCellReuseIdentifier: "MultipleVisitTableViewCell")
        tableView.register(UINib(nibName: "CallSlotsTableViewCell", bundle: nil), forCellReuseIdentifier: "CallSlotsTableViewCell")
        
        if slotType == "Call" {
            if fetchData?.first?.slots?.count == 1{
                tableHeight.constant = CGFloat(60 * (fetchData?.first?.slots?.count ?? 1))
            }else{
                tableHeight.constant = CGFloat(40 * (fetchData?.first?.slots?.count ?? 1))
            }
        } else {
            tableHeight.constant = CGFloat(80 * (fetchData?.first?.slots?.count ?? 1))
        }
        
        self.tableView.reloadData()
        
    }
}

extension VisitAvilabilityTableViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchData?.first?.slots?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if slotType == "Call" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CallSlotsTableViewCell", for: indexPath) as! CallSlotsTableViewCell
            let status = fetchData?.first?.slots?[indexPath.row].status ?? ""
            if status == "0" {
                cell.slotTime.text = "Not Available"
            } else {
                cell.slotTime.text = String(fetchData?.first?.slots?[indexPath.row].from ?? "") + "  to  " + String(fetchData?.first?.slots?[indexPath.row].to ?? "")
            }
            cell.slotNum.text = "Slot \(fetchData?.first?.slots?[indexPath.row].slotNum ?? "")"
            
            return cell
        } else {
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "MultipleVisitTableViewCell", for: indexPath) as! MultipleVisitTableViewCell
            let status = fetchData?.first?.slots?[indexPath.row].status ?? ""
            if status == "0" {
                cell1.slotTxt.text = "Not Available"
            } else {
                cell1.slotTxt.text = String(fetchData?.first?.slots?[indexPath.row].from ?? "") + "  to  " + String(fetchData?.first?.slots?[indexPath.row].to ?? "")
            }
            cell1.slotLbl.text = "Slot \(fetchData?.first?.slots?[indexPath.row].slotNum ?? "")"
            cell1.clinicName.text = fetchData?.first?.slots?[indexPath.row].clinic ?? ""
            
            return cell1
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if slotType == "Call" {
            if fetchData?.first?.slots?.count == 1 {
                return 60
            } else {
                return 40
            }
            
        } else {
            return 80
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if slotType == "Call" {
            if fetchData?.first?.slots?.count == 1 {
                return 60
            } else {
                return 40
            }
        } else {
            return 80
        }
    }
}

