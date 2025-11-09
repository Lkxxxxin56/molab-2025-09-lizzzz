//
//  AudioRecorderView.swift
//  EchoLog
//
//  Created by Manus AI on 11/8/25.
//

import SwiftUI
import AVFoundation
import Combine

struct AudioRecorderView: View {
    @ObservedObject var viewModel: JournalViewModel
    @StateObject private var audioRecorder = AudioRecorder()
    @Environment(\.dismiss) var dismiss
    @State private var showingSaveDialog = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: AppSpacing.xl) {
                    Spacer()
                    
                    // Waveform visualization
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppColors.primaryGreen.opacity(0.3),
                                        AppColors.darkGreen.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 220, height: 220)
                            .scaleEffect(audioRecorder.isRecording ? 1.1 : 1.0)
                            .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: audioRecorder.isRecording)
                        
                        Circle()
                            .fill(AppColors.cardBackground)
                            .frame(width: 180, height: 180)
                        
                        Image(systemName: "waveform")
                            .font(.system(size: 60))
                            .foregroundColor(audioRecorder.isRecording ? AppColors.primaryGreen : AppColors.textSecondary)
                    }
                    
                    // Recording time
                    Text(audioRecorder.recordingTime)
                        .font(.system(size: 56, weight: .bold, design: .rounded))
                        .foregroundColor(audioRecorder.isRecording ? AppColors.primaryGreen : AppColors.textPrimary)
                        .monospacedDigit()
                    
                    if audioRecorder.isRecording {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(AppColors.accentOrange)
                                .frame(width: 8, height: 8)
                            
                            Text("Recording")
                                .font(AppTypography.caption)
                                .foregroundColor(AppColors.textSecondary)
                        }
                    } else if audioRecorder.hasRecording {
                        Text("Recording saved")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    } else {
                        Text("Tap to start recording")
                            .font(AppTypography.caption)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Controls
                    HStack(spacing: AppSpacing.xl) {
                        if audioRecorder.hasRecording {
                            Button(action: {
                                audioRecorder.deleteRecording()
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
                            if audioRecorder.isRecording {
                                audioRecorder.stopRecording()
                            } else {
                                audioRecorder.startRecording()
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(audioRecorder.isRecording ? AppColors.accentOrange : AppColors.primaryGreen)
                                    .frame(width: 80, height: 80)
                                
                                if audioRecorder.isRecording {
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
                        
                        if audioRecorder.hasRecording && !audioRecorder.isRecording {
                            Button(action: {
                                showingSaveDialog = true
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
                .padding(AppSpacing.lg)
            }
            .navigationTitle("Voice Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(AppColors.textPrimary)
                }
            }
            .alert("Save Voice Note", isPresented: $showingSaveDialog) {
                Button("Save") {
                    Task {
                        if let audioData = audioRecorder.getRecordingData() {
                            await viewModel.addEntry(
                                mediaData: audioData,
                                mediaType: .audio,
                                userCaption: nil,
                                location: nil
                            )
                            dismiss()
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Save this voice note to your journal?")
            }
        }
    }
}

class AudioRecorder: NSObject, ObservableObject {
    @Published var isRecording = false
    @Published var hasRecording = false
    @Published var recordingTime = "00:00"
    
    private var audioRecorder: AVAudioRecorder?
    private var timer: Timer?
    private var startTime: Date?
    private var recordingURL: URL?
    
    override init() {
        super.init()
        setupAudioSession()
    }
    
    private func setupAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }
    
    func startRecording() {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        recordingURL = documentsPath.appendingPathComponent("recording_\(UUID().uuidString).m4a")
        
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: recordingURL!, settings: settings)
            audioRecorder?.record()
            
            isRecording = true
            startTime = Date()
            
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
                self?.updateRecordingTime()
            }
        } catch {
            print("Failed to start recording: \(error)")
        }
    }
    
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        hasRecording = true
        timer?.invalidate()
        timer = nil
    }
    
    func deleteRecording() {
        if let url = recordingURL {
            try? FileManager.default.removeItem(at: url)
        }
        hasRecording = false
        recordingTime = "00:00"
        recordingURL = nil
    }
    
    func getRecordingData() -> Data? {
        guard let url = recordingURL else { return nil }
        return try? Data(contentsOf: url)
    }
    
    private func updateRecordingTime() {
        guard let startTime = startTime else { return }
        let elapsed = Date().timeIntervalSince(startTime)
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        recordingTime = String(format: "%02d:%02d", minutes, seconds)
    }
}

#Preview {
    AudioRecorderView(viewModel: JournalViewModel())
}
