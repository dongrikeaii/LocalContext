import Cocoa
import FinderSync
@objc(FinderExtension)
final class FinderExtension:FIFinderSync {
 var selection:[URL]=[]
 let actions=["word","excel","powerpoint","text","markdown","folder","path","duplicate","copy","move","zip","unzip","terminal"]
 override init(){super.init();FIFinderSyncController.default().directoryURLs=[URL(fileURLWithPath:"/Users"),URL(fileURLWithPath:"/Volumes")]}
 override func menu(for menuKind:FIMenuKind)->NSMenu? {
 let c=FIFinderSyncController.default(); let selected=c.selectedItemURLs() ?? []; let urls = selected.isEmpty ? c.targetedURL().map{[$0]} ?? [] : selected
 selection=urls
 let menu=NSMenu(title:"本地右键工具"); let root=NSMenuItem(title:"本地右键工具",action:nil,keyEquivalent:"");let sub=NSMenu()
 for (name,id) in [("新建 Word 文档 (.docx)","word"),("新建 Excel 工作簿 (.xlsx)","excel"),("新建 PowerPoint 演示文稿 (.pptx)","powerpoint"),("新建文本文件","text"),("新建 Markdown","markdown"),("新建文件夹","folder"),("复制完整路径","path"),("创建副本","duplicate"),("复制到…","copy"),("移动到…","move"),("压缩为 ZIP（首项）","zip"),("解压 ZIP","unzip"),("在终端打开","terminal")] {let item=NSMenuItem(title:name,action:#selector(performAction(_:)),keyEquivalent:"");item.target=self;item.tag=actions.firstIndex(of:id)!;sub.addItem(item)}
 root.submenu=sub;menu.addItem(root);return menu
 }
 @objc func performAction(_ sender:NSMenuItem){guard actions.indices.contains(sender.tag) else{return};let id=actions[sender.tag];let urls=selection;NSLog("LocalContext action %@ count %d",id,urls.count)
 // Delegate file operations to the ordinary user process rather than request broad sandbox exceptions.
 var components=URLComponents();components.scheme="localcontext";components.host="action";components.queryItems=[URLQueryItem(name:"action",value:id)]+urls.map{URLQueryItem(name:"path",value:$0.path)};if let url=components.url {NSLog("LocalContext dispatch %d",NSWorkspace.shared.open(url))}
 }
}
