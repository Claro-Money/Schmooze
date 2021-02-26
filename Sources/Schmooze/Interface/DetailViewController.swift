#if !os(macOS)
import UIKit
import SnapKit


class DetailViewController: UIViewController {
    
    let request: Request
    
    let scrollView = UIScrollView()
    
    let statusIndicator = UIView()
    
    let methodLabel = UILabel()
    let requestDateLabel = UILabel()
    let responseDateLabel = UILabel()
    let responseTimeLabel = UILabel()
    let urlLabel = UILabel()
    let mimeLabel = UILabel()
    let maxTimeoutLabel = UILabel()
    let requestHeadersLabel = UILabel()
    let responseHeadersLabel = UILabel()
    let contentBox = UILabel()
    let errorLabel = UILabel()
    
    init(_ request: Request) {
        self.request = request
                
        super.init(nibName: nil, bundle: nil)
        
        title = request.url
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = statusIndicator
        statusIndicator.layer.cornerRadius = 12
        statusIndicator.backgroundColor = request.colorStatus
        statusIndicator.snp.makeConstraints { make in
            make.width.height.equalTo(24)
        }
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(methodLabel)
        methodLabel.font = .boldSystemFont(ofSize: 14)
        methodLabel.textColor = request.methodColor
        methodLabel.text = "[\(request.method ?? NA)]"
        methodLabel.snp.makeConstraints { make in
            make.top.equalTo(22)
            set(sides: make)
        }
        
        scrollView.addSubview(urlLabel)
        urlLabel.font = .systemFont(ofSize: 14)
        urlLabel.textColor = .darkText
        urlLabel.numberOfLines = 0
        urlLabel.lineBreakMode = .byCharWrapping
        urlLabel.text = request.url
        urlLabel.snp.makeConstraints { make in
            set(top: methodLabel, on: make)
            set(sides: make)
        }
        
        scrollView.addSubview(requestDateLabel)
        requestDateLabel.textColor = .darkText
        requestDateLabel.font = .boldSystemFont(ofSize: 14)
        requestDateLabel.numberOfLines = 0
        requestDateLabel.text = "Requested:\n\(request.formattedDate())"
        requestDateLabel.snp.makeConstraints { make in
            set(top: urlLabel, on: make)
            set(sides: make)
        }
        
        scrollView.addSubview(responseDateLabel)
        responseDateLabel.textColor = .darkText
        responseDateLabel.font = .boldSystemFont(ofSize: 14)
        responseDateLabel.numberOfLines = 0
        responseDateLabel.text = "Response:\n\(request.response?.formattedDate() ?? "waiting ...")"
        responseDateLabel.snp.makeConstraints { make in
            set(top: requestDateLabel, on: make)
            set(sides: make)
        }
        
        scrollView.addSubview(responseTimeLabel)
        responseTimeLabel.textColor = .darkText
        responseTimeLabel.font = .boldSystemFont(ofSize: 14)
        responseTimeLabel.numberOfLines = 0
        responseTimeLabel.text = "Response in:\n\(request.timeIntervalString() ?? "waiting ...")"
        responseTimeLabel.snp.makeConstraints { make in
            set(top: responseDateLabel, on: make)
            set(sides: make)
        }
        
        scrollView.addSubview(mimeLabel)
        mimeLabel.textColor = .darkText
        mimeLabel.font = .systemFont(ofSize: 14)
        mimeLabel.text = "MIME: \(request.response?.mimeType ?? NA)"
        mimeLabel.snp.makeConstraints { make in
            set(top: responseTimeLabel, on: make)
            set(sides: make)
        }
        
        scrollView.addSubview(maxTimeoutLabel)
        maxTimeoutLabel.textColor = .darkText
        maxTimeoutLabel.font = .systemFont(ofSize: 14)
        maxTimeoutLabel.text = "Max timeout: \(request.timeoutInterval)s"
        maxTimeoutLabel.snp.makeConstraints { make in
            set(top: mimeLabel, on: make)
            set(sides: make)
        }
        
        
        let requestHeadersTitleLabel = add(title: "Request headers:", below: maxTimeoutLabel)
        
        scrollView.addSubview(requestHeadersLabel)
        requestHeadersLabel.text = request.headers?.asFormattedText() ?? NA
        set(codeLabel: requestHeadersLabel, below: requestHeadersTitleLabel)
        
        let responseHeadersTitleLabel = add(title: "Response headers:", below: requestHeadersLabel)
        
        scrollView.addSubview(responseHeadersLabel)
        responseHeadersLabel.text = request.response?.headers.asFormattedText() ?? NA
        set(codeLabel: responseHeadersLabel, below: responseHeadersTitleLabel)
        
        let contentTitleLabel = add(title: "Content:", below: responseHeadersLabel)
        
        scrollView.addSubview(contentBox)
        set(codeLabel: contentBox, below: contentTitleLabel)
        if let data = request.response?.data {
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                if let prettyString = String(data: prettyData, encoding: .utf8) {
                    contentBox.text = prettyString
                }
            } catch {
                if let dataString = String(data: data, encoding: .utf8) {
                    contentBox.text = dataString
                }
            }
        }
        if contentBox.text == nil || contentBox.text?.isEmpty == true {
            contentBox.text = NA
        }
        
        let errorTitleLabel = add(title: "Error:", below: contentBox)
        
        scrollView.addSubview(errorLabel)
        errorLabel.text = request.response?.errorDescription ?? NA
        errorLabel.font = UIFont(name: "Courier", size: 13)
        errorLabel.textColor = .darkText
        errorLabel.numberOfLines = 0
        errorLabel.lineBreakMode = .byCharWrapping
        errorLabel.snp.makeConstraints { make in
            set(top: errorTitleLabel, on: make)
            set(sides: make)
            make.bottom.greaterThanOrEqualToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(sides make: ConstraintMaker) {
        make.leading.equalToSuperview().offset(12)
        make.trailing.equalToSuperview().offset(-12)
        make.width.lessThanOrEqualTo(view).offset(-24)
    }
    
    func set(top view: UIView, on make: ConstraintMaker) {
        make.top.equalTo(view.snp.bottom).offset(16)
    }
    
    func set(codeLabel label: UILabel, below view: UIView) {
        label.font = UIFont(name: "Courier", size: 13)
        label.textColor = .darkText
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.snp.makeConstraints { make in
            set(top: view, on: make)
            set(sides: make)
        }
    }
    
    func add(title: String, below view: UIView) -> UILabel {
        let label = UILabel()
        scrollView.addSubview(label)
        label.textColor = .darkText
        label.font = .boldSystemFont(ofSize: 14)
        label.text = title
        label.snp.makeConstraints { make in
            set(top: view, on: make)
            set(sides: make)
        }
        return label
    }
    
}
#endif
