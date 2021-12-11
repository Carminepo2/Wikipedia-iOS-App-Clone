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
