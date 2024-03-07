import UIKit
import SnapKit

class ViewController: UIViewController {

    let signUpButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 12
        return button
    }()

    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = 12
        return button
    }()

    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kfh")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        return imageView
    }()

    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()

    let topContainerView: UIView = {
        let view = UIView()
        return view
    }()

    let topLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to KFH"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    let additionalImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kfh")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(blurEffectView)
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        view.addSubview(topContainerView)
        topContainerView.addSubview(topLabel)
        topContainerView.addSubview(additionalImageView)

        topContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.equalTo(200)
            make.height.equalTo(220)
        }

        additionalImageView.snp.makeConstraints { make in
            make.centerX.equalTo(topContainerView)
            make.bottom.equalTo(topLabel.snp.top).offset(-16)
            make.width.height.equalTo(100)
        }

        topLabel.snp.makeConstraints { make in
            make.centerX.equalTo(topContainerView)
            make.centerY.equalTo(topContainerView).offset(50)
        }

        view.addSubview(signUpButton)
        signUpButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(120) 
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)

        view.addSubview(signInButton)
        signInButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(180)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }

    @objc private func signUpButtonTapped() {
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
    }

    @objc private func signInButtonTapped() {
        print("Submit button tapped")
        let signInViewController = SignInViewController()
        navigationController?.pushViewController(signInViewController, animated: true)
    }
}
