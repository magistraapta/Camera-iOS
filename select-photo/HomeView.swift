//
//  HomeView.swift
//  select-photo
//
//  Created by Magistra Apta on 09/02/24.
//

import SwiftUI
import PhotosUI

struct HomeView: View {
    @State var selectedImage: Image?
    @State var photoPickerItem: PhotosPickerItem?
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack (spacing: 24){
                VStack {
                    selectedImage?
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                    
                    
                        
                    PhotosPicker(selection: $photoPickerItem, matching: .images) {
                        Text("PhotoPicker")
                    }
                }
                Text("Click the camera icon to open camera")
                    .font(.headline)
                    .foregroundColor(.secondary)
                NavigationLink {
                    CameraView()
                } label: {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                }
            }
            .navigationTitle("Camera app")
            .onChange(of: photoPickerItem) { _ in
                Task {
                    if let data = try? await photoPickerItem?.loadTransferable(type: Image.self) {
                        selectedImage = data
                    } else {
                        print("failed")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}
