import Foundation

func goodURL(url: String?, format: String?) -> String {
    if url != nil && format != nil{
        var urlArray = Array("\(url!).\(format!)")
        if urlArray[4] != "s" { urlArray.insert("s", at: 4) }
        return String(urlArray)
    } else { return "https://www.rosheta.com/upload/e604a3b304e3515f3442a4fbfb7a48eb9435f9ea5eca681a349a2e2ab0a23494.png"}
}
