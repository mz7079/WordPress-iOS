import UIKit
import WordPressShared

protocol MyProfileViewModelObserver: AnyObject {
    func viewModelChanged(viewModel: MyProfileViewModel)
}

protocol MyProfilePresenter: AnyObject {
    func push<T>(controllerGenerator: T -> UIViewController) -> T -> Void
}

protocol MyProfileDelegate: MyProfileViewModelObserver, MyProfilePresenter {}

struct MyProfileViewModel {
    let title = NSLocalizedString("My Profile", comment: "My Profile view title")
    let tableViewModel: ImmuTable
}

class MyProfileController {
    let service: AccountSettingsService
    unowned var delegate: MyProfileDelegate

    var subscription: AccountSettingsSubscription? = nil
    var visible = false {
        didSet {
            if visible {
                subscribe()
            } else {
                unsubscribe()
            }
        }
    }

    init(service: AccountSettingsService, delegate: MyProfileDelegate) {
        self.service = service
        self.delegate = delegate
    }

    convenience init(account: WPAccount, delegate: MyProfileDelegate) {
        self.init(service: AccountSettingsService(userID: account.userID.integerValue, api: account.restApi), delegate: delegate)
    }

    func mapViewModel(settings: AccountSettings?) -> MyProfileViewModel {
        let firstNameRow = EditableTextRow(
            title: NSLocalizedString("First Name", comment: "My Profile first name label"),
            value: settings?.firstName ?? "",
            action: delegate.push(editText(AccountSettingsChange.FirstName)))

        let lastNameRow = EditableTextRow(
            title: NSLocalizedString("Last Name", comment: "My Profile last name label"),
            value: settings?.lastName ?? "",
            action: delegate.push(editText(AccountSettingsChange.LastName)))

        let displayNameRow = EditableTextRow(
            title: NSLocalizedString("Display Name", comment: "My Profile display name label"),
            value: settings?.displayName ?? "",
            action: delegate.push(editText(AccountSettingsChange.DisplayName)))

        let aboutMeRow = EditableTextRow(
            title: NSLocalizedString("About Me", comment: "My Profile 'About me' label"),
            value: settings?.aboutMe ?? "",
            action: delegate.push(editText(AccountSettingsChange.AboutMe)))

        return MyProfileViewModel(
            tableViewModel: ImmuTable(sections: [
                ImmuTableSection(rows: [
                    firstNameRow,
                    lastNameRow,
                    displayNameRow,
                    aboutMeRow
                    ])
                ]))
    }

    var immutableRows: [ImmuTableRow.Type] {
        return [EditableTextRow.self]
    }

    // MARK: - Model Subscription

    func subscribe() {
        subscription = service.subscribeSettings({
            [unowned self]
            (settings) -> Void in

            DDLogSwift.logDebug("Got settings \(settings)")
            let viewModel = self.mapViewModel(settings)
            self.delegate.viewModelChanged(viewModel)
        })
    }

    func unsubscribe() {
        subscription = nil
    }

    // MARK: - Actions

    func editText(changeType: (AccountSettingsChangeWithString), hint: String? = nil) -> ImmuTableRowControllerGenerator {
        return { [unowned self] row in
            let row = row as! EditableTextRow
            return self.controllerForEditableText(row, changeType: changeType, hint: hint)
        }
    }

    func controllerForEditableText(row: EditableTextRow, changeType: (AccountSettingsChangeWithString), hint: String? = nil, isPassword: Bool = false) -> SettingsTextViewController {
        let title = row.title
        let value = row.value

        let controller = SettingsTextViewController(
            text: value,
            placeholder: "\(title)...",
            hint: hint,
            isPassword: isPassword)

        controller.title = title
        controller.onValueChanged = {
            [unowned self]
            value in

            let change = changeType(value)
            self.service.saveChange(change)
            DDLogSwift.logDebug("\(title) changed: \(value)")
        }

        return controller
    }
}

class MyProfileViewController: UITableViewController, MyProfileDelegate {
    let account: WPAccount

    lazy var controller: MyProfileController = {
        return MyProfileController(account: self.account, delegate: self)
    }()

    var handler: ImmuTableViewHandler!

    // MARK: - Table View Controller

    init(account: WPAccount) {
        self.account = account
        super.init(style: .Grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        ImmuTable.registerRows(controller.immutableRows, tableView: self.tableView)

        handler = ImmuTableViewHandler(takeOver: self)

        WPStyleGuide.resetReadableMarginsForTableView(tableView)
        WPStyleGuide.configureColorsForView(view, andTableView: tableView)
    }

    override func viewWillAppear(animated: Bool) {
        controller.visible = true
    }

    override func viewWillDisappear(animated: Bool) {
        controller.visible = false
    }

    func viewModelChanged(viewModel: MyProfileViewModel) {
        title = viewModel.title
        handler.viewModel = viewModel.tableViewModel
    }

    func push<T>(controllerGenerator: T -> UIViewController) -> T -> Void {
        return {
            [unowned self] in
            let controller = controllerGenerator($0)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
