//
//  RecordButton.swift
//  TikTok
//
//  Created by Shotiko Klibadze on 27.05.22.
//

import UIKit

class RecordButton: UIButton {
    
    enum State {
        case recording
        case notRecording
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = nil
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height / 2
    }
    
    public func toggle(for state: State) {
        switch state {
        case .recording:
            backgroundColor = .systemRed
        case .notRecording:
            backgroundColor = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
