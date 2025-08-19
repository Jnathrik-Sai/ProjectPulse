//
//  MorphingSymbolView.swift
//  Morphing
//
//  Created by aj sai on 25/01/25.
//

import SwiftUI


struct MorphingSymbolView: View {
    var symbol : String
    var config : Config
    @State private var trigger : Bool = false
    @State private var nextSymbol : String = ""
    @State private var displayingSymbol : String = ""
    var body: some View {
        Canvas{ ctx, size in
            ctx.addFilter(.alphaThreshold(min: 0.4, color: config.foregroundColor))
            if let renderImage = ctx.resolveSymbol(id: 0){
                ctx.draw(renderImage, at: CGPoint(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            ImageView()
                .tag(0)
        }
        .frame(width: config.frame.width, height: config.frame.height)
        .onChange(of: symbol) { oldValue, newValue in
            trigger.toggle()
            nextSymbol = newValue
            
        }
        .task {
            guard displayingSymbol == "" else { return }
            displayingSymbol = symbol
        }
    }
    
    @ViewBuilder
    func ImageView() -> some View {
        KeyframeAnimator(
            initialValue: CGFloat.zero,
            trigger: trigger
        ){ radius in
            Image(systemName: displayingSymbol)
                .font(config.font)
                .blur(radius: 10)
                .frame(width : config.frame.width, height: config.frame.height)
                .onChange(of: radius) { oldValue, newValue in
                    if newValue.rounded() == config.radius {
                        withAnimation(config.symbolAnimation){
                            displayingSymbol = nextSymbol
                        }
                    }
                    
                }
        } keyframes: { _ in
            CubicKeyframe(config.radius, duration: config.keyFrameDuration)
        }
    }
    struct Config{
        var font : Font
        var frame : CGSize
        var radius : CGFloat
        var foregroundColor : Color
        var keyFrameDuration : Double = 0.4
        var symbolAnimation: Animation = .smooth(duration: 0.5, extraBounce: 0)
    }
}

#Preview {
    MorphingSymbolView(
        symbol: "gearshape.fill",
        config: .init(
            font: .system(size: 100, weight: .bold),
            frame: CGSize(width: 250, height: 200),
            radius: 15,
            foregroundColor: .black
        )
    )
}
