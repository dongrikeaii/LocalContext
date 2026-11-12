import Cocoa
struct Operations {
 static let fm = FileManager.default
 static func unique(_ dir:URL,_ name:String)->URL {let base=URL(fileURLWithPath:name); var u=dir.appendingPathComponent(name); var i=2; while fm.fileExists(atPath:u.path) {let ext=base.pathExtension; u=dir.appendingPathComponent(base.deletingPathExtension().lastPathComponent+" \(i)"+(ext.isEmpty ? "" : "."+ext)); i += 1}; return u}
 static func folder(_ u:URL)->URL {var d:ObjCBool=false; return fm.fileExists(atPath:u.path,isDirectory:&d) && d.boolValue ? u : u.deletingLastPathComponent()}
 static func run(_ executable:String,_ args:[String]) throws {let p=Process();p.executableURL=URL(fileURLWithPath:executable);p.arguments=args;let err=Pipe();p.standardError=err;try p.run();let data=err.fileHandleForReading.readDataToEndOfFile();p.waitUntilExit();if p.terminationStatus != 0 {throw NSError(domain:"LocalContext",code:Int(p.terminationStatus),userInfo:[NSLocalizedDescriptionKey:String(data:data,encoding:.utf8) ?? "操作失败"])}}
 static func perform(_ action:String,_ urls:[URL],destination:URL?=nil) throws {
 guard let first=urls.first else {return}
 switch action {
 case "path": NSPasteboard.general.clearContents(); NSPasteboard.general.setString(urls.map{$0.path}.joined(separator:"\n"),forType:.string)
 case "text": try Data().write(to:unique(folder(first),"未命名.txt"),options:.withoutOverwriting)
 case "markdown":try Data().write(to:unique(folder(first),"未命名.md"),options:.withoutOverwriting)
 case "word", "excel", "powerpoint":
 let ext=["word":"docx","excel":"xlsx","powerpoint":"pptx"][action]!
 guard let template=Bundle.main.url(forResource:"Blank",withExtension:ext,subdirectory:"Templates") else {throw NSError(domain:"LocalContext",code:2,userInfo:[NSLocalizedDescriptionKey:"Office 模板资源缺失，请重新安装应用"])}
 try fm.copyItem(at:template,to:unique(folder(first),"未命名."+ext))
 case "folder":try fm.createDirectory(at:unique(folder(first),"新建文件夹"),withIntermediateDirectories:false)
 case "duplicate":for u in urls {try fm.copyItem(at:u,to:unique(u.deletingLastPathComponent(),u.lastPathComponent))}
 case "copy", "move": guard let dest=destination else{return};for u in urls {let source=u.standardizedFileURL.resolvingSymlinksInPath().path;let destination=dest.standardizedFileURL.resolvingSymlinksInPath().path;guard destination != source && !destination.hasPrefix(source+"/") else {throw NSError(domain:"LocalContext",code:1,userInfo:[NSLocalizedDescriptionKey:"不能复制或移动到自身及其子目录"])};let target=unique(dest,u.lastPathComponent);if action == "copy" {try fm.copyItem(at:u,to:target)} else {try fm.moveItem(at:u,to:target)}}
 case "zip":let target=unique(first.deletingLastPathComponent(),first.deletingPathExtension().lastPathComponent+".zip");try run("/usr/bin/ditto",["-c","-k","--sequesterRsrc","--keepParent",first.path,target.path])
 case "unzip":for u in urls where u.pathExtension.lowercased() == "zip" {let target=unique(u.deletingLastPathComponent(),u.deletingPathExtension().lastPathComponent);try fm.createDirectory(at:target,withIntermediateDirectories:false);try run("/usr/bin/ditto",["-x","-k",u.path,target.path])}
 case "terminal":NSWorkspace.shared.open([folder(first)],withApplicationAt:URL(fileURLWithPath:"/System/Applications/Utilities/Terminal.app"),configuration:NSWorkspace.OpenConfiguration())
 default:break
 }
 }
}
