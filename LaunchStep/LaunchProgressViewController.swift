
public class LaunchProgressViewController: UIViewController {
    
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
    
    public init(launchScreenStoryboard: UIStoryboard, blurEffectStyle: UIBlurEffectStyle = .dark, title: String? = nil, progressTintColor: UIColor? = nil, launchSteps: [LaunchStep]) {
        self.launchSteps = launchSteps
        
        super.init(nibName: nil, bundle: nil)

        guard let launchViewController = launchScreenStoryboard.instantiateInitialViewController() else { return }
        launchViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        addChildViewController(launchViewController)
        view.addSubview(launchViewController.view)
        launchViewController.didMove(toParentViewController: self)

        if let progressTintColor = progressTintColor {
            progressView.progressTintColor = progressTintColor
        }
        
        if let title = title {
            titleLabel.text = title
            titleLabel.isHidden = false
        }

        let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: blurEffectStyle))
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)
        
        view.addSubview(titleLabel)
        view.addSubview(progressView)
        
        // Center the progress view
        NSLayoutConstraint.activate([
            launchViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            launchViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            launchViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            launchViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            progressView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            progressView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            progressView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -10)
        ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func showProgress() -> Bool {
        return launchSteps.filter { $0.shouldRun() }.contains(where: { $0.showProgress() })
    }
    
    public func startLaunchSteps(simultaneous: Bool, completion: @escaping () -> Void) {
        guard !launchSteps.filter({ $0.shouldRun() }).isEmpty else {
            // No Launch Steps to run
            completion()
            return
        }

        let hideProgress = !showProgress()
        progressView.isHidden = hideProgress
        titleLabel.isHidden = hideProgress
        
        controller.launch(launchSteps: launchSteps, simultaneous: simultaneous, progress: { [weak self] amount in
            DispatchQueue.main.async {
                self?.progressView.progress = amount
            }
        }, completion: {
            DispatchQueue.main.async {
                completion()
            }
        })
    }
    
}
