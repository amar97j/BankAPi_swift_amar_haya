import UIKit
import Alamofire
import SnapKit

class WithdrawViewController: UIViewController {

    var token: String?
    var updateBalanceAction: (() -> Void)?

    private let withdrawAmountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter withdrawal amount"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        let imageView = UIImageView(image: UIImage(systemName: "arrow.down.square"))
        imageView.tintColor = .systemRed
        imageView.frame = CGRect(x: 2, y: 0, width: 30, height: 20)
        textField.leftView = imageView
        textField.leftViewMode = .always
        return textField
    }()

    private let withdrawButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Withdraw", for: .normal)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let image: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "withdrwa"))
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
        title = "Withdraw"

        view.addSubview(backgroundImageView)
        view.addSubview(blurEffectView)

        blurEffectView.contentView.addSubview(image)
        blurEffectView.contentView.addSubview(withdrawAmountTextField)
        blurEffectView.contentView.addSubview(withdrawButton)

        setupLayout()

        withdrawButton.addTarget(self, action: #selector(withdrawButtonTapped), for: .touchUpInside)
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

        withdrawAmountTextField.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }

        withdrawButton.snp.makeConstraints { make in
            make.top.equalTo(withdrawAmountTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
    }

    @objc private func withdrawButtonTapped() {
        guard let amountString = withdrawAmountTextField.text, let amount = Double(amountString) else {
            showAlert(title: "Invalid Input", message: "Please enter a valid amount.")
            return
        }

     
        guard amount > 0 else {
            showAlert(title: "Invalid Amount", message: "Please enter an amount greater than zero.")
            return
        }

        let amountChange = AmountChange(amount: amount)
        NetworkManager.shared.withdraw(token: token ?? "", amountChange: amountChange) { [weak self] result in
            guard let self = self else { return }

            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.showAlert(title: "Withdrawal Successful", message: "Your withdrawal was successful.")
                    print("Withdrawal successful, updating balance.")
                    self.updateBalanceAction?()

                case .failure(let error):
                    self.showAlert(title: "Withdrawal Failed", message: error.localizedDescription)
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
