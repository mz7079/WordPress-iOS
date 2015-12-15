import UIKit
import RxSwift
import WordPressShared

class MyProfileController: SettingsController {
    let title = NSLocalizedString("My Profile", comment: "My Profile view title")
    let service: AccountSettingsService
    unowned var presenter: SettingsPresenter

    init(service: AccountSettingsService, presenter: SettingsPresenter) {
        self.service = service
        self.presenter = presenter
    }

    convenience init(account: WPAccount, presenter: SettingsPresenter) {
        self.init(service: AccountSettingsService(userID: account.userID.integerValue, api: account.restApi), presenter: presenter)
    }

    var viewModel: Observable<ImmuTable> {
        return service.settingsObserver.map(mapViewModel)
    }

    func refresh() {
        service.refreshSettings({ _ in })
    }

    func mapViewModel(settings: AccountSettings?) -> ImmuTable {
        let firstNameRow = EditableTextRow(
            title: NSLocalizedString("First Name", comment: "My Profile first name label"),
            value: settings?.firstName ?? "",
            action: presenter.push(editText(AccountSettingsChange.FirstName)))

        let lastNameRow = EditableTextRow(
            title: NSLocalizedString("Last Name", comment: "My Profile last name label"),
            value: settings?.lastName ?? "",
            action: presenter.push(editText(AccountSettingsChange.LastName)))

        let displayNameRow = EditableTextRow(
            title: NSLocalizedString("Display Name", comment: "My Profile display name label"),
            value: settings?.displayName ?? "",
            action: presenter.push(editText(AccountSettingsChange.DisplayName)))

        let aboutMeRow = EditableTextRow(
            title: NSLocalizedString("About Me", comment: "My Profile 'About me' label"),
            value: settings?.aboutMe ?? "",
            action: presenter.push(editText(AccountSettingsChange.AboutMe)))

        return ImmuTable(sections: [
            ImmuTableSection(rows: [
                firstNameRow,
                lastNameRow,
                displayNameRow,
                aboutMeRow
                ])
            ])
    }

    var immutableRows: [ImmuTableRow.Type] {
        return [EditableTextRow.self]
    }

}

class MyProfileViewController: UITableViewController, SettingsPresenter {
    let account: WPAccount

    lazy var controller: MyProfileController = {
        return MyProfileController(account: self.account, presenter: self)
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
        _ = controller.viewModel
            .takeUntil(self.rx_deallocated)
            .observeOn(MainScheduler.sharedInstance)
            .subscribeNext(bindViewModel)

        controller.refresh()

        WPStyleGuide.resetReadableMarginsForTableView(tableView)
        WPStyleGuide.configureColorsForView(view, andTableView: tableView)
    }

    func bindViewModel(viewModel: ImmuTable) {
        handler.viewModel = viewModel
    }
}
