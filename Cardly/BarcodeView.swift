import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BarcodeImageView: View {
    let value: String
    let type: CodeType
    private let context = CIContext()

    var body: some View {
        if let image = makeImage() {
            Image(uiImage: image)
                .interpolation(.none)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, minHeight: 190, maxHeight: 200)
        } else {
            ContentUnavailableView("Codice non valido", systemImage: "exclamationmark.triangle")
        }
    }

    private func makeImage() -> UIImage? {
        let output: CIImage?
        switch type {
        case .qr:
            let f = CIFilter.qrCodeGenerator()
            f.message = Data(value.utf8)
            f.correctionLevel = "M"
            output = f.outputImage
        case .barcode:
            let f = CIFilter.code128BarcodeGenerator()
            f.message = Data(value.utf8)
            f.quietSpace = 8
            output = f.outputImage
        }
        guard let output else { return nil }
        let scaled = output.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cg = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cg)
    }
}
