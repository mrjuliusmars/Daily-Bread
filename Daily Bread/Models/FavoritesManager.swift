//
//  FavoritesManager.swift
//  Daily Bread
//
//  Manages favorite Bible verses
//

import Foundation

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()
    
    @Published var favoriteVerses: [BibleVerse] = []
    
    private let favoritesKey = "favoriteVerses"
    private let userDefaults = UserDefaults.standard
    
    private init() {
        loadFavorites()
    }
    
    func loadFavorites() {
        if let data = userDefaults.data(forKey: favoritesKey),
           let decoded = try? JSONDecoder().decode([BibleVerse].self, from: data) {
            favoriteVerses = decoded
        }
    }
    
    func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteVerses) {
            userDefaults.set(encoded, forKey: favoritesKey)
            userDefaults.synchronize()
        }
    }
    
    func isFavorite(_ verse: BibleVerse) -> Bool {
        return favoriteVerses.contains { $0.id == verse.id }
    }
    
    func toggleFavorite(_ verse: BibleVerse) {
        if let index = favoriteVerses.firstIndex(where: { $0.id == verse.id }) {
            // Remove from favorites
            favoriteVerses.remove(at: index)
        } else {
            // Add to favorites
            favoriteVerses.append(verse)
        }
        saveFavorites()
    }
    
    func addFavorite(_ verse: BibleVerse) {
        if !isFavorite(verse) {
            favoriteVerses.append(verse)
            saveFavorites()
        }
    }
    
    func removeFavorite(_ verse: BibleVerse) {
        if let index = favoriteVerses.firstIndex(where: { $0.id == verse.id }) {
            favoriteVerses.remove(at: index)
            saveFavorites()
        }
    }
}

