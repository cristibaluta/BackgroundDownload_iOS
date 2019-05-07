//
//  DownloadService.swift
//  DownloadService
//
//  Created by Rashpinder on 11/07/18.
//  Copyright © 2018 DownloadTask. All rights reserved.
//

import Foundation

// Downloads song snippets, and stores in local file.
// Allows cancel, pause, resume download.
class DownloadService {

    var downloadsSession: URLSession!
    var task: URLSessionDownloadTask?
    var isDownloading = false
    var resumeData: Data?
    var url: URL!

  func startDownload(_ track: URL) {
    url =  track
    task = downloadsSession.downloadTask(with: track)
    task!.resume()
    isDownloading = true
  }

  func pauseDownload() {
    if isDownloading {
      task?.cancel(byProducingResumeData: { data in
        self.resumeData = data
      })
      isDownloading = false
    }
  }

  func cancelDownload() {
    task?.cancel()
  }

  func resumeDownload() {
    if let resumeData = resumeData {
      task = downloadsSession.downloadTask(withResumeData: resumeData)
    } else {
      task = downloadsSession.downloadTask(with: url)
    }
    task!.resume()
    isDownloading = true
  }

}
