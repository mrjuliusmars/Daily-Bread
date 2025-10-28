//
//  ShieldConfigurationExtension.swift
//  Daily Bread Shield Configuration
//
//  Created by Marshall Hodge on 10/28/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

// Shield Configuration Extension - Provides custom UI for blocked apps
// The system provides a default appearance for any methods that your subclass doesn't override.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    
    // Helper method to create the custom shield configuration
    private func createDailyBreadShield() -> ShieldConfiguration {
        return ShieldConfiguration(
            backgroundBlurStyle: .systemMaterialDark,
            backgroundColor: UIColor(red: 0.15, green: 0.3, blue: 0.55, alpha: 0.9),
            icon: UIImage(named: "DailyBread_Transparent") ?? UIImage(systemName: "book.closed.fill")!,
            title: ShieldConfiguration.Label(
                text: "Your Daily Bread Awaits",
                color: UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0) // Gold
            ),
            subtitle: ShieldConfiguration.Label(
                text: "Read a Bible verse to unlock your apps for today.\nPut God before social media.",
                color: UIColor(red: 1.0, green: 0.976, blue: 0.945, alpha: 1.0) // Ivory White
            ),
            primaryButtonLabel: ShieldConfiguration.Label(
                text: "Continue to Daily Bread",
                color: .black
            ),
            primaryButtonBackgroundColor: UIColor(red: 255/255, green: 215/255, blue: 0/255, alpha: 1.0), // Gold
            secondaryButtonLabel: nil
        )
    }
    
    override func configuration(shielding application: Application) -> ShieldConfiguration {
        // Customize the shield as needed for applications.
        return createDailyBreadShield()
    }
    
    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for applications shielded because of their category.
        return createDailyBreadShield()
    }
    
    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        // Customize the shield as needed for web domains.
        return createDailyBreadShield()
    }
    
    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        // Customize the shield as needed for web domains shielded because of their category.
        return createDailyBreadShield()
    }
}
