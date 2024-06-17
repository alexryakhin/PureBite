import SwiftUI

struct MonthYearWheelPickerView: UIViewRepresentable {
    @Binding private var selection: Date
    private let minimumDate: Date?
    private let maximumDate: Date?

    private let picker: MonthYearWheelPicker

    init(
        selection: Binding<Date>,
        minimumDate: Date?,
        maximumDate: Date?
    ) {
        self._selection = selection
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        self.picker = MonthYearWheelPicker(
            date: selection.wrappedValue,
            minimumDate: minimumDate,
            maximumDate: maximumDate
        )
    }

    func makeUIView(context: Context) -> MonthYearWheelPicker {
        selection = minimumDate ?? Date()
        picker.onDateSelected = { date in
            selection = date
        }
        return picker
    }

    func updateUIView(_ picker: MonthYearWheelPicker, context: Context) {
    }
}
