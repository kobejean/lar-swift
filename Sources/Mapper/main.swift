//
//  main.swift
//  
//
//  Created by Jean Flaherty on 2021/12/27.
//

import LocalAR
//import opencv2

let processor = MapProcessing()
processor.createMap("/Users/kobejean/Developer/GitHub/GeoARCore/input/snapshot")


let image = Imgcodecs.imread(filename: "/Users/kobejean/Developer/GitHub/GeoARCore/input/snapshot/00000001_image.jpeg", flags: ImreadModes.IMREAD_GRAYSCALE.rawValue)
var intrinsics = Mat(rows: 3, cols: 3, type: CvType.CV_32FC1)
try intrinsics.put(row: 0, col: 0, data: [1594.2728271484375])
try intrinsics.put(row: 1, col: 1, data: [1594.2728271484375])
try intrinsics.put(row: 0, col: 2, data: [952.7379150390625])
try intrinsics.put(row: 1, col: 2, data: [714.167236328125])
try intrinsics.put(row: 2, col: 2, data: [1.0])


var transform = Mat()

let map = Map(fromFile: "/Users/kobejean/Developer/GitHub/GeoARCore/input/snapshot/map.json")
let tracker = Tracking(map: map)
tracker.localize(image, intrinsics: intrinsics, transform: transform)
print(transform)
