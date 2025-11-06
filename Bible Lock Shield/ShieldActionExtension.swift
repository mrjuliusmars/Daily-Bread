//
//  ShieldActionExtension.swift
//  Daily Bread Shield
//
//  Created by Marshall Hodge on 10/27/25.
//

import ManagedSettings
import ManagedSettingsUI
import FamilyControls

// ShieldActionExtension handles button actions when user interacts with the shield screen
class ShieldActionExtension: ShieldActionDelegate {
    
    // MARK: - ShieldActionDelegate (Button Actions)
    // Override methods must be in the main class body, not in extensions
    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // When user presses a button on the shield screen
        switch action {
        case .primaryButtonPressed:
            // Primary button pressed - open Daily Bread app if possible
            // Note: We can't use UIApplication.shared in extensions, so this will just close
            completionHandler(.close)
        case .secondaryButtonPressed:
            // Secondary button - defer (don't close)
            completionHandler(.defer)
        @unknown default:
            completionHandler(.close)
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        default:
            completionHandler(.close)
        }
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            completionHandler(.close)
        default:
            completionHandler(.close)
        }
    }
}
