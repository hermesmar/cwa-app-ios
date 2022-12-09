//
// 🦠 Corona-Warn-App
//

enum SRSPreconditionError: Error {

	/// Precondition: The device time check is correct
	case deviceTimeError(PPACError)

	/// Precondition: the app was installed less than 48h
	case insufficientAppUsageTime
	
	/// Precondition: there was already a key submission without a registered test, depending from configuration (for e.g. in the last 3 months)
	case positiveTestResultWasAlreadySubmittedWithinThreshold
	
	var errorCode: String { self.description }
	
	var message: String {
		switch self {
		case  .deviceTimeError:
			return String(
				format: AppStrings.ExposureSubmissionDispatch.SRSWarnOthersPreconditionAlert.deviceCheckError,
				errorCode
			)
		case .insufficientAppUsageTime:
			return String(
				format: AppStrings.ExposureSubmissionDispatch.SRSWarnOthersPreconditionAlert.insufficientAppUsageTimeMessage,
				errorCode
			)
		case  .positiveTestResultWasAlreadySubmittedWithinThreshold:
			return String(
				format: AppStrings.ExposureSubmissionDispatch.SRSWarnOthersPreconditionAlert.positiveTestResultWasAlreadySubmittedWithin90DaysMessage,
				errorCode
			)
		}
	}
}

extension SRSPreconditionError: ErrorCodeProviding {
	var description: ErrorCodeProviding.ErrorCode {
		switch self {
		case .deviceTimeError(let ppacError):
			switch ppacError {
			case .timeIncorrect:
				return "DEVICE_TIME_INCORRECT"
			case .timeUnverified:
				return "DEVICE_TIME_UNVERIFIED"
			default:
				// this case is not reachable
				return "DEVICE_TIME_INCORRECT"
			}
		case .insufficientAppUsageTime:
			return "MIN_TIME_SINCE_ONBOARDING"
		case .positiveTestResultWasAlreadySubmittedWithinThreshold:
			return "SUBMISSION_TOO_EARLY"
			
		}
	}
}