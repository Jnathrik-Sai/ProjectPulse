//
//  nonBouncingScrollView.swift
//  ProjectPulse
//
//  Created by aj sai on 11/09/25.
//

import Foundation
import SwiftUI

struct NonBouncingScrollView<Content: View>: UIViewRepresentable {
    @Binding var bottomGradientOpacity: CGFloat
    let content: Content

    init(bottomGradientOpacity: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
        self._bottomGradientOpacity = bottomGradientOpacity
        self.content = content()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = false
        scrollView.delegate = context.coordinator

        let hostedView = UIHostingController(rootView: content)
        hostedView.view.translatesAutoresizingMaskIntoConstraints = false
        hostedView.view.backgroundColor = .clear

        scrollView.addSubview(hostedView.view)

        NSLayoutConstraint.activate([
            hostedView.view.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            hostedView.view.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            hostedView.view.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            hostedView.view.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            hostedView.view.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])

        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if let hostedController = uiView.subviews.first?.next as? UIHostingController<Content> {
            hostedController.rootView = content
        }
    }

    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent: NonBouncingScrollView

        init(parent: NonBouncingScrollView) {
            self.parent = parent
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            let maxOffset = scrollView.contentSize.height - scrollView.bounds.height
            let overscroll = max(scrollView.contentOffset.y - maxOffset, 0)
            DispatchQueue.main.async {
                let maxOpacity: CGFloat = 0.75
                self.parent.bottomGradientOpacity = min(overscroll / 50, maxOpacity)
            }
        }
    }
}
