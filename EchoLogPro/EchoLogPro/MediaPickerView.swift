//
//  MediaPickerView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI
import PhotosUI

struct MediaPickerView: UIViewControllerRepresentable {
    @ObservedObject var viewModel: JournalViewModel
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.mediaTypes = ["public.image", "public.movie"]
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: MediaPickerView
        
        init(_ parent: MediaPickerView) {
            self.parent = parent
        }
        
        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
        ) {
            parent.dismiss()
            
            Task {
                if let image = info[.originalImage] as? UIImage,
                   let imageData = image.jpegData(compressionQuality: 0.8) {
                    
                    // Show caption input
                    await MainActor.run {
                        // In a real app, show a caption input dialog here
                        Task {
                            await parent.viewModel.addEntry(
                                mediaData: imageData,
                                mediaType: .photo,
                                userCaption: nil,
                                location: nil
                            )
                        }
                    }
                } else if let videoURL = info[.mediaURL] as? URL {
                    do {
                        let videoData = try Data(contentsOf: videoURL)
                        await parent.viewModel.addEntry(
                            mediaData: videoData,
                            mediaType: .video,
                            userCaption: nil,
                            location: nil
                        )
                    } catch {
                        print("Error loading video: \(error)")
                    }
                }
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}
