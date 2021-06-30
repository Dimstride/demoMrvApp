import Foundation

func goodURL(url: String?, format: String?) -> String {
    if url != nil && format != nil{
        var urlArray = Array("\(url!).\(format!)")
        if urlArray[4] != "s" { urlArray.insert("s", at: 4) }
        return String(urlArray)
    } else { return "https://i.stack.imgur.com/6M513.png"}
}
