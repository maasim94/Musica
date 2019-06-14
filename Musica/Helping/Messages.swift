//
//  Messages.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import SwiftMessages

class Messages: SwiftMessages {
    
    /// show top message to user about results of their actions
    ///
    /// - Parameters:
    ///   - message: message to show
    ///   - theme: theme of pop up
    ///   - duration: optional duration in seconds, if not given it will hide automatic
    static func showMessage(message: String, theme: Theme, duration: Duration = .automatic) {
        
        var config: SwiftMessages.Config = SwiftMessages.defaultConfig
        config.duration = duration
        SwiftMessages.show(config: config) { () -> UIView in
            
            let view = MessageView.viewFromNib(layout: .cardView)
            view.button?.isHidden = true
            view.configureTheme(theme)
            view.configureDropShadow()
            var title = "Error"
            switch theme {
            case .success:
                title  = NSLocalizedString("Success", comment: "success message")
            case .info:
                title  = NSLocalizedString("Info", comment: "info message")
            case .warning:
                title  = NSLocalizedString("Warning", comment: "warning message")
            default:
                break
            }
            view.configureContent(title: title, body: message)
            
            return view
            
        }
    }
    
}
