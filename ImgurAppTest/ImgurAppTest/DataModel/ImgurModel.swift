//  
// Copyright (c) 2020 Loverde Co.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
 
import UIKit
import LCEssentials

struct ImgurData: Codable {
    let data: [ImgurModel]?
}

struct ImgurModel: Codable {
    var id, title, description, link: String?
    var images_count: Int?
    var images: [Image]?
    
    static func request(completion:@escaping ([ImgurModel]?) -> Void){
        API.headers = ["Authorization": "Client-ID 1ceddedc03a5d71"]
        API.get(withAction: "https://api.imgur.com/3/gallery/search/?q=cats", withDictParams: nil, debug: false) { (result) in
            if result is Error {
                completion(nil)
            }else{
                if let json = result as? String {
                    let dict = json.JSONStringToDictionary()
                    var output: [ImgurModel]? = [ImgurModel]()
                    (dict?["data"] as? [[String:Any]])?.forEach({ (obDic) in
                        let append: ImgurModel = obDic.toObjetct()
                        output?.append(append)
                    })
                    completion(output)
                    //printInfo(title: "RESULT", msg: json)
                }else{
                    //printInfo(title: "", msg: result.debugDescription)
                    completion(nil)
                }
            }
        }
    }
}

struct Image: Codable {
    var id: String?
    var title: String?
    var description: String?
    var type: String?
    var animated: Bool?
    var link: String?
}
