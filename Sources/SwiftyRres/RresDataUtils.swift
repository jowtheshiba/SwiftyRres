import Foundation

// MARK: - Data Utilities
public extension Rres {
    
    // MARK: - Raw Data Utilities
    static func getRawDataSize(_ chunk: rresResourceChunk) -> Int? {
        guard chunk.dataType == .raw,
              let props = chunk.data.props,
              chunk.data.propCount >= 1 else {
            return nil
        }
        return Int(props[0])
    }
    
    static func getRawDataExtension(_ chunk: rresResourceChunk) -> String? {
        guard chunk.dataType == .raw,
              let props = chunk.data.props,
              chunk.data.propCount >= 2 else {
            return nil
        }
        
        let ext1 = props[1]
        let ext2 = chunk.data.propCount >= 3 ? props[2] : 0
        
        var extensionBytes: [UInt8] = []
        
        // Convert ext1 (big-endian)
        extensionBytes.append(UInt8((ext1 >> 24) & 0xFF))
        extensionBytes.append(UInt8((ext1 >> 16) & 0xFF))
        extensionBytes.append(UInt8((ext1 >> 8) & 0xFF))
        extensionBytes.append(UInt8(ext1 & 0xFF))
        
        // Convert ext2 if present
        if ext2 != 0 {
            extensionBytes.append(UInt8((ext2 >> 24) & 0xFF))
            extensionBytes.append(UInt8((ext2 >> 16) & 0xFF))
            extensionBytes.append(UInt8((ext2 >> 8) & 0xFF))
            extensionBytes.append(UInt8(ext2 & 0xFF))
        }
        
        // Remove null bytes
        let nonZeroBytes = extensionBytes.prefix { $0 != 0 }
        
        guard !nonZeroBytes.isEmpty else { return nil }
        
        return String(bytes: Array(nonZeroBytes), encoding: .ascii)
    }
    
    // MARK: - Text Data Utilities
    static func getTextData(_ chunk: rresResourceChunk) -> String? {
        guard chunk.dataType == .text,
              let rawData = chunk.data.raw else {
            return nil
        }
        
        let dataSize = Int(chunk.data.propCount > 0 ? chunk.data.props![0] : 0)
        guard dataSize > 0 else { return nil }
        
        let data = Data(bytes: rawData, count: dataSize)
        return String(data: data, encoding: .utf8)
    }
    
    static func getTextEncoding(_ chunk: rresResourceChunk) -> RresTextEncoding? {
        guard chunk.dataType == .text,
              let props = chunk.data.props,
              chunk.data.propCount >= 2 else {
            return nil
        }
        return RresTextEncoding(rawValue: props[1])
    }
    
    static func getTextCodeLanguage(_ chunk: rresResourceChunk) -> RresCodeLang? {
        guard chunk.dataType == .text,
              let props = chunk.data.props,
              chunk.data.propCount >= 3 else {
            return nil
        }
        return RresCodeLang(rawValue: props[2])
    }
    
    // MARK: - Image Data Utilities
    static func getImageDimensions(_ chunk: rresResourceChunk) -> (width: Int, height: Int)? {
        guard chunk.dataType == .image,
              let props = chunk.data.props,
              chunk.data.propCount >= 2 else {
            return nil
        }
        return (width: Int(props[0]), height: Int(props[1]))
    }
    
    static func getImagePixelFormat(_ chunk: rresResourceChunk) -> RresPixelFormat? {
        guard chunk.dataType == .image,
              let props = chunk.data.props,
              chunk.data.propCount >= 3 else {
            return nil
        }
        return RresPixelFormat(rawValue: props[2])
    }
    
    static func getImageMipmaps(_ chunk: rresResourceChunk) -> Int? {
        guard chunk.dataType == .image,
              let props = chunk.data.props,
              chunk.data.propCount >= 4 else {
            return nil
        }
        return Int(props[3])
    }
    
    static func getImageData(_ chunk: rresResourceChunk) -> Data? {
        guard chunk.dataType == .image,
              let rawData = chunk.data.raw else {
            return nil
        }
        
        let dataSize = Int(chunk.info.packedSize)
        return Data(bytes: rawData, count: dataSize)
    }
    
    // MARK: - Wave Data Utilities
    static func getWaveInfo(_ chunk: rresResourceChunk) -> (frameCount: Int, sampleRate: Int, sampleSize: Int, channels: Int)? {
        guard chunk.dataType == .wave,
              let props = chunk.data.props,
              chunk.data.propCount >= 4 else {
            return nil
        }
        return (
            frameCount: Int(props[0]),
            sampleRate: Int(props[1]),
            sampleSize: Int(props[2]),
            channels: Int(props[3])
        )
    }
    
    static func getWaveData(_ chunk: rresResourceChunk) -> Data? {
        guard chunk.dataType == .wave,
              let rawData = chunk.data.raw else {
            return nil
        }
        
        let dataSize = Int(chunk.info.packedSize)
        return Data(bytes: rawData, count: dataSize)
    }
    
    // MARK: - Vertex Data Utilities
    static func getVertexInfo(_ chunk: rresResourceChunk) -> (vertexCount: Int, attribute: RresVertexAttribute, componentCount: Int, format: RresVertexFormat)? {
        guard chunk.dataType == .vertex,
              let props = chunk.data.props,
              chunk.data.propCount >= 4 else {
            return nil
        }
        
        guard let attribute = RresVertexAttribute(rawValue: props[1]),
              let format = RresVertexFormat(rawValue: props[3]) else {
            return nil
        }
        
        return (
            vertexCount: Int(props[0]),
            attribute: attribute,
            componentCount: Int(props[2]),
            format: format
        )
    }
    
    static func getVertexData(_ chunk: rresResourceChunk) -> Data? {
        guard chunk.dataType == .vertex,
              let rawData = chunk.data.raw else {
            return nil
        }
        
        let dataSize = Int(chunk.info.packedSize)
        return Data(bytes: rawData, count: dataSize)
    }
    
    // MARK: - Font Glyphs Data Utilities
    static func getFontGlyphsInfo(_ chunk: rresResourceChunk) -> (baseSize: Int, glyphCount: Int, glyphPadding: Int, style: RresFontStyle)? {
        guard chunk.dataType == .fontGlyphs,
              let props = chunk.data.props,
              chunk.data.propCount >= 4 else {
            return nil
        }
        
        guard let style = RresFontStyle(rawValue: props[3]) else {
            return nil
        }
        
        return (
            baseSize: Int(props[0]),
            glyphCount: Int(props[1]),
            glyphPadding: Int(props[2]),
            style: style
        )
    }
    
    static func getFontGlyphsData(_ chunk: rresResourceChunk) -> [rresFontGlyphInfo]? {
        guard chunk.dataType == .fontGlyphs,
              let rawData = chunk.data.raw else {
            return nil
        }
        
        guard let info = getFontGlyphsInfo(chunk) else {
            return nil
        }
        
        let glyphSize = MemoryLayout<rresFontGlyphInfo>.size
        let expectedSize = info.glyphCount * glyphSize
        
        guard expectedSize <= chunk.info.packedSize else {
            return nil
        }
        
        var glyphs: [rresFontGlyphInfo] = []
        let data = Data(bytes: rawData, count: expectedSize)
        
        for i in 0..<info.glyphCount {
            let offset = i * glyphSize
            let glyphData = data.subdata(in: offset..<(offset + glyphSize))
            
            var glyph = rresFontGlyphInfo()
            glyphData.copyBytes(to: withUnsafeMutableBytes(of: &glyph) { $0 })
            glyphs.append(glyph)
        }
        
        return glyphs
    }
    
    // MARK: - Link Data Utilities
    static func getLinkFilePath(_ chunk: rresResourceChunk) -> String? {
        guard chunk.dataType == .link,
              let rawData = chunk.data.raw else {
            return nil
        }
        
        let dataSize = Int(chunk.data.propCount > 0 ? chunk.data.props![0] : 0)
        guard dataSize > 0 else { return nil }
        
        let data = Data(bytes: rawData, count: dataSize)
        return String(data: data, encoding: .utf8)
    }
    
    // MARK: - Directory Data Utilities
    static func getDirectoryEntries(_ chunk: rresResourceChunk) -> [rresDirEntry]? {
        guard chunk.dataType == .directory,
              let rawData = chunk.data.raw else {
            return nil
        }
        
        let entryCount = Int(chunk.data.propCount > 0 ? chunk.data.props![0] : 0)
        guard entryCount > 0 else { return nil }
        
        let entrySize = MemoryLayout<rresDirEntry>.size
        let expectedSize = entryCount * entrySize
        
        guard expectedSize <= chunk.info.packedSize else {
            return nil
        }
        
        var entries: [rresDirEntry] = []
        let data = Data(bytes: rawData, count: expectedSize)
        
        for i in 0..<entryCount {
            let offset = i * entrySize
            let entryData = data.subdata(in: offset..<(offset + entrySize))
            
            var entry = rresDirEntry()
            entryData.copyBytes(to: withUnsafeMutableBytes(of: &entry) { $0 })
            entries.append(entry)
        }
        
        return entries
    }
}

// MARK: - Convenience Extensions for Data Access
public extension rresResourceChunk {
    
    var rawDataSize: Int? {
        return Rres.getRawDataSize(self)
    }
    
    var rawDataExtension: String? {
        return Rres.getRawDataExtension(self)
    }
    
    var textData: String? {
        return Rres.getTextData(self)
    }
    
    var textEncoding: RresTextEncoding? {
        return Rres.getTextEncoding(self)
    }
    
    var textCodeLanguage: RresCodeLang? {
        return Rres.getTextCodeLanguage(self)
    }
    
    var imageDimensions: (width: Int, height: Int)? {
        return Rres.getImageDimensions(self)
    }
    
    var imagePixelFormat: RresPixelFormat? {
        return Rres.getImagePixelFormat(self)
    }
    
    var imageMipmaps: Int? {
        return Rres.getImageMipmaps(self)
    }
    
    var imageData: Data? {
        return Rres.getImageData(self)
    }
    
    var waveInfo: (frameCount: Int, sampleRate: Int, sampleSize: Int, channels: Int)? {
        return Rres.getWaveInfo(self)
    }
    
    var waveData: Data? {
        return Rres.getWaveData(self)
    }
    
    var vertexInfo: (vertexCount: Int, attribute: RresVertexAttribute, componentCount: Int, format: RresVertexFormat)? {
        return Rres.getVertexInfo(self)
    }
    
    var vertexData: Data? {
        return Rres.getVertexData(self)
    }
    
    var fontGlyphsInfo: (baseSize: Int, glyphCount: Int, glyphPadding: Int, style: RresFontStyle)? {
        return Rres.getFontGlyphsInfo(self)
    }
    
    var fontGlyphsData: [rresFontGlyphInfo]? {
        return Rres.getFontGlyphsData(self)
    }
    
    var linkFilePath: String? {
        return Rres.getLinkFilePath(self)
    }
    
    var directoryEntries: [rresDirEntry]? {
        return Rres.getDirectoryEntries(self)
    }
} 