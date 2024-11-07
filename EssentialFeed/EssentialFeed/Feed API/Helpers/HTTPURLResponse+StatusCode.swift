//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Nicholas Ferretti on 2024/11/07.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool { return statusCode == HTTPURLResponse.OK_200 }
}
