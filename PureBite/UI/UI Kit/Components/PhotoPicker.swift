import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    typealias UIViewControllerType = PHPickerViewController

    private let filter: PHPickerFilter
    private let onComplete: ([PHPickerResult]) -> Void

    init(
        filter: PHPickerFilter,
        onComplete: @escaping ([PHPickerResult]) -> Void
    ) {
        self.filter = filter
        self.onComplete = onComplete
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = filter
        configuration.selectionLimit = 1
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: PHPickerViewControllerDelegate {

        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            parent.onComplete(results)
            picker.dismiss(animated: true)
        }

        private let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
    }

    static func convertToUIImageArray(
        fromResults results: [PHPickerResult],
        onComplete: @escaping ([UIImage]?, Error?) -> Void
    ) {
        var images = [UIImage]()

        let dispatchGroup = DispatchGroup()

        for result in results {
            dispatchGroup.enter()
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { (imageOrNil, errorOrNil) in
                    if let error = errorOrNil {
                        onComplete(nil, error)
                    }
                    if let image = imageOrNil as? UIImage {
                        images.append(image)
                    }
                    dispatchGroup.leave()
                }
            }
        }
        dispatchGroup.notify(queue: .main) {
            onComplete(images, nil)
        }
    }
}
