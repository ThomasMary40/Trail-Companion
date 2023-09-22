//
//  PageViewController.swift
//  Trail Companion
//
//  Created by Thomas Mary on 17/08/2023.
//

import Foundation
import SwiftUI

/// The page view controller stores an array of Page instances, which must be a type of View.
/// These are the pages you use to scroll.
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    @Binding var currentPage: Int
    
    /// SwiftUI calls this makeCoordinator() method before makeUIViewController(context:), so that you have access to the coordinator object when configuring your view controller.
    /// Tip : You can use this coordinator to implement common Cocoa patterns,
    /// such as delegates, data sources, and responding to user events via target-action.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /// SwiftUI calls this method a single time when it’s ready to display the view,
    /// and then manages the view controller’s life cycle.
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
           
        return pageViewController
    }
    
    /// For now, you create the UIHostingController that hosts the page SwiftUI view on every update.
    /// Later, you’ll make this more efficient by initializing the controller only once for the life of the page view controller.
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    /// A SwiftUI view that represents a UIKit view controller can define a Coordinator type
    /// that SwiftUI manages and provides as part of the representable view’s context.
    /// SwiftUI manages your UIViewControllerRepresentable type’s coordinator,
    /// and provides it as part of the context when calling the methods you created above.
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()
        
        /// The coordinator is a good place to store these controllers,
        /// because the system initializes them only once,
        /// and before you need them to update the view controller.
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }
        
        // UIPageViewControllerDataSource
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            
            if index == 0 {
                return nil
            }
            
            return controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else {
                return nil
            }
            
            if index + 1 == controllers.count {
                return nil
            }
            
            return controllers[index + 1]
        }
        
        // UIPageViewControllerDelegate
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
                if completed,
                   let visibleViewController = pageViewController.viewControllers?.first,
                   let index = controllers.firstIndex(of: visibleViewController) {
                    parent.currentPage = index
                }
            }
    }
}
