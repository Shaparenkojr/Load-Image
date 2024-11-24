//
//  CachedImage.swift
//  load images
//
//  Created by Тарас Шапаренко on 24.11.2024.
//

import UIKit

class CachedImage {
    let image: UIImage
    let appliedOptions: [DownloadOptions]

    init(image: UIImage, appliedOptions: [DownloadOptions]) {
        self.image = image
        self.appliedOptions = appliedOptions
    }
}
