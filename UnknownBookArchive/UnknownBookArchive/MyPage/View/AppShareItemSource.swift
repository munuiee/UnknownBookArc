//
//  AppShareItemSource.swift
//  UnknownBookArchive
//
//  Created by jyeee on 12/9/25.
//

import Foundation
import UIKit

final class AppShareItemSource: NSObject, UIActivityItemSource {
    private let appURL: URL
    private let messageText: String
    
    init(appURL: URL, messageText: String) {
        self.appURL = appURL
        self.messageText = messageText
        super.init()
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return messageText as NSString
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        switch activityType {
        case .copyToPasteboard:
            return appURL.absoluteString
        case .message, .mail:
            return "\(messageText)\n\(appURL.absoluteString)"
        default:
            return "\(messageText)\n\(appURL.absoluteString)"
        }
    }
}
