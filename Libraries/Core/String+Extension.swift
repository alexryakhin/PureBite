//
//  String+Extension.swift
//  PureBite
//
//  Created by Aleksandr Riakhin on 8/24/24.
//

import Foundation

extension String {
    var htmlStringFormatted: AttributedString {
        if let nsAttributedString = try? NSAttributedString(data: Data(self.utf8), options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            var attributedString = AttributedString(nsAttributedString)

            attributedString.font = .body
            attributedString.foregroundColor = .label
            attributedString.underlineColor = .accent
            return attributedString
        } else {
            return AttributedString(self)
        }
    }
}
