//
//  DownloadAlamofire.swift
//  BackgroundDownload
//
//  Created by Cristian Baluta on 07/05/2019.
//  Copyright © 2019 Imagin soft. All rights reserved.
//

import Foundation
import Alamofire

class DownloadAlamofire: NSObject {

    var onProgress: ((Float, String) -> Void)?

    private let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    // Strong reference to the session needed
    private lazy var sessionManager: Alamofire.Session = {
        let configuration = URLSessionConfiguration.background(withIdentifier: "ro.imagin.background.alamofire")
        return Alamofire.Session(configuration: configuration, eventMonitors: self.makeEvents())
    }()

    private func makeEvents() -> [EventMonitor] {
        let events = ClosureEventMonitor()
        events.requestDidFinish = { request in
            print("Request finished \(request)")
        }
        events.taskDidComplete = { session, task, error in
            print("Request failed \(session) \(task) \(error)")
            if  let urlString = (error as NSError?)?.userInfo["NSErrorFailingURLStringKey"] as? String,
                let resumedata = (error as NSError?)?.userInfo[NSURLSessionDownloadTaskResumeData] as? Data {
                print("Found resume data for url \(urlString)")
                self.startDownload(urlString, resumeData: resumedata)
            }
        }
        return [events]
    }

    func startDownload(_ url: String, resumeData: Data?) {

        let destination: DownloadRequest.Destination = { _, _ in
            let destinationURL = self.documentsPath.appendingPathComponent(URL(string: url)!.lastPathComponent)
            print(destinationURL)
            return (destinationURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        var request: DownloadRequest
        if let data = resumeData {
            request = sessionManager.download(resumingWith: data)
        } else {
            request = sessionManager.download(url, to: destination)
        }
        request.responseData { response in
            print(response)
        }
        request.downloadProgress { progress in
            let percent = progress.fractionCompleted
            let totalSize = ByteCountFormatter.string(fromByteCount: progress.totalUnitCount, countStyle: .file)
            self.onProgress?(Float(percent), totalSize)
        }
    }

    private var temporarySession: URLSession!
    func resumeDownload() {
        // Create the session and listen for errors in the EventManager
        let _ = sessionManager
    }
}
