//
//  DeeplinkURLBuilder.swift
//  ZvykTests
//
//  Created by Mityuklyaev-VE on 18.05.2023.
//

import Foundation

enum DeeplinkTest {}

extension DeeplinkTest {
    enum Builder {
        enum UrlType: String {
            /// "https"
            case universal = "https"
            /// "yourAppName"
            case urlScheme = "yourAppName"
        }

        class BaseBuilder {
            var components: URLComponents

            enum Path: String {
                case action
                case track
                case playlist
                case synthesis
            }

            internal init(scheme: UrlType) {
                components = URLComponents()
                components.scheme = scheme.rawValue
            }

            func path(_ path: Path) -> Self {
                components.path = components.path + "/" + path.rawValue
                return self
            }

            func path(_ path: String) -> Self {
                components.path = components.path + "/" + path
                return self
            }

            func id(_ id: String) -> Self {
                components.path = components.path.appending("/\(id)")
                return self
            }

            func queryItems(_ queryItems: [URLQueryItem]) -> Self {
                components.queryItems = queryItems
                return self
            }

            func build() -> URL? {
                return components.url
            }
        }

        class UniversalURLBuilder: BaseBuilder {
            enum Host: String {
                case yourAppName = "yourAppName.com"
                case action = "action"
            }

            init() {
                super.init(scheme: .universal)
            }

            func host(_ host: Host) -> Self {
                components.host = host.rawValue
                return self
            }
        }

        class SchemeURLBuilder: BaseBuilder {
            init() {
                super.init(scheme: .urlScheme)
            }

            func host(_ host: Builder.BaseBuilder.Path) -> Self {
                components.host = host.rawValue
                return self
            }

            /// Универсальные ссылки формально не имеют host и вместо него сразу идет path,
            /// но для правильного формаирования ссылки, host должен быть установлен,
            /// поэтому первый path устанавливается как host
            ///
            /// Пример:
            /// ссылка: yourAppName://profile/1164080496
            /// - cхема: "yourAppName"
            /// - хост: "profile"
            /// - путь: "/1164080496"
            override func path(_ path: Builder.BaseBuilder.Path) -> Self {
                if components.host == nil {
                    components.host = path.rawValue
                    return self
                } else {
                    return super.path(path)
                }
            }

            override func path(_ path: String) -> Self {
                if components.host == nil {
                    components.host = path
                    return self
                } else {
                    return super.path(path)
                }
            }
        }
    }
}

extension DeeplinkTest.Builder {
    static func trackURL(scheme: UrlType, id: String) -> URL? {
        switch scheme {
        case .urlScheme:
            return SchemeURLBuilder()
                .host(.track)
                .id(id)
                .build()
        case .universal:
            return UniversalURLBuilder()
                .host(.yourAppName)
                .path(.track)
                .id(id)
                .build()
        }
    }

    static func synthesisPlaylistURL(scheme: UrlType, id: String) -> URL? {
        switch scheme {
        case .urlScheme:
            return SchemeURLBuilder()
                .host(.playlist)
                .path(.synthesis)
                .id(id)
                .build()
        case .universal:
            return UniversalURLBuilder()
                .host(.yourAppName)
                .path(.playlist)
                .path(.synthesis)
                .id(id)
                .build()
        }
    }

    static func actionURL(scheme: UrlType, queryItems: [URLQueryItem]) -> URL? {
        switch scheme {
        case .urlScheme:
            return SchemeURLBuilder()
                .host(.action)
                .queryItems(queryItems)
                .build()
        case .universal:
            return UniversalURLBuilder()
                .host(.action)
                .queryItems(queryItems)
                .build()
        }
    }
}
