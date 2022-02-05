//
//  File.swift
//  
//
//  Created by Jean Flaherty on 2022/02/02.
//

import Foundation
import MapKit

public class LARMKUserLocationAnnotationView: MKAnnotationView {

    // MARK: Initialization

    public init(annotation: MKAnnotation?, color: UIColor, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        canShowCallout = false
        setupUI(color: color)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Setup

    private func setupUI(color: UIColor) {
        backgroundColor = .clear
        let circleLayer = CAShapeLayer();
        circleLayer.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 10, height: 10)).cgPath
        circleLayer.fillColor = color.cgColor
        layer.addSublayer(circleLayer)
    }
}
