import Foundation
import UIKit
import RxSwift
import WordPressShared
import WordPressComAnalytics

typealias ImmuTableRowControllerGenerator = ImmuTableRow -> UIViewController

class AccountSettingsController: SettingsController {
    let title = NSLocalizedString("Account Settings", comment: "Account Settings Title");
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
        let username = TextRow(
            title: NSLocalizedString("Username", comment: "Account Settings Username label"),
            value: settings?.username ?? "")

        let email = EditableTextRow(
            title: NSLocalizedString("Email", comment: "Account Settings Email label"),
            value: settings?.email ?? "",
            action: presenter.push(editEmail())
        )

        let webAddress = EditableTextRow(
            title: NSLocalizedString("Web Address", comment: "Account Settings Web Address label"),
            value: settings?.webAddress ?? "",
            action: presenter.push(editWebAddress())
        )

        let uploadSize = MediaSizeRow(
            title: NSLocalizedString("Max Image Upload Size", comment: "Title for the image size settings option."),
            value: Int(MediaService.maxImageSizeSetting().width),
            onChange: mediaSizeChanged())

        let visualEditor = SwitchRow(
            title: NSLocalizedString("Visual Editor", comment: "Option to enable the visual editor"),
            value: WPPostViewController.isNewEditorEnabled(),
            onChange: visualEditorChanged()
        )

        return ImmuTable(sections: [
            ImmuTableSection(
                rows: [
                    username,
                    email,
                    webAddress
                ]),
            ImmuTableSection(
                headerText: NSLocalizedString("Media", comment: "Title label for the media settings section in the app settings"),
                rows: [
                    uploadSize
                ],
                footerText: nil),
            ImmuTableSection(
                headerText: NSLocalizedString("Editor", comment: "Title label for the editor settings section in the app settings"),
                rows: [
                    visualEditor
                ],
                footerText: nil)
            ])
    }

    var immutableRows: [ImmuTableRow.Type] {
        return [
            TextRow.self,
            EditableTextRow.self,
            MediaSizeRow.self,
            SwitchRow.self]
    }

    // MARK: - Actions

    func editEmail() -> ImmuTableRowControllerGenerator {
        return editText(AccountSettingsChange.Email, hint: NSLocalizedString("Will not be publicly displayed", comment: "Help text when editing email"))
    }

    func editWebAddress() -> ImmuTableRowControllerGenerator {
        return editText(AccountSettingsChange.WebAddress, hint: NSLocalizedString("Shown publicly when you comment on blogs.", comment: "Help text when editing web address"))
    }

    func mediaSizeChanged() -> Int -> Void {
        return {
            value in
            let size = CGSize(width: value, height: value)
            MediaService.setMaxImageSizeSetting(size)
        }
    }

    func visualEditorChanged() -> Bool -> Void {
        return {
            enabled in
            if enabled {
                WPAnalytics.track(.EditorToggledOn)
            } else {
                WPAnalytics.track(.EditorToggledOff)
            }
            WPPostViewController.setNewEditorEnabled(enabled)
        }
    }
}

class AccountSettingsViewController: UITableViewController, SettingsPresenter {
    let account: WPAccount

    lazy var controller: AccountSettingsController = {
        return AccountSettingsController(account: self.account, presenter: self)
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

        self.title = controller.title

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

