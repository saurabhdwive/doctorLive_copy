//
//  FeesDetailViewC+Extension.swift
//  DoctorLive
//
//  Created by Kv on 16/09/24.
//

import Foundation
import UIKit

extension FeesDetailViewC{
    func setUpFeesDetailData(){
        self.videoPriceLbl.text = "৳\(self.feesDetailData?.callPrice ?? EMPTY)"
        self.followUpPriceLbl.text = "৳\(self.feesDetailData?.followUpPrice ?? EMPTY)"
        self.patientFeeTxt.text = self.feesDetailData?.callPrice ?? EMPTY
        self.followUpPatientFeesTxt.text = self.feesDetailData?.followUpPrice ?? EMPTY
        let callPercentage = Float(self.feesDetailData?.callPercentage ?? EMPTY) ?? Float(0)
        let followUpPercentage = Float(self.feesDetailData?.followUpPercentage ?? EMPTY) ?? Float(0)
        if callPercentage == Float(0){
            self.vatFeeTxt.text = self.feesDetailData?.callPrice ?? EMPTY
        }else{
            let videoPrice = Float(self.feesDetailData?.callPrice ?? EMPTY) ?? Float(0)
            let finalPrice = (videoPrice * callPercentage) / 100.0
            self.vatFeeTxt.text = String(Int(videoPrice - finalPrice))
        }
        if followUpPercentage == Float(0){
            self.followUpVatFeesTxt.text = self.feesDetailData?.followUpPrice ?? EMPTY
        }else{
            let followPrice = Float(self.feesDetailData?.followUpPrice ?? EMPTY) ?? Float(0)
            let finalPrice = (followPrice * followUpPercentage) / 100.0
            self.followUpVatFeesTxt.text = String(Int(followPrice - finalPrice))
        }
    }
}
