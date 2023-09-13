import Foundation

#if canImport(UIKit)
import UIKit

open class LaunchProgressViewController: UIViewController {
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.textColor = .white
        label.text = title
        label.textAlignment = .center
        label.font =  UIFont.systemFont(ofSize: 20)
        label.isHidden = true
        return label
    }()
    
    fileprivate lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    fileprivate let launchSteps: [LaunchStep]
    fileprivate let controller = LaunchStepController()
    
    public var statusBarHidden: Bool = true
    public var statusBarStyle: UIStatusBarStyle = .lightContent
    
    /// - Parameters:
    ///   - launchViewController: launch screen background
    ///   - blurEffectStyle: blur effect applied to the background (default is dark blur)
    ///   - title: title above the progress bar
    ///   - progressTintColor: progress tint color
    ///   - progressCenterYAnchorViewTag: this may be a tag for a view in the storyboard to anchor the progress bar's vertical center to (default is vertical center)
    ///   - progressWidthRatio: ratio of progress bar width to launch screen width (default is 0.9)
    ///   - progressMaxWidth: maximum progress bar width (default is none)
    ///   - launchSteps: launch steps
    public init(launchViewController: UIViewController,
                blurEffectStyle: UIBlurEffect.Style? = .dark,
                title: String? = nil,
                progressTintColor: UIColor? = nil,
                progressCenterYOffset: CGFloat? = nil,
                progressWidthRatio: CGFloat = 0.9,
                progressMaxWidth: CGFloat? = nil,
                launchSteps: [LaunchStep]) {
        self.launchSteps = launchSteps.filter { $0.shouldRun() }
        
        super.init(nibName: nil, bundle: nil)
        
        launchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChild(launchViewController)
        view.addSubview(launchViewController.view)
        launchViewController.didMove(toParent: self)
        
        if let progressTintColor = progressTintColor {
            progressView.progressTintColor = progressTintColor
        }
        
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        var blurEffectView: UIVisualEffectView?
        if let blurEffectStyle = blurEffectStyle {
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
            blurView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(blurView)
            blurEffectView = blurView
        }
        
        view.addSubview(titleLabel)
        view.addSubview(progressView)
        
        let progressWidthRatioConstraint = progressView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: progressWidthRatio)
        progressWidthRatioConstraint.priority = .defaultLow
        
        var constraints = [
            launchViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            launchViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: (progressCenterYOffset ?? 0)),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10),
            progressWidthRatioConstraint
        ]
        
        if let progressMaxWidth = progressMaxWidth {
            constraints.append(progressView.widthAnchor.constraint(lessThanOrEqualToConstant: progressMaxWidth))
        }
        
        if let blurEffectView = blurEffectView {
            constraints.append(blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
            constraints.append(blurEffectView.topAnchor.constraint(equalTo: view.topAnchor))
            constraints.append(blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
            constraints.append(blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    /// - Parameters:
    ///   - launchScreenStoryboard: launch screen background
    ///   - blurEffectStyle: blur effect applied to the background (default is dark blur)
    ///   - title: title above the progress bar
    ///   - progressTintColor: progress tint color
    ///   - progressCenterYAnchorViewTag: this may be a tag for a view in the storyboard to anchor the progress bar's vertical center to (default is vertical center)
    ///   - progressWidthRatio: ratio of progress bar width to launch screen width (default is 0.9)
    ///   - progressMaxWidth: maximum progress bar width (default is none)
    ///   - launchSteps: launch steps
    public init(launchScreenStoryboard: UIStoryboard,
                blurEffectStyle: UIBlurEffect.Style? = .dark,
                title: String? = nil,
                progressTintColor: UIColor? = nil,
                progressCenterYAnchorViewTag: Int? = nil,
                progressWidthRatio: CGFloat = 0.9,
                progressMaxWidth: CGFloat? = nil,
                launchSteps: [LaunchStep]) {
        self.launchSteps = launchSteps.filter { $0.shouldRun() }
        
        super.init(nibName: nil, bundle: nil)
        
        guard let launchViewController = launchScreenStoryboard.instantiateInitialViewController() else { return }
        launchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        let progressCenterYAnchorView = progressCenterYAnchorViewTag.flatMap { launchViewController.view.viewWithTag($0) }
        
        addChild(launchViewController)
        view.addSubview(launchViewController.view)
        launchViewController.didMove(toParent: self)
        
        if let progressTintColor = progressTintColor {
            progressView.progressTintColor = progressTintColor
        }
        
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }
        
        var blurEffectView: UIVisualEffectView?
        if let blurEffectStyle = blurEffectStyle {
            let blurView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
            blurView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(blurView)
            blurEffectView = blurView
        }
        
        view.addSubview(titleLabel)
        view.addSubview(progressView)
        
        let progressWidthRatioConstraint = progressView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: progressWidthRatio)
        progressWidthRatioConstraint.priority = .defaultLow
        
        var constraints = [
            launchViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            launchViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: progressCenterYAnchorView?.centerYAnchor ?? view.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10),
            progressWidthRatioConstraint
        ]
        
        if let progressMaxWidth = progressMaxWidth {
            constraints.append(progressView.widthAnchor.constraint(lessThanOrEqualToConstant: progressMaxWidth))
        }
        
        if let blurEffectView = blurEffectView {
            constraints.append(blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor))
            constraints.append(blurEffectView.topAnchor.constraint(equalTo: view.topAnchor))
            constraints.append(blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor))
            constraints.append(blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        }
        
        NSLayoutConstraint.activate(constraints)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func showProgress() -> Bool {
        return launchSteps.contains(where: { $0.showProgress() })
    }
    
    open func startLaunchSteps(simultaneous: Bool, completion: @escaping () -> Void) {
        guard !launchSteps.isEmpty else {
            // No Launch Steps to run
            completion()
            return
        }
        
        let hideProgress = !showProgress()
        progressView.isHidden = hideProgress
        titleLabel.isHidden = hideProgress
        
        controller.launch(launchSteps: launchSteps, simultaneous: simultaneous, progress: { [weak self] amount in
            DispatchQueue.main.async { [weak self] in
                let currentProgress = self?.progressView.progress ?? 0
                // Progress should be between 0 and 1, and never go backwards
                self?.progressView.progress = max(0, min(max(amount, currentProgress), 1))
            }
        }, completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
    open override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
}
#else

#endif
