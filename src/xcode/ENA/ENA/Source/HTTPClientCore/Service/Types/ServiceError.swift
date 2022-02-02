//
// 🦠 Corona-Warn-App
//

import ENASecurity

/**
The errors that can occur while using the service and calling http methods.
*/
enum ServiceError<RE>: Error, CustomStringConvertible, Equatable where RE: Error {
	case invalidRequestError(ResourceError)
	case trustEvaluationError(TrustEvaluationError)
	case transportationError(Error)
	case unexpectedServerError(Int)
	case resourceError(ResourceError?)
	case receivedResourceError(RE)
	case invalidResponse
	case invalidResponseType
	case fakeResponse

	// MARK: - Protocol CustomStringConvertible

	var description: String {
		switch self {
		case .invalidRequestError(let resourceError):
			return "invalidRequestError(\(resourceError))"
		case .trustEvaluationError(let trustEvaluationError):
			return "trustEvaluationError(\(trustEvaluationError))"
		case .transportationError(let error):
			return "transportationError(\(error))"
		case .unexpectedServerError(let errorCode):
			return "unexpectedServerError(\(errorCode))"
		case .resourceError(let resourceError):
			return "resourceError(\(String(describing: resourceError)))"
		case .receivedResourceError(let resourceError):
			return "\(resourceError)"
		case .invalidResponse:
			return "invalidResponse"
		case .invalidResponseType:
			return "invalidResponseType"
		case .fakeResponse:
			return "fakeResponse"
		}
	}

	// MARK: - Protocol Equatable

	// swiftlint:disable cyclomatic_complexity
	static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
		switch (lhs, rhs) {
		case let (.invalidRequestError(lResourceError), .invalidRequestError(rResourceError)):
			return lResourceError.localizedDescription == rResourceError.localizedDescription
		case (.invalidRequestError, _):
			return false
		case let (.transportationError(lError), .transportationError(rError)):
			return lError.localizedDescription == rError.localizedDescription
		case (.transportationError, _):
			return false

		case let (.unexpectedServerError(lInt), .unexpectedServerError(rInt)):
			return lInt == rInt
		case (.unexpectedServerError, _):
			return false

		case let (.resourceError(lResourceError), .resourceError(rResourceError)):
			return lResourceError?.localizedDescription == rResourceError?.localizedDescription
		case (.resourceError, _):
			return false

		case let (.receivedResourceError(lError), .receivedResourceError(rError)):
			return lError.localizedDescription == rError.localizedDescription
		case (.receivedResourceError, _):
			return false
		case (.invalidResponse, .invalidResponse):
			return true
		case (.invalidResponse, _):
			return false
		case (.invalidResponseType, .invalidResponseType):
			return true
		case (.invalidResponseType, _):
			return false
		case (.fakeResponse, .fakeResponse):
			return true
		case (.fakeResponse, _):
			return false
		case (.trustEvaluationError, .trustEvaluationError):
			return true
		case (.trustEvaluationError, _):
			return false
		}
	}
}