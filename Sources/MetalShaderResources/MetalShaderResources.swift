import Metal
import Foundation

/// Provides access to Metal shader resources bundled with the package
public enum MetalShaderResources {
    /// The Metal device for GPU access
    public static var metalDevice: MTLDevice? = MTLCreateSystemDefaultDevice()

    /// The Metal library containing compiled shaders from this package
    public static var packageMetalLibrary: MTLLibrary? = {
        guard let device = metalDevice else { return nil }
        return try? device.makeDefaultLibrary(bundle: Bundle.module)
    }()

    /// Lists all available Metal shader function names in the package
    public static var availableFunctions: [String] {
        return packageMetalLibrary?.functionNames ?? []
    }

    /// Creates a Metal library from the package's compiled shaders
    /// - Parameter device: The Metal device to use for creating the library
    /// - Returns: A Metal library instance, or nil if the library cannot be created
    public static func makeLibrary(device: MTLDevice) -> MTLLibrary? {
        return try? device.makeDefaultLibrary(bundle: Bundle.module)
    }
}