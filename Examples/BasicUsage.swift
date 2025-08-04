import Foundation
import SwiftyRres

// Basic usage example for SwiftyRres
func basicUsageExample() {
    print("=== SwiftyRres Basic Usage Example ===")
    
    // 1. CRC32 computation
    let testData: [UInt8] = [0x48, 0x65, 0x6C, 0x6C, 0x6F] // "Hello"
    let crc32 = Rres.computeCRC32(data: testData)
    print("CRC32 for 'Hello': \(String(format: "0x%08X", crc32))")
    
    // 2. Password management for encryption
    Rres.setCipherPassword("mySecretPassword")
    let currentPassword = Rres.getCipherPassword()
    print("Set password: \(currentPassword ?? "nil")")
    
    // 3. Data type handling
    let rawFourCC: [UInt8] = [0x52, 0x41, 0x57, 0x44] // "RAWD"
    let dataType = Rres.getDataType(fourCC: rawFourCC)
    print("Data type for 'RAWD': \(dataType)")
    
    // 4. Creating and working with structures
    var chunk = rresResourceChunk()
    chunk.info.type = [0x52, 0x41, 0x57, 0x44] // "RAWD"
    chunk.info.compType = RresCompressionType.deflate.rawValue
    chunk.info.cipherType = RresEncryptionType.aes.rawValue
    
    print("Chunk data type: \(chunk.dataType)")
    print("Compression type: \(chunk.compressionType)")
    print("Encryption type: \(chunk.encryptionType)")
    
    // 5. Clear password
    Rres.setCipherPassword("")
    print("Password after clearing: \(Rres.getCipherPassword() ?? "nil")")
    
    print("=== Example completed ===")
}

// Example of working with different resource types
func resourceTypesExample() {
    print("\n=== Resource Types Example ===")
    
    // Creating a chunk with text data
    var textChunk = rresResourceChunk()
    textChunk.info.type = [0x54, 0x45, 0x58, 0x54] // "TEXT"
    textChunk.data.propCount = 4
    textChunk.data.props = UnsafePointer<UInt32>.allocate(capacity: 4)
    textChunk.data.props![0] = 11 // data size
    textChunk.data.props![1] = RresTextEncoding.utf8.rawValue
    textChunk.data.props![2] = RresCodeLang.python.rawValue
    textChunk.data.props![3] = 0 // culture code
    
    print("Text chunk type: \(textChunk.dataType)")
    print("Text encoding: \(textChunk.textEncoding?.rawValue ?? 0)")
    print("Code language: \(textChunk.textCodeLanguage?.rawValue ?? 0)")
    
    // Creating a chunk with image data
    var imageChunk = rresResourceChunk()
    imageChunk.info.type = [0x49, 0x4D, 0x47, 0x45] // "IMGE"
    imageChunk.data.propCount = 4
    imageChunk.data.props = UnsafePointer<UInt32>.allocate(capacity: 4)
    imageChunk.data.props![0] = 1920 // width
    imageChunk.data.props![1] = 1080 // height
    imageChunk.data.props![2] = RresPixelFormat.uncompR8G8B8A8.rawValue
    imageChunk.data.props![3] = 1 // mipmaps
    
    print("Image dimensions: \(imageChunk.imageDimensions?.width ?? 0) x \(imageChunk.imageDimensions?.height ?? 0)")
    print("Pixel format: \(imageChunk.imagePixelFormat?.rawValue ?? 0)")
    print("Number of mipmap levels: \(imageChunk.imageMipmaps ?? 0)")
    
    // Memory cleanup
    textChunk.data.props?.deallocate()
    imageChunk.data.props?.deallocate()
    
    print("=== Example completed ===")
}

// Example of working with central directory
func centralDirectoryExample() {
    print("\n=== Central Directory Example ===")
    
    // Creating central directory
    var centralDir = rresCentralDir()
    centralDir.count = 2
    
    // Creating directory entries
    var entries = [rresDirEntry(), rresDirEntry()]
    entries[0].id = 12345
    entries[0].offset = 1000
    entries[0].fileNameSize = 12
    entries[0].fileName = Array(repeating: 0, count: 256)
    "texture.png".utf8CString.prefix(11).enumerated().forEach { index, char in
        entries[0].fileName[index] = Int8(char)
    }
    
    entries[1].id = 67890
    entries[1].offset = 5000
    entries[1].fileNameSize = 10
    entries[1].fileName = Array(repeating: 0, count: 256)
    "sound.wav".utf8CString.prefix(9).enumerated().forEach { index, char in
        entries[1].fileName[index] = Int8(char)
    }
    
    print("Number of entries in directory: \(centralDir.count)")
    print("First entry - ID: \(entries[0].id), file: \(String(cString: entries[0].fileName))")
    print("Second entry - ID: \(entries[1].id), file: \(String(cString: entries[1].fileName))")
    
    print("=== Example completed ===")
}

// Main function to run examples
func runExamples() {
    basicUsageExample()
    resourceTypesExample()
    centralDirectoryExample()
}

// Run examples if file is executed directly
#if canImport(Foundation)
if CommandLine.arguments.contains("--run-examples") {
    runExamples()
}
#endif 