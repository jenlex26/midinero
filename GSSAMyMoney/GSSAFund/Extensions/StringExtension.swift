//
//  StringExtension.swift
//  GSSAFund
//
//  Created by Usuario Phinder 2021 on 04/08/21.
//

import Foundation

extension String {
    func numbergrouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
       let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
       return String(cleanedUpCopy.enumerated().map() {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
       }.joined().dropFirst())
    }
    
}
