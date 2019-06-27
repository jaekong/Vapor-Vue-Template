import Vapor
import FluentSQLite

protocol CRUDable: _FluentSQLiteModel, Migration, Parameter, Content {
    func update(to updated: Self)
}

protocol CRUDModel: CRUDable, FluentSQLiteModel {}

protocol ViewController {
    func setupView(_ router: inout Router, use templateLocation: String)
}

class CRUDController<T: CRUDable>: ViewController {
    func create(_ request: Request) throws -> Future<Response> {
        return try request.content.decode(T.self).flatMap { $0.save(on: request).encode(status: .created, for: request) }
    }

    func read(_ request: Request) throws -> Future<T> {
        return try request.parameters.next(T.self) as! Future<T>
    }

    func update(_ request: Request) throws -> Future<T> {
        return try flatMap(request.parameters.next(T.self) as! Future<T>, request.content.decode(T.self)) { original, updated in
            original.update(to: updated)
            return original.save(on: request)
        }
    }

    func delete(_ request: Request) throws -> Future<HTTPResponseStatus> {
        return try (request.parameters.next(T.self) as! Future<T>).delete(on: request).transform(to: .noContent)
    }

    func list(_ request: Request) throws -> Future<[T]> {
        return T.query(on: request).sort(T.idKey, .ascending).all()
    }

    func setup(_ router: inout Router) {
        router.post(use: create)
        router.get(T.parameter, "raw", use: read)
        router.put(T.parameter, use: update)
        router.delete(T.parameter, use: delete)
        router.get("list", use: list)
    }

    func setupView(_ router: inout Router, use templateLocation: String) {
        router.get(show: "\(templateLocation)/list")
        router.get(T.parameter, show: "\(templateLocation)/detail")
    }
}
