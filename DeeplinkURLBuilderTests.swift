//
//  DeeplinkURLBuilderTest.swift
//  ZvykTests
//
//  Created by Mityuklyaev-VE on 18.05.2023.
//

import Foundation
import XCTest

class DeeplinkURLBuilderTest: XCTestCase {
    typealias SchemeURLBuilder = DeeplinkTest.Builder.UniversalURLBuilder
    typealias UniversalURLBuilder = DeeplinkTest.Builder.SchemeURLBuilder

    // MARK: - Host

    func testUniversalSetHost() {
        let targetUrl = URL(string: "yourAppName://track")
        let urlWithHost = UniversalURLBuilder()
            .host(.track)
            .build()
        let urlWirhoutHost = UniversalURLBuilder()
            .path(.track)
            .build()

        XCTAssertEqual(urlWithHost, targetUrl)
        XCTAssertEqual(urlWirhoutHost, targetUrl)
    }

    func testSchemeSetHost() {
        let targetUrl = URL(string: "https://yourAppName.com")
        let buildedUrl = SchemeURLBuilder()
            .host(.yourAppName)
            .build()

        XCTAssertEqual(buildedUrl, targetUrl)
    }

    // MARK: - Host and path

    func testUniversalSetHostAndPath() {
        let targetUrl = URL(string: "yourAppName://playlist/synthesis")
        let urlWithHost = UniversalURLBuilder()
            .host(.playlist)
            .path(.synthesis)
            .build()
        let urlWirhoutHost = UniversalURLBuilder()
            .path(.playlist)
            .path(.synthesis)
            .build()

        XCTAssertEqual(urlWithHost, targetUrl)
        XCTAssertEqual(urlWirhoutHost, targetUrl)
    }

    func testUniversalSetLongUrl() {
        let targetUrl = URL(string: "yourAppName://playlist/synthesis/synthesis")
        let veryLongUrl = URL(string: "yourAppName://playlist/synthesis/track/synthesis")

        let urlWithHost = UniversalURLBuilder()
            .host(.playlist)
            .path(.synthesis)
            .path(.synthesis)
            .build()
        let urlWirhoutHost = UniversalURLBuilder()
            .path(.playlist)
            .path(.synthesis)
            .path(.synthesis)
            .build()
        let veryLongUrlWithHost = UniversalURLBuilder()
            .host(.playlist)
            .path(.synthesis)
            .path(.track)
            .path(.synthesis)
            .build()
        let veryLongUrlWithoutHost = UniversalURLBuilder()
            .path(.playlist)
            .path(.synthesis)
            .path(.track)
            .path(.synthesis)
            .build()

        XCTAssertEqual(urlWithHost, targetUrl)
        XCTAssertEqual(urlWirhoutHost, targetUrl)
        XCTAssertEqual(veryLongUrlWithHost, veryLongUrl)
        XCTAssertEqual(veryLongUrlWithoutHost, veryLongUrl)
    }

    func testSchemeSetHostAndPath() {
        let targetUrl = URL(string: "https://yourAppName.com/playlist/synthesis")
        let buildedUrl = SchemeURLBuilder()
            .host(.yourAppName)
            .path(.playlist)
            .path(.synthesis)
            .build()

        XCTAssertEqual(buildedUrl, targetUrl)
    }

    func testUniversalSetSomepath() {
        let targetUrl = URL(string: "yourAppName://somepath/track/synthesis")
        let buildedUrl = UniversalURLBuilder()
            .path("somepath")
            .path(.track)
            .path(.synthesis)
            .build()

        XCTAssertEqual(buildedUrl, targetUrl)
    }

    func testSchemeSetSomepath() {
        let targetUrl = URL(string: "https://yourAppName.com/somepath/track/synthesis")
        let buildedUrl = SchemeURLBuilder()
            .host(.yourAppName)
            .path("somepath")
            .path(.track)
            .path(.synthesis)
            .build()

        XCTAssertEqual(buildedUrl, targetUrl)
    }

    // MARK: - ID

    func testUniversalSetIdInUrl() {
        let targetUrl = URL(string: "yourAppName://playlist/synthesis/1234567")
        let buildUrl = UniversalURLBuilder()
            .host(.playlist)
            .path(.synthesis)
            .id("1234567")
            .build()

        XCTAssertEqual(buildUrl, targetUrl)
    }

    func testSchemeSetIdInUrl() {
        let targetUrl = URL(string: "https://yourAppName.com/playlist/synthesis/126822")
        let buildUrl = SchemeURLBuilder()
            .host(.yourAppName)
            .path(.playlist)
            .path(.synthesis)
            .id("126822")
            .build()

        XCTAssertEqual(buildUrl, targetUrl)
    }

    // MARK: - QueryItems

    func testUniversalSetQueryItems() {
        let targetUrl = URL(string: "yourAppName://playlist?autoplay=true")
        let buildUrl = UniversalURLBuilder()
            .path(.playlist)
            .queryItems([URLQueryItem(name: "autoplay", value: "true")])
            .build()

        XCTAssertEqual(buildUrl, targetUrl)
    }

    func testSchemeSetQueryItems() {
        let targetUrl = URL(string: "https://yourAppName.com/playlist?autoplay=true")
        let buildUrl = SchemeURLBuilder()
            .host(.yourAppName)
            .path(.playlist)
            .queryItems([URLQueryItem(name: "autoplay", value: "true")])
            .build()

        XCTAssertEqual(buildUrl, targetUrl)
    }
}
