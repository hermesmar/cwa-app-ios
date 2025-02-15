//
// 🦠 Corona-Warn-App
//

import Foundation
import XCTest
@testable import ENA
import OpenCombine

class DiaryOverviewViewModelTest: CWATestCase {
	
	var subscriptions = [AnyCancellable]()
	
	override func setUp() {
		super.setUp()
		subscriptions.forEach({ $0.cancel() })
		subscriptions.removeAll()
	}

	/** riksupdate on homeState must trigger refrashTableview*/
	func testGIVEN_ViewModel_WHEN_ChangeRiskLevel_THEN_Refresh() {
		// GIVEN
		let diaryStore = makeMockStore()
		let store = MockTestStore()
		let homeState = HomeState(
			store: store,
			riskProvider: MockRiskProvider(),
			exposureManagerState: ExposureManagerState(authorized: true, enabled: true, status: .active),
			enState: .enabled,
			statisticsProvider: StatisticsProvider(
				client: CachingHTTPClientMock(),
				store: store
			), localStatisticsProvider: LocalStatisticsProvider(
				client: CachingHTTPClientMock(),
				store: store
			)
		)
		homeState.updateDetectionMode(.automatic)

		let viewModel = DiaryOverviewViewModel(
			diaryStore: diaryStore,
			store: store,
			eventStore: MockEventStore(),
			homeState: homeState
		)

		let expectationRefreshTableView = expectation(description: "Refresh Tableview")
		/*** why 3 times: 1 - initial value days + 1 - initial value homeState + 1 update HomeState */
		expectationRefreshTableView.expectedFulfillmentCount = 3
		
		viewModel.$days
			.sink { _ in
				expectationRefreshTableView.fulfill()
			}
			.store(in: &subscriptions)
		
		viewModel.homeState.$riskState
			.sink { _ in
				expectationRefreshTableView.fulfill()
			}
			.store(in: &subscriptions)

		// WHEN
		homeState.riskState = .risk(.mocked)
		// THEN
		wait(for: [expectationRefreshTableView], timeout: .medium)
	}

	func testDaysAreUpdatedWhenStoreChanges() throws {
		let diaryStore = makeMockStore()
		let store = MockTestStore()

		let viewModel = DiaryOverviewViewModel(
			diaryStore: diaryStore,
			store: store,
			eventStore: MockEventStore(),
			homeState: .fake()
		)

		let daysPublisherExpectation = expectation(description: "Days publisher called")
		/*** why 2 times: 1 - initial value days + 1 updata Diary days  */
		daysPublisherExpectation.expectedFulfillmentCount = 2
		
		viewModel.$days
			.sink { _ in
				daysPublisherExpectation.fulfill()
			}
			.store(in: &subscriptions)
		
		diaryStore.addContactPerson(name: "Martin Augst")

		waitForExpectations(timeout: .medium)
	}

	func testNumberOfSections() throws {
		let viewModel = DiaryOverviewViewModel(
			diaryStore: makeMockStore(),
			store: MockTestStore(),
			eventStore: MockEventStore(),
			homeState: .fake()
		)

		XCTAssertEqual(viewModel.numberOfSections, 2)
	}

	func testNumberOfRows() throws {
		let viewModel = DiaryOverviewViewModel(
			diaryStore: makeMockStore(),
			store: MockTestStore(),
			eventStore: MockEventStore(),
			homeState: .fake()
		)

		XCTAssertEqual(viewModel.numberOfRows(in: 0), 1)
		XCTAssertEqual(viewModel.numberOfRows(in: 1), 15)
	}

	func testGIVEN_DiaryOverviewViewModel_WHEN_noneHistoryExposureIsInStore_THEN_NoneHistoryExposureIsReturned() {
		// GIVEN
		let viewModel = DiaryOverviewViewModel(
			diaryStore: makeMockStore(),
			store: MockTestStore(),
			eventStore: MockEventStore(),
			homeState: .fake()
		)

		// WHEN
		let diaryOverviewDayCellModel = viewModel.cellModel(for: IndexPath(row: 4, section: 0))

		// THEN
		XCTAssertEqual(diaryOverviewDayCellModel.historyExposure, .none)
	}
	
	func testGIVEN_DiaryOverviewViewModel_WHEN_noneCheckinsWithRiskInStore_THEN_EmptyCheckinWithRiskIsReturned() {
		// GIVEN
		let viewModel = DiaryOverviewViewModel(
			diaryStore: makeMockStore(),
			store: MockTestStore(),
			eventStore: MockEventStore(),
			homeState: .fake()
		)

		// WHEN
		let diaryOverviewDayCellModel = viewModel.cellModel(for: IndexPath(row: 4, section: 0))

		// THEN
		XCTAssertTrue(diaryOverviewDayCellModel.checkinsWithRisk.isEmpty)
	}

	func testGIVEN_DiaryOverviewViewModel_WHEN_lowHistoryExposureIsInStore_THEN_LowHistoryExposureIsReturned() throws {

		// GIVEN
		let dateFormatter = ISO8601DateFormatter.justUTCDateFormatter
		let todayString = dateFormatter.string(from: Date())
		let today = try XCTUnwrap(dateFormatter.date(from: todayString))

		let wrongFormattedTodayMinus5Days = try XCTUnwrap(Calendar.utcCalendar.date(byAdding: .day, value: -5, to: today))
		let todayMinus5DaysString = dateFormatter.string(from: wrongFormattedTodayMinus5Days)
		let todayMinus5Days = try XCTUnwrap(dateFormatter.date(from: todayMinus5DaysString))
		
		let store = MockTestStore()
		store.enfRiskCalculationResult = ENFRiskCalculationResult(
			riskLevel: .low,
			minimumDistinctEncountersWithLowRisk: 1,
			minimumDistinctEncountersWithHighRisk: 1,
			mostRecentDateWithLowRisk: nil,
			mostRecentDateWithHighRisk: nil,
			numberOfDaysWithLowRisk: 1,
			numberOfDaysWithHighRisk: 1,
			calculationDate: today,
			riskLevelPerDate: [todayMinus5Days: .low],
			minimumDistinctEncountersWithHighRiskPerDate: [:]
		)
		let viewModel = DiaryOverviewViewModel(
			diaryStore: makeMockStore(),
			store: store,
			eventStore: MockEventStore(),
			homeState: .fake()
		)

		// WHEN
		let diaryOverviewDayCellModel = viewModel.cellModel(for: IndexPath(row: 5, section: 0))

		// THEN
		XCTAssertEqual(diaryOverviewDayCellModel.historyExposure, .encounter(.low))
	}

	func testGIVEN_DiaryOverviewViewModel_WHEN_highHistoryExposureIsInStore_THEN_HighHistoryExposureIsReturned() throws {

		// GIVEN
		let dateFormatter = ISO8601DateFormatter.justUTCDateFormatter
		let todayString = dateFormatter.string(from: Date())
		let today = try XCTUnwrap(dateFormatter.date(from: todayString))

		let wrongFormattedTodayMinus5Days = try XCTUnwrap(Calendar.utcCalendar.date(byAdding: .day, value: -7, to: today))
		let todayMinus7DaysString = dateFormatter.string(from: wrongFormattedTodayMinus5Days)
		let todayMinus7Days = try XCTUnwrap(dateFormatter.date(from: todayMinus7DaysString))
		
		let store = MockTestStore()
		store.enfRiskCalculationResult = ENFRiskCalculationResult(
			riskLevel: .low,
			minimumDistinctEncountersWithLowRisk: 1,
			minimumDistinctEncountersWithHighRisk: 1,
			mostRecentDateWithLowRisk: nil,
			mostRecentDateWithHighRisk: nil,
			numberOfDaysWithLowRisk: 1,
			numberOfDaysWithHighRisk: 1,
			calculationDate: today,
			riskLevelPerDate: [todayMinus7Days: .high],
			minimumDistinctEncountersWithHighRiskPerDate: [Date(): 1]
		)
		let viewModel = DiaryOverviewViewModel(
			diaryStore: makeMockStore(),
			store: store,
			eventStore: MockEventStore(),
			homeState: .fake()
		)


		// WHEN
		let diaryOverviewDayCellModel = viewModel.cellModel(for: IndexPath(row: 7, section: 0))
		let diaryOverviewDayCellModelNone = viewModel.cellModel(for: IndexPath(row: 5, section: 0))

		// THEN
		XCTAssertEqual(diaryOverviewDayCellModel.historyExposure, .encounter(.high))
		XCTAssertEqual(diaryOverviewDayCellModelNone.historyExposure, .none)

	}
	
	func testGIVEN_DiaryOverviewViewModel_WHEN_someCheckinsWithRiskAreInStore_THEN_CheckinsWithRiskAreReturned() throws {

		// GIVEN
		let dateFormatter = ISO8601DateFormatter.justUTCDateFormatter

		let todayString = dateFormatter.string(from: Date())
		let today = try XCTUnwrap(dateFormatter.date(from: todayString))

		let wrongFormattedTodayMinus5Days = try XCTUnwrap(Calendar.utcCalendar.date(byAdding: .day, value: -5, to: today))
		let todayMinus5DaysString = dateFormatter.string(from: wrongFormattedTodayMinus5Days)
		let todayMinus5Days = try XCTUnwrap(dateFormatter.date(from: todayMinus5DaysString))
		
		let eventStore = MockEventStore()
		
		guard case .success(let checkinId1) = eventStore.createCheckin(Checkin.mock()) else {
			XCTFail("Success result expected.")
			return
		}
		guard case .success(let checkinId2) = eventStore.createCheckin(Checkin.mock()) else {
			XCTFail("Success result expected.")
			return
		}
		let store = MockTestStore()

		let checkinOne = CheckinIdWithRisk(checkinId: checkinId1, riskLevel: .low)
		let checkinTwo = CheckinIdWithRisk(checkinId: checkinId2, riskLevel: .high)
		let checkinRiskCalculation = CheckinRiskCalculationResult(
            calculationDate: today,
            checkinIdsWithRiskPerDate: [todayMinus5Days: [checkinOne, checkinTwo]],
            riskLevelPerDate: [:]
		)
		
		store.checkinRiskCalculationResult = checkinRiskCalculation
		let viewModel = DiaryOverviewViewModel(
			diaryStore: makeMockStore(),
			store: store,
			eventStore: eventStore,
			homeState: .fake()
		)

		// WHEN
		let diaryOverviewDayCellModel = viewModel.cellModel(for: IndexPath(row: 5, section: 0))

		// THEN
		XCTAssertEqual(diaryOverviewDayCellModel.checkinsWithRisk.count, 2)
	}

	// MARK: - Private Helpers

	func makeMockStore() -> MockDiaryStore {
		let store = MockDiaryStore()
		store.addContactPerson(name: "Nick Gündling")
		store.addContactPerson(name: "Marcus Scherer")
		store.addContactPerson(name: "Artur Friesen")
		store.addContactPerson(name: "Pascal Brause")
		store.addContactPerson(name: "Kai Teuber")
		store.addContactPerson(name: "Karsten Gahn")
		store.addContactPerson(name: "Carsten Knoblich")
		store.addContactPerson(name: "Andreas Vogel")
		store.addContactPerson(name: "Puneet Mahali")
		store.addContactPerson(name: "Omar Ahmed")
		store.addLocation(name: "Supermarket")
		store.addLocation(name: "Bakery")

		return store
	}

}
