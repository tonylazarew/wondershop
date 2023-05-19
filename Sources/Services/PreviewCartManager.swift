//
//  PreviewCartManager.swift
//  Wondershop
//
//  Created by Anton Lazarev on 16/05/2023.
//

import Foundation

#if DEBUG

func previewCartManager() -> CartManager {
    CartManagerImpl(store: PreviewCartStore())
}

#endif
