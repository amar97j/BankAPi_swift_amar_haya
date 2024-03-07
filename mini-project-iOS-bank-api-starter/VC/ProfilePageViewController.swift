import UIKit
import SnapKit
import Kingfisher

class ProfilePageViewController: UIViewController {

    var user: User?
    var account: AccountDetails?
    var token: String?

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kfh")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        return imageView
    }()

    private let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemMaterialDark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        return blurView
    }()

    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .white
        return label
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .yellow
        return label
    }()

    let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .white
        return label
    }()

    let idLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        return label
    }()

    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "kfh")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 90
        return imageView
    }()

    let withdrawButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Withdraw", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()

    let depositButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Deposit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User Profile"
        view.backgroundColor = .white

        view.addSubview(backgroundImageView)
        backgroundImageView.addSubview(blurEffectView)
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(emailLabel)
        view.addSubview(balanceLabel)
        view.addSubview(idLabel)
        view.addSubview(withdrawButton)
        view.addSubview(depositButton)

        setupLayout()
        fetch()

        let instructionsButton = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(instructionsButtonTapped))
        navigationItem.rightBarButtonItem = instructionsButton
    }

    @objc private func instructionsButtonTapped() {
        let instructionsVC = TransactionsViewController()
        instructionsVC.modalPresentationStyle = .popover
        instructionsVC.token = token
        present(instructionsVC, animated: true, completion: nil)
    }

    private func setupLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(180)
            profileImageView.layer.cornerRadius = 90
        }

        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        balanceLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        idLabel.snp.makeConstraints { make in
            make.top.equalTo(balanceLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        withdrawButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(depositButton.snp.leading).offset(-10)
            make.height.equalTo(60)
            withdrawButton.addTarget(self, action: #selector(withdrawButtonTapped), for: .touchUpInside)
        }

        depositButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-20)
            make.trailing.equalToSuperview().offset(-20)
            make.width.equalTo(withdrawButton.snp.width)
            make.height.equalTo(60)
            depositButton.addTarget(self, action: #selector(depositButtonTapped), for: .touchUpInside)
        }
    }

    private func fetch() {
        NetworkManager.shared.fetchAccountDetail(token: token!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let details):
                    self.usernameLabel.text = details.username
                    self.balanceLabel.text = "Balance: \(details.balance) KWD"
                    self.emailLabel.text = details.email
                    self.idLabel.text = "User ID: \(details.id)"

                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    ///// update balance
    
    func updateBalanceLabel(newBalance: Double) {
            balanceLabel.text = "Balance: \(newBalance) USD"
        }

        func fetchAndUpdateBalance() {
            guard let token = token else {
                return
            }

            NetworkManager.shared.fetchAccountDetail(token: token) { [weak self] result in
                guard let self = self else { return }

                DispatchQueue.main.async {
                    switch result {
                    case .success(let details):
                        print("Fetching and updating balance.")
                        self.updateBalanceLabel(newBalance: details.balance)
                    case .failure(let error):
                        print("Error updating balance: \(error.localizedDescription)")
                    }
                }
            }
        }
    

    @objc func withdrawButtonTapped() {
        let withdrawViewController = WithdrawViewController()
        withdrawViewController.modalPresentationStyle = .popover
        withdrawViewController.token = token
        self.present(withdrawViewController, animated: true)
        
    }

    @objc func depositButtonTapped() {
        let depositViewController = DepositViewController()
        depositViewController.modalPresentationStyle = .popover
        depositViewController.token = token
        self.present(depositViewController, animated: true)
    }
    
    
}
