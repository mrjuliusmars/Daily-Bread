//
//  BibleViewWithNav.swift
//  Daily Bread
//
//  Bible view with bottom navigation overlay and tab switching
//

import SwiftUI

struct BibleViewWithNav: View {
    @State private var selectedTab: Tab = .read
    @State private var showNavBar: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content based on selection
            Group {
                switch selectedTab {
                case .home:
                    // Dismiss to go back to home
                    Color.clear
                        .onAppear {
                            dismiss()
                        }
                case .search:
                    SearchTabView()
                        .transition(.identity)
                case .read:
                    BibleView()
                        .transition(.identity)
                case .favorites:
                    FavoritesTabView()
                        .transition(.identity)
                case .more:
                    MoreTabView()
                        .transition(.identity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                let impact = UIImpactFeedbackGenerator(style: .light)
                impact.impactOccurred()
                withAnimation(.easeInOut(duration: 0.3)) {
                    showNavBar.toggle()
                }
            }
            
            // Bottom navigation bar - toggle visibility with tap
            BottomTabBar(selectedTab: $selectedTab)
                .opacity(showNavBar ? 1.0 : 0.0)
                .allowsHitTesting(showNavBar)
        }
        .navigationBarHidden(true)
        .ignoresSafeArea()
    }
}

#Preview {
    BibleViewWithNav()
}

