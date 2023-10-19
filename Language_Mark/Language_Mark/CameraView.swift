//
//  CameraView.swift
//  Language_Mark
//
//  Created by 양문경 on 2023/09/14.
//

import SwiftUI

struct CameraView: UIViewControllerRepresentable{
    var pointsProcessorHandler: (([CGPoint]) -> Void)?
    func makeUIViewController(context: Context) -> CameraViewController {
        
        let cvc = CameraViewController()
        cvc.view.backgroundColor = .black
        cvc.pointsProcessorHandler = pointsProcessorHandler
        return cvc
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        //Not needed for this app
    }
}
