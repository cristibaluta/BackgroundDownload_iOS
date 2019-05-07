//
//  DownloadAlamofire.swift
//  BackgroundDownload
//
//  Created by Cristian Baluta on 07/05/2019.
//  Copyright © 2019 Imagin soft. All rights reserved.
//

import Foundation
import Alamofire

class DownloadAlamofire {

    var onProgress: ((Float, String) -> Void)?

    // Strong reference to the session needed
    private var sessionManager: Alamofire.Session!
    private let events = ClosureEventMonitor()
    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

    func startDownload(_ url: String) {

        // Create a background configuration
        let configuration = URLSessionConfiguration.background(withIdentifier: "ro.imagin.background.alamofire")
        // Set events
        events.requestDidFinish = { request in
            print("Request finished \(request)")
        }
        events.requestDidFailToCreateURLRequestWithError = { request, error in
            print("Request failed \(request) \(error)")
        }

        let delegate = CustomSessionDelegate()

        sessionManager = Alamofire.Session(configuration: configuration, delegate: delegate)//, eventMonitors: [events])
//        sessionManager = Alamofire.Session(configuration: configuration)
        let destination: DownloadRequest.Destination = { _, _ in
            let destinationURL = self.documentsPath.appendingPathComponent(URL(string: url)!.lastPathComponent)
            print(destinationURL)
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        sessionManager.download(url, to: destination)
            .responseData { response in
                print(response)
            }
            .downloadProgress { progress in
                let percent = progress.fractionCompleted
                let totalSize = ByteCountFormatter.string(fromByteCount: progress.totalUnitCount, countStyle: .file)
                self.onProgress?(Float(percent), totalSize)
        }
    }

    func resumeDownload() {
        events.requestDidFinish = { request in
            print("Request finished 2 \(request)")
        }
        events.requestDidFailToCreateURLRequestWithError = { request, error in
            print("Request failed 2 \(request) \(error)")
        }
        let configuration = URLSessionConfiguration.background(withIdentifier: "ro.imagin.background.alamofire")
        sessionManager = Alamofire.Session(configuration: configuration, eventMonitors: [events])
    }
}

class CustomSessionDelegate: Alamofire.SessionDelegate {

}
