//
//  AddEntryView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI
import PhotosUI

struct AddEntryView: View {
    @ObservedObject var viewModel: JournalViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var selectedMediaType: MediaType?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingAudioRecorder = false
    
    @State private var selectedImage: UIImage?
    @State private var selectedVideoURL: URL?
    @State private var audioData: Data?
    @State private var audioFileName: String?
    
    @State private var caption: String = ""
    @State private var selectedCategory: SustainabilityCategory?
    @State private var useLocation: Bool = true
    
    @State private var isProcessing = false
    @State private var showingSuccessAlert = false
    
    var hasMedia: Bool {
        selectedImage != nil || selectedVideoURL != nil || audioData != nil
    }
    
    var canSave: Bool {
        hasMedia && !caption.isEmpty
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: AppSpacing.lg) {
                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("New Entry")
                                .font(AppTypography.largeTitle)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("Capture your sustainable action")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textSecondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                        
                        // Media Upload Section
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Media")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            if let image = selectedImage {
                                // Show selected image
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipped()
                                        .cornerRadius(AppRadius.md)
                                    
                                    Button(action: {
                                        selectedImage = nil
                                        selectedMediaType = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .background(Circle().fill(Color.black.opacity(0.6)))
                                    }
                                    .padding(AppSpacing.sm)
                                }
                            } else if let videoURL = selectedVideoURL {
                                // Show video placeholder
                                ZStack(alignment: .topTrailing) {
                                    VStack(spacing: AppSpacing.md) {
                                        Image(systemName: "video.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(AppColors.primaryGreen)
                                        
                                        Text("Video Selected")
                                            .font(AppTypography.body)
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Text(videoURL.lastPathComponent)
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .background(AppColors.primaryGreen.opacity(0.1))
                                    .cornerRadius(AppRadius.md)
                                    
                                    Button(action: {
                                        selectedVideoURL = nil
                                        selectedMediaType = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                    .padding(AppSpacing.sm)
                                }
                            } else if let audioName = audioFileName {
                                // Show audio placeholder
                                ZStack(alignment: .topTrailing) {
                                    VStack(spacing: AppSpacing.md) {
                                        Image(systemName: "waveform")
                                            .font(.system(size: 50))
                                            .foregroundColor(AppColors.primaryGreen)
                                        
                                        Text("Audio Recorded")
                                            .font(AppTypography.body)
                                            .foregroundColor(AppColors.textPrimary)
                                        
                                        Text(audioName)
                                            .font(AppTypography.caption)
                                            .foregroundColor(AppColors.textSecondary)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 200)
                                    .background(AppColors.primaryGreen.opacity(0.1))
                                    .cornerRadius(AppRadius.md)
                                    
                                    Button(action: {
                                        audioData = nil
                                        audioFileName = nil
                                        selectedMediaType = nil
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(AppColors.textPrimary)
                                    }
                                    .padding(AppSpacing.sm)
                                }
                            } else {
                                // Upload buttons
                                VStack(spacing: AppSpacing.sm) {
                                    Button(action: {
                                        showingCamera = true
                                    }) {
                                        HStack {
                                            Image(systemName: "camera.fill")
                                                .font(.title3)
                                            Text("Take Photo")
                                                .font(AppTypography.body)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(AppSpacing.md)
                                        .cardStyle()
                                    }
                                    
                                    Button(action: {
                                        showingImagePicker = true
                                    }) {
                                        HStack {
                                            Image(systemName: "photo.fill")
                                                .font(.title3)
                                            Text("Choose Photo")
                                                .font(AppTypography.body)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(AppSpacing.md)
                                        .cardStyle()
                                    }
                                    
                                    Button(action: {
                                        showingAudioRecorder = true
                                    }) {
                                        HStack {
                                            Image(systemName: "mic.fill")
                                                .font(.title3)
                                            Text("Record Audio")
                                                .font(AppTypography.body)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .font(.caption)
                                                .foregroundColor(AppColors.textSecondary)
                                        }
                                        .foregroundColor(AppColors.textPrimary)
                                        .padding(AppSpacing.md)
                                        .cardStyle()
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        // Caption Section
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Caption")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            ZStack(alignment: .topLeading) {
                                if caption.isEmpty {
                                    Text("Describe your sustainable action...")
                                        .font(AppTypography.body)
                                        .foregroundColor(AppColors.textSecondary)
                                        .padding(.horizontal, 4)
                                        .padding(.vertical, 8)
                                }
                                
                                TextEditor(text: $caption)
                                    .font(AppTypography.body)
                                    .foregroundColor(AppColors.textPrimary)
                                    .frame(minHeight: 120)
                                    .scrollContentBackground(.hidden)
                            }
                            .padding(AppSpacing.md)
                            .background(AppColors.cardBackground)
                            .cornerRadius(AppRadius.md)
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        // Optional Category Selection
                        VStack(alignment: .leading, spacing: AppSpacing.md) {
                            Text("Category (Optional)")
                                .font(AppTypography.headline)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Text("AI will auto-classify if not selected")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: AppSpacing.sm) {
                                    ForEach(SustainabilityCategory.allCases) { category in
                                        Button(action: {
                                            if selectedCategory == category {
                                                selectedCategory = nil
                                            } else {
                                                selectedCategory = category
                                            }
                                        }) {
                                            VStack(spacing: AppSpacing.sm) {
                                                Image(systemName: category.icon)
                                                    .font(.title3)
                                                    .foregroundColor(selectedCategory == category ? .white : category.color)
                                                
                                                Text(category.rawValue)
                                                    .font(AppTypography.small)
                                                    .foregroundColor(selectedCategory == category ? .white : AppColors.textPrimary)
                                                    .lineLimit(2)
                                                    .multilineTextAlignment(.center)
                                            }
                                            .frame(width: 100)
                                            .padding(AppSpacing.md)
                                            .background(selectedCategory == category ? category.color : AppColors.cardBackground)
                                            .cornerRadius(AppRadius.md)
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        
                        // Location Toggle
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(AppColors.primaryGreen)
                            
                            Text("Include Location")
                                .font(AppTypography.body)
                                .foregroundColor(AppColors.textPrimary)
                            
                            Spacer()
                            
                            Toggle("", isOn: $useLocation)
                                .tint(AppColors.primaryGreen)
                        }
                        .padding(AppSpacing.md)
                        .cardStyle()
                        .padding(.horizontal, AppSpacing.lg)
                        
                        // Save Button
                        Button(action: saveEntry) {
                            HStack {
                                if isProcessing {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "checkmark.circle.fill")
                                        .font(.title3)
                                    Text("Save Entry")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .pillButton(
                                backgroundColor: canSave ? AppColors.primaryGreen : AppColors.textSecondary,
                                foregroundColor: .white
                            )
                        }
                        .disabled(!canSave || isProcessing)
                        .padding(.horizontal, AppSpacing.lg)
                        .padding(.top, AppSpacing.md)
                        
                        Spacer(minLength: AppSpacing.xxl)
                    }
                }
            }
            .navigationBarHidden(true)
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(AppColors.textSecondary)
                        .padding(AppSpacing.lg)
                }
            }
            .sheet(isPresented: $showingImagePicker) {
                ImagePicker(image: $selectedImage, sourceType: .photoLibrary) {
                    selectedMediaType = .photo
                }
            }
            .sheet(isPresented: $showingCamera) {
                ImagePicker(image: $selectedImage, sourceType: .camera) {
                    selectedMediaType = .photo
                }
            }
            .sheet(isPresented: $showingAudioRecorder) {
                AudioRecorderSheet(audioData: $audioData, audioFileName: $audioFileName) {
                    selectedMediaType = .audio
                }
            }
            .alert("Entry Saved!", isPresented: $showingSuccessAlert) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Your sustainable action has been logged successfully!")
            }
        }
    }
    
    func saveEntry() {
        guard canSave else { return }
        
        isProcessing = true
        
        Task {
            var mediaData: Data?
            var mediaType: MediaType = .photo
            
            // Prepare media data
            if let image = selectedImage {
                mediaData = image.jpegData(compressionQuality: 0.8)
                mediaType = .photo
            } else if let videoURL = selectedVideoURL {
                mediaData = try? Data(contentsOf: videoURL)
                mediaType = .video
            } else if let audio = audioData {
                mediaData = audio
                mediaType = .audio
            }
            
            guard let data = mediaData else {
                isProcessing = false
                return
            }
            
            // Add entry with caption
            await viewModel.addEntry(
                mediaData: data,
                mediaType: mediaType,
                userCaption: caption,
                location: useLocation ? LocationData(coordinate: .init(latitude: 37.7749, longitude: -122.4194)) : nil
            )
            
            await MainActor.run {
                isProcessing = false
                showingSuccessAlert = true
            }
        }
    }
}

// Image Picker Helper
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    let sourceType: UIImagePickerController.SourceType
    let onSelect: () -> Void
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                parent.onSelect()
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

// Audio Recorder Sheet
struct AudioRecorderSheet: View {
    @Binding var audioData: Data?
    @Binding var audioFileName: String?
    let onRecord: () -> Void
    @Environment(\.dismiss) var dismiss
    
    @StateObject private var recorder = AudioRecorder()
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.xl) {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(AppColors.primaryGreen.opacity(0.2))
                            .frame(width: 200, height: 200)
                            .scaleEffect(recorder.isRecording ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: recorder.isRecording)
                        
                        Image(systemName: "waveform")
                            .font(.system(size: 60))
                            .foregroundColor(recorder.isRecording ? AppColors.primaryGreen : AppColors.textSecondary)
                    }
                    
                    Text(recorder.recordingTime)
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(AppColors.textPrimary)
                        .monospacedDigit()
                    
                    Spacer()
                    
                    HStack(spacing: AppSpacing.xl) {
                        if recorder.hasRecording {
                            Button(action: {
                                recorder.deleteRecording()
                            }) {
                                Image(systemName: "trash.fill")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(AppColors.accentOrange)
                                    .clipShape(Circle())
                            }
                        }
                        
                        Button(action: {
                            if recorder.isRecording {
                                recorder.stopRecording()
                            } else {
                                recorder.startRecording()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(recorder.isRecording ? AppColors.accentOrange : AppColors.primaryGreen)
                                    .frame(width: 80, height: 80)
                                
                                if recorder.isRecording {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(.white)
                                        .frame(width: 30, height: 30)
                                } else {
                                    Image(systemName: "mic.fill")
                                        .font(.title)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        if recorder.hasRecording && !recorder.isRecording {
                            Button(action: {
                                if let data = recorder.getRecordingData() {
                                    audioData = data
                                    audioFileName = "Recording \(Date().formatted(date: .omitted, time: .shortened))"
                                    onRecord()
                                    dismiss()
                                }
                            }) {
                                Image(systemName: "checkmark")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(width: 60, height: 60)
                                    .background(AppColors.primaryGreen)
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    Spacer()
                }
            }
            .navigationTitle("Record Audio")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddEntryView(viewModel: JournalViewModel())
}
