//
//  ImageCache.swift
//  SpaceX
//
//  Created by Sagaya Abdulhafeez on 11/05/2022.
//

import Foundation
import UIKit.UIImage
import Combine


public protocol ImageCacheType: AnyObject {
  // Returns the image associated with a given url
  func image(for url: URL) -> UIImage?
  // Inserts the image of the specified url in the cache
  func insertImage(_ image: UIImage?, for url: URL)
  // Removes the image of the specified url in the cache
  func removeImage(for url: URL)
  // Removes all images from the cache
  func removeAllImages()
  // Accesses the value associated with the given key for reading and writing
  subscript(_ url: URL) -> UIImage? { get set }
}

public final class ImageCache: ImageCacheType {
  
  private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
    let cache = NSCache<AnyObject, AnyObject>()
    cache.countLimit = config.countLimit
    return cache
  }()
  private let lock = NSLock()
  private let config: Config
  
  public struct Config {
    public let countLimit: Int
    public static let defaultConfig = Config(countLimit: 100)
  }
  
  public init(config: Config = Config.defaultConfig) {
    self.config = config
  }
  
  public func image(for url: URL) -> UIImage? {
    lock.lock(); defer { lock.unlock() }
    if let decodedImage = imageCache.object(forKey: url as AnyObject) as? UIImage {
      return decodedImage
    }
    if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
      let decodedImage = image.decodedImage()
      return decodedImage
    }
    return nil
  }
  
  public func insertImage(_ image: UIImage?, for url: URL) {
    guard let image = image else { return removeImage(for: url) }
    let decompressedImage = image.decodedImage()
    
    lock.lock(); defer { lock.unlock() }
    imageCache.setObject(decompressedImage, forKey: url as AnyObject, cost: 1)
  }
  
  public func removeImage(for url: URL) {
    lock.lock(); defer { lock.unlock() }
    imageCache.removeObject(forKey: url as AnyObject)
  }
  
  public func removeAllImages() {
    lock.lock(); defer { lock.unlock() }
    imageCache.removeAllObjects()
  }
  
  public subscript(_ key: URL) -> UIImage? {
    get {
      return image(for: key)
    }
    set {
      return insertImage(newValue, for: key)
    }
  }
}

fileprivate extension UIImage {
  
  func decodedImage() -> UIImage {
    guard let cgImage = cgImage else { return self }
    let size = CGSize(width: cgImage.width, height: cgImage.height)
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
    context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
    guard let decodedImage = context?.makeImage() else { return self }
    return UIImage(cgImage: decodedImage)
  }
  
  var diskSize: Int {
    guard let cgImage = cgImage else { return 0 }
    return cgImage.bytesPerRow * cgImage.height
  }
}
