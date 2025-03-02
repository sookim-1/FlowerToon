import ProjectDescription

// MARK: - 스키마
let schemes: [Scheme] = [
    Scheme.scheme(
        name: "FlowerToon Debug",
        shared: true,
        buildAction: .buildAction(targets: ["FlowerToon"]),
        runAction: .runAction(configuration: "Debug"),
        archiveAction: .archiveAction(configuration: "Debug"),
        profileAction: .profileAction(configuration: "Debug"),
        analyzeAction: .analyzeAction(configuration: "Debug")
    ),
    Scheme.scheme(
        name: "FlowerToon",
        shared: true,
        buildAction: .buildAction(targets: ["FlowerToon"]),
        runAction: .runAction(configuration: "Release"),
        archiveAction: .archiveAction(configuration: "Release"),
        profileAction: .profileAction(configuration: "Release"),
        analyzeAction: .analyzeAction(configuration: "Release")
    ),
]

// MARK: - 세팅
let configurations: [Configuration] = [
    .debug(
        name: "Debug",
        xcconfig: .relativeToRoot("Configurations/FlowerToonBeta.xcconfig")
    ),
    .release(
        name: "Release",
        xcconfig: .relativeToRoot("Configurations/FlowerToonRelease.xcconfig")
    )
]

let settings = Settings.settings(configurations: configurations)



// MARK: - 타겟
let flowerToonTarget = Target.target(name: "FlowerToon",
                                     destinations: [.iPhone],
                                     product: .app,
                                     bundleId: "com.sookim.FlowerToon",
                                     deploymentTargets: .iOS("17.0"),
                                     infoPlist: "FlowerToon/Info.plist",
                                     sources: ["FlowerToon/Sources/**"],
                                     resources: ["FlowerToon/Resources/**"],
                                     dependencies: [
                                        .package(product: "SnapKit"),
                                        .package(product: "Then"),
                                        .package(product: "RxSwift"),
                                        .package(product: "RxGesture"),
                                        .package(product: "Kingfisher")
                                     ],
                                     settings: settings,
                                     coreDataModels: [.coreDataModel(("FlowerToon/Sources/Data/PersistentStorage/CoreDataStorage/CoreDataStorage.xcdatamodeld"))])

// MARK: 프로젝트
let project = Project(name: "FlowerToon",
                      organizationName: "sookim-1",
                      packages: [
                          .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMajor(from: "5.7.1")),
                          .remote(url: "https://github.com/devxoul/Then.git", requirement: .upToNextMajor(from: "3.0.0")),
                          .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .upToNextMajor(from: "6.6.0")),
                          .remote(url: "https://github.com/RxSwiftCommunity/RxGesture", requirement: .upToNextMajor(from: "4.0.4")),
                          .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .upToNextMajor(from: "7.11.0"))
                      ],
                      settings: settings,
                      targets: [flowerToonTarget],
                      schemes: schemes)
