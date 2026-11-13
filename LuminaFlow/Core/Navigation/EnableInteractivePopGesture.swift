//
//  NavigationControllerPopGesture.swift
//  LuminaFlow
//
//  Created by Ali Görkem Aksöz on 13.11.2026.
//

import SwiftUI
import UIKit

struct EnableInteractivePopGesture: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Controller {
        Controller()
    }

    func updateUIViewController(_ uiViewController: Controller, context: Context) {}

    final class Controller: UIViewController, UIGestureRecognizerDelegate {
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            enablePopGesture()
        }

        private func enablePopGesture() {
            guard let nav = nearestNavigationController() else { return }
            nav.interactivePopGestureRecognizer?.isEnabled = true
            nav.interactivePopGestureRecognizer?.delegate = self
        }

        private func nearestNavigationController() -> UINavigationController? {
            var current: UIViewController? = self
            while let c = current {
                if let nav = c as? UINavigationController { return nav }
                if let nav = c.navigationController { return nav }
                current = c.parent
            }
            return nil
        }

        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            (nearestNavigationController()?.viewControllers.count ?? 0) > 1
        }
    }
}
