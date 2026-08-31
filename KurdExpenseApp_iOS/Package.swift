// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "KurdExpenseApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "KurdExpenseApp",
            targets: ["KurdExpenseApp"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.20.0")
    ],
    targets: [
        .target(
            name: "KurdExpenseApp",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
            ],
            path: "KurdExpenseApp"
        ),
    ]
)
