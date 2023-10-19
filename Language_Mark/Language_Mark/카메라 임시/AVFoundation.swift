//
//  AVFoundation.swift
//  Language_Mark
//
//  Created by 양문경 on 2023/09/05.
//

import Foundation
import AVFoundation
import Vision
import CoreML

class CameraService: NSObject{
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    private var handPoseRequest = VNDetectHumanHandPoseRequest()
    
    
    //미리보기 레이어
    let preViewLayer = AVCaptureVideoPreviewLayer()
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping
               (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
    }
    
    //권한 확인하기
    private func checkPermissions(completion: @escaping
                                  (Error?) -> ()) {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self]
                granted in guard granted  else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setupCamera(completion: completion)
        @unknown default:
            break
        }
    }
    
    // 설정 카메라 기능 생성 (개인 기능 설정 카메라)
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device  = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                preViewLayer.videoGravity = .resizeAspectFill
                preViewLayer.session = session
                
                session.startRunning()
                self.session = session
                    
            } catch {
                completion(error)
            }
        }
    }
}
