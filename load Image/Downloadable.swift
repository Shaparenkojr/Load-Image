

import UIKit
class DownloadableImageView: UIImageView, Downloadable {}
enum DownloadOptions: Equatable, Codable {
    enum From: Codable {
        case disk
        case memory
    }
    
    case circle
    case cached(From)
    case resize
}

protocol Downloadable {
    func loadImage(from url: URL, withOptions options: [DownloadOptions])
}

extension Downloadable where Self: UIImageView {
    
    func loadImage(from url: URL, withOptions options: [DownloadOptions]) {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            var cachedImage: CachedImage?
            
            if options.contains(.cached(.memory)) {
                cachedImage = MemoryManager.shared.getImageFromMemory(.memoryCache, for: url)
            }
            
            if cachedImage == nil, options.contains(.cached(.disk)) {
                cachedImage = MemoryManager.shared.getImageFromMemory(.diskCache, for: url)
            }
            
            if let cachedImage = cachedImage {
                let remainingOptions: [DownloadOptions]
                if !cachedImage.appliedOptions.isEmpty {
                    remainingOptions = options.filter { !cachedImage.appliedOptions.contains($0) }
                } else {
                    remainingOptions = options
                }
                
                var image = cachedImage.image
                
                remainingOptions.forEach {
                    switch $0 {
                    case .circle:
                        DispatchQueue.main.async {
                            image = image.maskRoundedImage(image: image, radius: self.bounds.height / 2) ?? image
                            semaphore.signal()
                        }
                        semaphore.wait()
                    case .resize:
                        if options.contains(.circle) {
                            DispatchQueue.main.async {
                                let imageSize = self.bounds.size
                                let radius = self.bounds.height / 2
                                DispatchQueue.global().async {
                                    image = image.resizeImage(to: imageSize, preserveCorners: true, cornerRadius: radius) ?? image
                                    semaphore.signal()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                let imageSize = self.bounds.size
                                let radius = self.bounds.height / 2
                                DispatchQueue.global().async {
                                    image = image.resizeImage(to: imageSize, preserveCorners: false, cornerRadius: radius) ?? image
                                    semaphore.signal()
                                }
                            }
                        }
                        
                        semaphore.wait()
                    default:
                        break
                    }
                }
                
                DispatchQueue.main.async {
                    self.image = image
                }
            } else {
                Response.shared.getUrlData(from: url) { imageData in
                    guard let imageData, var image = UIImage(data: imageData) else { return }
                    
                    var appliedOptions: [DownloadOptions] = []
                    let imageSize = self.bounds.size
                    let imageRadius = self.bounds.height / 2
                    
                    DispatchQueue.global(qos: .userInitiated).async {
                        options.forEach { option in
                            switch option {
                            case .resize:
                                if options.contains(.circle) {
                                    image = image.resizeImage(to: imageSize, preserveCorners: true, cornerRadius: imageRadius) ?? image
                                    appliedOptions.append(.resize)
                                } else {
                                    image = image.resizeImage(to: imageSize, preserveCorners: false, cornerRadius: imageRadius) ?? image
                                    appliedOptions.append(.resize)
                                }
                                
                            case .cached(.memory):
                                let cachedImage = CachedImage(image: image, appliedOptions: appliedOptions)
                                MemoryManager.shared.saveImageToMemory(.memoryCache, cachedImage, for: url)
                                
                            case .cached(.disk):
                                let cachedImage = CachedImage(image: image, appliedOptions: appliedOptions)
                                MemoryManager.shared.saveImageToMemory(.diskCache, cachedImage, for: url)
                                
                                
                            case .circle:
                                image = image.maskRoundedImage(image: image, radius: imageRadius) ?? image
                                appliedOptions.append(.circle)
                            }
                        }
                        DispatchQueue.main.async {
                            self.image = image
                        }
                    }
                }
            }
        }
    }
}
