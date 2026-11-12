import Cocoa
@main struct Acceptance {
 static func main() throws {
 let fm=FileManager.default;let root=URL(fileURLWithPath:CommandLine.arguments[1]);try fm.createDirectory(at:root,withIntermediateDirectories:true)
 try Operations.perform("text",[root]);try Operations.perform("text",[root]);try Operations.perform("markdown",[root]);try Operations.perform("folder",[root]);let file=root.appendingPathComponent("未命名.txt");try Data("保留原文\n".utf8).write(to:file)
 try Operations.perform("duplicate",[file]);let dest=root.appendingPathComponent("目标");try fm.createDirectory(at:dest,withIntermediateDirectories:false);try Operations.perform("copy",[file],destination:dest)
 let movable=root.appendingPathComponent("移动样本.txt");try Data("移动".utf8).write(to:movable);try Operations.perform("move",[movable],destination:dest)
 try Operations.perform("zip",[file]);try Operations.perform("unzip",[root.appendingPathComponent("未命名.zip")])
 let original = try Data(contentsOf:file); assert(original == Data("保留原文\n".utf8));assert(fm.fileExists(atPath:root.appendingPathComponent("未命名 2.txt").path));assert(fm.fileExists(atPath:dest.appendingPathComponent("移动样本.txt").path));assert(!fm.fileExists(atPath:movable.path));let restored = try Data(contentsOf:root.appendingPathComponent("未命名/\(root.lastPathComponent)/未命名.txt")); assert(restored == original)
 print("PASS: 新建文本/重名避让/Markdown/文件夹/副本/复制/移动/ZIP往返及原文保留")
 }
}
