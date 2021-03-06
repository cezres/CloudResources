//
//  UIImageView+CloudResources.swift
//  CloudResources
//
//  Created by azusa on 2022/6/12.
//

import Foundation
import UIKit

public extension UIImageView {
    func setCloudAsset(name: String) {
        CloudResources.shared.fetchResourceURL(name) { [weak self] url, error in
            guard let weakself = self, let url = url, let data = try? Data(contentsOf: url), let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                weakself.image = image
            }
        }
//        .cancel(onObjectRelease: self)
    }
    
    func setCloudAssetFromLocal(name: String) {
        guard
            let url = CloudResources.shared.fetchResourceUrlFromLocal(name),
            let image = UIImage(contentsOfFile: url.path)
        else {
            return
        }
        self.image = image
    }
}

extension Operation {
    func cancel(onObjectRelease object: NSObject) {
        object.addReleaseAction { [weak self] in
            self?.cancel()
        }
    }
}


private var __releaseProxyAssociatedKey: Int = 0

extension NSObject {
    class ReleaseProxy: NSObject {
        typealias Action = () -> Void
        var actions: [Action] = []
        
        deinit {
            for action in actions {
                action()
            }
        }
    }
    
    func addReleaseAction(_ action: @escaping () -> Void) {
        __releaseProxy.actions.append(action)
    }
    
    var __releaseProxy: ReleaseProxy {
        get {
            var proxy: ReleaseProxy
            if let result = objc_getAssociatedObject(self, &__releaseProxyAssociatedKey) as? ReleaseProxy {
                proxy = result
            } else {
                proxy = .init()
                objc_setAssociatedObject(self, &__releaseProxyAssociatedKey, proxy, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
            return proxy
        }
    }
}
