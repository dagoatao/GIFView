//
//  ViewController.swift
//  GifImageView
//
//  Created by Michael Colon on 2/3/25.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let gifView = GIFView(frame: CGRect(x: 0, y: 100, width: view.bounds.size.width, height: view.bounds.size.height * 0.5))
        gifView.loadGif(named: "girl0")
        gifView.contentMode = .scaleAspectFit
        view.addSubview(gifView)
    }
}

