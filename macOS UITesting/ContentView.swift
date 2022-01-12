//
//  ContentView.swift
//  macOS UITesting
//
//  Created by Rudrank Riyam on 31/10/21.
//

import SwiftUI
import Speech

struct ContentView: View {
  @StateObject private var viewModel = ContentViewModel()
  
  var body: some View {
    VStack {
      if viewModel.showWelcomeLabel {
        Text("Welcome to Codemagic!")
          .font(.largeTitle)
          .padding()
      }
      
      Button("Show") {
        viewModel.takeScreensShots(folderName: "macOS_uitesting")
        viewModel.showWelcomeLabel.toggle()
        
        viewModel.speech()
        
        viewModel.photos()
      }
      .accessibilityIdentifier("Show Button")
    }
    .frame(width: 500, height: 500, alignment: .center)
  }
  
  
}


struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

import Photos

class ContentViewModel: NSObject, ObservableObject {
  @Published var showWelcomeLabel = false
  
  let audioEngine = AVAudioEngine()
  var speechRecognizer = SFSpeechRecognizer()
  let request = SFSpeechAudioBufferRecognitionRequest()
  var recognitionTask: SFSpeechRecognitionTask?
  
  func photos() {
    do {
      let session: AVCaptureSession = AVCaptureSession()
      
      session.sessionPreset = AVCaptureSession.Preset.low
      guard let device = AVCaptureDevice.default(for: .video) else {
        print("NOT FOUND")
        return
      }
      
      print("device found = ", device)
      
      let input: AVCaptureInput = try AVCaptureDeviceInput(device: device)
      session.addInput(input)
      
      session.startRunning()
    } catch {
      print(error)
    }
    
  }
  
  func takeScreensShots(folderName: String){
    
    var displayCount: UInt32 = 0;
    var result = CGGetActiveDisplayList(0, nil, &displayCount)
    if (result != CGError.success) {
      print("error: \(result)")
      return
    }
    let allocated = Int(displayCount)
    let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: allocated)
    result = CGGetActiveDisplayList(displayCount, activeDisplays, &displayCount)
    
    if (result != CGError.success) {
      print("error: \(result)")
      return
    }
    
    for i in 1...displayCount {
      let unixTimestamp = CreateTimeStamp()
      let fileUrl = URL(fileURLWithPath: folderName + "\(unixTimestamp)" + "_" + "\(i)" + ".jpg", isDirectory: true)
      let screenShot:CGImage = CGDisplayCreateImage(activeDisplays[Int(i-1)])!
      let bitmapRep = NSBitmapImageRep(cgImage: screenShot)
      let jpegData = bitmapRep.representation(using: NSBitmapImageRep.FileType.jpeg, properties: [:])!
      
      do {
        try jpegData.write(to: fileUrl, options: .atomic)
      }
      catch {print("error: \(error)")}
    }
  }
  
  func CreateTimeStamp() -> Int32 {
    return Int32(Date().timeIntervalSince1970)
  }
  
  func speech() {
    speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    speechRecognizer?.delegate = self
    
    SFSpeechRecognizer.requestAuthorization { [self] authStatus in
      if authStatus == .authorized {
      }
    }
  }
}

extension ContentViewModel: SFSpeechRecognizerDelegate {
  
}
