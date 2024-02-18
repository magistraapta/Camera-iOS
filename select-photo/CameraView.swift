//
//  CameraManager.swift
//  select-photo
//
//  Created by Magistra Apta on 09/02/24.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @StateObject var cameraModel = CameraModel()
    @State var showCamera = false
    @State var selectedImage: UIImage?
    @State var image: UIImage?
    
    var body: some View {
        ZStack {
            CameraPreview(cameraModel: cameraModel)
                .ignoresSafeArea()
            
            VStack {

                if cameraModel.isTaken {
                    HStack {
                        Spacer()
                        
                        Button {
                            cameraModel.retake()
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath.camera")
                                .foregroundColor(.black)
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                        }
                    .padding(.trailing, 10)
                    }

                }
                
                Spacer()
                
                HStack {
                    if cameraModel.isTaken {
                        Button {
//                            if !cameraModel.isSaved {
//                                cameraModel.savePic()
//                            }
                        } label: {
                            Text(cameraModel.isSaved ? "Saved" : "Save")
                                .padding()
                                .foregroundColor(.black)
                                .background(.white)
                                .cornerRadius(12)
                        }
                        .padding(.leading)
                        
                        Spacer()

                    } else {
                        
                        Button(action: cameraModel.takePic) {
                            ZStack {
                                Circle()
                                    .fill(.white)
                                    .frame(width: 65)
                                
                                Circle()
                                    .stroke(Color.white, lineWidth: 2)
                                    .frame(width: 75)
                            }
                        }

                    }
                }
            }
        }
        .onAppear(perform: {
            cameraModel.check()
        })

    }
}

struct CameraPreview: UIViewRepresentable {
    
    @ObservedObject var cameraModel: CameraModel
    
    func makeUIView(context: Context) -> some UIView {
        
        let view = UIView(frame: UIScreen.main.bounds)
        
        cameraModel.preview = AVCaptureVideoPreviewLayer(session: cameraModel.session)
        cameraModel.preview.frame = view.frame
        cameraModel.preview.videoGravity = .resizeAspectFill
        view.layer.addSublayer(cameraModel.preview)
        
        cameraModel.session.startRunning()
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}
