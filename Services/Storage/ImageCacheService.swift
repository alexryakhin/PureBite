//
//  ImageCacheService.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 1/1/25.
//

import Foundation
import UIKit

@MainActor
final class ImageCacheService: ObservableObject {
    static let shared = ImageCacheService()
    
    private let cache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let maxCacheSize = 100 * 1024 * 1024 // 100MB
    private let maxCacheAge: TimeInterval = 7 * 24 * 60 * 60 // 7 days
    
    private init() {
        setupCache()
        loadCachedImages()
    }
    
    private func setupCache() {
        cache.totalCostLimit = maxCacheSize
        cache.countLimit = 200 // Max 200 images
    }
    
    // MARK: - Image Caching
    
    func cacheImage(_ image: UIImage, forKey key: String) {
        let nsKey = NSString(string: key)
        cache.setObject(image, forKey: nsKey)
        
        // Save to disk
        saveImageToDisk(image, forKey: key)
    }
    
    func getCachedImage(forKey key: String) -> UIImage? {
        let nsKey = NSString(string: key)
        
        // Check memory cache first
        if let image = cache.object(forKey: nsKey) {
            return image
        }
        
        // Check disk cache
        if let image = loadImageFromDisk(forKey: key) {
            cache.setObject(image, forKey: nsKey)
            return image
        }
        
        return nil
    }
    
    func clearCache() {
        cache.removeAllObjects()
        clearDiskCache()
    }
    
    // MARK: - Private Methods
    
    private func saveImageToDisk(_ image: UIImage, forKey key: String) {
        guard let data = image.jpegData(compressionQuality: 0.8) else { return }
        
        let cacheDirectory = getCacheDirectory()
        let fileURL = cacheDirectory.appendingPathComponent("\(key).jpg")
        
        do {
            try data.write(to: fileURL)
            print("✅ [IMAGE_CACHE] Saved image for key: \(key)")
        } catch {
            print("❌ [IMAGE_CACHE] Failed to save image for key \(key): \(error)")
        }
    }
    
    private func loadImageFromDisk(forKey key: String) -> UIImage? {
        let cacheDirectory = getCacheDirectory()
        let fileURL = cacheDirectory.appendingPathComponent("\(key).jpg")
        
        guard let data = try? Data(contentsOf: fileURL),
              let image = UIImage(data: data) else {
            return nil
        }
        
        return image
    }
    
    private func clearDiskCache() {
        let cacheDirectory = getCacheDirectory()
        
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print("❌ [IMAGE_CACHE] Failed to clear disk cache: \(error)")
        }
    }
    
    private func loadCachedImages() {
        let cacheDirectory = getCacheDirectory()
        
        // Check if directory exists and has files
        guard fileManager.fileExists(atPath: cacheDirectory.path) else {
            print("ℹ️ [IMAGE_CACHE] Cache directory doesn't exist yet, will be created on first use")
            return
        }
        
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: [.creationDateKey])
            
            for file in files {
                let fileName = file.lastPathComponent
                let key = fileName.replacingOccurrences(of: ".jpg", with: "")
                
                if let image = loadImageFromDisk(forKey: key) {
                    let nsKey = NSString(string: key)
                    cache.setObject(image, forKey: nsKey)
                }
            }
            
            print("✅ [IMAGE_CACHE] Loaded \(files.count) cached images")
        } catch {
            print("❌ [IMAGE_CACHE] Failed to load cached images: \(error)")
        }
    }
    
    private func getCacheDirectory() -> URL {
        let paths = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let cacheDirectory = paths[0].appendingPathComponent("RecipeImages")
        
        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
            } catch {
                print("❌ [IMAGE_CACHE] Failed to create cache directory: \(error)")
            }
        }
        
        return cacheDirectory
    }
} 