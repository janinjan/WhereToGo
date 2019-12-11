//
//  BaseScreenViewController+extensionSliderView.swift
//  WhereToGo
//
//  Created by Janin Culhaoglu on 10/12/2019.
//  Copyright © 2019 Janin Culhaoglu. All rights reserved.
//

import UIKit

// =========================================
// MARK: - Sliders CardVIew
// =========================================
extension BaseScreenViewController {
    func setupSlider() {
        self.sliderViewController?.removeFromParent()
        self.sliderViewController?.view.removeFromSuperview()
        self.visualEffectView?.isHidden = true
        
        sliderHeight = screenSize.height * sliderRatio - 110
//        var sliderHandleAreaHeight = 200

        visualEffectView = UIVisualEffectView()
        self.visualEffectView.frame = self.mapView.bounds
        self.view.addSubview(visualEffectView)
        visualEffectView.isHidden = true

        sliderViewController = (self.storyboard?.instantiateViewController(withIdentifier: "slider") as! SliderViewController)
        self.addChild(sliderViewController)
        self.view.addSubview(sliderViewController.view)

        sliderViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - sliderHandleAreaHeight, width: self.view.bounds.width, height: sliderHeight)
        sliderViewController.view.clipsToBounds = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BaseScreenViewController.handleSliderTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(BaseScreenViewController.handleSliderPan(recognizer:)))

        sliderViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        sliderViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func handleSliderTap(recognizer:UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            startInteractiveTransition(state: nextState, duration: 0.8)
            continueInteractiveTransition()
        default:
            break
        }
    }

    @objc func handleSliderPan(recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.5)
        case .changed:
            let translation = recognizer.translation(in: self.sliderViewController.handleArea)
            let fractionCompleted = translation.y / sliderHeight
            updateInteractiveTransition(fractionCompleted: sliderVisible ? fractionCompleted : -fractionCompleted)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }

    func animateTransitionIfNeeded(state:SliderState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.sliderViewController.view.frame.origin.y = self.view.frame.height - self.sliderHeight
                case .collapsed:
                    self.sliderViewController.view.frame.origin.y = self.view.frame.height - self.sliderHandleAreaHeight
                }
            }
            frameAnimator.addCompletion { _ in
                self.sliderVisible = !self.sliderVisible
                self.runningAnimations.removeAll()
            }
            frameAnimator.startAnimation()
            self.runningAnimations.append(frameAnimator)

            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    self.sliderViewController.view.layer.cornerRadius = 0
                case .collapsed:
                    self.sliderViewController.view.layer.cornerRadius = 30

                }
            }

            cornerRadiusAnimator.startAnimation()
            runningAnimations.append(cornerRadiusAnimator)

            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.mapView.addSubview(self.visualEffectView)
                    self.visualEffectView.effect = UIBlurEffect(style: .light)
                case .collapsed:
                    self.visualEffectView.effect = nil
                }
            }

            blurAnimator.addCompletion {_ in
                switch state {
                case .expanded:
                    break
                case .collapsed:
                    self.visualEffectView.removeFromSuperview()
                }
            }

            blurAnimator.startAnimation()
            runningAnimations.append(blurAnimator)
        }
    }

    func startInteractiveTransition(state:SliderState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }

    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }

    func continueInteractiveTransition () {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
