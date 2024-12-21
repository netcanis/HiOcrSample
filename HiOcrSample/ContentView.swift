//
//  ContentView.swift
//  HiOcrSample
//
//  Created by netcanis on 12/21/24.
//

import SwiftUI
import feat_ocr

struct ContentView: View {
    @State private var scannedImage: UIImage? = nil
    @State private var cardNumber: String = "Card Number: N/A"
    @State private var expiryDate: String = "Expiry Date: N/A"
    @State private var holderName: String = "Holder Name: N/A"
    @State private var issuingNetwork: String = "Issuer: N/A"

    var body: some View {
        NavigationView {
            VStack {
                // Display scanned card information and image
                VStack {
                    if let scannedImage = scannedImage {
                        Image(uiImage: scannedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .cornerRadius(10)
                            .padding()
                    } else {
                        Image(systemName: "creditcard")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 200)
                            .foregroundColor(.gray)
                            .padding()
                    }

                    Text(cardNumber)
                        .font(.headline)
                        .padding(.bottom, 2)
                    Text(expiryDate)
                        .font(.subheadline)
                        .padding(.bottom, 2)
                    Text(holderName)
                        .font(.subheadline)
                        .padding(.bottom, 2)
                    Text(issuingNetwork)
                        .font(.subheadline)
                }
                .padding(.bottom, 20)

                Spacer()

                // Buttons for OCR scan and list view
                VStack {
                    Button(action: startOcrScan) {
                        Text("Start Credit Card OCR Scan")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: HiCardNumberListView()) {
                        Text("View Scanned Cards")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                Spacer()
            }
            .padding()
            .navigationTitle("HiOCR Sample")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // Action to start OCR scan
    private func startOcrScan() {
        HiCardScanner.shared.licenseKey = "5172842b555966c14149f47505756c48c5f5394178f18b0cffb3dbd11e69898b|1750331753"
        HiCardScanner.shared.start { result in
            DispatchQueue.main.async {
                self.cardNumber = "Card Number: \(result.cardNumber ?? "N/A")"
                self.expiryDate = "Expiry Date: \(result.expiryDate ?? "N/A")"
                self.holderName = "Holder Name: \(result.holderName ?? "N/A")"
                self.issuingNetwork = "Issuer: \(result.issuingNetwork ?? "N/A")"
                
                if let lastImage = HiCardScanner.shared.lastScannedImage {
                    print("Last scanned image update.")
                    self.scannedImage = lastImage
                } else {
                    print("Error: Last scanned image is nil.")
                }
                
                HiCardScanner.shared.stop()
            }
        }
    }
}

#Preview {
    ContentView()
}
