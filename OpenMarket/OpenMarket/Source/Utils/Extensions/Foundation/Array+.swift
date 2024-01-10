//  OpenMarket - Array+.swift
//  Created by zhilly on 2023/03/18

extension Array {
    public subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
