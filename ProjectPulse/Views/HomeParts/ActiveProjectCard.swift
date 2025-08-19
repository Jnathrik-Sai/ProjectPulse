//
//  ActiveProjectCard.swift
//  ProjectManager
//
//  Created by aj sai on 14/07/25.
//

import SwiftUI

struct ActiveProjectCard: View {
    var projectId: String

    var body: some View {
            BezierCurveView()
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .padding(.horizontal)
                .padding(.top,6)
        }
}

struct BezierCurve: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Reference size from original drawing
        let maxW: CGFloat = 1019.85
        let maxH: CGFloat = 278.4

        // Rounded rectangle
        let cornerRadius: CGFloat = 72.4 / maxW * rect.width
        let roundedRect = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
        path.addRoundedRect(in: roundedRect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
        
        // Bezier Curve - overlay shape
        path.move(to: CGPoint(x: 548.73 / maxW * rect.width, y: 0.5 / maxH * rect.height))
        path.addCurve(
            to: CGPoint(x: 613.29 / maxW * rect.width, y: 59.56 / maxH * rect.height),
            control1: CGPoint(x: 548.73 / maxW * rect.width, y: 0.5 / maxH * rect.height),
            control2: CGPoint(x: 558.78 / maxW * rect.width, y: 61.06 / maxH * rect.height)
        )
        path.addCurve(
            to: CGPoint(x: 1018.56 / maxW * rect.width, y: 59.58 / maxH * rect.height),
            control1: CGPoint(x: 667.81 / maxW * rect.width, y: 58.05 / maxH * rect.height),
            control2: CGPoint(x: 1018.56 / maxW * rect.width, y: 59.58 / maxH * rect.height)
        )
        path.addCurve(
            to: CGPoint(x: 997.43 / maxW * rect.width, y: 20.97 / maxH * rect.height),
            control1: CGPoint(x: 1018.56 / maxW * rect.width, y: 59.58 / maxH * rect.height),
            control2: CGPoint(x: 1013.38 / maxW * rect.width, y: 36.94 / maxH * rect.height)
        )
        path.addCurve(
            to: CGPoint(x: 968.35 / maxW * rect.width, y: 3.48 / maxH * rect.height),
            control1: CGPoint(x: 988.25 / maxW * rect.width, y: 11.79 / maxH * rect.height),
            control2: CGPoint(x: 976.6 / maxW * rect.width, y: 6.4 / maxH * rect.height)
        )
        path.addCurve(
            to: CGPoint(x: 950.79 / maxW * rect.width, y: 0.5 / maxH * rect.height),
            control1: CGPoint(x: 962.69 / maxW * rect.width, y: 1.47 / maxH * rect.height),
            control2: CGPoint(x: 956.76 / maxW * rect.width, y: 0.5 / maxH * rect.height)
        )
        path.addLine(to: CGPoint(x: 548.73 / maxW * rect.width, y: 0.5 / maxH * rect.height))
        path.closeSubpath()
        
        return path
    }
}

struct BezierCurveView: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                BezierCurve()
                    .fill(Color.white)
                
                BezierCurve()
                    .stroke(Color.black.opacity(0.1), lineWidth: 1)
                ZStack(alignment: .top) {
                    // Top right label
                    Text("Created By Max")
                        .font(.system(size: 13))
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity, alignment: .topTrailing)
                        .padding(.horizontal, 50)
                        .padding(.top, 3)

                    // Main content
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 10) {
                            // Folder Icon
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.black)
                                    .frame(width: 40, height: 40)
                                Image(systemName: "folder")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundStyle(.white)
                                    .frame(width: 24, height: 24)
                            }
                            // Text Stack
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Mobile App Development")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)

                                Text("Time")
                                    .font(.caption)
                            }
                        }
                        .padding(.top, 25)
                        .padding(.horizontal, 15)

                        // Progress bar
                        ProgressView(value: 0.6) // Example: 60% complete
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .frame(height: 3)
                            .padding(.horizontal, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .top
                )
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .aspectRatio(1019.85 / 278.4, contentMode: .fit)
    }
}
#Preview {
    TabBarContentView()
}
