import SwiftUI
import Vision
import AVFoundation

struct CameraViews: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    
    let cameraService: CameraService
    
    
    func makeUIViewController(context: Context) -> UIViewController {
        cameraService.start(delegate: EmptyCaptureDelegate()) { error in
            if let error = error {
                // 에러 처리 로직 추가
                print("카메라 서비스 시작 중 오류 발생: \(error.localizedDescription)")
            }
        }
        let viewController  = UIViewController()
        viewController.view.backgroundColor = .black
        viewController.view.layer.addSublayer(cameraService.preViewLayer)
        cameraService.preViewLayer.frame = CGRect(x: 0, y: 0, width: viewController.view.bounds.width, height: 400)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    

}

class EmptyCaptureDelegate: NSObject, AVCapturePhotoCaptureDelegate {
    // AVCapturePhotoCaptureDelegate의 요구사항 구현 (필요한 경우)
}



