//
//  ContentView.swift
//  CameraController
//
//  Created by Itay Brenner on 7/19/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import SwiftUI
import Combine
import AVFoundation

struct ContentView: View {
    @ObservedObject var manager = DevicesManager.shared

    var body: some View {
        HStack {
            VStack {
                Picker(selection: $manager.selectedDevice.animation(.linear), label: Text("Camera")) {
                    ForEach(manager.devices, id: \.self) { device in
                        Text(device.name).tag(device as CaptureDevice?)
                    }
                }
                cameraPreview(captureDevice: $manager.selectedDevice).animation(.spring())
                settingsView(captureDevice: $manager.selectedDevice).animation(.spring())
                ProfileSelector()
            }.onAppear {
                DevicesManager.shared.startMonitoring()
            }.onDisappear {
                DevicesManager.shared.stopMonitoring()
            }
        }.padding(.all, 10.0).frame(width: 450)
    }

    func cameraPreview(captureDevice: Binding<CaptureDevice?>) -> AnyView {
        if captureDevice.wrappedValue != nil {
            return AnyView(CameraPreview(captureDevice: captureDevice)
                .frame(width: 400, height: 225))
        } else {
            return AnyView(Image("video.slash")
                .frame(width: 400, height: 225)
                .background(Color.gray))
        }
    }

    func settingsView(captureDevice: Binding<CaptureDevice?>) -> some View {
        if captureDevice.wrappedValue != nil {
            return AnyView(SettingsView(captureDevice: captureDevice))
        } else {
            return AnyView(EmptyView())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
