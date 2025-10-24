//
//  ContentView.swift
//  Kaleidoscope
//
//  Created by Kexin Liu on 10/23/25.
//

import SwiftUI
import PhotosUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    // UI state
    @State private var processedImage: Image?
    @State private var selectedItem: PhotosPickerItem?

    // Filter params (keep simple first)
    @State private var tileWidth: CGFloat = 150 //zoom/scale
    @State private var rotation: CGFloat = 0 //radians
    @State private var centerX: CGFloat = 0.5 // normalized (0...1)
    @State private var centerY: CGFloat = 0.5 // normalized (0...1)

    // Core Image state
    @State private var inputCIImage: CIImage?
    @State private var currentFilter: CIFilter = CIFilter.sixfoldReflectedTile()

    let context = CIContext()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Spacer()
                PhotosPicker(selection: $selectedItem) {
                    if let processedImage {
                        processedImage
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 360)
                    } else {
                        ContentUnavailableView(
                            "No picture",
                            systemImage: "photo.badge.plus",
                            description: Text("Tap to add a photo")
                        )
                    }
                }
                .buttonStyle(.plain)
                .onChange(of: selectedItem, loadImage)
                
                Spacer()
                
                // Controls
               Group {
                   LabeledContent("Tile Width") {
                       Slider(value: $tileWidth, in: 300...600) { _ in applyProcessing() }
                   }
                   LabeledContent("Rotation") {
                       Slider(value: $rotation, in: 0...(2 * .pi)) { _ in applyProcessing() }
                   }
                   LabeledContent("Center X") {
                       Slider(value: $centerX, in: 0...1) { _ in applyProcessing() }
                   }
                   LabeledContent("Center Y") {
                       Slider(value: $centerY, in: 0...1) { _ in applyProcessing() }
                   }
               }
            }
            .padding([.horizontal, .bottom])
            .navigationTitle("Kaleidoscope")
        }
    }
    
    func loadImage() {
        Task {
            guard let data = try await selectedItem?.loadTransferable(type: Data.self),
                  let uiImage = UIImage(data: data)
            else { return }

            let beginImage = CIImage(image: uiImage)
            inputCIImage = beginImage

            // ensure a filter is ready and points at this image
            currentFilter = CIFilter.sixfoldReflectedTile()
            currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

            applyProcessing()
        }
    }
    
    func applyProcessing() {
        guard let input = inputCIImage else { return }

        // 1) Compute center from your normalized sliders
        let extent = input.extent
        let cx = extent.origin.x + centerX * extent.width
        let cy = extent.origin.y + centerY * extent.height

        // 2) Set filter params
        currentFilter.setValue(input, forKey: kCIInputImageKey)
        if currentFilter.inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: cx, y: cy), forKey: kCIInputCenterKey)
        }
        if currentFilter.inputKeys.contains(kCIInputAngleKey) {
            currentFilter.setValue(rotation, forKey: kCIInputAngleKey)
        }
        if currentFilter.inputKeys.contains(kCIInputWidthKey) {
            currentFilter.setValue(tileWidth, forKey: kCIInputWidthKey)
        }
        if currentFilter.inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(tileWidth, forKey: kCIInputScaleKey)
        }

        // 3) Get output and crop to a finite rect (e.g., the input image rect or a centered square)
        guard let output = currentFilter.outputImage else { return }

        // Option A: crop to the original input rect
        // let drawRect = extent

        // Option B (prettier square): centered square within the input
        let s = min(extent.width, extent.height)
        let drawRect = CGRect(x: extent.midX - s/2, y: extent.midY - s/2, width: s, height: s)

        let cropped = output.cropped(to: drawRect)

        // 4) Render the cropped image
        guard let cg = context.createCGImage(cropped, from: drawRect) else { return }
        processedImage = Image(uiImage: UIImage(cgImage: cg))
    }


}

#Preview {
    ContentView()
}
