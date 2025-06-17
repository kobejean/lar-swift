//
//  Misc.swift
//  LARScan
//
//  Created by Jean Flaherty on 2022/01/30.
//

import Foundation
import LocalizeAR
import SceneKit

func prioritizedLandmarks(_ landmarks: [LARLandmark], max: Int) -> AnySequence<LARLandmark> {
    let seq = landmarks.sorted(by: {
        $0.lastSeen > $1.lastSeen || ($0.lastSeen == $1.lastSeen && $0.isMatched)
    }).prefix(max)
    return AnySequence(seq)
}
