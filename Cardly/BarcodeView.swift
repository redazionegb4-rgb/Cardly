import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct BarcodeImageView: View {
    let value: String
    let kind: CodeKind
    var height: CGFloat = 160

    private let context = CIContext()

    var body: some View {
        Group {
            if let image = makeImage() {
                Image(uiImage: image)
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, minHeight: height, maxHeight: height)
            } else {
                Label("Codice non valido", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func makeImage() -> UIImage? {
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
            filter.quietSpace = 8
            guard let output = filter.outputImage else { return nil }
            return render(output)
        }
    }

    private func render(_ input: CIImage) -> UIImage? {
        let scaled = input.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
        guard let cg = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cg)
    }
}
