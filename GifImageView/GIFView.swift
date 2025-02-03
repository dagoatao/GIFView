//
//  GIFViewView.swift
//  GIFView
//
//  Created by Michael Colon on 2/3/25.
//

import UIKit
import ImageIO

class GIFView: UIImageView {
    
    func loadGif(fromData gifData: Data?) {
        guard let data = gifData else {
            print("error no data found")
            return
        }
        playGif(from: data)
    }
    
    func loadGif(named: String) {
        guard let gifUrl = Bundle.main.url(forResource: named, withExtension: "gif"), let imageData = try? Data(contentsOf: gifUrl) else { return }
        playGif(from: imageData)
    }
    
    private func playGif(from data: Data) {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else { return }
        let frameCount = CGImageSourceGetCount(source)
        var frames: [UIImage] = []
        var totalDuration: TimeInterval = 0
        let loopCount = loopCount(from: source)
        
        for i in 0..<frameCount {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let frameDuration = frameDuration(from: source, at: i)
                totalDuration += frameDuration
                frames.append(UIImage(cgImage: cgImage))
            }
        }
        
        if frames.isEmpty {
            return
        }
        
        self.image = UIImage.animatedImage(with: frames, duration: totalDuration)
    }
    
    private func frameDuration(from source: CGImageSource, at index: Int) -> TimeInterval {
        guard let properties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let duration = gifProperties[kCGImagePropertyGIFUnclampedDelayTime] as? TimeInterval
        else { return 0.1 }
        
        return duration < 0.01 ? 0.1 : duration
    }
    
    private func loopCount(from source: CGImageSource) -> Int {
        guard let properties = CGImageSourceCopyProperties(source, nil) as? [CFString: Any],
              let gifProperties = properties[kCGImagePropertyGIFDictionary] as? [CFString: Any],
              let loopCount = gifProperties[kCGImagePropertyGIFLoopCount] as? Int
        else { return 0 }
        return loopCount
    }
}


