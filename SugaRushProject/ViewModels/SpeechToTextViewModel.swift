//
//  SpeechToTextViewModel.swift
//  SugaRushProject
//
//  Created by David C on 2024-12-08.
//

import Foundation
import Speech
import AVFoundation

class SpeechRecognizerController: ObservableObject {
	private var audioEngine = AVAudioEngine()
	private var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
	private var recognitionTask: SFSpeechRecognitionTask?

	@Published var transcribedText: String = ""

	/// Starts the speech recognition process
	func startListening() {
		if audioEngine.isRunning {
			stopListening()
			return
		}

		self.transcribedText = "";

		print("[Start Listening] Requesting Permission...")
		requestSpeechRecognitionPermission { [weak self] authorized in
			guard authorized else {
				print("[Start Listening] Speech recognition not authorized.")
				return
			}

			print("[Start Listening] Permission granted. Configuring audio session...")
			self?.configureAudioSession()

			let request = SFSpeechAudioBufferRecognitionRequest()
			request.shouldReportPartialResults = true // Enable partial results

			// Start the recognition task
			self?.recognitionTask = self?.speechRecognizer?.recognitionTask(with: request) { result, error in
				if let result = result {
					let transcribedText = result.bestTranscription.formattedString
					self?.transcribedText = transcribedText // Update the published property
					print("[Recognition Task] Transcribed text: \(transcribedText)")
				}

				if let error = error {
					print("[Recognition Task] Recognition error: \(error.localizedDescription)")

					if(error.localizedDescription == "Retry")
						{
						self?.transcribedText = "Retry (Ensure the environment is quiet)"
					}
					self?.stopListening() // Stop listening on error
				}
			}

			// Start the audio engine
			self?.startAudioEngine(with: request)
		}
	}

	private func configureAudioSession() {
		let audioSession = AVAudioSession.sharedInstance()
		do {
			// Set category to playAndRecord
			try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.defaultToSpeaker])
			try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
			print("[Audio Session] Configured successfully.")
		} catch {
			print("[Audio Session] Failed to set up audio session: \(error.localizedDescription)")
		}
	}

	private func startAudioEngine(with request: SFSpeechAudioBufferRecognitionRequest) {
		let inputNode = audioEngine.inputNode

		// Configure audio tap
		inputNode.installTap(onBus: 0, bufferSize: 1024, format: inputNode.outputFormat(forBus: 0)) { (buffer, _) in
			request.append(buffer)
		}

		audioEngine.prepare()
		do {
			try audioEngine.start()
			print("[Audio Engine] Started successfully.")
		} catch {
			print("[Audio Engine] Failed to start: \(error.localizedDescription)")
		}
	}

	func stopListening() {
		if audioEngine.isRunning {
			audioEngine.stop()
			audioEngine.inputNode.removeTap(onBus: 0)
			recognitionTask?.finish()
			recognitionTask = nil
			print("[Stop Listening] Stopped successfully.")
		}
	}

	/// Requests permission for speech recognition
	func requestSpeechRecognitionPermission(completion: @escaping (Bool) -> Void) {
		SFSpeechRecognizer.requestAuthorization { authStatus in
			DispatchQueue.main.async {
				switch authStatus {
				case .authorized:
					print("[Permission] Speech recognition authorized.")
					completion(true)
				case .denied:
					print("[Permission] Speech recognition authorization denied.")
					completion(false)
				case .restricted:
					print("[Permission] Speech recognition restricted on this device.")
					completion(false)
				case .notDetermined:
					print("[Permission] Speech recognition not yet determined.")
					completion(false)
				@unknown default:
					print("[Permission] Unexpected authorization status.")
					completion(false)
				}
			}
		}
	}
}
