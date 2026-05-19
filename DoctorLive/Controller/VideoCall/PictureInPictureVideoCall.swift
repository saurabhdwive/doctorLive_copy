//
//  PictureInPictureVideoCall.swift
//  DoctorLive
//
//  Created by apple on 18/01/22.
//

import Foundation
import UIKit
import AVFoundation
import PIPKit
import Combine


class SampleBufferVideoCallView: UIView {
    override class var layerClass: AnyClass {
        get { return AVSampleBufferDisplayLayer.self }
    }

    var sampleBufferDisplayLayer: AVSampleBufferDisplayLayer {
        return layer as! AVSampleBufferDisplayLayer
    }
}
@available(iOS 15.0, *)
class VideoView: UIView, AVPIPUIKitUsable {

    var pipTargetView: UIView { self
        return UIView()
    }
   
}
