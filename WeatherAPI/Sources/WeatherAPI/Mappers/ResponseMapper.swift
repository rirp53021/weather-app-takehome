import Foundation

// MARK: - Response Mapper Protocol (Internal)
internal protocol ResponseMapper {
    associatedtype Response
    associatedtype Domain
    
    func map(_ response: Response) throws -> Domain
}
