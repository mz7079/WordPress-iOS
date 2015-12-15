import UIKit
import RxSwift

protocol SettingsPresenter: AnyObject {
    func push<T>(controllerGenerator: T -> UIViewController) -> T -> Void
}

extension SettingsPresenter where Self: UIViewController {
    func push<T>(controllerGenerator: T -> UIViewController) -> T -> Void {
        return {
            [unowned self] in
            let controller = controllerGenerator($0)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

protocol SettingsController: AnyObject {
    var title: String { get }
    var viewModel: Observable<ImmuTable> { get }
    var service: AccountSettingsService { get }
}

// Actions
extension SettingsController {
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

