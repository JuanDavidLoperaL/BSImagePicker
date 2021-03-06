// The MIT License (MIT)
//
// Copyright (c) 2019 Joakim Gyllström
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit
import Photos
import CoreLocation

class PreviewTitleBuilder {
    // TODO: Move to settings/theme
    private static let titleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
        NSAttributedString.Key.foregroundColor: UIColor.black
    ]
    private static let subtitleAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12),
        NSAttributedString.Key.foregroundColor: UIColor.black
    ]
    
    static func titleFor(asset: PHAsset, completion: @escaping (NSAttributedString) -> Void) {
        if let location = asset.location {
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if let locality = placemarks?.first?.locality {
                    let mutableAttributedString = NSMutableAttributedString()
                    mutableAttributedString.append(NSAttributedString(string: locality, attributes: titleAttributes))
                    
                    if let created = asset.creationDate {
                        let formatter = DateFormatter()
                        formatter.dateStyle = .long
                        formatter.timeStyle = .short
                        let dateString = "\n" + formatter.string(from: created)
                        
                        mutableAttributedString.append(NSAttributedString(string: dateString, attributes: subtitleAttributes))
                    }
                    
                    completion(mutableAttributedString)
                } else if let created = asset.creationDate {
                    completion(titleFor(date: created))
                }
            }
        } else if let created = asset.creationDate {
            completion(titleFor(date: created))
        }
    }
    
    private static func titleFor(date: Date) -> NSAttributedString {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        
        let text = NSMutableAttributedString()
        
        text.append(NSAttributedString(string: dateFormatter.string(from: date), attributes: titleAttributes))
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        text.append(NSAttributedString(string: "\n" + dateFormatter.string(from: date), attributes: subtitleAttributes))
        
        return text
    }
}
