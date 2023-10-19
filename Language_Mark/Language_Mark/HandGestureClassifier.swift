//
//  HandGestureClassifier.swift
//  Language_Mark
//
//  Created by 양문경 on 2023/09/20.
//

import CoreML

class HandGestureClassifier {
    let model: handPose = {
        do {
            return try handPose(configuration: MLModelConfiguration())
        } catch {
            fatalError("Error loading model: \(error)")
        }
    }()
}

