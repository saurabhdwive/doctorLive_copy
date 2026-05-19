//
//  CustomTable.swift
//  Healthcare
//
//  Created by mobulous on 27/04/21.
//
import UIKit
import Foundation
class SelfSizedTableView: UITableView {
  var maxHeight: CGFloat = UIScreen.main.bounds.size.height
  override func reloadData() {
    super.reloadData()
    self.invalidateIntrinsicContentSize()
    self.layoutIfNeeded()
  }
  
  override var intrinsicContentSize: CGSize {
    setNeedsLayout()
    layoutIfNeeded()
    let height = min(contentSize.height, maxHeight)
    return CGSize(width: contentSize.width, height: height)
  }
}
