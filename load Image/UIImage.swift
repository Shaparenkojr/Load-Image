

import UIKit

extension UIImage {
    
    func resizeImage(to size: CGSize, preserveCorners: Bool = false, cornerRadius: CGFloat? = nil) -> UIImage? {
        // Использование UIGraphicsImageRenderer для лучшей производительности
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { context in
            // Если нужно сохранить закругленные углы
            if preserveCorners, let cornerRadius = cornerRadius {
                let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
                path.addClip() // Применяем маску с закругленными углами
            }

            // Рисуем измененное изображение
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: image.size)
        
        // Использование UIGraphicsImageRenderer для лучшего качества
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            // Создаем путь для маски с закругленными углами
            let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
            path.addClip()
            
            // Рисуем изображение в контексте
            image.draw(in: rect)
        }
    }
}

