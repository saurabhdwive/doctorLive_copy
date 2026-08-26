import UIKit

class ChatRightPdfCell: UITableViewCell {
    
    let bubbleView = UIView()
    let pdfIcon = UIImageView()
    let fileNameLbl = UILabel()
    let timeLbl = UILabel()
    let pdfBtn = UIButton(type: .system)
    
    var pdfBtnTapped: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.backgroundColor = UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
        bubbleView.layer.cornerRadius = 12
        self.contentView.addSubview(bubbleView)
        
        pdfIcon.translatesAutoresizingMaskIntoConstraints = false
        pdfIcon.image = UIImage(systemName: "doc.text.fill")?.withTintColor(UIColor(red: 234/255.0, green: 67/255.0, blue: 53/255.0, alpha: 1.0), renderingMode: .alwaysOriginal)
        pdfIcon.contentMode = .scaleAspectFit
        bubbleView.addSubview(pdfIcon)
        
        fileNameLbl.translatesAutoresizingMaskIntoConstraints = false
        fileNameLbl.textColor = .white
        fileNameLbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        fileNameLbl.numberOfLines = 2
        fileNameLbl.lineBreakMode = .byTruncatingMiddle
        bubbleView.addSubview(fileNameLbl)
        
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        timeLbl.textColor = .white
        timeLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        timeLbl.textAlignment = .right
        bubbleView.addSubview(timeLbl)
        
        pdfBtn.translatesAutoresizingMaskIntoConstraints = false
        pdfBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        bubbleView.addSubview(pdfBtn)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            bubbleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -12),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            pdfIcon.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            pdfIcon.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            pdfIcon.widthAnchor.constraint(equalToConstant: 30),
            pdfIcon.heightAnchor.constraint(equalToConstant: 35),
            
            fileNameLbl.leadingAnchor.constraint(equalTo: pdfIcon.trailingAnchor, constant: 12),
            fileNameLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            fileNameLbl.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            
            timeLbl.topAnchor.constraint(equalTo: fileNameLbl.bottomAnchor, constant: 4),
            timeLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            
            pdfBtn.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            pdfBtn.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            pdfBtn.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            pdfBtn.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor)
        ])
    }
    
    @objc func btnTapped() {
        pdfBtnTapped?()
    }
}

class ChatLeftPdfCell: UITableViewCell {
    
    let bubbleView = UIView()
    let pdfIcon = UIImageView()
    let fileNameLbl = UILabel()
    let timeLbl = UILabel()
    let pdfBtn = UIButton(type: .system)
    
    var pdfBtnTapped: (() -> ())?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.backgroundColor = UIColor(red: 227/255.0, green: 240/255.0, blue: 254/255.0, alpha: 1.0)
        bubbleView.layer.cornerRadius = 12
        self.contentView.addSubview(bubbleView)
        
        pdfIcon.translatesAutoresizingMaskIntoConstraints = false
        pdfIcon.image = UIImage(systemName: "doc.text.fill")?.withTintColor(UIColor(red: 234/255.0, green: 67/255.0, blue: 53/255.0, alpha: 1.0), renderingMode: .alwaysOriginal)
        pdfIcon.contentMode = .scaleAspectFit
        bubbleView.addSubview(pdfIcon)
        
        fileNameLbl.translatesAutoresizingMaskIntoConstraints = false
        fileNameLbl.textColor = .black
        fileNameLbl.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        fileNameLbl.numberOfLines = 2
        fileNameLbl.lineBreakMode = .byTruncatingMiddle
        bubbleView.addSubview(fileNameLbl)
        
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        timeLbl.textColor = .darkGray
        timeLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        timeLbl.textAlignment = .right
        bubbleView.addSubview(timeLbl)
        
        pdfBtn.translatesAutoresizingMaskIntoConstraints = false
        pdfBtn.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        bubbleView.addSubview(pdfBtn)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 5),
            bubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -5),
            bubbleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 12),
            bubbleView.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
            
            pdfIcon.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            pdfIcon.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            pdfIcon.widthAnchor.constraint(equalToConstant: 30),
            pdfIcon.heightAnchor.constraint(equalToConstant: 35),
            
            fileNameLbl.leadingAnchor.constraint(equalTo: pdfIcon.trailingAnchor, constant: 12),
            fileNameLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            fileNameLbl.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 12),
            
            timeLbl.topAnchor.constraint(equalTo: fileNameLbl.bottomAnchor, constant: 4),
            timeLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -8),
            
            pdfBtn.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor),
            pdfBtn.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor),
            pdfBtn.topAnchor.constraint(equalTo: bubbleView.topAnchor),
            pdfBtn.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor)
        ])
    }
    
    @objc func btnTapped() {
        pdfBtnTapped?()
    }
}
