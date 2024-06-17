#if os(iOS)
import SwiftUI
import UIKit
import CoreGraphics
import PDFKit

/**
 You can use this renderer to create pdf files from a SwiftUI View.
 */
public final class PDFRenderer<Content: View> {

    private let size: CGSize
    private let content: () -> Content

    /**
     Create an image renderer with a certain view content.

     - Parameters:
       - size: The size of the rendered image.
       - content: The view to render.
     */
    @MainActor
    init(size: CGSize, content: @escaping () -> Content) {
        self.size = size
        self.content = content
    }

    @MainActor
    public func writeToURL(_ localURL: URL) throws {
        if #available(iOS 16.0, *) {
            writeUsingImageRenderer(to: localURL)
        } else {
            try writeUsingLayer(to: localURL)
        }
    }

    @MainActor
    @available(iOS 16.0, *)
    private func writeUsingImageRenderer(to url: URL) {
        let renderer = ImageRenderer(content: content())
        if let consumer = CGDataConsumer(url: url as CFURL),
           let context = CGContext(consumer: consumer, mediaBox: nil, nil) {
            renderer.render { size, renderer in
                var mediaBox = CGRect(origin: .zero, size: size)
                context.beginPage(mediaBox: &mediaBox)

                // Drawing PDF
                renderer(context)

                context.endPDFPage()
                context.closePDF()
            }
        }
    }

    private func writeUsingLayer(to url: URL) throws {
        let window = UIWindow(frame: CGRect(origin: .zero, size: size))
        let hosting = UIHostingController(rootView: content())
        hosting.view.frame = window.frame
        window.addSubview(hosting.view)
        window.makeKeyAndVisible()

        guard 
            let mutableData = CFDataCreateMutable(nil, 0),
            let dataConsumer = CGDataConsumer(data: mutableData) 
        else {
            throw(PDFError.cannotCreateDataConsumer)
        }
        if let context = CGContext(consumer: dataConsumer, mediaBox: nil, nil) {
            var mediaBox = CGRect(origin: .zero, size: size)
            context.beginPage(mediaBox: &mediaBox)

            // Apply a vertical flip transformation
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1, y: -1)

            // Drawing PDF
            hosting.view.layer.render(in: context)

            context.endPDFPage()
            context.closePDF()

            // Updating the PDF URL
            let data = mutableData as Data
            try data.write(to: url, options: .atomic)
        }
    }
}

enum PDFError: Error {
    case cannotCreateDataConsumer
}
#endif
