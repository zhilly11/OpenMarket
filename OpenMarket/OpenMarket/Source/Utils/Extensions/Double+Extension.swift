//  OpenMarket - Double+Extension.swift
//  Created by zhilly on 2023/03/31

import UIKit

extension Double {
    func convertNumberFormat() -> String {
        let numberFormatter: NumberFormatter = NumberFormatter()
       
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter.string(for: self) ?? String()
    }
}
