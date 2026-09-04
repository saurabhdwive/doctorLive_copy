//import UIKit
//
//class ExpiredOverlayView: UIView {
//    
//     let visualEffectView: UIVisualEffectView = {
//        let blurEffect = UIBlurEffect(style: .dark)
//        let view = UIVisualEffectView(effect: blurEffect)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.alpha = 0.8
//        
//        return view
//    }()
//    
//    private let expiredLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Expired"
//        label.textColor = .red
//        label.font = UIFont.boldSystemFont(ofSize: 18)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupView()
//    }
//    
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//        setupView()
//    }
//    
//    private func setupView() {
//        self.backgroundColor = .clear
//        self.isUserInteractionEnabled = true // To consume taps and prevent interaction if needed
//        
//        self.addSubview(visualEffectView)
//        visualEffectView.contentView.addSubview(expiredLabel)
//        
//        NSLayoutConstraint.activate([
//            visualEffectView.topAnchor.constraint(equalTo: self.topAnchor,constant: 3),
//            visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -3),
//            visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 3),
//            visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -3),
//            
//            expiredLabel.centerXAnchor.constraint(equalTo: visualEffectView.contentView.centerXAnchor),
//            expiredLabel.centerYAnchor.constraint(equalTo: visualEffectView.contentView.centerYAnchor)
//        ])
//    }
//}
//
//extension UIView {
//    private struct AssociatedKeys {
//        static var overlayView = "expiredOverlayView"
//    }
//    
//    func setExpiredOverlay(isExpired: Int,isAudioCell:Bool = false) {
//        if isExpired == 1{
//            if self.viewWithTag(9999) == nil {
//                let overlay = ExpiredOverlayView()
//                overlay.tag = 9999
//                overlay.translatesAutoresizingMaskIntoConstraints = false
//                overlay.clipsToBounds = true
//                self.addSubview(overlay)
//                
//                NSLayoutConstraint.activate([
//                    overlay.topAnchor.constraint(equalTo: self.topAnchor),
//                    overlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//                    overlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
//                    overlay.trailingAnchor.constraint(equalTo: self.trailingAnchor)
//                ])
//                overlay.visualEffectView.clipsToBounds = true
//                // Add corner radius matching the parent view if needed
//                overlay.visualEffectView.layer.cornerRadius = self.layer.cornerRadius - (isAudioCell ? 5 : 0)
//                
//                // Keep overlay above all other subviews
//                self.bringSubviewToFront(overlay)
//            }
//        } else {
//            if let overlay = self.viewWithTag(9999) {
//                overlay.removeFromSuperview()
//            }
//        }
//    }
//}



import UIKit

class ExpiredOverlayView: UIView {
    
     let visualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0.8
        
        return view
    }()
    
    private let expiredContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let expiredLabel: UILabel = {
        let label = UILabel()
        label.text = "Expired"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
//    private func setupView() {
//        self.backgroundColor = .clear
//        self.isUserInteractionEnabled = true // To consume taps and prevent interaction if needed
//
//        self.addSubview(visualEffectView)
//        visualEffectView.contentView.addSubview(expiredLabel)
//
//        NSLayoutConstraint.activate([
//            visualEffectView.topAnchor.constraint(equalTo: self.topAnchor,constant: 3),
//            visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -3),
//            visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 3),
//            visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -3),
//
//            expiredLabel.centerXAnchor.constraint(equalTo: visualEffectView.contentView.centerXAnchor),
//            expiredLabel.centerYAnchor.constraint(equalTo: visualEffectView.contentView.centerYAnchor)
//        ])
//    }
    private func setupView() {
        self.backgroundColor = .clear
        self.isUserInteractionEnabled = true

        self.addSubview(visualEffectView)
        visualEffectView.contentView.addSubview(expiredContainerView)
        expiredContainerView.addSubview(expiredLabel)

        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: self.topAnchor, constant: 3),
            visualEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -3),
            visualEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3),
            visualEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -3),

            // Container centered inside blur view
            expiredContainerView.centerXAnchor.constraint(
                equalTo: visualEffectView.contentView.centerXAnchor
            ),
            expiredContainerView.centerYAnchor.constraint(
                equalTo: visualEffectView.contentView.centerYAnchor
            ),

            // 3pt padding on all sides
            expiredLabel.topAnchor.constraint(
                equalTo: expiredContainerView.topAnchor,
                constant: 3
            ),
            expiredLabel.bottomAnchor.constraint(
                equalTo: expiredContainerView.bottomAnchor,
                constant: -3
            ),
            expiredLabel.leadingAnchor.constraint(
                equalTo: expiredContainerView.leadingAnchor,
                constant: 5
            ),
            expiredLabel.trailingAnchor.constraint(
                equalTo: expiredContainerView.trailingAnchor,
                constant: -5
            )
        ])
    }
}

extension UIView {
    private struct AssociatedKeys {
        static var overlayView = "expiredOverlayView"
    }
    
    func setExpiredOverlay(isExpired: Int,isAudioCell:Bool = false) {
        if isExpired == 1 {
            if self.viewWithTag(9999) == nil {
                let overlay = ExpiredOverlayView()
                overlay.tag = 9999
                overlay.translatesAutoresizingMaskIntoConstraints = false
                overlay.clipsToBounds = true
                self.addSubview(overlay)
                
                NSLayoutConstraint.activate([
                    overlay.topAnchor.constraint(equalTo: self.topAnchor),
                    overlay.bottomAnchor.constraint(equalTo: self.bottomAnchor),
                    overlay.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                    overlay.trailingAnchor.constraint(equalTo: self.trailingAnchor)
                ])
                overlay.visualEffectView.clipsToBounds = true
                // Add corner radius matching the parent view if needed
                overlay.visualEffectView.layer.cornerRadius = self.layer.cornerRadius - (isAudioCell ? 5 : 0)
                
                // Keep overlay above all other subviews
                self.bringSubviewToFront(overlay)
            }
        } else {
            if let overlay = self.viewWithTag(9999) {
                overlay.removeFromSuperview()
            }
        }
    }
}
