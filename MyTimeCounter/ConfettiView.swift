//
//  ConfettiView.swift
//  MyTimeCounter
//
//  Created by Javier Rodríguez Gómez on 23/10/22.
//

import SwiftUI


func getRect() -> CGRect {
    return UIScreen.main.bounds
}

struct EmitterView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterCells = createEmitterCells()
        emitterLayer.emitterSize = CGSize(width: getRect().width, height: 1)
        emitterLayer.emitterPosition = CGPoint(x: getRect().width / 2, y: 0)
        
        view.layer.addSublayer(emitterLayer)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { }
    
    func createEmitterCells() -> [CAEmitterCell] {
        var emitterCells: [CAEmitterCell] = []
        for _ in 1...12 {
            let cell = CAEmitterCell()
            cell.contents = UIImage(named: "heart.fill")?.cgImage
            cell.color = getColor().cgColor
            cell.birthRate = 4.5
            cell.lifetime = 20
            cell.velocity = 120
            cell.scale = 0.25
            cell.scaleRange = 0.3
            cell.emissionLongitude = .pi
            cell.emissionRange = 0.5
            cell.spin = 3.5
            cell.spinRange = 1
            cell.yAcceleration = 40
            
            emitterCells.append(cell)
        }
        
        return emitterCells
    }
        
    func getColor() -> UIColor {
        let colors: [UIColor] = [.systemPink, .systemGreen, .systemPurple, .systemRed, .systemBlue, .systemOrange, .systemCyan]
        return colors.randomElement()!
    }
}
