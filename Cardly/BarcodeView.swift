import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BarcodeImageView: View {
    let value: String
    let kind: CodeKind
    var height: CGFloat = 150

    private let context = CIContext()

    var body: some View {
        Group {
            if let image = generate() {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            } else {
                ContentUnavailableView("Codice non valido", systemImage: "barcode.viewfinder")
            }
        }
    }

    private func generate() -> UIImage? {
        switch kind {
        case .qr:
            let filter = CIFilter.qrCodeGenerator()
            filter.message = Data(value.utf8)
            filter.correctionLevel = "M"
            guard let output = filter.outputImage else { return nil }
            return render(output)
        case .code128:
            let filter = CIFilter.code128BarcodeGenerator()
            filter.message = Data(value.utf8)
            filter.quietSpace = 7
            guard let output = filter.outputImage else { return nil }
            return render(output)
        case .ean13:
            // Core Image non include un generatore EAN-13 nativo.
            // Nella prima build usiamo Code 128 come rappresentazione scansionabile
            // preservando il numero della tessera.
            let filter = CIFilter.code128BarcodeGenerator()
            filter.message = Data(value.utf8)
            filter.quietSpace = 7
            guard let output = filter.outputImage else { return nil }
            return render(output)
        }
    }

    private func render(_ image: CIImage) -> UIImage? {
        let scaled = image.transformed(by: CGAffineTransform(scaleX: 8, y: 8))
        guard let cg = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cg)
    }
}
