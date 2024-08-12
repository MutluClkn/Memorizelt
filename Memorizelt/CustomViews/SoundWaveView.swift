//
//  SoundWaveView.swift
//  Memorizelt
//
//  Created by Mutlu Çalkan on 12.08.2024.
//

import UIKit

class SoundWaveView: UIView {
    private var waveLayers = [CAShapeLayer]()
    private var displayLink: CADisplayLink?
    private var waveAmplitude: CGFloat = 20.0 // Amplitude of the wave
    private var waveFrequency: CGFloat = 1.5  // Frequency of the wave
    private var waveSpeed: CGFloat = 0.1      // Speed of the wave
    private var phase: CGFloat = 0            // Phase offset for wave animation
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupWaveLayers()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupWaveLayers()
    }
    
    private func setupWaveLayers() {
        for _ in 0..<5 {
            let waveLayer = CAShapeLayer()
            waveLayer.strokeColor = UIColor.blue.cgColor
            waveLayer.fillColor = UIColor.clear.cgColor
            waveLayer.lineWidth = 2
            waveLayers.append(waveLayer)
            layer.addSublayer(waveLayer)
        }
    }
    
    func startAnimating() {
        displayLink = CADisplayLink(target: self, selector: #selector(updateWaveLayers))
        displayLink?.add(to: .main, forMode: .common)
    }
    
    func stopAnimating() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func updateWaveLayers() {
        phase += waveSpeed
        for (index, waveLayer) in waveLayers.enumerated() {
            let path = createWavePath(for: index)
            waveLayer.path = path.cgPath
        }
    }
    
    private func createWavePath(for index: Int) -> UIBezierPath {
        let path = UIBezierPath()
        let midY = bounds.midY
        let width = bounds.width
        
        let offset = CGFloat(index) * 10.0 // Offset between waves
        let amplitude = waveAmplitude - (CGFloat(index) * 2.0) // Reduce amplitude for inner waves
        
        path.move(to: CGPoint(x: 0, y: midY))
        
        for x in stride(from: 0, to: width, by: 1) {
            let relativeX = x / width
            let normalizedX = relativeX * 2 * .pi * waveFrequency
            let y = amplitude * sin(normalizedX + phase + offset) + midY
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return path
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for waveLayer in waveLayers {
            waveLayer.frame = bounds
        }
    }
}

