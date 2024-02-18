//
//  HomeView.swift
//  select-photo
//
//  Created by Magistra Apta on 09/02/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            
            VStack (spacing: 24){
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
