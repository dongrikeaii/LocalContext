import Cocoa
final class Service: NSObject, NSApplicationDelegate {
 var window: NSWindow!
 func applicationDidFinishLaunching(_ notification: Notification) {
 let menu=NSMenu();let item=NSMenuItem();let sub=NSMenu();sub.addItem(withTitle:"退出本地右键工具",action:#selector(NSApplication.terminate(_:)),keyEquivalent:"q");item.submenu=sub;menu.addItem(item);NSApp.mainMenu=menu
 NSApp.servicesProvider = self
 NSUpdateDynamicServices()
 window = NSWindow(contentRect: NSRect(x:0,y:0,width:560,height:250), styleMask:[.titled,.closable,.miniaturizable], backing:.buffered,defer:false)
 window.title = "本地右键工具"
 let label = NSTextField(wrappingLabelWithString:"本地右键工具已启动\n\nFinder 选中文件/目录或右键空白处 → 本地右键工具：\n新建 Word、Excel、PowerPoint、文本、Markdown、文件夹；复制路径；创建副本；\n复制/移动到…；ZIP 压缩解压；在终端打开。\n\nFinder 扩展：系统设置 → 通用 → 登录项与扩展 → Finder → 启用本地右键工具。\n文件操作在本机完成。")
 label.frame = NSRect(x:24,y:24,width:510,height:200)
 window.contentView!.addSubview(label); window.center(); window.makeKeyAndOrderFront(nil); NSApp.activate(ignoringOtherApps:true)
 }
 func application(_ application:NSApplication,open urls:[URL]) {
 for url in urls {guard let c=URLComponents(url:url,resolvingAgainstBaseURL:false),c.scheme == "localcontext",c.host == "action" else {continue};let q=c.queryItems ?? [];let action=q.first{$0.name == "action"}?.value ?? "";let files=q.filter{$0.name == "path"}.compactMap{$0.value}.map{URL(fileURLWithPath:$0)};var dest:URL?=nil
 if action == "copy" || action == "move" {NSApp.activate(ignoringOtherApps:true);let panel=NSOpenPanel();panel.canChooseDirectories=true;panel.canChooseFiles=false;panel.prompt=action == "copy" ? "复制到这里" : "移动到这里";guard panel.runModal() == .OK else {continue};dest=panel.url}
 do {try Operations.perform(action,files,destination:dest)} catch {let alert=NSAlert(error:error);alert.runModal()}
 }
 }
 @objc func copyPaths(_ p:NSPasteboard,userData:String,error:AutoreleasingUnsafeMutablePointer<NSString?>) {
 let urls = p.readObjects(forClasses:[NSURL.self],options:[.urlReadingFileURLsOnly:true]) as? [URL] ?? []
 NSPasteboard.general.clearContents(); NSPasteboard.general.setString(urls.map{$0.path}.joined(separator:"\n"),forType:.string)
 }
 @objc func newText(_ p:NSPasteboard,userData:String,error:AutoreleasingUnsafeMutablePointer<NSString?>) {
 let urls = p.readObjects(forClasses:[NSURL.self],options:[.urlReadingFileURLsOnly:true]) as? [URL] ?? []
 do { for u in urls { var dir:ObjCBool=false; guard FileManager.default.fileExists(atPath:u.path,isDirectory:&dir),dir.boolValue else {continue}; var n=0; var target:URL
 repeat {target=u.appendingPathComponent(n == 0 ? "未命名.txt" : "未命名 \(n).txt"); n += 1} while FileManager.default.fileExists(atPath:target.path)
 try Data().write(to:target,options:.withoutOverwriting)
 } } catch let e {error.pointee=e.localizedDescription as NSString}
 }
}
let app=NSApplication.shared
let delegate=Service(); app.delegate=delegate; app.setActivationPolicy(.regular); app.run()
