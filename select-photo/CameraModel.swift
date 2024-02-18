//
//  CameraModel.swift
//  select-photo
//
//  Created by Magistra Apta on 09/02/24.
//

import Foundation
import AVFoundation
import SwiftUI

class CameraModel: NSObject ,ObservableObject, AVCapturePhotoCaptureDelegate {
    
    @Published var isTaken = false
    @Published var session = AVCaptureSession()
    @Published var alert = false
    @Published var output = AVCapturePhotoOutput()
    @Published var preview: AVCaptureVideoPreviewLayer!
    @Published var isSaved = false
    @Published var picData = Data(count: 0)
    
    func check() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.setUp()
                }
            })
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp() {
        
        self.session.beginConfiguration()

        guard let device = AVCaptureDevice.default(for: .video) else { return }

        guard let input = try? AVCaptureDeviceInput(device: device) else {
            return
        }

        if self.session.canAddInput(input) {
            self.session.addInput(input)
        }

        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
        }

        self.session.commitConfiguration()
    }
    
    func takePic() {
        DispatchQueue.global(qos: .background).async {
            self.output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
            self.session.stopRunning()
        }
        
        DispatchQueue.main.async {
            withAnimation{self.isTaken.toggle()}
        }
    }
    
    func retake() {
        DispatchQueue.global(qos: .background).async {
            self.session.startRunning()
            
            
            DispatchQueue.main.async {
                withAnimation { self.isTaken.toggle()}
                self.isSaved = false
            }
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            return
        }
        
        print("pic taken")
        
        guard let imageData = photo.fileDataRepresentation() else { return }
        
        self.picData = imageData
    }
    
//    func savePic() {
//
//        guard let image = UIImage(data: self.picData) else { return }
//
//        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//
//        self.isSaved = true
//        print("Saved successfully...")
//
//    }
    
}
