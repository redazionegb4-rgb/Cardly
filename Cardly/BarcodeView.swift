import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BarcodeImageView: View {
    let value: String
    let type: CodeType
    private let context = CIContext()

    var body: some View {
        Group {
            if let image = generate() {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: 185, maxHeight: 195)
            } else {
                Label("Codice non valido", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func generate() -> UIImage? {
        let output: CIImage?

        switch type {
        case .qr:
            let filter = CIFilter.qrCodeGenerator()
            filter.message = Data(value.utf8)
            filter.correctionLevel = "M"
            output = filter.outputImage
        case .barcode:
            let filter = CIFilter.code128BarcodeGenerator()
            filter.message = Data(value.utf8)
            filter.quietSpace = 8
            output = filter.outputImage
        }

        guard let output else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cg = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cg)
    }
}
