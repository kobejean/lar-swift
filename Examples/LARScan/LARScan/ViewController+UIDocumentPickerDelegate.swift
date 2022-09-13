//
//  ViewController+MKMapViewDelegate.swift
//  LARScan
//
//  Created by Jean Flaherty on 2022/02/02.
//

import Foundation
import MapKit
import LocalizeAR

extension ViewController: UIDocumentPickerDelegate {
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        // document is picked after load button is pressed
        if let directory = urls.first {
            let filePath = directory.appendingPathComponent("map.json").path
            tracker = LARTracker(map: LARMap(contentsOf: filePath))
            localizeButton.isEnabled = true
        }
    }
    
}
