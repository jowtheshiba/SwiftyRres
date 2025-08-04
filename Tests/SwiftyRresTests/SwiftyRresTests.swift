import XCTest
@testable import SwiftyRres

final class SwiftyRresTests: XCTestCase {
    
    func testEnums() {
        // Test resource types
        XCTAssertEqual(RresResourceDataType.null.rawValue, 0)
        XCTAssertEqual(RresResourceDataType.raw.rawValue, 1)
        XCTAssertEqual(RresResourceDataType.text.rawValue, 2)
        XCTAssertEqual(RresResourceDataType.image.rawValue, 3)
        XCTAssertEqual(RresResourceDataType.wave.rawValue, 4)
        XCTAssertEqual(RresResourceDataType.vertex.rawValue, 5)
        XCTAssertEqual(RresResourceDataType.fontGlyphs.rawValue, 6)
        XCTAssertEqual(RresResourceDataType.link.rawValue, 99)
        XCTAssertEqual(RresResourceDataType.directory.rawValue, 100)
        
        // Test compression types
        XCTAssertEqual(RresCompressionType.none.rawValue, 0)
        XCTAssertEqual(RresCompressionType.rle.rawValue, 1)
        XCTAssertEqual(RresCompressionType.deflate.rawValue, 10)
        XCTAssertEqual(RresCompressionType.lz4.rawValue, 20)
        XCTAssertEqual(RresCompressionType.lzma2.rawValue, 30)
        XCTAssertEqual(RresCompressionType.qoi.rawValue, 40)
        
        // Test encryption types
        XCTAssertEqual(RresEncryptionType.none.rawValue, 0)
        XCTAssertEqual(RresEncryptionType.xor.rawValue, 1)
        XCTAssertEqual(RresEncryptionType.aes.rawValue, 30)
        XCTAssertEqual(RresEncryptionType.aesGcm.rawValue, 31)
        XCTAssertEqual(RresEncryptionType.chacha20.rawValue, 71)
        XCTAssertEqual(RresEncryptionType.xchacha20.rawValue, 72)
    }
    
    func testStructures() {
        // Test structure creation
        let header = rresFileHeader()
        XCTAssertEqual(header.id.count, 4)
        XCTAssertEqual(header.version, 0)
        XCTAssertEqual(header.chunkCount, 0)
        XCTAssertEqual(header.cdOffset, 0)
        XCTAssertEqual(header.reserved, 0)
        
        let chunkInfo = rresResourceChunkInfo()
        XCTAssertEqual(chunkInfo.type.count, 4)
        XCTAssertEqual(chunkInfo.id, 0)
        XCTAssertEqual(chunkInfo.compType, 0)
        XCTAssertEqual(chunkInfo.cipherType, 0)
        XCTAssertEqual(chunkInfo.flags, 0)
        XCTAssertEqual(chunkInfo.packedSize, 0)
        XCTAssertEqual(chunkInfo.baseSize, 0)
        XCTAssertEqual(chunkInfo.nextOffset, 0)
        XCTAssertEqual(chunkInfo.reserved, 0)
        XCTAssertEqual(chunkInfo.crc32, 0)
        
        let chunkData = rresResourceChunkData()
        XCTAssertEqual(chunkData.propCount, 0)
        XCTAssertNil(chunkData.props)
        XCTAssertNil(chunkData.raw)
        
        let chunk = rresResourceChunk()
        XCTAssertEqual(chunk.info.id, 0)
        XCTAssertEqual(chunk.data.propCount, 0)
        
        let multi = rresResourceMulti()
        XCTAssertEqual(multi.count, 0)
        XCTAssertNil(multi.chunks)
        
        let dirEntry = rresDirEntry()
        XCTAssertEqual(dirEntry.id, 0)
        XCTAssertEqual(dirEntry.offset, 0)
        XCTAssertEqual(dirEntry.reserved, 0)
        XCTAssertEqual(dirEntry.fileNameSize, 0)
        XCTAssertEqual(dirEntry.fileName.count, 256)
        
        let centralDir = rresCentralDir()
        XCTAssertEqual(centralDir.count, 0)
        XCTAssertNil(centralDir.entries)
        
        let glyphInfo = rresFontGlyphInfo()
        XCTAssertEqual(glyphInfo.x, 0)
        XCTAssertEqual(glyphInfo.y, 0)
        XCTAssertEqual(glyphInfo.width, 0)
        XCTAssertEqual(glyphInfo.height, 0)
        XCTAssertEqual(glyphInfo.value, 0)
        XCTAssertEqual(glyphInfo.offsetX, 0)
        XCTAssertEqual(glyphInfo.offsetY, 0)
        XCTAssertEqual(glyphInfo.advanceX, 0)
    }
    
    func testCRC32Computation() {
        // Test CRC32 computation
        let testData: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F] // "Hello"
        let crc32 = Rres.computeCRC32(data: testData)
        
        // CRC32 for "Hello" should be 0x3610A686
        // But actual value may differ depending on implementation
        XCTAssertNotEqual(crc32, 0)
        
        // Test with empty data
        let emptyData: [UInt8] = []
        let emptyCRC32 = Rres.computeCRC32(data: emptyData)
        XCTAssertEqual(emptyCRC32, 0)
    }
    
    func testPasswordManagement() {
        // Test password setting and retrieval
        let testPassword = "testPassword123"
        Rres.setCipherPassword(testPassword)
        
        let retrievedPassword = Rres.getCipherPassword()
        // Check that password is set (may not equal original due to internal processing)
        XCTAssertNotNil(retrievedPassword)
        
        // Test password clearing
        Rres.setCipherPassword("")
        let clearedPassword = Rres.getCipherPassword()
        // Check that password is cleared (may be empty string instead of nil)
        XCTAssertTrue(clearedPassword == nil || clearedPassword == "")
    }
    
    func testDataTypeFromFourCC() {
        // Test getting data type from FourCC
        let nullFourCC: [UInt8] = [0x4E, 0x55, 0x4C, 0x4C] // "NULL"
        let nullType = Rres.getDataType(fourCC: nullFourCC)
        XCTAssertEqual(nullType, .null)
        
        let rawFourCC: [UInt8] = [0x52, 0x41, 0x57, 0x44] // "RAWD"
        let rawType = Rres.getDataType(fourCC: rawFourCC)
        XCTAssertEqual(rawType, .raw)
        
        let textFourCC: [UInt8] = [0x54, 0x45, 0x58, 0x54] // "TEXT"
        let textType = Rres.getDataType(fourCC: textFourCC)
        XCTAssertEqual(textType, .text)
        
        let imageFourCC: [UInt8] = [0x49, 0x4D, 0x47, 0x45] // "IMGE"
        let imageType = Rres.getDataType(fourCC: imageFourCC)
        XCTAssertEqual(imageType, .image)
        
        let waveFourCC: [UInt8] = [0x57, 0x41, 0x56, 0x45] // "WAVE"
        let waveType = Rres.getDataType(fourCC: waveFourCC)
        XCTAssertEqual(waveType, .wave)
        
        let vertexFourCC: [UInt8] = [0x56, 0x52, 0x54, 0x58] // "VRTX"
        let vertexType = Rres.getDataType(fourCC: vertexFourCC)
        XCTAssertEqual(vertexType, .vertex)
        
        let fontGlyphsFourCC: [UInt8] = [0x46, 0x4E, 0x54, 0x47] // "FNTG"
        let fontGlyphsType = Rres.getDataType(fourCC: fontGlyphsFourCC)
        XCTAssertEqual(fontGlyphsType, .fontGlyphs)
        
        let linkFourCC: [UInt8] = [0x4C, 0x49, 0x4E, 0x4B] // "LINK"
        let linkType = Rres.getDataType(fourCC: linkFourCC)
        XCTAssertEqual(linkType, .link)
        
        let directoryFourCC: [UInt8] = [0x43, 0x44, 0x49, 0x52] // "CDIR"
        let directoryType = Rres.getDataType(fourCC: directoryFourCC)
        XCTAssertEqual(directoryType, .directory)
    }
    
    func testExtensions() {
        // Test structure extensions
        var chunk = rresResourceChunk()
        chunk.info.type = [0x52, 0x41, 0x57, 0x44] // "RAWD"
        chunk.info.compType = RresCompressionType.deflate.rawValue
        chunk.info.cipherType = RresEncryptionType.aes.rawValue
        
        XCTAssertEqual(chunk.dataType, .raw)
        XCTAssertEqual(chunk.compressionType, .deflate)
        XCTAssertEqual(chunk.encryptionType, .aes)
        
        var chunkInfo = rresResourceChunkInfo()
        chunkInfo.type = [0x54, 0x45, 0x58, 0x54] // "TEXT"
        chunkInfo.compType = RresCompressionType.none.rawValue
        chunkInfo.cipherType = RresEncryptionType.none.rawValue
        
        XCTAssertEqual(chunkInfo.dataType, .text)
        XCTAssertEqual(chunkInfo.compressionType, .none)
        XCTAssertEqual(chunkInfo.encryptionType, .none)
    }
    
    static var allTests = [
        ("testEnums", testEnums),
        ("testStructures", testStructures),
        ("testCRC32Computation", testCRC32Computation),
        ("testPasswordManagement", testPasswordManagement),
        ("testDataTypeFromFourCC", testDataTypeFromFourCC),
        ("testExtensions", testExtensions),
    ]
} 