//
//  CameraPreview.swift
//  Language_Mark
//
//  Created by 양문경 on 2023/09/14.
//

import UIKit
import AVFoundation

final class CameraPreview: UIView{
    
    var previewLayer : AVCaptureVideoPreviewLayer{
        layer as! AVCaptureVideoPreviewLayer
    }
    
    override class var layerClass: AnyClass{
        AVCaptureVideoPreviewLayer.self
    }
}
