#!/usr/bin/env xcrun swift

/// Created by Alessandro Marzoli.
/// $ chmod +x xcode_plugins_updater.swift


import Foundation


public extension String {
  
  // http://pueblo.sourceforge.net/doc/manual/ansi_color_codes.html
  
  /// bold
  var bold: String {
    return "\u{001B}[1m"+self+"\u{001B}[22m"
  }
  
  /// italic
  var italic: String {
    return "\u{001B}[3m"+self+"\u{001B}[23m"
  }
  
  /// underline
  var underline: String {
    return "\u{001B}[4m"+self+"\u{001B}[24m"
  }
  
  /// reverse foreground & background color
  var inverse: String {
    return "\u{001B}[7m"+self+"\u{001B}[27m"
  }
  
  /// strikethough
  var strikethrough: String {
    return "\u{001B}[9m"+self+"\u{001B}[29m"
  }
  
  /// black foreground color
  var black: String {
    return "\u{001B}[30m"+self+"\u{001B}[0m"
  }
  
  /// red foreground color
  var red: String {
    return "\u{001B}[31m"+self+"\u{001B}[0m"
  }
  
  /// green foreground color
  var green: String {
    return "\u{001B}[32m"+self+"\u{001B}[0m"
  }
  
  /// yellow foreground color
  var yellow: String {
    return "\u{001B}[33m"+self+"\u{001B}[0m"
  }
  
  /// blue foreground color
  var blue: String {
    return "\u{001B}[34m"+self+"\u{001B}[0m"
  }
  
  /// magenta foreground color
  var magenta: String {
    return "\u{001B}[35m"+self+"\u{001B}[0m"
  }
  
  /// cyan foreground color
  var cyan: String {
    return "\u{001B}[36m"+self+"\u{001B}[0m"
  }
  
  /// white foreground color
  var white: String {
    return "\u{001B}[37m"+self+"\u{001B}[0m"
  }
  
  /// default foreground color (white)
  var defaultColor: String {
    return "\u{001B}[39m"+self+"\u{001B}[0m"
  }
  
  /// black background color
  var backgroundBlack: String {
    return "\u{001B}[40m"+self+"\u{001B}[0m"
  }
  
  /// red background color
  var backgroundRed: String {
    return "\u{001B}[41m"+self+"\u{001B}[0m"
  }
  
  /// green background color
  var backgroundGreen: String {
    return "\u{001B}[42m"+self+"\u{001B}[0m"
  }
  
  /// yellow background color
  var backgroundYellow: String {
    return "\u{001B}[43m"+self+"\u{001B}[0m"
  }
  
  /// blue background color
  var backgroundBlue: String {
    return "\u{001B}[44m"+self+"\u{001B}[0m"
  }
  
  /// magenta background color
  var backgroundMagenta: String {
    return "\u{001B}[45m"+self+"\u{001B}[0m"
  }
  
  /// cyan background color
  var backgroundCyan: String {
    return "\u{001B}[46m"+self+"\u{001B}[0m"
  }
  
  /// white background color
  var backgroundWhite: String {
    return "\u{001B}[47m"+self+"\u{001B}[0m"
  }
  
  /// default background color (black)
  var backgroundDefaultColor: String {
    return "\u{001B}[49m"+self+"\u{001B}[0m"
  }
  
}


enum Command {
  
  case version
  case help
  case xcode
  case xcodeBeta
  case xcodeWithPath(String)
  
  enum ScriptError: Error {
    case xcodeInfoPlistNotFound(String)
    case xcodeInfoPlistReadFailed(String)
    case xcodePluginsNotFound(String)
    case xcodePluginInfoPlistWriteFailed(String)
  }
  
  private struct Constants {
    
    static let version                   = "1.0.2"
    static let scriptName                = "Xcode Plugins Updater"
    static let xcodeDefaultPath          = "/Applications/Xcode.app"
    static let xcodeBetaDefaultPath      = "/Applications/Xcode-beta.app"
    static let xcodeCompatibilityUUID    = "DVTPlugInCompatibilityUUID"
    static let pluginCompatibilityUUIDs  = "DVTPlugInCompatibilityUUIDs"
    static let xcodePluginsDirectoryPath = ("~/Library/Application Support/Developer/Shared/Xcode/Plug-ins" as NSString).expandingTildeInPath
    
  }
  
  /// find a command for a given `argument`
  static func findCommand(for argument: String) -> Command? {
    
    switch argument {
      
    case "-v", "--version":
      return .version
      
    case "-h", "--help":
      return .help
      
    case "-xc", "--xcode":
      return .xcode
      
    case "-xcb", "--xcodebeta":
      return .xcodeBeta
      
    case let a where a.hasPrefix("-xcp="):
      let xcodePath = a.substring(from: a.index(a.startIndex, offsetBy: "-xcp=".characters.count))
      return xcodeWithPath(xcodePath)
      
    case let a where a.hasPrefix("--xcodepath="):
      let xcodePath = a.substring(from: a.index(a.startIndex, offsetBy: "--xcodepath=".characters.count))
      return xcodeWithPath(xcodePath)
      
    default:
      return nil
    }
    
  }
  
  /// exec a `command`
  static func exec(command : Command) throws {
    
    switch command {
      
    case version:
      
      let message = "\n" +
        "-----------------------------------------" +
        "\n\n" +
        "\(Constants.scriptName)".bold.blue +
        "\n" +
        "\n" +
        "Version: \(Constants.version)" +
        "\n" +
        "\n" +
        "-----------------------------------------" +
      "\n"
      
      print(message)
      
    case help:
      
      let message = "\n" +
        "-----------------------------------------" +
        "\n\n" +
        "\(Constants.scriptName)".bold.blue +
        "\n\n" +
        "USAGE:".underline +
        "\n\n" +
        "-v, --version : version" +
        "\n" +
        "\n" +
        "-h, --help : help" +
        "\n" +
        "\n" +
        "-xc, --xcode : update plugins for Xcode at path: \(Constants.xcodeDefaultPath)." +
        "\n" +
        "\n" +
        "-xcb, --xcodebeta : update plugins for Xcode at path: \(Constants.xcodeBetaDefaultPath)." +
        "\n" +
        "\n" +
        "-xcp="+"/CUSTOM_PATH".bold+", --xcodepath="+"/CUSTOM_PATH".bold+" : update plugins for Xcode at a given custom path. (ex. -xcp=/Applications/Xcode-beta.app)" +
        "\n" +
        "\n" +
        "-----------------------------------------" +
      "\n"
      
      print(message)
      
    case xcode:
      try updatePluginsForXcode(at: Constants.xcodeDefaultPath)
      
    case xcodeBeta:
      try  updatePluginsForXcode(at: Constants.xcodeBetaDefaultPath)
      
    case xcodeWithPath(let path):
      try updatePluginsForXcode(at: path)
      
    }
    
  }
  
  /// Xcode info.plist
  static func infoPlistForXcode(at path: String) -> NSDictionary? {
    
    let xcodeInfoPlistURL = NSURL(fileURLWithPath: path).appendingPathComponent("Contents/Info.plist")
    return  NSDictionary(contentsOf: xcodeInfoPlistURL!)
    
  }
  
  /// Xcode plugins URLs
  static func getXcodePlugins() -> [URL]? {
    
    let pluginsDirectoryURL = NSURL(fileURLWithPath: Constants.xcodePluginsDirectoryPath)
    let fileManager = FileManager.default
    guard
      let pluginURLs = try? fileManager.contentsOfDirectory(at: pluginsDirectoryURL as URL, includingPropertiesForKeys: nil, options: [.skipsSubdirectoryDescendants, .skipsPackageDescendants]) else {
        return nil
    }
    let validPluginURLs = pluginURLs.filter{ $0.pathExtension == "xcplugin"}
    return validPluginURLs
    
  }
  
  /// update plugins for Xcode at a specified `path` or throws an error
  static func updatePluginsForXcode(at path: String) throws {
    
    guard
      let info = infoPlistForXcode(at: path) else {
        throw ScriptError.xcodeInfoPlistNotFound("Info.plist not found for Xcode at \(path)")
    }
    
    guard let compatibilityUUIDValue = info[Constants.xcodeCompatibilityUUID] as? String else {
      throw ScriptError.xcodeInfoPlistReadFailed("Failed to read \(Constants.xcodeCompatibilityUUID) from Xcode Info.plist")
    }
    
    print("\nUpdating plugins for Xcode at path \(path)...".bold)
    print("\n")
    print("DVTPlugInCompatibilityUUID: \(compatibilityUUIDValue)".cyan)
    print("\n")
    
    guard let pluginURLs = getXcodePlugins() else {
      throw ScriptError.xcodePluginsNotFound("Plugins not found for Xcode at \(path)")
    }
    
    
    for pluginURL in pluginURLs {
      
      guard let pluginName = (pluginURL.lastPathComponent as NSString?)?.deletingPathExtension else {
        continue
      }
      
      let pluginInfoPlistURL = pluginURL.appendingPathComponent("Contents/Info.plist")
      
      guard let pluginInfoPlist = NSMutableDictionary(contentsOf: pluginInfoPlistURL) else {
        let message = "⚠️ Failed to read Info.plist at \(pluginInfoPlistURL)".yellow
        print("\n\(message)")
        continue
      }
      
      // DVTPlugInCompatibilityUUID update
      if pluginInfoPlist[Constants.pluginCompatibilityUUIDs] == nil {
        
        // add the first DVTPlugInCompatibilityUUID
        pluginInfoPlist[Constants.pluginCompatibilityUUIDs] = [compatibilityUUIDValue]
        
      } else if var compatibilityUUIDs = pluginInfoPlist[Constants.pluginCompatibilityUUIDs] as? [String] {
        
        guard !compatibilityUUIDs.contains(compatibilityUUIDValue) else {
          let message = "‣ \(pluginName) is already compatible".yellow
          print("\(message)\n")
          continue
        }
        
        // add a new DVTPlugInCompatibilityUUID to the list
        compatibilityUUIDs.append(compatibilityUUIDValue)
        pluginInfoPlist[Constants.pluginCompatibilityUUIDs] = compatibilityUUIDs
        
      }
      
      guard
        let infoPlistData = try?  PropertyListSerialization.data(fromPropertyList: pluginInfoPlist, format: .xml, options: 0),
        let _ = try?  infoPlistData.write(to: pluginInfoPlistURL, options: [.atomicWrite])
        else {
          throw ScriptError.xcodePluginInfoPlistWriteFailed("Info.plist not found for Xcode at \(pluginInfoPlistURL)")
      }
      
      print("‣ \(pluginName.green) ✅\n")
      
    }
    
  }
  
}


func main(arguments args: [String]) {
  
  guard args.count == 2 else {
    fail(with: "Invalid number of arguments: type -h for help.")
  }
  
  guard let command = Command.findCommand(for: args[1] as String) else {
    fail(with: "Operation not supported: type -h for help.")
  }
  
  do {
    
    try Command.exec(command: command)
    exit(EXIT_SUCCESS)
    
  } catch Command.ScriptError.xcodeInfoPlistNotFound(let message) {
    fail(with: message)
    
  } catch Command.ScriptError.xcodeInfoPlistReadFailed(let message) {
    fail(with: message)
    
  } catch Command.ScriptError.xcodePluginsNotFound(let message) {
    fail(with: message)
    
  } catch Command.ScriptError.xcodePluginInfoPlistWriteFailed(let message) {
    fail(with: message)
    
  } catch {
    fail(with: "\(error)")
  }
  
  
}

func fail(with message: String) -> Never  {
  print("🚫 "+message.red+"\n")
  exit(EXIT_FAILURE)
}

// let's start
main(arguments: CommandLine.arguments)

