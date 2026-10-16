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

// MARK: - WhatsApp Style Multi-Image Grid View & Cells
import SDWebImage

private class GridImageView: UIImageView {
    override var intrinsicContentSize: CGSize {
        return CGSize(width: UIView.noIntrinsicMetric, height: UIView.noIntrinsicMetric)
    }
}

class WhatsAppMediaGridView: UIView {
    
    private let containerStack = UIStackView()
    private var imageViews: [UIImageView] = []
    private var overlayLabel: UILabel?
    private var overlayView: UIView?
    
    var onImageTapped: ((Int) -> Void)?
    private(set) var urls: [String] = []
    private var gridHeightConstraint: NSLayoutConstraint!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        containerStack.axis = .vertical
        containerStack.spacing = 3
        containerStack.distribution = .fillEqually
        addSubview(containerStack)
        
        let widthConstraint = self.widthAnchor.constraint(equalToConstant: 236)
        widthConstraint.priority = UILayoutPriority(999)
        
        gridHeightConstraint = self.heightAnchor.constraint(equalToConstant: 200)
        gridHeightConstraint.priority = UILayoutPriority(999)
        
        NSLayoutConstraint.activate([
            widthConstraint,
            gridHeightConstraint,
            containerStack.topAnchor.constraint(equalTo: self.topAnchor),
            containerStack.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStack.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStack.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func prepareForReuse() {
        imageViews.forEach { $0.sd_cancelCurrentImageLoad() }
        imageViews.removeAll()
        containerStack.arrangedSubviews.forEach { subview in
            containerStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        overlayView?.removeFromSuperview()
        overlayView = nil
        overlayLabel = nil
        urls = []
    }
    
    func configure(urls: [String]) {
        self.urls = urls
        imageViews.forEach { $0.sd_cancelCurrentImageLoad() }
        imageViews.removeAll()
        containerStack.arrangedSubviews.forEach { subview in
            containerStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        overlayView?.removeFromSuperview()
        overlayView = nil
        overlayLabel = nil
        
        let count = urls.count
        guard count > 0 else {
            gridHeightConstraint.constant = 0
            return
        }
        
        if count == 1 {
            gridHeightConstraint.constant = 160
            let iv = createImageView(index: 0)
            loadImage(iv: iv, urlString: urls[0])
            containerStack.addArrangedSubview(iv)
        } else if count == 2 {
            gridHeightConstraint.constant = 135
            let hStack = createHStack()
            let iv1 = createImageView(index: 0)
            let iv2 = createImageView(index: 1)
            loadImage(iv: iv1, urlString: urls[0])
            loadImage(iv: iv2, urlString: urls[1])
            hStack.addArrangedSubview(iv1)
            hStack.addArrangedSubview(iv2)
            containerStack.addArrangedSubview(hStack)
            iv1.widthAnchor.constraint(equalTo: iv2.widthAnchor).isActive = true
        } else if count == 3 {
            gridHeightConstraint.constant = 160
            let hStack = createHStack()
            let leftIv = createImageView(index: 0)
            loadImage(iv: leftIv, urlString: urls[0])
            
            let rightVStack = UIStackView()
            rightVStack.translatesAutoresizingMaskIntoConstraints = false
            rightVStack.axis = .vertical
            rightVStack.spacing = 3
            rightVStack.distribution = .fillEqually
            
            let rightTopIv = createImageView(index: 1)
            let rightBottomIv = createImageView(index: 2)
            loadImage(iv: rightTopIv, urlString: urls[1])
            loadImage(iv: rightBottomIv, urlString: urls[2])
            
            rightVStack.addArrangedSubview(rightTopIv)
            rightVStack.addArrangedSubview(rightBottomIv)
            
            hStack.addArrangedSubview(leftIv)
            hStack.addArrangedSubview(rightVStack)
            containerStack.addArrangedSubview(hStack)
            
            leftIv.widthAnchor.constraint(equalTo: rightVStack.widthAnchor).isActive = true
            rightTopIv.heightAnchor.constraint(equalTo: rightBottomIv.heightAnchor).isActive = true
        } else {
            // 4 or more images -> 2x2 grid
            gridHeightConstraint.constant = 200
            let topHStack = createHStack()
            let bottomHStack = createHStack()
            
            let iv0 = createImageView(index: 0)
            let iv1 = createImageView(index: 1)
            let iv2 = createImageView(index: 2)
            let iv3 = createImageView(index: 3)
            
            loadImage(iv: iv0, urlString: urls[0])
            loadImage(iv: iv1, urlString: urls[1])
            loadImage(iv: iv2, urlString: urls[2])
            loadImage(iv: iv3, urlString: urls[3])
            
            topHStack.addArrangedSubview(iv0)
            topHStack.addArrangedSubview(iv1)
            bottomHStack.addArrangedSubview(iv2)
            bottomHStack.addArrangedSubview(iv3)
            
            containerStack.addArrangedSubview(topHStack)
            containerStack.addArrangedSubview(bottomHStack)
            
            topHStack.heightAnchor.constraint(equalTo: bottomHStack.heightAnchor).isActive = true
            iv0.widthAnchor.constraint(equalTo: iv1.widthAnchor).isActive = true
            iv2.widthAnchor.constraint(equalTo: iv3.widthAnchor).isActive = true
            
            if count > 4 {
                // Add +N overlay on 4th image (iv3)
                let overlay = UIView()
                overlay.translatesAutoresizingMaskIntoConstraints = false
                overlay.backgroundColor = UIColor.black.withAlphaComponent(0.55)
                overlay.isUserInteractionEnabled = false
                iv3.addSubview(overlay)
                
                let label = UILabel()
                label.translatesAutoresizingMaskIntoConstraints = false
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 22, weight: .bold)
                label.text = "+\(count - 3)"
                label.textAlignment = .center
                overlay.addSubview(label)
                
                NSLayoutConstraint.activate([
                    overlay.topAnchor.constraint(equalTo: iv3.topAnchor),
                    overlay.bottomAnchor.constraint(equalTo: iv3.bottomAnchor),
                    overlay.leadingAnchor.constraint(equalTo: iv3.leadingAnchor),
                    overlay.trailingAnchor.constraint(equalTo: iv3.trailingAnchor),
                    label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
                    label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor)
                ])
                self.overlayView = overlay
                self.overlayLabel = label
            }
        }
    }
    
    private func createHStack() -> UIStackView {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 3
        stack.distribution = .fillEqually
        return stack
    }
    
    private func createImageView(index: Int) -> UIImageView {
        let iv = GridImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor(white: 0.15, alpha: 1)
        iv.isUserInteractionEnabled = true
        iv.tag = index
        
        iv.setContentHuggingPriority(UILayoutPriority(1), for: .horizontal)
        iv.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        iv.setContentCompressionResistancePriority(UILayoutPriority(1), for: .horizontal)
        iv.setContentCompressionResistancePriority(UILayoutPriority(1), for: .vertical)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleImageTap(_:)))
        iv.addGestureRecognizer(tap)
        imageViews.append(iv)
        return iv
    }
    
    private func loadImage(iv: UIImageView, urlString: String) {
        let clean = urlString.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: " ", with: "%20")
        if let url = URL(string: clean) {
            iv.sd_imageIndicator = SDWebImageActivityIndicator.gray
            iv.sd_setImage(with: url, placeholderImage: UIImage(named: "blurVideoIcon"), options: [.progressiveLoad, .continueInBackground])
        }
    }
    
    @objc private func handleImageTap(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        onImageTapped?(view.tag)
    }
}

// MARK: - Right Multi-Image Cell (Sender)
class ChatRightMultipleImageCell: UITableViewCell {
    
    let bubbleView = UIView()
    let mediaGrid = WhatsAppMediaGridView()
    let timeLbl = UILabel()
    
    var onImageTapped: ((Int, [String]) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaGrid.prepareForReuse()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.backgroundColor = UIColor(named: "ThemeColor") ?? UIColor(red: 21/255.0, green: 101/255.0, blue: 192/255.0, alpha: 1.0)
        bubbleView.layer.cornerRadius = 14
        bubbleView.clipsToBounds = true
        contentView.addSubview(bubbleView)
        
        bubbleView.addSubview(mediaGrid)
        
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        timeLbl.textColor = UIColor.white.withAlphaComponent(0.85)
        timeLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        timeLbl.textAlignment = .right
        bubbleView.addSubview(timeLbl)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            bubbleView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 40),
            
            mediaGrid.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 4),
            mediaGrid.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 4),
            mediaGrid.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -4),
            
            timeLbl.topAnchor.constraint(equalTo: mediaGrid.bottomAnchor, constant: 3),
            timeLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5)
        ])
        
        mediaGrid.onImageTapped = { [weak self] index in
            guard let self = self else { return }
            self.onImageTapped?(index, self.mediaGrid.urls)
        }
    }
    
    func configure(chat: ChatData?, onImageTap: @escaping (Int, [String]) -> Void) {
        self.onImageTapped = onImageTap
        timeLbl.text = chat?.time ?? ""
        bubbleView.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
        
        let rawMessage = chat?.message ?? ""
        var urls: [String] = []
        if rawMessage.trimmingCharacters(in: .whitespaces).starts(with: "[") {
            if let data = rawMessage.data(using: .utf8),
               let arr = try? JSONSerialization.jsonObject(with: data) as? [String] {
                urls = arr
            }
        }
        if urls.isEmpty {
            urls = rawMessage.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        }
        mediaGrid.configure(urls: urls)
    }
}

// MARK: - Left Multi-Image Cell (Receiver)
class ChatLeftMultipleImageCell: UITableViewCell {
    
    let bubbleView = UIView()
    let mediaGrid = WhatsAppMediaGridView()
    let timeLbl = UILabel()
    
    var onImageTapped: ((Int, [String]) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mediaGrid.prepareForReuse()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        bubbleView.translatesAutoresizingMaskIntoConstraints = false
        bubbleView.backgroundColor = UIColor(red: 227/255.0, green: 240/255.0, blue: 254/255.0, alpha: 1.0)
        bubbleView.layer.cornerRadius = 14
        bubbleView.clipsToBounds = true
        contentView.addSubview(bubbleView)
        
        bubbleView.addSubview(mediaGrid)
        
        timeLbl.translatesAutoresizingMaskIntoConstraints = false
        timeLbl.textColor = UIColor.darkGray
        timeLbl.font = UIFont.systemFont(ofSize: 11, weight: .regular)
        timeLbl.textAlignment = .right
        bubbleView.addSubview(timeLbl)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -40),
            
            mediaGrid.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 4),
            mediaGrid.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 4),
            mediaGrid.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -4),
            
            timeLbl.topAnchor.constraint(equalTo: mediaGrid.bottomAnchor, constant: 3),
            timeLbl.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8),
            timeLbl.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -5)
        ])
        
        mediaGrid.onImageTapped = { [weak self] index in
            guard let self = self else { return }
            self.onImageTapped?(index, self.mediaGrid.urls)
        }
    }
    
    func configure(chat: ChatData?, onImageTap: @escaping (Int, [String]) -> Void) {
        self.onImageTapped = onImageTap
        timeLbl.text = chat?.time ?? ""
        bubbleView.setExpiredOverlay(isExpired: chat?.isExpired ?? 0)
        
        let rawMessage = chat?.message ?? ""
        var urls: [String] = []
        if rawMessage.trimmingCharacters(in: .whitespaces).starts(with: "[") {
            if let data = rawMessage.data(using: .utf8),
               let arr = try? JSONSerialization.jsonObject(with: data) as? [String] {
                urls = arr
            }
        }
        if urls.isEmpty {
            urls = rawMessage.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        }
        mediaGrid.configure(urls: urls)
    }
}

