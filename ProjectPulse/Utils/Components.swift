//
//  Components.swift
//  ProjectManager
//
//  Created by aj sai on 14/07/25.
//

import UIKit
import SwiftUI

class UIBackdropView: UIView {
    override class var layerClass: AnyClass {
        NSClassFromString("CABackdropLayer") ?? CALayer.self
    }
}

struct Backdrop: UIViewRepresentable {
    func makeUIView(context: Context) -> UIBackdropView {
        UIBackdropView()
    }
    
    func updateUIView(_ uiView: UIBackdropView, context: Context) {}
}

struct Blur: View {
    var radius: CGFloat = 3
    var opaque: Bool = false
    
    var body: some View {
        Backdrop()
            .blur(radius: radius, opaque: opaque)
    }
}
struct BackgroundColorPicker: View {
    @Binding var selected: String
    let backgrounds: [String]

    var body: some View {
        HStack {
            Text("Background")
            Spacer()
            ForEach(backgrounds, id: \.self) { bg in
                BackgroundColorCircle(bg: bg, selected: $selected)
            }
        }
    }
}

struct BackgroundColorCircle: View {
    let bg: String
    @Binding var selected: String

    var body: some View {
        Circle()
            .fill(Color(hex: bg))
            .frame(width: 24, height: 24)
            .overlay(
                Circle().stroke(selected == bg ? Color.blue : .clear, lineWidth: 2)
            )
            .onTapGesture {
                selected = bg
            }
    }
}

struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner

    struct CornerRadiusShape: Shape {
        var radius = CGFloat.infinity
        var corners = UIRectCorner.allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }

    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius, corners: corners))
    }
}
