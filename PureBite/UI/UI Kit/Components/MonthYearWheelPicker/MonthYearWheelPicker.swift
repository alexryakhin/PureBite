import UIKit

/// A control for the inputting of month and year values in a view that uses a spinning-wheel or slot-machine metaphor.
final class MonthYearWheelPicker: UIPickerView {

    private let calendar = Calendar(identifier: .gregorian)
    private(set) var maximumDate: Date
    private(set) var minimumDate: Date
    private(set) var date: Date
    private(set) var months = [String]()
    private(set) var years = [Int]()

    /// The month displayed by the picker.
    public var month: Int {
        calendar.component(.month, from: date)
    }

    /// The year displayed by the picker.
    public var year: Int {
        calendar.component(.year, from: date)
    }

    /// A completion handler to receive the date when the picker value is changed.
    public var onDateSelected: ((_ date: Date) -> Void)?

    public init(
        date: Date,
        minimumDate: Date? = nil,
        maximumDate: Date? = nil
    ) {
        self.date = date
        self.minimumDate = minimumDate ?? Self.formattedDate(from: Date())
        self.maximumDate = maximumDate ?? Self.formattedDate(from: Calendar(identifier: .gregorian).date(byAdding: .year, value: 25, to: Date()) ?? Date())
        super.init(frame: .zero)
        commonSetup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func updatePickers(animated: Bool) {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)

        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            selectRow(month - 1, inComponent: 0, animated: animated)
            if let firstYearIndex = years.firstIndex(of: year) {
                selectRow(firstYearIndex, inComponent: 1, animated: animated)
            }
        }
    }

    private func pickerViewDidSelectRow() {
        let month = selectedRow(inComponent: 0) + 1
        let year = years[selectedRow(inComponent: 1)]
        guard let date = DateComponents(calendar: calendar, year: year, month: month).date else {
            return
        }
        setDate(date, animated: true)
        onDateSelected?(self.date)
    }

    private static func formattedDate(from date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return DateComponents(
            calendar: calendar,
            year: calendar.component(.year, from: date),
            month: calendar.component(.month, from: date)
        ).date ?? Date()
    }

    private func setDate(_ date: Date, animated: Bool) {
        let date = Self.formattedDate(from: date)
        self.date = date
        if date > maximumDate {
            setDate(maximumDate, animated: true)
            return
        }
        if date < minimumDate {
            setDate(minimumDate, animated: true)
            return
        }
        updatePickers(animated: animated)
    }

    private func commonSetup() {
        delegate = self
        dataSource = self
        updateAvailableMonths()
        updateAvailableYears()
        updatePickers(animated: false)
    }

    private func updateAvailableMonths() {
        months = DateFormatter().standaloneMonthSymbols
            .compactMap { $0.capitalized }
    }

    private func updateAvailableYears() {
        var years = [Int]()

        let startYear = calendar.component(.year, from: minimumDate)
        let endYear = max(calendar.component(.year, from: maximumDate), startYear)

        while years.last != endYear {
            years.append((years.last ?? startYear - 1) + 1)
        }
        self.years = years
    }
}

extension MonthYearWheelPicker: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0: months.count
        case 1: years.count
        default: 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerViewDidSelectRow()
        if component == 1 {
            pickerView.reloadComponent(0)
        }
    }

    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {

        var text: String? = switch component {
        case 0: months[row]
        case 1: "\(years[row])"
        default: nil
        }

        guard let text = text else { return nil }

        var attributes = [NSAttributedString.Key: Any]()
        attributes[.foregroundColor] = UIColor.label

        if component == 0 {
            let month = row + 1
            let year = years[selectedRow(inComponent: 1)]
            if let date = DateComponents(calendar: calendar, year: year, month: month).date, date < minimumDate || date > maximumDate {
                attributes[.foregroundColor] = UIColor.secondaryLabel
            }
        }

        return NSAttributedString(string: text, attributes: attributes)
    }
}
