#if !os(macOS)
import UIKit


class EntryCell: UITableViewCell {
    
    let vertical = 8
    let horizontal = 12
    
    let methodLabel = UILabel()
    let dateLabel = UILabel()
    let urlLabel = UILabel()
    let statusIndicator = UIView()
    
    func configure(for request: Request) {
        methodLabel.text = "[\(request.method ?? NA)]"
        methodLabel.textColor = request.methodColor
        
        if let time = request.timeIntervalString() {
            if let statusCode = request.response?.statusCode {
                dateLabel.text = request.formattedDate() + " (\(statusCode) - \(time))"
            } else {
                dateLabel.text = request.formattedDate() + " (\(time))"
            }
        } else {
            dateLabel.text = request.formattedDate()
        }
        urlLabel.text = request.url
        
        statusIndicator.backgroundColor = request.colorStatus
        
        methodLabel.sizeToFit()
        
        methodLabel.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(vertical)
            make.leading.equalToSuperview().offset(horizontal)
            make.width.equalTo(methodLabel.frame.size.width)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        accessoryType = .disclosureIndicator
        
        contentView.addSubview(methodLabel)
        methodLabel.font = .boldSystemFont(ofSize: 12)
        methodLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset((vertical + 1))
            make.leading.equalToSuperview().offset(horizontal)
            make.width.equalTo(methodLabel.frame.size.width)
        }
        
        contentView.addSubview(dateLabel)
        dateLabel.textColor = .darkText
        dateLabel.font = .boldSystemFont(ofSize: 12)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(methodLabel)
            make.leading.equalTo(methodLabel.snp.trailing).offset(8)
            make.trailing.equalToSuperview().offset(-horizontal)
        }
        
        contentView.addSubview(statusIndicator)
        statusIndicator.layer.cornerRadius = 8
        statusIndicator.backgroundColor = .gray
        statusIndicator.snp.makeConstraints { make in
            make.top.equalTo(methodLabel.snp.bottom).offset(vertical)
            make.width.height.equalTo(16)
            make.leading.equalTo(methodLabel)
        }
        
        contentView.addSubview(urlLabel)
        urlLabel.font = .systemFont(ofSize: 12)
        urlLabel.textColor = .darkText
        urlLabel.lineBreakMode = .byTruncatingMiddle
        urlLabel.snp.makeConstraints { make in
            make.top.equalTo(statusIndicator).offset(1)
            make.leading.equalTo(statusIndicator.snp.trailing).offset(8)
            make.trailing.equalTo(dateLabel)
            make.bottom.equalToSuperview().offset(-(vertical + 1))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#endif
