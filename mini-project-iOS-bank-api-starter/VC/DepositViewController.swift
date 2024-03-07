import UIKit
import Alamofire
import SnapKit

class DepositViewController: UIViewController {

    var token: String?
    var updateBalanceAction: (() -> Void)?

    private let depositAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter deposit amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        let imageView = UIImageView(image: UIImage(systemName: "dollarsign.circle"))
        imageView.tintColor = .systemGreen
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        textField.leftView = imageView
        textField.leftViewMode = .always
        return textField
    }()

    private let depositButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Deposit", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let image: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "deposit"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kfh")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Deposit"

        view.addSubview(backgroundImageView)
        view.addSubview(blurEffectView)

        blurEffectView.contentView.addSubview(image)
        blurEffectView.contentView.addSubview(depositAmountTextField)
        blurEffectView.contentView.addSubview(depositButton)

        setupLayout()

        depositButton.addTarget(self, action: #selector(depositButtonTapped), for: .touchUpInside)
    }

    private func setupLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        image.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(300)
        }

        depositAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        depositButton.snp.makeConstraints { make in
            make.top.equalTo(depositAmountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }

    @objc private func depositButtonTapped() {
        guard let amountString = depositAmountTextField.text, let amount = Double(amountString) else {
            showAlert(title: "Invalid Input", message: "Please enter a valid amount.")
            return
        }

        let amountChange = AmountChange(amount: amount)
        NetworkManager.shared.deposit(token: token ?? "", amountChange: amountChange) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.showAlert(title: "Deposit Successful", message: "Your deposit was successful.")
                    print("Deposit successful, updating balance.")
                    self.updateBalanceAction?()

                case .failure(let error):
                    self.showAlert(title: "Deposit Failed", message: error.localizedDescription)
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
