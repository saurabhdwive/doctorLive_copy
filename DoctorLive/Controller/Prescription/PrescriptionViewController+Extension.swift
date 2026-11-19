//
//  PrescriptionViewController+Extension.swift
//  DoctorLive
//
//  Created by Kv on 06/11/24.
//

import Foundation
import UIKit

extension PrescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableHightConstraint.constant = CGFloat(arrayData.count * 160)
        return arrayData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PrescriptionTableViewCell", for: indexPath) as! PrescriptionTableViewCell
        cell.medicineName.text = arrayData[indexPath.row].name
        cell.pediatric.text = "Dosage: \(arrayData[indexPath.row].dosage)"
        cell.frequency.text = "Frequency: \(arrayData[indexPath.row].frequencyFirst)"
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(buttonEditTapped(sender:)), for: .touchUpInside)
        cell.duration.text = "Duration: \(arrayData[indexPath.row].duration)"
        cell.meal.text = "Instruction: \(arrayData[indexPath.row].meals)"
        cell.delegate = self
        return cell
    }
}
