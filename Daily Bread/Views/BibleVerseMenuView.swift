//
//  BibleVerseMenuView.swift
//  Daily Bread
//
//  Menu that appears when tapping the cross/logo button
//

import SwiftUI
import UIKit

struct BibleVerseMenuView: View {
    let verse: BibleVerse
    @Binding var showDevotional: Bool
    @Binding var isPresented: Bool
    @ObservedObject private var favoritesManager = FavoritesManager.shared
    @State private var isVisible = false
    @State private var blurRadius: CGFloat = 0
    @State private var overlayOpacity: Double = 0
    @State private var showShareSheet = false
    @State private var shareImage: UIImage?
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Blurred background showing the photo behind - animates in smoothly
                Image(verse.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: blurRadius)
                    .ignoresSafeArea()
                
                // Dark overlay for better text readability - animates in
                Color.black.opacity(overlayOpacity)
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    // Menu options - smooth scale and fade animation
                    VStack(spacing: 0) {
                        // Menu options
                        VStack(spacing: 16) {
                            MenuOption(
                                icon: "square.and.arrow.up",
                                text: "SHARE",
                                action: { shareVerse() }
                            )
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.3).delay(0.0), value: isVisible)
                            
                            Button(action: {
                                favoriteVerse()
                            }) {
                                HStack(spacing: 16) {
                                    Image(systemName: favoritesManager.isFavorite(verse) ? "heart.fill" : "heart")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.black)
                                        .frame(width: 24)
                                    
                                    Text("FAVORITE")
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                        .foregroundColor(.black)
                                        .tracking(1)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.3).delay(0.03), value: isVisible)
                            
                            Button(action: {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    isPresented = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showDevotional = true
                                }
                            }) {
                                HStack(spacing: 16) {
                                    // Custom Christian cross icon
                                    ZStack {
                                        // Vertical line (longer)
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 2.5, height: 20)
                                        
                                        // Horizontal line (shorter, centered)
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(width: 14, height: 2.5)
                                            .offset(y: -2.5)
                                    }
                                    .frame(width: 24, height: 24)
                                    
                                    Text("DEVOTIONAL")
                                        .font(.system(size: 16, weight: .medium, design: .default))
                                        .foregroundColor(.black)
                                        .tracking(1)
                                    
                                    Spacer()
                                }
                                .padding(.vertical, 16)
                                .padding(.horizontal, 20)
                                .background(Color.white)
                                .cornerRadius(12)
                            }
                            .buttonStyle(PlainButtonStyle())
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.3).delay(0.06), value: isVisible)
                            
                            MenuOption(
                                icon: "bubble.left.and.bubble.right",
                                text: "EXPLAIN VERSE",
                                action: { explainVerse() }
                            )
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.3).delay(0.09), value: isVisible)
                            
                            MenuOption(
                                icon: "questionmark.bubble",
                                text: "ASK BIBLE CHAT",
                                action: { askBibleChat() }
                            )
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.3).delay(0.12), value: isVisible)
                            
                            // Unlock Apps - unlocks apps
                            MenuOption(
                                icon: "lock.open.fill",
                                text: "UNLOCK APPS",
                                action: { doneForToday() }
                            )
                            .opacity(isVisible ? 1.0 : 0.0)
                            .animation(.easeOut(duration: 0.3).delay(0.15), value: isVisible)
                        }
                        .padding(.bottom, 24)
                        
                        // Close button (X) - same position as cross button
                        Button(action: {
                            let impact = UIImpactFeedbackGenerator(style: .light)
                            impact.impactOccurred()
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isPresented = false
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.4), lineWidth: 2)
                                    )
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .opacity(isVisible ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.3).delay(0.18), value: isVisible)
                    }
                    .opacity(isVisible ? 1.0 : 0.0)
                    .offset(y: isVisible ? 0 : 30)
                    .padding(.horizontal, 32)
                    .padding(.bottom, max(geometry.safeAreaInsets.bottom + 20, 40)) // Same position as cross button
                }
            }
        }
        .onAppear {
            // Smooth unified animation for everything
            withAnimation(.easeOut(duration: 0.5)) {
                blurRadius = 20
                overlayOpacity = 0.3
            }
            
            // Menu content fades in smoothly after slight delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.easeOut(duration: 0.4)) {
                    isVisible = true
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            if let image = shareImage {
                ShareSheet(activityItems: [
                    image,
                    "\(verse.text)\n\n\(verse.reference)\n\n— Daily Bread"
                ])
            }
        }
    }
    
    private func shareVerse() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Generate image of the verse
        generateVerseImage { image in
            if let image = image {
                DispatchQueue.main.async {
                    self.shareImage = image
                    self.showShareSheet = true
                }
            }
        }
    }
    
    private func generateVerseImage(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Vertical format for social media (9:16 aspect ratio)
            let size = CGSize(width: 1080, height: 1920)
            
            // Load background image
            guard let bgImage = UIImage(named: verse.backgroundImage) else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Create image context
            let renderer = UIGraphicsImageRenderer(size: size)
            let image = renderer.image { context in
                let cgContext = context.cgContext
                
                // Draw background image (scaled to fill)
                bgImage.draw(in: CGRect(origin: .zero, size: size))
                
                // Add subtle dark overlay for text readability
                cgContext.setFillColor(UIColor.black.withAlphaComponent(0.2).cgColor)
                cgContext.fill(CGRect(origin: .zero, size: size))
                
                // Draw verse text
                let textColor = UIColor(red: 1.0, green: 0.976, blue: 0.945, alpha: 1.0)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .center
                paragraphStyle.lineSpacing = 4
                
                // Verse text - Try Lora font, fallback to system serif
                var verseFont = UIFont.systemFont(ofSize: 64, weight: .regular)
                if let loraFont = UIFont(name: "Lora-Regular", size: 64) ?? UIFont(name: "Lora", size: 64) {
                    verseFont = loraFont
                } else {
                    // Try system serif
                    if let serifFont = UIFont(name: "Georgia", size: 64) {
                        verseFont = serifFont
                    }
                }
                
                let verseAttributes: [NSAttributedString.Key: Any] = [
                    .font: verseFont,
                    .foregroundColor: textColor,
                    .paragraphStyle: paragraphStyle
                ]
                let verseText = NSAttributedString(string: verse.text, attributes: verseAttributes)
                // Position verse in upper third
                let verseRect = CGRect(x: 120, y: 400, width: size.width - 240, height: 800)
                verseText.draw(in: verseRect)
                
                // Reference text - Try DM Sans, fallback to system font
                var referenceFont = UIFont.systemFont(ofSize: 32, weight: .regular)
                if let dmSansFont = UIFont(name: "DMSans-Regular", size: 32) ?? UIFont(name: "DM Sans Regular", size: 32) {
                    referenceFont = dmSansFont
                }
                
                let referenceAttributes: [NSAttributedString.Key: Any] = [
                    .font: referenceFont,
                    .foregroundColor: textColor,
                    .kern: 2.0,
                    .paragraphStyle: paragraphStyle
                ]
                let referenceText = NSAttributedString(string: verse.reference.uppercased(), attributes: referenceAttributes)
                // Position reference below verse
                let referenceRect = CGRect(x: 120, y: 1300, width: size.width - 240, height: 100)
                referenceText.draw(in: referenceRect)
                
                // "Bible Lock" branding at the bottom
                let brandingFont = UIFont.systemFont(ofSize: 24, weight: .medium)
                let brandingAttributes: [NSAttributedString.Key: Any] = [
                    .font: brandingFont,
                    .foregroundColor: textColor.withAlphaComponent(0.7),
                    .paragraphStyle: paragraphStyle
                ]
                let brandingText = NSAttributedString(string: "Bible Lock", attributes: brandingAttributes)
                let brandingRect = CGRect(x: 120, y: size.height - 150, width: size.width - 240, height: 50)
                brandingText.draw(in: brandingRect)
            }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    private func favoriteVerse() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        favoritesManager.toggleFavorite(verse)
        
        if favoritesManager.isFavorite(verse) {
            print("✅ Added to favorites: \(verse.reference)")
        } else {
            print("❌ Removed from favorites: \(verse.reference)")
        }
    }
    
    private func doneForToday() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        // Mark devotional as read and unlock apps
        let verseManager = DailyVerseManager.shared
        verseManager.markDevotionalAsRead()
        
        // Close menu
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
        }
        
        print("✅ Done for today - apps unlocked")
    }
    
    private func explainVerse() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        // TODO: Implement explain verse functionality
        print("Explain verse: \(verse.reference)")
    }
    
    private func askBibleChat() {
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        // TODO: Implement Bible chat functionality
        print("Ask Bible chat about: \(verse.reference)")
    }
}

struct MenuOption: View {
    let icon: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: {
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            action()
        }) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 24)
                
                Text(text)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundColor(.black)
                    .tracking(1)
                
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Share sheet wrapper for UIActivityViewController
struct ShareSheet: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: nil
        )
        // Exclude some activities if needed
        controller.excludedActivityTypes = [
            .assignToContact,
            .addToReadingList
        ]
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}

#Preview {
    BibleVerseMenuView(
        verse: BibleVerse(
            text: "For I, the Lord your God, will hold your right hand, saying to you, 'Don't be afraid. I will help you.'",
            reference: "ISAIAH 41:13",
            devotional: "When anxiety creeps in, remember that God is holding your hand.",
            backgroundImage: "b1",
            tags: ["anxiety"]
        ),
        showDevotional: .constant(false),
        isPresented: .constant(true)
    )
}
