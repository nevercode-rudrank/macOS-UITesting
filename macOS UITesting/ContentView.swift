//
//  ContentView.swift
//  macOS UITesting
//
//  Created by Rudrank Riyam on 31/10/21.
//

import SwiftUI

struct ContentView: View {
  @State private var showWelcomeLabel = false
  
  var body: some View {
    VStack {
      if showWelcomeLabel {
        Text("Welcome to Codemagic!")
          .font(.largeTitle)
          .padding()
      }
      
      Button("Show") {
        takeScreensShots(folderName: "macOS_uitesting")
        showWelcomeLabel.toggle()
      }
      .accessibilityIdentifier("Show Button")
    }
    .frame(width: 500, height: 500, alignment: .center)
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

  func CreateTimeStamp() -> Int32
  {
      return Int32(Date().timeIntervalSince1970)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
