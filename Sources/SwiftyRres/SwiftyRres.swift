import Foundation

// MARK: - C Bridge
@_silgen_name("rresLoadResourceChunk")
private func rresLoadResourceChunk(_ fileName: UnsafePointer<Int8>, _ rresId: Int32) -> rresResourceChunk

@_silgen_name("rresUnloadResourceChunk")
private func rresUnloadResourceChunk(_ chunk: rresResourceChunk)

@_silgen_name("rresLoadResourceMulti")
private func rresLoadResourceMulti(_ fileName: UnsafePointer<Int8>, _ rresId: Int32) -> rresResourceMulti

@_silgen_name("rresUnloadResourceMulti")
private func rresUnloadResourceMulti(_ multi: rresResourceMulti)

@_silgen_name("rresLoadResourceChunkInfo")
private func rresLoadResourceChunkInfo(_ fileName: UnsafePointer<Int8>, _ rresId: Int32) -> rresResourceChunkInfo

@_silgen_name("rresLoadCentralDirectory")
private func rresLoadCentralDirectory(_ fileName: UnsafePointer<Int8>) -> rresCentralDir

@_silgen_name("rresUnloadCentralDirectory")
private func rresUnloadCentralDirectory(_ dir: rresCentralDir)

@_silgen_name("rresGetDataType")
private func rresGetDataType(_ fourCC: UnsafePointer<UInt8>) -> UInt32

@_silgen_name("rresGetResourceId")
private func rresGetResourceId(_ dir: rresCentralDir, _ fileName: UnsafePointer<Int8>) -> Int32

@_silgen_name("rresComputeCRC32")
private func rresComputeCRC32(_ data: UnsafePointer<UInt8>, _ len: Int32) -> UInt32

@_silgen_name("rresSetCipherPassword")
private func rresSetCipherPassword(_ pass: UnsafePointer<Int8>)

@_silgen_name("rresGetCipherPassword")
private func rresGetCipherPassword() -> UnsafePointer<Int8>?

// MARK: - C Structures
public struct rresFileHeader {
    public var id: [UInt8]
    public var version: UInt16
    public var chunkCount: UInt16
    public var cdOffset: UInt32
    public var reserved: UInt32
    
    public init() {
        self.id = [0, 0, 0, 0]
        self.version = 0
        self.chunkCount = 0
        self.cdOffset = 0
        self.reserved = 0
    }
}

public struct rresResourceChunkInfo {
    public var type: [UInt8]
    public var id: UInt32
    public var compType: UInt8
    public var cipherType: UInt8
    public var flags: UInt16
    public var packedSize: UInt32
    public var baseSize: UInt32
    public var nextOffset: UInt32
    public var reserved: UInt32
    public var crc32: UInt32
    
    public init() {
        self.type = [0, 0, 0, 0]
        self.id = 0
        self.compType = 0
        self.cipherType = 0
        self.flags = 0
        self.packedSize = 0
        self.baseSize = 0
        self.nextOffset = 0
        self.reserved = 0
        self.crc32 = 0
    }
}

public struct rresResourceChunkData {
    public var propCount: UInt32
    public var props: UnsafePointer<UInt32>?
    public var raw: UnsafeMutableRawPointer?
    
    public init() {
        self.propCount = 0
        self.props = nil
        self.raw = nil
    }
}

public struct rresResourceChunk {
    public var info: rresResourceChunkInfo
    public var data: rresResourceChunkData
    
    public init() {
        self.info = rresResourceChunkInfo()
        self.data = rresResourceChunkData()
    }
}

public struct rresResourceMulti {
    public var count: UInt32
    public var chunks: UnsafePointer<rresResourceChunk>?
    
    public init() {
        self.count = 0
        self.chunks = nil
    }
}

public struct rresDirEntry {
    public var id: UInt32
    public var offset: UInt32
    public var reserved: UInt32
    public var fileNameSize: UInt32
    public var fileName: [Int8]
    
    public init() {
        self.id = 0
        self.offset = 0
        self.reserved = 0
        self.fileNameSize = 0
        self.fileName = Array(repeating: 0, count: 256) // RRES_MAX_FILENAME_SIZE
    }
}

public struct rresCentralDir {
    public var count: UInt32
    public var entries: UnsafePointer<rresDirEntry>?
    
    public init() {
        self.count = 0
        self.entries = nil
    }
}

public struct rresFontGlyphInfo {
    public var x: Int32
    public var y: Int32
    public var width: Int32
    public var height: Int32
    public var value: Int32
    public var offsetX: Int32
    public var offsetY: Int32
    public var advanceX: Int32
    
    public init() {
        self.x = 0
        self.y = 0
        self.width = 0
        self.height = 0
        self.value = 0
        self.offsetX = 0
        self.offsetY = 0
        self.advanceX = 0
    }
}

// MARK: - Enums
public enum RresResourceDataType: UInt32 {
    case null = 0
    case raw = 1
    case text = 2
    case image = 3
    case wave = 4
    case vertex = 5
    case fontGlyphs = 6
    case link = 99
    case directory = 100
}

public enum RresCompressionType: UInt8 {
    case none = 0
    case rle = 1
    case deflate = 10
    case lz4 = 20
    case lzma2 = 30
    case qoi = 40
}

public enum RresEncryptionType: UInt8 {
    case none = 0
    case xor = 1
    case des = 10
    case tdes = 11
    case idea = 20
    case aes = 30
    case aesGcm = 31
    case xtea = 40
    case blowfish = 50
    case rsa = 60
    case salsa20 = 70
    case chacha20 = 71
    case xchacha20 = 72
    case xchacha20Poly1305 = 73
}

public enum RresErrorType: Int32 {
    case success = 0
    case fileNotFound = 1
    case fileFormat = 2
    case memoryAlloc = 3
}

public enum RresTextEncoding: UInt32 {
    case undefined = 0
    case utf8 = 1
    case utf8Bom = 2
    case utf16Le = 10
    case utf16Be = 11
}

public enum RresCodeLang: UInt32 {
    case undefined = 0
    case c = 1
    case cpp = 2
    case cs = 3
    case lua = 4
    case js = 5
    case python = 6
    case rust = 7
    case zig = 8
    case odin = 9
    case jai = 10
    case gdscript = 11
    case glsl = 12
}

public enum RresPixelFormat: UInt32 {
    case undefined = 0
    case uncompGrayscale = 1
    case uncompGrayAlpha = 2
    case uncompR5G6B5 = 3
    case uncompR8G8B8 = 4
    case uncompR5G5B5A1 = 5
    case uncompR4G4B4A4 = 6
    case uncompR8G8B8A8 = 7
    case uncompR32 = 8
    case uncompR32G32B32 = 9
    case uncompR32G32B32A32 = 10
    case compDxt1Rgb = 11
    case compDxt1Rgba = 12
    case compDxt3Rgba = 13
    case compDxt5Rgba = 14
    case compEtc1Rgb = 15
    case compEtc2Rgb = 16
    case compEtc2EacRgba = 17
    case compPvrtRgb = 18
    case compPvrtRgba = 19
    case compAstc4x4Rgba = 20
    case compAstc8x8Rgba = 21
}

public enum RresVertexAttribute: UInt32 {
    case position = 0
    case texcoord1 = 10
    case texcoord2 = 11
    case texcoord3 = 12
    case texcoord4 = 13
    case normal = 20
    case tangent = 30
    case color = 40
    case index = 100
}

public enum RresVertexFormat: UInt32 {
    case ubyte = 0
    case byte = 1
    case ushort = 2
    case short = 3
    case uint = 4
    case int = 5
    case hfloat = 6
    case float = 7
}

public enum RresFontStyle: UInt32 {
    case undefined = 0
    case regular = 1
    case bold = 2
    case italic = 3
}

// MARK: - Main Rres Class
public class Rres {
    
    // MARK: - Resource Loading
    public static func loadResourceChunk(fileName: String, rresId: Int32) -> rresResourceChunk {
        return fileName.withCString { fileNamePtr in
            rresLoadResourceChunk(fileNamePtr, rresId)
        }
    }
    
    public static func unloadResourceChunk(_ chunk: rresResourceChunk) {
        rresUnloadResourceChunk(chunk)
    }
    
    public static func loadResourceMulti(fileName: String, rresId: Int32) -> rresResourceMulti {
        return fileName.withCString { fileNamePtr in
            rresLoadResourceMulti(fileNamePtr, rresId)
        }
    }
    
    public static func unloadResourceMulti(_ multi: rresResourceMulti) {
        rresUnloadResourceMulti(multi)
    }
    
    public static func loadResourceChunkInfo(fileName: String, rresId: Int32) -> rresResourceChunkInfo {
        return fileName.withCString { fileNamePtr in
            rresLoadResourceChunkInfo(fileNamePtr, rresId)
        }
    }
    
    // MARK: - Central Directory
    public static func loadCentralDirectory(fileName: String) -> rresCentralDir {
        return fileName.withCString { fileNamePtr in
            rresLoadCentralDirectory(fileNamePtr)
        }
    }
    
    public static func unloadCentralDirectory(_ dir: rresCentralDir) {
        rresUnloadCentralDirectory(dir)
    }
    
    // MARK: - Utility Functions
    public static func getDataType(fourCC: [UInt8]) -> RresResourceDataType {
        return fourCC.withUnsafeBufferPointer { buffer in
            let dataType = rresGetDataType(buffer.baseAddress!)
            return RresResourceDataType(rawValue: dataType) ?? .null
        }
    }
    
    public static func getResourceId(dir: rresCentralDir, fileName: String) -> Int32 {
        return fileName.withCString { fileNamePtr in
            rresGetResourceId(dir, fileNamePtr)
        }
    }
    
    public static func computeCRC32(data: [UInt8]) -> UInt32 {
        return data.withUnsafeBufferPointer { buffer in
            rresComputeCRC32(buffer.baseAddress!, Int32(data.count))
        }
    }
    
    // MARK: - Password Management
    public static func setCipherPassword(_ password: String) {
        password.withCString { passwordPtr in
            rresSetCipherPassword(passwordPtr)
        }
    }
    
    public static func getCipherPassword() -> String? {
        guard let passwordPtr = rresGetCipherPassword() else {
            return nil
        }
        return String(cString: passwordPtr)
    }
}

// MARK: - Convenience Extensions
extension rresResourceChunk {
    public var dataType: RresResourceDataType {
        let fourCC = Array(info.type)
        return Rres.getDataType(fourCC: fourCC)
    }
    
    public var compressionType: RresCompressionType {
        return RresCompressionType(rawValue: info.compType) ?? .none
    }
    
    public var encryptionType: RresEncryptionType {
        return RresEncryptionType(rawValue: info.cipherType) ?? .none
    }
}

extension rresResourceChunkInfo {
    public var dataType: RresResourceDataType {
        let fourCC = Array(type)
        return Rres.getDataType(fourCC: fourCC)
    }
    
    public var compressionType: RresCompressionType {
        return RresCompressionType(rawValue: compType) ?? .none
    }
    
    public var encryptionType: RresEncryptionType {
        return RresEncryptionType(rawValue: cipherType) ?? .none
    }
} 