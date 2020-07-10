//
//  VideoViewController.swift
//  Captureful
//
//  Created by vikas.jangir on 10/07/20.
//  Copyright © 2020 Gwinyai Nyatsoka. All rights reserved.
//

import UIKit
import AVFoundation

class VideoViewController: UIViewController {
    
    @IBOutlet weak var videoView: UIView!
    var videoURL : URL!
    
    let avPlayer = AVPlayer()
    
    var avPlayerLayer : AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        avPlayerLayer.frame = view.bounds
        avPlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.insertSublayer(avPlayerLayer, at: 0)
        view.layoutIfNeeded()
        
        let plaerItem = AVPlayerItem(url: videoURL)
        avPlayer.replaceCurrentItem(with: plaerItem)
        avPlayer.play()
        
    }
    
    @IBAction func didMissButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
