//
//  CameraViewController.swift
//  Language_Mark
//
//  Created by 양문경 on 2023/09/14.
//
import SwiftUI
import AVFoundation
import UIKit
import Vision
import CoreML

enum errors: Error{
    case CameraError
}

enum HandSign: String {
    case me = "me"
    case you = "you"
    case nothing = "nothing"
    case mountaion = "mountaion"
    case name = "name"
}


final class CameraViewController : UIViewController{
    
    private var cameraFeedSession: AVCaptureSession?
    
    override func loadView() {
        view = CameraPreview()
    }
    
    private var cameraView: CameraPreview{ view as! CameraPreview}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        do{
            
            if cameraFeedSession == nil{
                try setupAVSession()
                
                cameraView.previewLayer.session = cameraFeedSession
                //MARK: Commented out cause it cropped out our View Finder
             //   cameraView.previewLayer.videoGravity = .resizeAspectFill
            }
            
            //MARK: Surronded the code into a DispatchQueue cause it may cause a crash
            DispatchQueue.global(qos: .userInteractive).async {
                self.cameraFeedSession?.startRunning()
               }
            
        }catch{
            print(error.localizedDescription)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        cameraFeedSession?.stopRunning()
        super.viewDidDisappear(animated)
    }
    
    private let videoDataOutputQueue =
        DispatchQueue(label: "CameraFeedOutput", qos: .userInteractive)
    
    
    func setupAVSession() throws {
        //Start of Camera setup
        //이 부분이 카메라 방향 정하는 부분
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
            throw errors.CameraError
        }
        
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else{
            throw errors.CameraError
        }
        
        let session = AVCaptureSession()
        session.beginConfiguration()
        //You can change the quality of the media from view finder from this line
        session.sessionPreset = AVCaptureSession.Preset.photo
        
        guard session.canAddInput(deviceInput) else{
            throw errors.CameraError
        }
        
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput){
            session.addOutput(dataOutput)
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        }else{
            throw errors.CameraError
        }
        
        session.commitConfiguration()
        cameraFeedSession = session
    }
    
    
    //MARK: Vision Init Below
    
    private let handPoseRequest : VNDetectHumanHandPoseRequest = {
            let request = VNDetectHumanHandPoseRequest()
             // Here is where we limit the number of hands Vision can detect at a single given moment
            request.maximumHandCount = 1
            return request
        }()
        
     
        var pointsProcessorHandler: (([CGPoint]) -> Void)?

        func processPoints(_ fingerTips: [CGPoint]) {
          
          let convertedPoints = fingerTips.map {
            cameraView.previewLayer.layerPointConverted(fromCaptureDevicePoint: $0)
          }

          pointsProcessorHandler?(convertedPoints)
        }
    }

extension CameraViewController: AVCaptureVideoDataOutputSampleBufferDelegate{
    
    //Handler and Observation
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }

        guard let handSignsModel = try? VNCoreMLModel(for: handModel(configuration: .init()).model) else { return }
        
        let request =  VNCoreMLRequest(model: handSignsModel) { (finishedRequest, err) in
            guard let results = finishedRequest.results as? [VNClassificationObservation] else { return }
            guard let firstResult = results.first else { return }
            
            DispatchQueue.main.sync {
                switch firstResult.identifier {
                case HandSign.me.rawValue:
                    print("me")
                case HandSign.you.rawValue:
                    print("you")
                case HandSign.nothing.rawValue:
                    print("nothing")
                case HandSign.mountaion.rawValue:
                    print("mountain")
                case HandSign.name.rawValue:
                    print("name")
                default:
                    print("뭘까")
                }
            }
        }
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
        
        
        var fingerTips: [CGPoint] = []
        defer {
          DispatchQueue.main.sync {
            self.processPoints(fingerTips)
          }
        }
        
        
        let handler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer,   orientation: .up,   options: [:])
        
        do{
            try handler.perform([handPoseRequest])
            
            guard let results = handPoseRequest.results?.prefix(2),     !results.isEmpty  else{
                return
            }
            
            var recognizedPoints: [VNRecognizedPoint] = []
            
            try results.forEach { observation in
                
                let fingers = try observation.recognizedPoints(.all)
                
                
                if fingers[.thumbTip]?.confidence ?? 0.0 > 0.7{
                    recognizedPoints.append(fingers[.thumbTip]!)
                    recognizedPoints.append(fingers[.thumbIP]!)
                    recognizedPoints.append(fingers[.thumbMP]!)
                    recognizedPoints.append(fingers[.thumbCMC]!)
                }
                
                
                if fingers[.indexTip]?.confidence ?? 0.0 > 0.7  {
                    recognizedPoints.append(fingers[.indexTip]!)
                    recognizedPoints.append(fingers[.indexDIP]!)
                    recognizedPoints.append(fingers[.indexMCP]!)
                    recognizedPoints.append(fingers[.indexPIP]!)
                    }
                
                
                if fingers[.middleTip]?.confidence ?? 0.0 > 0.7 {
                    recognizedPoints.append(fingers[.middleTip]!)
                    recognizedPoints.append(fingers[.middlePIP]!)
                    recognizedPoints.append(fingers[.middleMCP]!)
                    recognizedPoints.append(fingers[.middleDIP]!)
                }
                
                
                if fingers[.ringTip]?.confidence ?? 0.0 > 0.7 {
                    recognizedPoints.append(fingers[.ringTip]!)
                    recognizedPoints.append(fingers[.ringDIP]!)
                    recognizedPoints.append(fingers[.ringMCP]!)
                    recognizedPoints.append(fingers[.ringPIP]!)
                }
                
                if fingers[.littleTip]?.confidence ?? 0.0 > 0.7 {
                    recognizedPoints.append(fingers[.littleTip]!)
                    recognizedPoints.append(fingers[.littleDIP]!)
                    recognizedPoints.append(fingers[.littleMCP]!)
                    recognizedPoints.append(fingers[.littlePIP]!)
                }
                
            }
            
            fingerTips = recognizedPoints.filter {
              $0.confidence > 0.9
            }
            .map {
              CGPoint(x: $0.location.x, y: 1 - $0.location.y)
            }
            
        }catch{
            cameraFeedSession?.stopRunning()
        }
        
    }
        
}
