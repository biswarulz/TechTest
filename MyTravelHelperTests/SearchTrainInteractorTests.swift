//
//  SearchTrainInteractorTests.swift
//  MyTravelHelperTests
//
//  Created by Biswajyoti Sahu on 31/05/21.
//  Copyright © 2021 Sample. All rights reserved.
//

import XCTest
@testable import MyTravelHelper

class SearchTrainInteractorTests: XCTestCase {

    private var interactor: SearchTrainInteractor! = nil
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        interactor = SearchTrainInteractor()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        interactor = nil
    }

    private class InteractorToPresenterProtocolSpy: InteractorToPresenterProtocol {
        
        var stationListFetchedCalled = false
        var fetchedTrainsListCalled = false
        var showNoTrainAvailbilityFromSourceCalled = false
        var showNoInterNetAvailabilityMessageCalled = false
        
        func stationListFetched(list: [Station]) {
            
            stationListFetchedCalled = true
        }
        
        func fetchedTrainsList(trainsList: [StationTrain]?) {
            
            fetchedTrainsListCalled = true
        }
        
        func showNoTrainAvailbilityFromSource() {
            
            showNoTrainAvailbilityFromSourceCalled = true
        }
        
        func showNoInterNetAvailabilityMessage() {
            
            showNoInterNetAvailabilityMessageCalled = true
        }
        
    }
    
    private class ReachTrueSpy: Reach {
        
        override func isNetworkReachable() -> Bool {
            
            return true
        }
    }
    
    private class ReachFalseSpy: Reach {
        
        override func isNetworkReachable() -> Bool {
            
            return false
        }
    }

    private class URLSessionSpy: URLSession {
        
        override class var shared: URLSession {
            
            get{
                
                return URLSessionSpy()
            }
            
            set {
                
            }
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            let station = Stations(stationsList: [])
            let data = try? JSONEncoder().encode(station)
            completionHandler(data, nil, nil)
            return URLSessionDataTaskSpy()
        }
    }
    
    private class URLSessionSpy1: URLSession {
        
        override class var shared: URLSession {
            
            get{
                
                return URLSessionSpy1()
            }
            
            set {
                
            }
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            completionHandler(Data(), nil, nil)
            return URLSessionDataTaskSpy()
        }
    }
    
    private class URLSessionSpy2: URLSession {
        
        override class var shared: URLSession {
            
            get{
                
                return URLSessionSpy2()
            }
            
            set {
                
            }
        }
        
        override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            
            let station = StationData(trainsList: [])
            let data = try? JSONEncoder().encode(station)
            completionHandler(data, nil, nil)
            return URLSessionDataTaskSpy()
        }
    }
    
    private class URLSessionDataTaskSpy: URLSessionDataTask {
        
        var resumeCalled = false
        override func resume() {
            
            resumeCalled = true
        }
    }

    
    func testFetchallStationsIfReachable() {
        
        // Given
        let session = URLSessionSpy()
        interactor.urlSession = session
        let presenter = InteractorToPresenterProtocolSpy()
        interactor.presenter = presenter
        interactor.reach = ReachTrueSpy()
        
        // When
        interactor.fetchallStations()
        
        // Then
        XCTAssertTrue(presenter.stationListFetchedCalled, "should be called")
    }
    
    func testFetchallStationsIfUnReachable() {
        
        // Given
        let session = URLSessionSpy()
        interactor.urlSession = session
        let presenter = InteractorToPresenterProtocolSpy()
        interactor.presenter = presenter
        interactor.reach = ReachFalseSpy()
        
        // When
        interactor.fetchallStations()
        
        // Then
        XCTAssertTrue(presenter.showNoInterNetAvailabilityMessageCalled, "should be called")
    }
    
    func testfetchTrainsFromSourceIfReachable() {
        
        // Given
        let session = URLSessionSpy2()
        interactor.urlSession = session
        let presenter = InteractorToPresenterProtocolSpy()
        interactor.presenter = presenter
        interactor.reach = ReachTrueSpy()
        
        // When
        interactor.fetchTrainsFromSource(sourceCode: "source", destinationCode: "destination")
        
        // Then
        XCTAssertTrue(presenter.showNoTrainAvailbilityFromSourceCalled, "should be called")
    }
    
    func testfetchTrainsFromSourceUnReachable() {
        
        // Given
        let session = URLSessionSpy2()
        interactor.urlSession = session
        let presenter = InteractorToPresenterProtocolSpy()
        interactor.presenter = presenter
        interactor.reach = ReachFalseSpy()
        
        // When
        interactor.fetchTrainsFromSource(sourceCode: "source", destinationCode: "destination")
        
        // Then
        XCTAssertTrue(presenter.showNoInterNetAvailabilityMessageCalled, "should be called")
    }
}
