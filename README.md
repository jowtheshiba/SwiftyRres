# SwiftyRres

A Swift wrapper for the [RRES (Resource File Format)](https://github.com/raysan5/rres) library, providing easy access to resource file operations in Swift applications.

## Features

- **Multi-platform support**: macOS, Linux
- **Resource types**: Raw data, text, images, audio, vertex data, fonts, links, directories
- **Compression**: RLE, Deflate, LZ4, LZMA2, QOI
- **Encryption**: XOR, DES, AES, ChaCha20, and more
- **CRC32 validation**: Built-in data integrity checking

## Installation

### Swift Package Manager

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SwiftyRres.git", from: "1.0.0")
]
```

## Quick Start

```swift
import SwiftyRres

// Load a resource chunk
let chunk = Rres.loadResourceChunk(fileName: "resources.rres", rresId: 1)

// Get resource type
let dataType = chunk.dataType

// Access data based on type
if let textData = chunk.textData {
    print("Text content: \(textData)")
}

// Clean up
Rres.unloadResourceChunk(chunk)
```

## License

MIT License - see LICENSE file for details. 