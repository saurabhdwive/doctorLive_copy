import UIKit





//extension UIColor {
//    static let drBlue600 = UIColor(hex: "#1C5EC9")
//    static let drBlue500 = UIColor(hex: "#2170DC")
//    static let drBlue100 = UIColor(hex: "#DFEAFB")
//    static let drBlue050 = UIColor(hex: "#EEF4FD")
//
//    static let ink900 = UIColor(hex: "#101C2F")
//    static let ink700 = UIColor(hex: "#2C3A52")
//    static let ink600 = UIColor(hex: "#5C6B82")
//    static let ink400 = UIColor(hex: "#94A1B8")
//
//    static let line = UIColor(hex: "#DBE6F4")
//    static let green = UIColor(hex: "#1F9D55")
//    static let red = UIColor(hex: "#E2483E")
//    static let amber = UIColor(hex: "#C8860D")
//    static let purple = UIColor(hex: "#6E4FC9")
//}

// MARK: - Booking Divider Cell
class ChatBookingDividerCell: UITableViewCell {
    
    let line1 = UIView()
    let line2 = UIView()
    let chipView = UIView()
    let iconView = UIImageView()
    let titleLabel = UILabel()
    let statusDot = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        line1.backgroundColor = UIColor(red: 219/255, green: 230/255, blue: 244/255, alpha: 1.0)
        line2.backgroundColor = UIColor(red: 219/255, green: 230/255, blue: 244/255, alpha: 1.0)
        
        chipView.backgroundColor = .white
        chipView.layer.borderColor = UIColor(red: 219/255, green: 230/255, blue: 244/255, alpha: 1.0).cgColor
        chipView.layer.borderWidth = 1
        chipView.layer.cornerRadius = 15
        chipView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1.0).cgColor
        chipView.layer.shadowOpacity = 0.05
        chipView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chipView.layer.shadowRadius = 6
        
        iconView.image = UIImage(systemName: "calendar")
        iconView.tintColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1.0)
        iconView.backgroundColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1.0)
        iconView.layer.cornerRadius = 6
        iconView.contentMode = .center
        
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        titleLabel.textColor = UIColor(red: 44/255, green: 58/255, blue: 82/255, alpha: 1.0)
        
        statusDot.backgroundColor = UIColor(red: 33/255, green: 112/255, blue: 220/255, alpha: 1.0)
        statusDot.layer.cornerRadius = 3
        
        [line1, chipView, line2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [iconView, titleLabel, statusDot].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            chipView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            chipView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            chipView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
            chipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            chipView.heightAnchor.constraint(equalToConstant: 30),
            
            line1.centerYAnchor.constraint(equalTo: chipView.centerYAnchor),
            line1.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            line1.trailingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: -10),
            line1.heightAnchor.constraint(equalToConstant: 1),
            
            line2.centerYAnchor.constraint(equalTo: chipView.centerYAnchor),
            line2.leadingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: 10),
            line2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            line2.heightAnchor.constraint(equalToConstant: 1),
            
            iconView.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 6),
            iconView.centerYAnchor.constraint(equalTo: chipView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            iconView.heightAnchor.constraint(equalToConstant: 20),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 6),
            titleLabel.centerYAnchor.constraint(equalTo: chipView.centerYAnchor),
            
            statusDot.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 6),
            statusDot.trailingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: -8),
            statusDot.centerYAnchor.constraint(equalTo: chipView.centerYAnchor),
            statusDot.widthAnchor.constraint(equalToConstant: 6),
            statusDot.heightAnchor.constraint(equalToConstant: 6)
        ])
    }
    
    func configure(title: String, icon: UIImage?, isRedDot: Bool = false) {
        titleLabel.text = title
        iconView.image = icon
        if isRedDot {
            statusDot.backgroundColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1.0)
        } else {
            statusDot.backgroundColor = UIColor(red: 33/255, green: 112/255, blue: 220/255, alpha: 1.0)
        }
    }
}

// MARK: - Stage Chip Cell
class ChatStageChipCell: UITableViewCell {
    
    let chipView = UIView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        chipView.layer.cornerRadius = 14
        chipView.layer.borderWidth = 1
        chipView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1.0).cgColor
        chipView.layer.shadowOpacity = 0.06
        chipView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chipView.layer.shadowRadius = 6
        
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .heavy)
        titleLabel.textAlignment = .center
        
        [chipView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            chipView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            chipView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            chipView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            chipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            chipView.heightAnchor.constraint(equalToConstant: 28),
            
            titleLabel.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: -12),
            titleLabel.centerYAnchor.constraint(equalTo: chipView.centerYAnchor)
        ])
    }
    
    func configure(type: String) {
        // REQUESTED, CANCELLED, PAYMENT_COMPLETED, PAYMENT_PENDING
        switch type {
        case "PAYMENT_COMPLETED":
            chipView.backgroundColor = UIColor(red: 227/255, green: 237/255, blue: 255/255, alpha: 1)
            chipView.layer.borderColor = UIColor(red: 207/255, green: 224/255, blue: 255/255, alpha: 1).cgColor
            titleLabel.textColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
        case "CALL_STARTED" , "CALL_ENDED":
            chipView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 254/255, alpha: 1)
            chipView.layer.borderColor = UIColor(red: 222/255, green: 221/255, blue: 246/255, alpha: 1).cgColor
            titleLabel.textColor = UIColor(red: 104/255, green: 81/255, blue: 185/255, alpha: 1)
        case "REJECTED","CANCELLED","PAYMENT_EXPIRED":
            chipView.backgroundColor = UIColor(red: 251/255, green: 228/255, blue: 226/255, alpha: 1)
            chipView.layer.borderColor = UIColor(red: 246/255, green: 202/255, blue: 198/255, alpha: 1).cgColor
            titleLabel.textColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
        case "PAYMENT_PENDING","SUGGESTED_TIME_ACCEPTED","CONSULTATION_COMPLETED":
            chipView.backgroundColor = UIColor(red: 227/255, green: 246/255, blue: 234/255, alpha: 1)
            chipView.layer.borderColor = UIColor(red: 191/255, green: 231/255, blue: 205/255, alpha: 1).cgColor
            titleLabel.textColor = UIColor(red: 31/255, green: 157/255, blue: 85/255, alpha: 1)
        case "PRESCRIPTION_SENT":
            chipView.backgroundColor = UIColor(red: 255/255, green: 244/255, blue: 224/255, alpha: 1)
            chipView.layer.borderColor = UIColor(red: 243/255, green: 217/255, blue: 160/255, alpha: 1).cgColor
            titleLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
        default:
            print("❌❌❌❌❌\(type)")
            chipView.backgroundColor = UIColor(red: 238/255, green: 241/255, blue: 245/255, alpha: 1)
            chipView.layer.borderColor = UIColor(red: 219/255, green: 230/255, blue: 244/255, alpha: 1).cgColor
            titleLabel.textColor = UIColor(red: 148/255, green: 161/255, blue: 184/255, alpha: 1)
        }
    }
}

//class ChatStageChipCell2: UITableViewCell {
//    
//    let chipView = UIView()
//    let titleLabel = UILabel()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        backgroundColor = .clear
//        
////        chipView.layer.cornerRadius = 14
////        chipView.layer.borderWidth = 1
////        chipView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1.0).cgColor
////        chipView.layer.shadowOpacity = 0.06
////        chipView.layer.shadowOffset = CGSize(width: 0, height: 2)
////        chipView.layer.shadowRadius = 6
//        chipView.backgroundColor = .white
//        chipView.layer.borderColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1).cgColor
//        chipView.layer.borderWidth = 1.5
//        chipView.layer.cornerRadius = 13
//        chipView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1).cgColor
//        chipView.layer.shadowOpacity = 0.06
//        chipView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        chipView.layer.shadowRadius = 8
//        
//        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .regular)
//        titleLabel.textAlignment = .center
//        titleLabel.numberOfLines = 0
//        
//        [chipView].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        [titleLabel].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            chipView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            chipView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
//            chipView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
//            chipView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
//            chipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
//            
//            titleLabel.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 12),
//            titleLabel.trailingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: -12),
//            titleLabel.topAnchor.constraint(equalTo: chipView.topAnchor, constant: 6),
//            titleLabel.bottomAnchor.constraint(equalTo: chipView.bottomAnchor, constant: -6)
//        ])
//    }
//    
//    func configure(type: String) {
////        chipView.backgroundColor = .white
////        chipView.layer.borderColor = UIColor.gray.cgColor
//        titleLabel.textColor = .black
//    }
//}

class ChatStageChipCell2: UITableViewCell {

    let chipView = UIView()
    let titleLabel = UILabel()

    private let dashedBorderLayer = CAShapeLayer()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear

        chipView.backgroundColor = .white

        // Remove the solid border — we'll use a dashed CAShapeLayer instead
        // chipView.layer.borderColor = ...
        // chipView.layer.borderWidth = 1.5

        chipView.layer.cornerRadius = 13
        chipView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1).cgColor
        chipView.layer.shadowOpacity = 0.06
        chipView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chipView.layer.shadowRadius = 8

        // MARK: Dashed border layer
        dashedBorderLayer.strokeColor = UIColor(
            red: 223/255,
            green: 234/255,
            blue: 251/255,
            alpha: 1
        ).cgColor
        dashedBorderLayer.fillColor = UIColor.clear.cgColor
        dashedBorderLayer.lineWidth = 1.5
        dashedBorderLayer.lineDashPattern = [4, 3]   // 4pt dash, 3pt gap
        dashedBorderLayer.lineCap = .round

        chipView.layer.addSublayer(dashedBorderLayer)

        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .regular)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0

        [chipView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            chipView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            chipView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            chipView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            chipView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            chipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            titleLabel.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: chipView.topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: chipView.bottomAnchor, constant: -6)
        ])
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update the dashed path whenever the chip's size changes
        dashedBorderLayer.frame = chipView.bounds

        let cornerRadius: CGFloat = 13
        let inset = dashedBorderLayer.lineWidth / 2

        let rect = chipView.bounds.insetBy(dx: inset, dy: inset)

        dashedBorderLayer.path = UIBezierPath(
            roundedRect: rect,
            cornerRadius: cornerRadius
        ).cgPath
    }

    // MARK: - Configure

    func configure(type: String) {
        titleLabel.textColor = .gray
    }
}

class ChatStageChipCell3: UITableViewCell {
    
    let chipView = UIView()
    let titleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        chipView.layer.cornerRadius = 14
        chipView.layer.borderWidth = 1
        chipView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1.0).cgColor
        chipView.layer.shadowOpacity = 0.06
        chipView.layer.shadowOffset = CGSize(width: 0, height: 2)
        chipView.layer.shadowRadius = 6
        
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .heavy)
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        
        chipView.backgroundColor = UIColor(red: 238/255, green: 241/255, blue: 245/255, alpha: 1)
        chipView.layer.borderColor = UIColor(red: 219/255, green: 230/255, blue: 244/255, alpha: 1).cgColor
        titleLabel.textColor = UIColor(red: 148/255, green: 161/255, blue: 184/255, alpha: 1)
    
        [chipView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            chipView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            chipView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            chipView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            chipView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            chipView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            titleLabel.leadingAnchor.constraint(equalTo: chipView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: chipView.trailingAnchor, constant: -12),
            titleLabel.topAnchor.constraint(equalTo: chipView.topAnchor, constant: 6),
            titleLabel.bottomAnchor.constraint(equalTo: chipView.bottomAnchor, constant: -6)
        ])
    }
    
    func configure(type: String) {
//        titleLabel.textColor = .black
    }
}

// MARK: - Action Card Cell
class ChatActionCardCell: UITableViewCell {
    
    let cardView = UIView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let actionBtn = UIButton(type: .system)
    let actionBtn2 = UIButton(type: .system)
    
    var actionBtnTapped: (() -> Void)?
    var actionBtn2Tapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func configure(actionBtn2Hide:Bool) {
        actionBtn2.isHidden = actionBtn2Hide
    }
    
    private func setupViews() {
        actionBtn2.isHidden = true
        selectionStyle = .none
        backgroundColor = .clear
        
        cardView.backgroundColor = .white
        cardView.layer.borderColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1).cgColor
        cardView.layer.borderWidth = 1.5
        cardView.layer.cornerRadius = 13
        cardView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1).cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
        
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .heavy)
        titleLabel.textColor = UIColor(red: 16/255, green: 28/255, blue: 47/255, alpha: 1)
        
        subLabel.font = UIFont.systemFont(ofSize: 12.5)
        subLabel.textColor = UIColor(red: 92/255, green: 107/255, blue: 130/255, alpha: 1)
        subLabel.numberOfLines = 0
        
        actionBtn.backgroundColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
        actionBtn.setTitleColor(.white, for: .normal)
        actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        actionBtn.layer.cornerRadius = 10
        actionBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        
        actionBtn2.backgroundColor = UIColor(red: 239/255, green: 247/255, blue: 252/255, alpha: 1)
        actionBtn2.setTitleColor(UIColor(red: 63/255, green: 97/255, blue: 191/255, alpha: 1), for: .normal)
        actionBtn2.titleLabel?.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        actionBtn2.layer.cornerRadius = 10
        actionBtn2.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        actionBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        actionBtn2.addTarget(self, action: #selector(btnAction2), for: .touchUpInside)
        
        [cardView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [titleLabel, subLabel, actionBtn,actionBtn2].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            cardView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.86),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            subLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            
            actionBtn.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 9),
            actionBtn.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            actionBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            actionBtn.heightAnchor.constraint(equalToConstant: 30),
            
            actionBtn2.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 9),
            actionBtn2.leadingAnchor.constraint(equalTo: actionBtn.trailingAnchor, constant: 8),
            actionBtn2.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            actionBtn2.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func btnAction() { actionBtnTapped?() }
    @objc func btnAction2() { actionBtn2Tapped?() }
}

// MARK: - Pay Card Cell
class ChatPayCardCell: UITableViewCell {
    
    let cardView = UIView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let timerLabel = UILabel()
    let actionBtn = UIButton(type: .system)
    
    var actionBtnTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        cardView.backgroundColor = UIColor(red: 255/255, green: 248/255, blue: 234/255, alpha: 1)
        cardView.layer.borderColor = UIColor(red: 243/255, green: 217/255, blue: 160/255, alpha: 1).cgColor
        cardView.layer.borderWidth = 1.5
        cardView.layer.cornerRadius = 13
        
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .heavy)
        titleLabel.textColor = UIColor(red: 16/255, green: 28/255, blue: 47/255, alpha: 1)
        
        subLabel.font = UIFont.systemFont(ofSize: 12.5)
        subLabel.textColor = UIColor(red: 92/255, green: 107/255, blue: 130/255, alpha: 1)
        subLabel.numberOfLines = 0
        
        timerLabel.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        timerLabel.textColor = UIColor(red: 200/255, green: 134/255, blue: 13/255, alpha: 1)
        
        actionBtn.backgroundColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
        actionBtn.setTitleColor(.white, for: .normal)
        actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        actionBtn.layer.cornerRadius = 10
        actionBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        actionBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        [cardView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [titleLabel, subLabel, timerLabel, actionBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            cardView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.86),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            subLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            
            timerLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 4),
            timerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            timerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            
            actionBtn.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 8),
            actionBtn.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            actionBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            actionBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func btnAction() { actionBtnTapped?() }
}

// MARK: - Booking Summary / Prescription Card Cell
//class ChatBookingSummaryCardCell: UITableViewCell {
//    
//    let cardView = UIView()
//    let iconView = UIImageView()
//    let titleLabel = UILabel()
//    let subLabel = UILabel()
//    let expandLabel = UILabel()
//    let expandLabel2 = UILabel()
//    
//    var expandTapped: (() -> Void)?
//    var expand2Tapped: (() -> Void)?
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupViews()
//    }
//    
//    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
//    
//    private func setupViews() {
//        selectionStyle = .none
//        backgroundColor = .clear
//        
//        cardView.backgroundColor = .white
//        cardView.layer.borderColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1).cgColor
//        cardView.layer.borderWidth = 1.5
//        cardView.layer.cornerRadius = 13
//        cardView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1).cgColor
//        cardView.layer.shadowOpacity = 0.06
//        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
//        cardView.layer.shadowRadius = 8
//        
//        iconView.backgroundColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1)
//        iconView.tintColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
//        iconView.layer.cornerRadius = 8
//        iconView.contentMode = .center
//        
//        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .heavy)
//        titleLabel.textColor = UIColor(red: 16/255, green: 28/255, blue: 47/255, alpha: 1)
//        
//        subLabel.font = UIFont.systemFont(ofSize: 12.5)
//        subLabel.textColor = UIColor(red: 148/255, green: 161/255, blue: 184/255, alpha: 1)
//        
//        expandLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
//        expandLabel.textColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
//        
//        expandLabel2.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
//        expandLabel2.textColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
//        
//        expandLabel.isUserInteractionEnabled = true
//        expandLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expandAction)))
//        
//        expandLabel2.isUserInteractionEnabled = true
//        expandLabel2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(expand2Action)))
//        
//        [cardView].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        [iconView, titleLabel, subLabel, expandLabel,expandLabel2].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            cardView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
//            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
//            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
//            cardView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.84),
//            
//            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 11),
//            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
//            iconView.widthAnchor.constraint(equalToConstant: 24),
//            iconView.heightAnchor.constraint(equalToConstant: 24),
//            
//            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 11),
//            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
//            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
//            
//            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
//            subLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
//            subLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
//            
//            expandLabel.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 3),
//            expandLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
//            expandLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -11),
//            
//            expandLabel2.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 3),
//            expandLabel2.leadingAnchor.constraint(equalTo: expandLabel.trailingAnchor, constant: 16),
//            expandLabel2.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -11)
//        ])
//    }
//    
//    @objc func expandAction() { expandTapped?() }
//    @objc func expand2Action() { expand2Tapped?() }
//}

class ChatBookingSummaryCardCell: UITableViewCell {

    let cardView = UIView()

    let iconView = UIView()
    let iconLabel = UILabel()

    let titleLabel = UILabel()
    let subLabel = UILabel()
    let expandLabel = UILabel()
    let expandLabel2 = UILabel()

    var expandTapped: (() -> Void)?
    var expand2Tapped: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {

        selectionStyle = .none
        backgroundColor = .clear

        // MARK: - Card
        cardView.backgroundColor = .white
        cardView.layer.borderColor = UIColor(
            red: 223/255,
            green: 234/255,
            blue: 251/255,
            alpha: 1
        ).cgColor
        cardView.layer.borderWidth = 1.5
        cardView.layer.cornerRadius = 13
        cardView.layer.shadowColor = UIColor(
            red: 20/255,
            green: 45/255,
            blue: 90/255,
            alpha: 1
        ).cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8

        // MARK: - Icon View
        iconView.backgroundColor = UIColor(
            red: 223/255,
            green: 234/255,
            blue: 251/255,
            alpha: 1
        )
        iconView.layer.cornerRadius = 8
        iconView.clipsToBounds = true

        iconLabel.text = ""
        iconLabel.font = UIFont.systemFont(ofSize: 14)
        iconLabel.textAlignment = .center
        iconLabel.adjustsFontSizeToFitWidth = true

        // MARK: - Labels
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .heavy)
        titleLabel.textColor = UIColor(
            red: 16/255,
            green: 28/255,
            blue: 47/255,
            alpha: 1
        )

        subLabel.font = UIFont.systemFont(ofSize: 12.5)
        subLabel.textColor = UIColor(
            red: 148/255,
            green: 161/255,
            blue: 184/255,
            alpha: 1
        )

        expandLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        expandLabel.textColor = UIColor(
            red: 28/255,
            green: 94/255,
            blue: 201/255,
            alpha: 1
        )

        expandLabel2.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        expandLabel2.textColor = UIColor(
            red: 28/255,
            green: 94/255,
            blue: 201/255,
            alpha: 1
        )

        // MARK: - Add Views
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        [
            iconView,
            titleLabel,
            subLabel,
            expandLabel,
            expandLabel2
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }

        // Emoji inside iconView
        iconLabel.translatesAutoresizingMaskIntoConstraints = false
        iconView.addSubview(iconLabel)

        // MARK: - Gestures
        expandLabel.isUserInteractionEnabled = true
        expandLabel.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(expandAction)
            )
        )

        expandLabel2.isUserInteractionEnabled = true
        expandLabel2.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(expand2Action)
            )
        )

        // MARK: - Constraints
        NSLayoutConstraint.activate([

            // Card
            cardView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 6
            ),
            cardView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -6
            ),
            cardView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 14
            ),
            cardView.widthAnchor.constraint(
                lessThanOrEqualTo: contentView.widthAnchor,
                multiplier: 0.84
            ),

            // Icon
            iconView.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 11
            ),
            iconView.leadingAnchor.constraint(
                equalTo: cardView.leadingAnchor,
                constant: 13
            ),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),

            // Emoji
            iconLabel.centerXAnchor.constraint(
                equalTo: iconView.centerXAnchor
            ),
            iconLabel.centerYAnchor.constraint(
                equalTo: iconView.centerYAnchor
            ),

            // Title
            titleLabel.topAnchor.constraint(
                equalTo: cardView.topAnchor,
                constant: 11
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: iconView.trailingAnchor,
                constant: 8
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -13
            ),

            // Subtitle
            subLabel.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: 1
            ),
            subLabel.leadingAnchor.constraint(
                equalTo: iconView.trailingAnchor,
                constant: 8
            ),
            subLabel.trailingAnchor.constraint(
                equalTo: cardView.trailingAnchor,
                constant: -13
            ),

            // Expand 1
            expandLabel.topAnchor.constraint(
                equalTo: subLabel.bottomAnchor,
                constant: 3
            ),
            expandLabel.leadingAnchor.constraint(
                equalTo: iconView.trailingAnchor,
                constant: 8
            ),
            expandLabel.bottomAnchor.constraint(
                equalTo: cardView.bottomAnchor,
                constant: -11
            ),

            // Expand 2
            expandLabel2.topAnchor.constraint(
                equalTo: subLabel.bottomAnchor,
                constant: 3
            ),
            expandLabel2.leadingAnchor.constraint(
                equalTo: expandLabel.trailingAnchor,
                constant: 16
            ),
            expandLabel2.bottomAnchor.constraint(
                equalTo: cardView.bottomAnchor,
                constant: -11
            )
        ])
    }

    @objc func expandAction() {
        expandTapped?()
    }

    @objc func expand2Action() {
        expand2Tapped?()
    }
}

// MARK: - Rating Card Cell
class ChatRatingCardCell: UITableViewCell {
    
    let cardView = UIView()
    let iconView = UIImageView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    let starsStackView = UIStackView()
//    let actionBtn = UIButton(type: .system)
    
//    var actionBtnTapped: (() -> Void)?
    var currentRating: Int = 0
//    var ratingChanged: ((Int) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        cardView.backgroundColor = .white
        cardView.layer.borderColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1).cgColor
        cardView.layer.borderWidth = 1.5
        cardView.layer.cornerRadius = 13
        cardView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1).cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
        
        iconView.image = UIImage(systemName: "star.fill")
        iconView.tintColor = UIColor(red: 245/255, green: 166/255, blue: 35/255, alpha: 1)
        iconView.backgroundColor = UIColor(red: 255/255, green: 248/255, blue: 234/255, alpha: 1)
        iconView.layer.cornerRadius = 8
        iconView.contentMode = .center
        
        titleLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .heavy)
        titleLabel.textColor = UIColor(red: 16/255, green: 28/255, blue: 47/255, alpha: 1)
        
        subLabel.font = UIFont.systemFont(ofSize: 12.5)
        subLabel.textColor = UIColor(red: 148/255, green: 161/255, blue: 184/255, alpha: 1)
        
        starsStackView.axis = .horizontal
        starsStackView.spacing = 4
        for i in 0..<5 {
            let starBtn = UIButton(type: .system)
            starBtn.setImage(UIImage(systemName: "star"), for: .normal)
            starBtn.tintColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
            starBtn.tag = i + 1
            starBtn.addTarget(self, action: #selector(starTapped(_:)), for: .touchUpInside)
            starsStackView.addArrangedSubview(starBtn)
        }
        
//        actionBtn.backgroundColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
//        actionBtn.setTitleColor(.white, for: .normal)
//        actionBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12.5.5, weight: .bold)
//        actionBtn.layer.cornerRadius = 10
//        actionBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
//        actionBtn.setTitle("Submit Rating", for: .normal)
//        actionBtn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        [cardView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [iconView, titleLabel, subLabel, starsStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            cardView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            cardView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.84),
            
            iconView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 11),
            iconView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 11),
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            
            subLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1),
            subLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 8),
            subLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -13),
            
            starsStackView.topAnchor.constraint(equalTo: subLabel.bottomAnchor, constant: 8),
            starsStackView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
            starsStackView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -11),
            
//            actionBtn.topAnchor.constraint(equalTo: starsStackView.bottomAnchor, constant: 10),
//            actionBtn.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 13),
//            actionBtn.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -11),
//            actionBtn.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc func starTapped(_ sender: UIButton) {
//        currentRating = sender.tag
//        ratingChanged?(currentRating)
//        for (index, view) in starsStackView.arrangedSubviews.enumerated() {
//            if let btn = view as? UIButton {
//                let imageName = (index < currentRating) ? "star.fill" : "star"
//                let color = (index < currentRating) ? UIColor.systemYellow : UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
//                btn.setImage(UIImage(systemName: imageName), for: .normal)
//                btn.tintColor = color
//            }
//        }
    }
    
//    @objc func btnAction() { actionBtnTapped?() }
}

// MARK: - Media Message Cell
class ChatMediaMsgCell: UITableViewCell {
    
    let bubbleView = UIView()
    let iconView = UIImageView()
    let msgLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        bubbleView.backgroundColor = .white
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1).cgColor
        bubbleView.layer.shadowOpacity = 0.05
        bubbleView.layer.shadowOffset = CGSize(width: 0, height: 1)
        bubbleView.layer.shadowRadius = 4
        
        iconView.backgroundColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1)
        iconView.tintColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
        iconView.layer.cornerRadius = 8
        iconView.contentMode = .center
        
        msgLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        msgLabel.textColor = UIColor(red: 16/255, green: 28/255, blue: 47/255, alpha: 1)
        
        [bubbleView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [iconView, msgLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            bubbleView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            bubbleView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -14),
            
            iconView.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 9),
            iconView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 12),
            iconView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -9),
            iconView.widthAnchor.constraint(equalToConstant: 28),
            iconView.heightAnchor.constraint(equalToConstant: 28),
            
            msgLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 9),
            msgLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -12),
            msgLabel.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor)
        ])
    }
}

// MARK: - Video Call Live Badge Cell
class ChatVideoCallBadgeCell: UITableViewCell {
    
    let badgeView = UIView()
    let dotView = UIView()
    let timeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        badgeView.backgroundColor = UIColor(red: 226/255, green: 72/255, blue: 62/255, alpha: 1)
        badgeView.layer.cornerRadius = 14
        
        dotView.backgroundColor = .white
        dotView.layer.cornerRadius = 3.5
        
        // Simple pulse animation for the dot
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1.0
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 0.35
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .infinity
        dotView.layer.add(pulseAnimation, forKey: "pulse")
        
        timeLabel.font = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        timeLabel.textColor = .white
        
        [badgeView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        [dotView, timeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            badgeView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            badgeView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            badgeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            badgeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            badgeView.heightAnchor.constraint(equalToConstant: 28),
            
            dotView.leadingAnchor.constraint(equalTo: badgeView.leadingAnchor, constant: 14),
            dotView.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor),
            dotView.widthAnchor.constraint(equalToConstant: 7),
            dotView.heightAnchor.constraint(equalToConstant: 7),
            
            timeLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: 6),
            timeLabel.trailingAnchor.constraint(equalTo: badgeView.trailingAnchor, constant: -14),
            timeLabel.centerYAnchor.constraint(equalTo: badgeView.centerYAnchor)
        ])
    }
    
    var timer: Timer?
    var startDate: Date?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        timer?.invalidate()
        timer = nil
        dotView.isHidden = false
        if dotView.layer.animation(forKey: "pulse") == nil {
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 1.0
            pulseAnimation.fromValue = 1.0
            pulseAnimation.toValue = 0.35
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = .infinity
            dotView.layer.add(pulseAnimation, forKey: "pulse")
        }
    }
    
    func startTimer(with date: Date) {
        self.startDate = date
        timer?.invalidate()
        updateTimeLabel()
        dotView.isHidden = false
        if dotView.layer.animation(forKey: "pulse") == nil {
            let pulseAnimation = CABasicAnimation(keyPath: "opacity")
            pulseAnimation.duration = 1.0
            pulseAnimation.fromValue = 1.0
            pulseAnimation.toValue = 0.35
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = .infinity
            dotView.layer.add(pulseAnimation, forKey: "pulse")
        }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    func stopTimer(with text: String) {
        timer?.invalidate()
        timer = nil
        dotView.isHidden = false
        dotView.layer.removeAnimation(forKey: "pulse")
        timeLabel.text = text
    }
    
    @objc private func updateTimeLabel() {
        guard let startDate = startDate else { return }
        let duration = Date().timeIntervalSince(startDate)
        if duration >= 0 {
            let mins = Int(duration) / 60
            let secs = Int(duration) % 60
            timeLabel.text = String(format: "%02d:%02d", mins, secs)
        } else {
            timeLabel.text = "00:00"
        }
    }
}

// MARK: - New Booking Request Cell
class ChatNewBookingRequestCell: UITableViewCell {
    
    let cardView = UIView()
    let titleLabel = UILabel()
    let subLabel = UILabel()
    
    let availableNowBtn = UIButton(type: .system)
    let suggestTimeBtn = UIButton(type: .system)
//    let chatBtn = UIButton(type: .system)
//    let callBtn = UIButton(type: .system)
    let rejectBtn = UIButton(type: .system)
    
    var availableNowTapped: (() -> Void)?
    var suggestTimeTapped: ((String) -> Void)?
    var chatTapped: (() -> Void)?
    var callTapped: (() -> Void)?
    var rejectTapped: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(dummyTextField)
        dummyTextField.isHidden = true
        
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        dummyTextField.inputView = datePicker
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        toolBar.setItems([cancel, flexible, done], animated: false)
        dummyTextField.inputAccessoryView = toolBar
        
        cardView.backgroundColor = .white
        cardView.layer.borderColor = UIColor(red: 223/255, green: 234/255, blue: 251/255, alpha: 1).cgColor
        cardView.layer.borderWidth = 1.5
        cardView.layer.cornerRadius = 13
        cardView.layer.shadowColor = UIColor(red: 20/255, green: 45/255, blue: 90/255, alpha: 1).cgColor
        cardView.layer.shadowOpacity = 0.06
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)
        cardView.layer.shadowRadius = 8
        
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = UIColor(red: 16/255, green: 28/255, blue: 47/255, alpha: 1)
        titleLabel.text = "New Booking Request"
        
        subLabel.font = UIFont.systemFont(ofSize: 12.5)
        subLabel.textColor = UIColor(red: 92/255, green: 107/255, blue: 130/255, alpha: 1)
        subLabel.numberOfLines = 0
        
        let btnFont = UIFont.systemFont(ofSize: 13.5, weight: .bold)
        
        availableNowBtn.backgroundColor = UIColor(red: 34/255, green: 164/255, blue: 93/255, alpha: 1)
        availableNowBtn.setTitleColor(.white, for: .normal)
        availableNowBtn.titleLabel?.font = btnFont
        availableNowBtn.layer.cornerRadius = 12
        availableNowBtn.setTitle("🟢 Available Now", for: .normal)
        availableNowBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        let blueTextColor = UIColor(red: 28/255, green: 94/255, blue: 201/255, alpha: 1)
        let grayBgColor = UIColor(red: 239/255, green: 243/255, blue: 248/255, alpha: 1)
        
        suggestTimeBtn.backgroundColor = grayBgColor
        suggestTimeBtn.setTitleColor(blueTextColor, for: .normal)
        suggestTimeBtn.titleLabel?.font = btnFont
        suggestTimeBtn.layer.cornerRadius = 12
        suggestTimeBtn.setTitle("⏱ Suggest Time", for: .normal)
        suggestTimeBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
//        chatBtn.backgroundColor = grayBgColor
//        chatBtn.setTitleColor(blueTextColor, for: .normal)
//        chatBtn.titleLabel?.font = btnFont
//        chatBtn.layer.cornerRadius = 12
//        chatBtn.setTitle("💬 Chat", for: .normal)
//        chatBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
//        
//        callBtn.backgroundColor = grayBgColor
//        callBtn.setTitleColor(blueTextColor, for: .normal)
//        callBtn.titleLabel?.font = btnFont
//        callBtn.layer.cornerRadius = 12
//        callBtn.setTitle("📞 Call", for: .normal)
//        callBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
        rejectBtn.backgroundColor = UIColor(red: 253/255, green: 232/255, blue: 232/255, alpha: 1)
        rejectBtn.setTitleColor(UIColor(red: 224/255, green: 36/255, blue: 36/255, alpha: 1), for: .normal)
        rejectBtn.titleLabel?.font = btnFont
        rejectBtn.layer.cornerRadius = 12
        rejectBtn.setTitle("❌ Reject", for: .normal)
        rejectBtn.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
        
//        [availableNowBtn, suggestTimeBtn, chatBtn, callBtn, rejectBtn].forEach {
//            $0.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
//        }
        [availableNowBtn, suggestTimeBtn, rejectBtn].forEach {
            $0.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
        }
        
        let row1Stack = UIStackView(arrangedSubviews: [availableNowBtn, suggestTimeBtn])
        row1Stack.axis = .horizontal
        row1Stack.spacing = 8
        row1Stack.alignment = .fill
        row1Stack.distribution = .fill
        
//        let row2Stack = UIStackView(arrangedSubviews: [chatBtn, callBtn, rejectBtn])
        let row2Stack = UIStackView(arrangedSubviews: [rejectBtn])
        row2Stack.axis = .horizontal
        row2Stack.spacing = 8
        row2Stack.alignment = .fill
        row2Stack.distribution = .fill
        
        let contentStack = UIStackView(arrangedSubviews: [titleLabel, subLabel, row1Stack, row2Stack])
        contentStack.axis = .vertical
        contentStack.spacing = 10
        contentStack.alignment = .leading
        
        [cardView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        contentStack.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(contentStack)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            cardView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -14),
            
            contentStack.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            contentStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14),
            contentStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            contentStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -14)
        ])
    }
    
    let dummyTextField = UITextField()
    let datePicker = UIDatePicker()
    
    @objc private func buttonAction(_ sender: UIButton) {
        if sender == availableNowBtn { availableNowTapped?() }
        else if sender == suggestTimeBtn { 
            dummyTextField.becomeFirstResponder()
        }
//        else if sender == chatBtn { chatTapped?() }
//        else if sender == callBtn { callTapped?() }
        else if sender == rejectBtn { rejectTapped?() }
    }

    @objc private func cancelPicker() {
        dummyTextField.resignFirstResponder()
    }

    @objc private func donePicker() {
        dummyTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateStr = formatter.string(from: datePicker.date)
        suggestTimeTapped?(dateStr)
    }
    
    func configure(patientName: String, fee: String) {
        subLabel.text = "Patient: \(patientName) • Consultation Fee: \(fee)"
    }
}

// MARK: - Dynamic Stack Cell
class ChatDynamicStackCell: UITableViewCell {
    
    let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    private func setupViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

