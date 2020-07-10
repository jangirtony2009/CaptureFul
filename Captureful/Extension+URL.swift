//
//  Extension+URL.swift
//  Captureful
//
//

import Foundation

import AVFoundation

import UIKit

extension URL {
    
    func makeThumbnail() -> UIImage? {
        
        do {
            let asset = AVURLAsset(url: self, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage
            
        } catch let error as NSError {
            print("Error generating thumbnail: \(error)")
        }
        
        return nil
        
    }
    
    
}
