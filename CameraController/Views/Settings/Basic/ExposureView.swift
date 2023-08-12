//
//  ExposureView.swift
//  CameraController
//
//  Created by Itay Brenner on 7/21/20.
//  Copyright © 2020 Itaysoft. All rights reserved.
//

import SwiftUI
import UVC

struct ExposureView: View {
    @ObservedObject var exposureMode: BitmapCaptureDeviceProperty
    @ObservedObject var exposureTime: NumberCaptureDeviceProperty
    @ObservedObject var gain: NumberCaptureDeviceProperty

    var auto: Binding<Bool> {
        Binding(get: {
            exposureMode.selected == .aperturePriority
        }, set: { auto in
            withAnimation {
                exposureMode.selected = auto ? .aperturePriority : .manual
            }
        })
    }

    init(controller: DeviceController) {
        self.exposureTime = controller.exposureTime
        self.exposureMode = controller.exposureMode
        self.gain = controller.gain
    }

    var body: some View {
        SectionView {
            SectionTitle(title: "Exposure",
                         image: Image(systemName: "clock.fill")) {
                if auto.wrappedValue {
                    AutoBadge()
                        .transition(.opacity)
                }
            }

            HStack {
                Toggle(isOn: auto.animation())
                Slider(value: $exposureTime.sliderValue,
                          step: exposureTime.resolution,
                          sliderRange: exposureTime.minimum...exposureTime.maximum)
                    .disabled(auto.wrappedValue)
            }

            if !auto.wrappedValue {
                HStack {
                    Toggle(isOn: .constant(false))
                        .hidden()
                    VStack {
                        HStack {
                            Text("Gain")
                                .fontWeight(.heavy)
                            Spacer()
                        }
                        HStack {
                            Slider(value: $gain.sliderValue,
                                      step: gain.resolution,
                                      sliderRange: gain.minimum...gain.maximum)
                            .disabled(auto.wrappedValue)
                        }
                    }
                }
            }
        }
    }
}
