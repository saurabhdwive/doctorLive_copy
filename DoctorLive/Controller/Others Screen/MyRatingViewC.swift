//
//  MyRatingViewC.swift
//  DoctorLive
//
//  Created by Kv on 14/11/24.
//

import UIKit

class MyRatingViewC: ParentViewController {

    @IBOutlet weak var ratingTblVw: UITableView!{
        didSet{
            self.ratingTblVw.delegate = self
            self.ratingTblVw.dataSource = self
        }
    }
    
    var viewmodel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpViews()
        self.registerXib()
        self.myRatingListApi()
    }
    
    private func setUpViews(){
        self.navigationController?.isNavigationBarHidden = false
        self.setupNavigationBarTitle("My Rating", leftBarButtonsType: [.back], rightBarButtonsType: [])
    }
    
    private func registerXib(){
        self.ratingTblVw.register(UINib(nibName: MyRatingCell.className, bundle: nil), forCellReuseIdentifier: MyRatingCell.className)
    }
    
}
