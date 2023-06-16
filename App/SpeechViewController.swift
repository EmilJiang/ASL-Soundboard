import UIKit
import Speech

class SpeechViewController: UIViewController {
    func authorizeSR() {
        SFSpeechRecognizer.requestAuthorization { authStatus in

            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.transcribeButton.isEnabled = true

                case .denied:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle("Speech recognition access denied by user", for: .disabled)

                case .restricted:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle(
                      "Speech recognition restricted on device", for: .disabled)

                case .notDetermined:
                    self.transcribeButton.isEnabled = false
                    self.transcribeButton.setTitle(
                      "Speech recognition not authorized", for: .disabled)
                @unknown default:
                    print("Unknown state")
                }
            }
        }
    }

    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var transcribeButton: UIButton!
    @IBOutlet weak var myTextView: UITextView!
    private let speechRecognizer = SFSpeechRecognizer(locale:
            Locale(identifier: "en-US"))!

    private var speechRecognitionRequest:
        SFSpeechAudioBufferRecognitionRequest?
    private var speechRecognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myTextView.isEditable = false
        stopButton.backgroundColor = .clear
        stopButton.layer.cornerRadius = 10
        stopButton.layer.borderWidth = 1
        stopButton.layer.borderColor = UIColor.blue.cgColor
        transcribeButton.backgroundColor = .clear
        transcribeButton.layer.cornerRadius = 10
        transcribeButton.layer.borderWidth = 1
        transcribeButton.layer.borderColor = UIColor.blue.cgColor
        authorizeSR()
    }

    @IBAction func startTranscribing(_ sender: Any) {
        transcribeButton.zoomInWithEasing()
        transcribeButton.isEnabled = false
        stopButton.isEnabled = true
        
        do {
            try startSession()
        } catch {
            // Handle Error
        }
    }

    func startSession() throws {

        if let recognitionTask = speechRecognitionTask {
            recognitionTask.cancel()
            self.speechRecognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(AVAudioSession.Category.record,
                            mode: .default)

        speechRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        guard let recognitionRequest = speechRecognitionRequest else {
          fatalError(
        "SFSpeechAudioBufferRecognitionRequest object creation failed") }

        let inputNode = audioEngine.inputNode

        recognitionRequest.shouldReportPartialResults = true

        speechRecognitionTask = speechRecognizer.recognitionTask(
            with: recognitionRequest) { result, error in

            var finished = false

            if let result = result {
                self.myTextView.text =
                result.bestTranscription.formattedString
                finished = result.isFinal
            }

            if error != nil || finished {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)

                self.speechRecognitionRequest = nil
                self.speechRecognitionTask = nil

                self.transcribeButton.isEnabled = true
            }
        }

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) {
         (buffer: AVAudioPCMBuffer, when: AVAudioTime) in

            self.speechRecognitionRequest?.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()
    }
    
    @IBAction func stopTranscribing(_ sender: Any) {
        stopButton.zoomInWithEasing()
        myTextView.text = ""
        if audioEngine.isRunning {
            audioEngine.stop()
            speechRecognitionRequest?.endAudio()
            transcribeButton.isEnabled = true
            stopButton.isEnabled = false
        }
    }
}

