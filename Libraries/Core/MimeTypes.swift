import UniformTypeIdentifiers

public enum MimeTypes {

    public static subscript(ext: String) -> String? {
        UTType(filenameExtension: ext)?.preferredMIMEType
    }

    public static func fileExtension(for mimeType: String) -> String? {
        UTType(mimeType: mimeType)?.preferredFilenameExtension
    }
}
