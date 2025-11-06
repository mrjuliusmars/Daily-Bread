//
//  Daily_BreadApp.swift
//  Daily Bread
//
//  Created by Marshall Hodge on 10/23/25.
//

import SwiftUI
import SuperwallKit
import CoreText

@main
struct Daily_BreadApp: App {
    @StateObject private var onboardingState = OnboardingState()
    @State private var hasCompletedOnboarding = false
    @State private var showSplash = true
    
    init() {
        // Configure Superwall
        Superwall.configure(apiKey: "pk_C8cldqMI26f1HGQ9ZWkiA")
        
        // Download and register Lora font (for verse)
        downloadLora()
        
        // Download and register DM Sans font (for reference)
        downloadDMSans()
        
        // Debug: Print all available fonts to verify fonts are loaded
        #if DEBUG
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print("🔍 Checking for fonts...")
            let allFonts = UIFont.familyNames.sorted()
            let loraFonts = allFonts.filter { $0.localizedCaseInsensitiveContains("Lora") }
            let dmSansFonts = allFonts.filter { $0.localizedCaseInsensitiveContains("DM Sans") || $0.localizedCaseInsensitiveContains("DMSans") }
            
            if !loraFonts.isEmpty {
                print("✅ Found Lora font family: \(loraFonts)")
            }
            if !dmSansFonts.isEmpty {
                print("✅ Found DM Sans font family: \(dmSansFonts)")
                for family in dmSansFonts {
                    let fonts = UIFont.fontNames(forFamilyName: family)
                    print("   Fonts in \(family): \(fonts)")
                }
            }
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            Group {
                if showSplash {
                    SplashView()
                        .onAppear {
                            // Show splash for 2 seconds, then transition
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                withAnimation(.easeOut(duration: 0.5)) {
                                    showSplash = false
                                }
                            }
                        }
                } else if hasCompletedOnboarding {
                    ContentView()
                } else {
                    OnboardingFlowView(
                        onboardingState: onboardingState,
                        onOnboardingComplete: {
                            hasCompletedOnboarding = true
                        }
                    )
                }
            }
            .onAppear {
                loadOnboardingStatus()
            }
        }
    }
    
    private func loadOnboardingStatus() {
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    }
    
    private func downloadLora() {
        // Check if Lora is already registered
        let loraFonts = UIFont.fontNames(forFamilyName: "Lora")
        if !loraFonts.isEmpty {
            #if DEBUG
            print("✅ Lora already available")
            #endif
            return
        }
        
        // Download Lora Regular from GitHub (Google Fonts repository)
        guard let fontURL = URL(string: "https://github.com/google/fonts/raw/main/ofl/lora/Lora-Regular.ttf") else {
            #if DEBUG
            print("⚠️ Invalid Lora URL")
            #endif
            return
        }
        
        URLSession.shared.dataTask(with: fontURL) { data, response, error in
            guard let data = data, error == nil else {
                #if DEBUG
                print("⚠️ Failed to download Lora: \(error?.localizedDescription ?? "Unknown error")")
                #endif
                return
            }
            
            // Save to documents directory (persistent)
            let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fontFileURL = documentsDir.appendingPathComponent("Lora-Regular.ttf")
            
            do {
                try data.write(to: fontFileURL)
                
                // Register the font
                var error: Unmanaged<CFError>?
                if CTFontManagerRegisterFontsForURL(fontFileURL as CFURL, .process, &error) {
                    #if DEBUG
                    print("✅ Successfully downloaded and registered Lora!")
                    #endif
                } else {
                    #if DEBUG
                    if let error = error?.takeRetainedValue() {
                        let errorDescription = CFErrorCopyDescription(error)
                        print("⚠️ Failed to register Lora: \(errorDescription ?? "Unknown error" as CFString)")
                    }
                    #endif
                }
            } catch {
                #if DEBUG
                print("⚠️ Failed to save Lora: \(error.localizedDescription)")
                #endif
            }
        }.resume()
    }
    
    private func downloadDMSans() {
        // Check if DM Sans is already registered
        let dmSansFonts = UIFont.fontNames(forFamilyName: "DM Sans")
        if !dmSansFonts.isEmpty {
            #if DEBUG
            print("✅ DM Sans already available")
            #endif
            return
        }
        
        // Download DM Sans Regular from GitHub (Google Fonts repository)
        guard let fontURL = URL(string: "https://github.com/google/fonts/raw/main/ofl/dmsans/DMSans-Regular.ttf") else {
            #if DEBUG
            print("⚠️ Invalid DM Sans URL")
            #endif
            return
        }
        
        URLSession.shared.dataTask(with: fontURL) { data, response, error in
            guard let data = data, error == nil else {
                #if DEBUG
                print("⚠️ Failed to download DM Sans: \(error?.localizedDescription ?? "Unknown error")")
                #endif
                return
            }
            
            // Save to documents directory (persistent)
            let documentsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fontFileURL = documentsDir.appendingPathComponent("DMSans-Regular.ttf")
            
            do {
                try data.write(to: fontFileURL)
                
                // Register the font
                var error: Unmanaged<CFError>?
                if CTFontManagerRegisterFontsForURL(fontFileURL as CFURL, .process, &error) {
                    #if DEBUG
                    print("✅ Successfully downloaded and registered DM Sans!")
                    #endif
                } else {
                    #if DEBUG
                    if let error = error?.takeRetainedValue() {
                        let errorDescription = CFErrorCopyDescription(error)
                        print("⚠️ Failed to register DM Sans: \(errorDescription ?? "Unknown error" as CFString)")
                    }
                    #endif
                }
            } catch {
                #if DEBUG
                print("⚠️ Failed to save DM Sans: \(error.localizedDescription)")
                #endif
            }
        }.resume()
    }
}
