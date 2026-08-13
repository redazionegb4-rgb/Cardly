import SwiftUI
import VisionKit

struct ScannerView: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss
    @Binding var scannedValue: String

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    func makeUIViewController(context: Context) -> UIViewController {
        guard DataScannerViewController.isSupported,
              DataScannerViewController.isAvailable else {
            return UIHostingController(rootView:
                ContentUnavailableView("Scanner non disponibile",
                                       systemImage: "camera.fill",
                                       description: Text("Inserisci il codice manualmente."))
            )
        }

        let c = DataScannerViewController(
            recognizedDataTypes: [.barcode()],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        c.delegate = context.coordinator
        try? c.startScanning()
        return c
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}

    final class Coordinator: NSObject, DataScannerViewControllerDelegate {
        let parent: ScannerView
        init(parent: ScannerView) { self.parent = parent }

        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            guard case .barcode(let barcode) = item,
                  let payload = barcode.payloadStringValue else { return }
            parent.scannedValue = payload
            parent.dismiss()
        }
    }
}
