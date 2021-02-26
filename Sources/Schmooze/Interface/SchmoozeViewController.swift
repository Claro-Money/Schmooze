#if !os(macOS)
import Presentables


public class SchmoozeViewController: PresentableTableViewController {
    
    init(tracker: Tracker = Tracker.default) {
        self.tracker = tracker
        
        super.init(nibName: nil, bundle: nil)
        
        setup()
        setupData()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Active tracker
    public var tracker: Tracker {
        didSet {
            setupData()
        }
    }
    
    let section = PresentableSection()
    
    @available(*, unavailable)
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        data.append(section)
    }
    
    // MARK: Setup
    
    func setup() {
        let close = UIBarButtonItem(barButtonSystemItem: .done, target: SchmoozeViewController.launcher, action: #selector(SchmoozeViewController.Launcher.hide))
        navigationItem.leftBarButtonItem = close
        
        title = "Schmooze"
        
        let reload = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(setupData))
        navigationItem.rightBarButtonItem = reload
        
        presentableManager.selectedCell = { info in
            info.tableView.deselectRow(at: info.indexPath, animated: true)
        }
    }
    
    @objc func setupData() {
        section.removeAll()
        tracker.requests.bindAndFire { requests in
            for request in requests.reversed() {
                let presentable = Presentable<EntryCell>.create({ cell in
                    cell.configure(for: request)
                }).cellSelected {
                    self.show(detail: request)
                }
                self.section.append(presentable)
            }
        }
        tableView.reloadData()
    }
    
    func show(detail request: Request) {
        let detail = DetailViewController(request)
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func prepareToBeRemoved() {
        tracker.requests.bind(listener: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupData()
    }
    
}

extension SchmoozeViewController {
    
    class Launcher: NSObject {
        
        var oldViewController: UIViewController? = nil
        
        @objc func showSchmooze() {
            SchmoozeViewController.show()
        }
        
        @objc func hide() {
            SchmoozeViewController.hide()
        }
        
    }
    
    static let launcher = Launcher()
    
    public static var defaultRecognizer: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer()
        #if targetEnvironment(simulator)
        tap.numberOfTouchesRequired = 2
        tap.numberOfTapsRequired = 3
        #else
        tap.numberOfTouchesRequired = 3
        tap.numberOfTapsRequired = 3
        #endif
        tap.addTarget(launcher, action: #selector(Launcher.showSchmooze))
        return tap
    }()
    
    
    /// Setup Schmooze on an active window
    /// - Parameters:
    ///   - window: UIWindow
    ///   - gestureRecognizer: Triggering gesture recognizer (optional, default 3 taps, three fingers, two on simulator)
    public static func register(with window: UIWindow, gestureRecognizer: UIGestureRecognizer = defaultRecognizer) {
        window.addGestureRecognizer(gestureRecognizer)
    }
    
    /// Show Schmooze window
    /// - Parameter tracker: Custom Tracker (optional)
    public static func show(tracker: Tracker = Tracker.default) {
        launcher.oldViewController = keyWindow?.rootViewController
        
        let controller = SchmoozeViewController()
        controller.tracker = tracker
        keyWindow?.rootViewController = UINavigationController(rootViewController: controller)
    }
    
    /// Hide Schmooze
    public static func hide() {
        (keyWindow?.rootViewController as? SchmoozeViewController)?.prepareToBeRemoved()
        keyWindow?.rootViewController = launcher.oldViewController
        launcher.oldViewController = nil
    }
    
    private static var keyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first
    }
    
}

#endif
