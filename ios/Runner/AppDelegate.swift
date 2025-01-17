import UIKit
import Flutter
import Photos

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let CHANNEL = "com.shimultamo.flutter_gallery_app"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
      switch call.method {
      case "getAlbums":
        self.getAlbums { albums in
          result(albums)
        }
      case "getImagesForAlbum":
        guard let args = call.arguments as? [String: Any],
              let albumName = args["albumName"] as? String else {
          result([])
          return
        }
        self.getImagesForAlbum(albumName: albumName) { images in
          result(images)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func getAlbums(completion: @escaping ([[String: Any]]) -> Void) {
    PHPhotoLibrary.requestAuthorization { status in
      guard status == .authorized || status == .limited else {
        completion([])
        return
      }

      var albumList = [[String: Any]]()
      let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
      userAlbums.enumerateObjects { (collection, _, _) in
        if let assetCollection = collection as? PHAssetCollection {
          let albumName = assetCollection.localizedTitle ?? "Unknown"
          let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
          let count = assets.count

          albumList.append([
            "name": albumName,
            "count": count
          ])
        }
      }
      completion(albumList)
    }
  }

  private func getImagesForAlbum(albumName: String, completion: @escaping ([String]) -> Void) {
    PHPhotoLibrary.requestAuthorization { status in
      guard status == .authorized || status == .limited else {
        completion([])
        return
      }

      var imagePaths = [String]()
      let userAlbums = PHCollectionList.fetchTopLevelUserCollections(with: nil)
      userAlbums.enumerateObjects { (collection, _, _) in
        if let assetCollection = collection as? PHAssetCollection,
           let title = assetCollection.localizedTitle, title == albumName
        {
          let assets = PHAsset.fetchAssets(in: assetCollection, options: nil)
          assets.enumerateObjects { (asset, _, _) in
            let options = PHImageRequestOptions()
            options.isSynchronous = true
            PHImageManager.default().requestImageDataAndOrientation(for: asset, options: options) {
              data, _, _, info in
              if let info = info,
                 let fileUrl = info["PHImageFileURLKey"] as? NSURL {
                imagePaths.append(fileUrl.path ?? "")
              }
            }
          }
        }
      }
      completion(imagePaths)
    }
  }
}

