// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "a9c6be416b4d0ad1b7eef3477b28a537"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: Entry.self)
  }
}