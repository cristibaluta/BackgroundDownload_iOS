//
//  ViewController.swift
//  BackgroundDownload
//
//  Created by Cristian Baluta on 15/03/2019.
//  Copyright © 2019 Imagin soft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!

    let url = "https://cache.sko.fm/ngxmaps/versioned/full/v1/20180605/package/RO.skm"
    let native = DownloadNative()
    let alamofire = DownloadAlamofire()

    override func viewDidLoad() {
        super.viewDidLoad()

        native.onProgress = { percent, totalSize in
            self.progressView.progress = percent
            self.progressLabel.text = totalSize
        }
        alamofire.onProgress = { percent, totalSize in
            self.progressView.progress = percent
            self.progressLabel.text = totalSize
        }
    }


    @IBAction func handleDownload() {
        native.startDownload(url, resumeData: nil)
    }
    @IBAction func handleResume() {
        native.resumeDownload()
    }


    @IBAction func handleAlamofireDownload() {
        alamofire.startDownload(url, resumeData: nil)
    }
    @IBAction func handleAlamofireResume() {
        alamofire.resumeDownload()
    }
}
