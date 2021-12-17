//
//  Array.swift
//  Wikipedia
//
//  Created by Carmine Porricelli on 09/12/21.
//

import Foundation

extension Array {
    func elementAtIndex(_ index: Int) -> Element? {
        if self.count > index {
            return self[index]
        }
        return nil
    }
}


extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
