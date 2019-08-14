//
//  OABorder.swift
//
//  Created by 吳政賢 on 2019/3/19.
//  Copyright © 2019 ioa.tw. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func url(_ url: URL, placeholder: UIImage? = nil) {
        if let image = placeholder {
            self.image = image
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    public func url(_ link: String, placeholder: UIImage? = nil) {
        if let image = placeholder {
            self.image = image
        }
        guard let url = URL(string: link) else { return }
        self.url(url)
    }
}
