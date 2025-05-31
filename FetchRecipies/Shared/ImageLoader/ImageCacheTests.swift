import XCTest
@testable import FetchRecipies

final class ImageCacheTests: XCTestCase {
    var sut: ImageCache!
    let testKey = "test-image-key"
    var testImage: UIImage!
    
    override func setUp() {
        super.setUp()
        sut = ImageCache.shared
        testImage = UIImage(systemName: "star.fill")!
    }
    
    override func tearDown() {
        sut.clearCache()
        sut = nil
        testImage = nil
        super.tearDown()
    }
    
    func testImageCache_WhenImageIsStored_ShouldBeRetrievableFromMemory() {
        // Given
        sut.set(testImage, forKey: testKey)
        
        // When
        let retrievedImage = sut.get(forKey: testKey)
        
        // Then
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(
            retrievedImage?.pngData(),
            testImage.pngData(),
            "Retrieved image should match the stored image"
        )
    }
    
    func testImageCache_WhenImageIsStored_ShouldBeRetrievableFromDisk() {
        // Given
        sut.set(testImage, forKey: testKey)
        
        // When - Clear memory cache to force disk retrieval
        sut.clearCache()
        let retrievedImage = sut.get(forKey: testKey)
        
        // Then
        XCTAssertNotNil(retrievedImage)
        XCTAssertEqual(
            retrievedImage?.pngData(),
            testImage.pngData(),
            "Retrieved image from disk should match the stored image"
        )
    }
    
    func testImageCache_WhenCacheIsCleared_ShouldRemoveAllImages() {
        // Given
        sut.set(testImage, forKey: testKey)
        
        // When
        sut.clearCache()
        let retrievedImage = sut.get(forKey: testKey)
        
        // Then
        XCTAssertNil(retrievedImage, "Image should not be retrievable after cache is cleared")
    }
    
    func testImageCache_WhenNonexistentKeyIsQueried_ShouldReturnNil() {
        // When
        let retrievedImage = sut.get(forKey: "nonexistent-key")
        
        // Then
        XCTAssertNil(retrievedImage, "Should return nil for nonexistent key")
    }
    
    func testImageCache_WhenMultipleImagesAreStored_ShouldRetrieveCorrectImages() {
        // Given
        let testKey2 = "test-image-key-2"
        let testImage2 = UIImage(systemName: "circle.fill")!
        
        // When
        sut.set(testImage, forKey: testKey)
        sut.set(testImage2, forKey: testKey2)
        
        // Then
        let retrievedImage1 = sut.get(forKey: testKey)
        let retrievedImage2 = sut.get(forKey: testKey2)
        
        XCTAssertEqual(
            retrievedImage1?.pngData(),
            testImage.pngData(),
            "First retrieved image should match first stored image"
        )
        XCTAssertEqual(
            retrievedImage2?.pngData(),
            testImage2.pngData(),
            "Second retrieved image should match second stored image"
        )
    }
} 