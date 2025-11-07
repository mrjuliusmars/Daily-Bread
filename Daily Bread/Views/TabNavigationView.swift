//
//  TabNavigationView.swift
//  Daily Bread
//
//  Bottom tab navigation system with 5 tabs
//

import SwiftUI

enum Tab: Int, CaseIterable {
    case home = 0
    case search = 1
    case read = 2
    case favorites = 3
    case more = 4
    
    var title: String {
        switch self {
        case .home: return "Home"
        case .search: return "Search"
        case .read: return "Read"
        case .favorites: return "Favorites"
        case .more: return "More"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "house"
        case .search: return "magnifyingglass"
        case .read: return "book"
        case .favorites: return "heart"
        case .more: return "ellipsis"
        }
    }
    
    var iconFilled: String {
        switch self {
        case .home: return "house.fill"
        case .search: return "magnifyingglass"
        case .read: return "book.fill"
        case .favorites: return "heart.fill"
        case .more: return "ellipsis"
        }
    }
}

struct TabNavigationView: View {
    @State private var selectedTab: Tab = .home
    @State private var showNavBar: Bool = false
    @StateObject private var homeNavigationState = NavigationState()
    @StateObject private var searchNavigationState = NavigationState()
    @StateObject private var readNavigationState = NavigationState()
    @StateObject private var favoritesNavigationState = NavigationState()
    @StateObject private var moreNavigationState = NavigationState()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Tab content - instant switching with no animation
            Group {
                switch selectedTab {
                case .home:
                    HomeTabView()
                        .environmentObject(homeNavigationState)
                        .transition(.identity)
                case .search:
                    SearchTabView()
                        .environmentObject(searchNavigationState)
                        .transition(.identity)
                case .read:
                    ReadTabView()
                        .environmentObject(readNavigationState)
                        .transition(.identity)
                case .favorites:
                    FavoritesTabView()
                        .environmentObject(favoritesNavigationState)
                        .transition(.identity)
                case .more:
                    MoreTabView()
                        .environmentObject(moreNavigationState)
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
        .ignoresSafeArea(.keyboard)
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("SwitchTab"))) { notification in
            if let tabRawValue = notification.userInfo?["tab"] as? Int,
               let tab = Tab(rawValue: tabRawValue) {
                selectedTab = tab
            }
        }
    }
}

// Navigation state to preserve tab state
class NavigationState: ObservableObject {
    @Published var path: [String] = []
}

// Bottom Tab Bar Component
struct BottomTabBar: View {
    @Binding var selectedTab: Tab
    var onTabChange: ((Tab) -> Void)? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                
                HStack(spacing: 0) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        TabBarButton(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            action: {
                                // Instant switch - no animation
                                let impact = UIImpactFeedbackGenerator(style: .light)
                                impact.impactOccurred()
                                selectedTab = tab
                                onTabChange?(tab)
                            }
                        )
                        .frame(maxWidth: .infinity)
                    }
                }
                .frame(height: 50)
                .padding(.horizontal, 20)
                .padding(.bottom, max(geometry.safeAreaInsets.bottom, 16))
                .background(
                    // Transparent background - let content show through
                    Color.clear
                )
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// Individual Tab Bar Button
struct TabBarButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: isSelected ? tab.iconFilled : tab.icon)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundColor(.white.opacity(isSelected ? 1.0 : 0.2))
                    .frame(height: 28)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .accessibilityLabel(tab.title)
    }
}

#Preview {
    TabNavigationView()
}

