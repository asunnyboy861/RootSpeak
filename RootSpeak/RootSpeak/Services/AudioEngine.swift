import Foundation
import AVFoundation

@Observable
final class AudioEngine {
    private var recorder: AVAudioRecorder?
    private var player: AVAudioPlayer?
    private var currentRecordingFile: String?
    var isRecording = false
    var isPlaying = false

    private let fileManager = FileManager.default

    private var audioDirectory: URL {
        let docs = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let dir = docs.appendingPathComponent("RootSpeakAudio", isDirectory: true)
        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    func startRecording(to fileName: String) throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .default)
        try session.setActive(true)

        let url = audioDirectory.appendingPathComponent("\(fileName).m4a")
        currentRecordingFile = "\(fileName).m4a"

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        recorder = try AVAudioRecorder(url: url, settings: settings)
        recorder?.record()
        isRecording = true
    }

    @discardableResult
    func stopRecording() -> String? {
        recorder?.stop()
        isRecording = false
        let file = currentRecordingFile
        currentRecordingFile = nil
        return file
    }

    func play(fileName: String) throws {
        let url = audioDirectory.appendingPathComponent(fileName)
        guard fileManager.fileExists(atPath: url.path) else { return }

        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playback, mode: .default)
        try session.setActive(true)

        player = try AVAudioPlayer(contentsOf: url)
        player?.play()
        isPlaying = true
    }

    func stopPlayback() {
        player?.stop()
        isPlaying = false
    }

    func deleteAudio(fileName: String) throws {
        let url = audioDirectory.appendingPathComponent(fileName)
        if fileManager.fileExists(atPath: url.path) {
            try fileManager.removeItem(at: url)
        }
    }
}
