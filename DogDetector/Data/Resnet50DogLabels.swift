//
//  Resnet50DogLabels.swift
//  DogDetector
//
//  Created by Quoc Nguyen on 1/15/18.
//  Copyright © 2018 Quoc Nguyen. All rights reserved.
//

import Foundation

struct Resnet50DogLabels: Codable {
    let dog: [String]

    static func dogsLabel() -> [String] {
        guard let file = Bundle.main.url(forResource: "Resnet50Dog", withExtension: "json") else {
            return []
        }
        guard let resnetDog = Resnet50DogLabels(from: file) else {
            return []
        }
        return resnetDog.dog
    }
}

// MARK: Convenience initializers

extension Resnet50DogLabels {
    init?(from url: URL) {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        self.init(data: data)
    }

    init?(data: Data) {
        guard let me = try? JSONDecoder().decode(Resnet50DogLabels.self, from: data) else { return nil }
        self = me
    }
}
