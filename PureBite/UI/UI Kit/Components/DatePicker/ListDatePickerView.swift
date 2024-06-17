import SwiftUI

struct ListDatePickerView: View  {

    @Binding private var date: Date?

    private let state: BasicInputView.State
    private let placeholder: String
    private let header: String?
    private let caption: String?
    private let datePlaceholder: String?
    private let minDate: Date?
    private let maxDate: Date?
    private let pickerMode: DatePickerWithPlaceholder.PickerMode
    private let minuteInterval: Int

    init(
        date: Binding<Date?>,
        state: BasicInputView.State,
        header: String? = nil,
        caption: String? = nil,
        placeholder: String,
        datePlaceholder: String? = nil,
        minDate: Date?,
        maxDate: Date?,
        pickerMode: DatePickerWithPlaceholder.PickerMode,
        minuteInterval: Int = 1
    ) {
        self._date = date
        self.state = state
        self.header = header
        self.caption = caption
        self.placeholder = placeholder
        self.datePlaceholder = datePlaceholder
        self.minDate = minDate
        self.maxDate = maxDate
        self.pickerMode = pickerMode
        self.minuteInterval = minuteInterval
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let header {
                Text(header)
                    .textStyle(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 12)
            }
            HStack {
                Text(placeholder)
                    .textStyle(.body)
                    .foregroundColor(date == nil ? .secondary : .primary)
                Spacer()
                DatePickerWithPlaceholder(
                    date: $date,
                    placeholder: datePlaceholder,
                    minDate: minDate,
                    maxDate: maxDate,
                    pickerMode: pickerMode,
                    minuteInterval: minuteInterval
                )
            }
            .padding(.horizontal, 12)
            .frame(height: 52)
            .background(state.backgroundColor.swiftUIColor)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            if let caption {
                Text(caption)
                    .textStyle(.caption1)
                    .foregroundColor(state == .error ? .red : .secondary)
                    .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 12)
    }
}
