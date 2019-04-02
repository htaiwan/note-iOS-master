# Swift 5的新特性

------

- ABI的穩定
- 新特色
  - [SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md): Add Result to the Standard Library
  - [SE-0228](https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md): Fix `ExpressibleByStringInterpolation`
  - [SE-0230](https://github.com/apple/swift-evolution/blob/master/proposals/0230-flatten-optional-try.md): Flatten nested optionals resulting from 'try?'
  - [SE-0216](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md): Introduce user-defined dynamically "callable" types
  - [SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md): Handling Future Enum Cases
  - [SE-0233](https://github.com/apple/swift-evolution/blob/master/proposals/0233-additive-arithmetic-protocol.md): Make `Numeric` Refine a new `AdditiveArithmetic`Protocol

------

#### **<u>什麼是ABI</u>**

- Application Binary Interface
- ABI Stable的穩定表示binary的接口穩定，也就是裡用Swift 5以上的編譯器編譯出來的binary可以任意執行在Swift 5以上的runtime裡，在5之前，編譯器會將所需要的Swift runtime放到app裡，然後在執行時apple會將這個run time在放到iOS或mac系統上。
- 因為IOS12.2已經預設有Swift 5的runtime，所以Swift 5以上的編譯器打包出來的binary不在需要將所需的Swift runtime放到app裡，因此app size會大幅減少。
- 執行效率更快，因為直接使用系統內建的runtime，系統不需要將app中runtime移到系統中，再來執行。

#### <u>**Swift 5有哪些新特色**</u>

[Swift CHANGELOG](https://github.com/apple/swift/blob/master/CHANGELOG.md) 

SR - XXXX 表示修bug, SE-XXX表示新feature。

[SE-0235](https://github.com/apple/swift-evolution/blob/master/proposals/0235-add-result.md): Add Result to the Standard Library

這個feature的新增，對error handle的處理可以更加的彈性化，尤其在處理API的回應的設計上可以更加簡潔。

```swift
// 原本的做法
URLSession.shared.dataTask(with: url) { (data, response, error) in
    // 先判斷error是否為空，處理錯誤
    guard error != nil else { self.handleError(error!) }
    // 在判斷data, response是否為空
    guard let data = data, let response = response else { return }
    // 處理回應的資料
    handleResponse(response, data: data)
}
```

```Swift
// 新作法 利用Result來綁定API的回覆
URLSession.shared.dataTask(with: url) { (result: Result<(response: URLResponse, data: Data), Error>) in 
    // 更簡潔方式，利用switch方式來處理api                              
    switch result {
    case let .success(success):
        handleResponse(success.response, data: success.data)
    case let .error(error):
        handleError(error)
    }
}
```

[SE-0228](https://github.com/apple/swift-evolution/blob/master/proposals/0228-fix-expressiblebystringinterpolation.md): Fix `ExpressibleByStringInterpolation`

我個人是很少用這個，我都用簡單 \ (XXX)來動態綁定我要呈現的字串，很少call api 來進行處理。

```Swift
// 目前作法：很沒效率且讓費資源。
// 1. 每次呼叫String(stringInterpolationSegment）都會init一個新字串，在記憶體管理上相當浪費
String(stringInterpolation:
  String(stringInterpolationSegment: "hello "), 
  String(stringInterpolationSegment: name), 
  String(stringInterpolationSegment: "!"))
```

```Swift
// 1 先宣告一個interpolation
var interpolation = DefaultStringInterpolation(
  literalCapacity: 7,
  interpolationCount: 1)
// 2. 利用append, appendInterpolation來添加新字串，優化記憶體管理
let language = "Swift"
interpolation.appendLiteral(language)
let space = " "
interpolation.appendLiteral(space)
let version = 5
interpolation.appendInterpolation(version)
// 3 產生最終的string
let string = String(stringInterpolation: interpolation)
```

[SE-0230](https://github.com/apple/swift-evolution/blob/master/proposals/0230-flatten-optional-try.md): Flatten nested optionals resulting from 'try?'

try?, try, try! 都是可以處理optional的方式

[知錯能改善莫大焉的 Error Handling](https://www.appcoda.com.tw/swift-error-handling/)

這一個是用來優化 try? 想要安全取出optional的值，但又不想處理error，然而當想取出try? 的值，會因為try?綁住更多一層的?號

```Swift
llet number: Int? = 10
let division = try? number?.divideBy(2)
// 在Swift 4, division是??, 所以你要使用division, 就要進行兩次if let來解除?
if let division = division, 
   let final = division {
  print(final)
}

// 在Swift 5, division是?, 所以只要進行一次 if let來解除?
if let division = division {
  print(division)
}
```

[SE-0216](https://github.com/apple/swift-evolution/blob/master/proposals/0216-dynamic-callable.md): Introduce user-defined dynamically "callable" types

這個功能有點像python中的"callables"，可以讓你動態傳進不同數量的參數到函式中。

```swift
// 宣告此class支援dynamicCallable
@dynamicCallable
class DynamicFeatures {
  // 實作dynamicCallable的function
  func dynamicallyCall(withArguments params: [Int]) -> Int? {
    guard !params.isEmpty else {
      return nil
    }
    // 將傳進來的params進行相加，然後回傳
    return params.reduce(0, +)
  }
  
  // 實作dynamicCallable的function
  func dynamicallyCall(withKeywordArguments params: KeyValuePairs<String, Int>) -> Int? {
    guard !params.isEmpty else {
      return nil
    }
    // 只針對有key值的param進行相加
    return params.reduce(0) { $1.key.isEmpty ? $0 : $0 + $1.value }
  }
}

let features = DynamicFeatures()
features() // nil
features(3, 4, 5) // 12
features(first: 3, 4, second: 5) // 8

```

[SE-0227](https://github.com/apple/swift-evolution/blob/master/proposals/0227-identity-keypath.md): Identity key path

有點像OC的KVC取值的方式

```swift
class Tutorial {
  let title: String
  let author: String
  init(title: String, author: String) {
    self.title = title
    self.author = author
  }
}

var tutorial = Tutorial(title: "What's New in Swift 5.0?", author: "Cosmin Pupaza")
// Swift 4.2 利用self來更新原本的值
tutorial.self = Tutorial(title: "What's New in Swift 5?", author: "Cosmin Pupăză")

// Swift 5 可以利用keyPath來進行更新
tutorial[keyPath: \.self] = Tutorial(
  title: "What's New in Swift 5?",
  author: "Cosmin Pupăză")
}
```

[SE-0192](https://github.com/apple/swift-evolution/blob/master/proposals/0192-non-exhaustive-enums.md): Handling Future Enum Cases

加了unknown的關鍵字，幫助我們處理未來新增的enum class更有彈性

```Swift
// 假設原本的enum如下
enum Post {
  case tutorial, article, screencast, course
}

// 利用switch來處理對應enum的動作
func readPost(_ post: Post) -> String {
  switch post {
    case .tutorial:
      return "You are reading a tutorial."
    case .article:
      return "You are reading an article."
    default:
      return "You are watching a video."
  }
}

// 這些都是正常我們要的結果
let screencast = Post.screencast
readPost(screencast) // "You are watching a video."
let course = Post.course
readPost(course) // "You are watching a video."

// 假設某一天，我們的enum多了一個podcast，但我們卻忘記在swith增加對應的處理
enum Post {
  case tutorial, article, podcast, screencast, course
}

let podcast = Post.podcast
readPost(podcast) // 此時就有可能產生未如預期的結果

// Swift 5.0
func readPost(_ post: BlogPost) -> String {
  switch post {
    case .tutorial:
      return "You are reading a tutorial."
    case .article:
      return "You are reading an article."
    // 增加一個unknown來修飾default, 此時swift就會產生warning告訴我們並未處理enum所有的值
    @unknown default:
      return "You are reading a blog post."
  }
}

```

[SE-0233](https://github.com/apple/swift-evolution/blob/master/proposals/0233-additive-arithmetic-protocol.md) Make `Numeric` Refine a new `AdditiveArithmetic`Protocol

在Swift5.0新增一個`AdditiveArithmetic`Protocol來處理向量的加減法，不用像Swift4.2必須要實作Numeric Protocol，然後被強制要處理乘除法。希望之後Swift也可以像python一樣有numpy套件可以使用

```swift
// 宣告一個向量
struct Vector {
  let x, y: Int
  
  init(_ x: Int, _ y: Int) {
    self.x = x
    self.y = y
  }
}

// 實作ExpressibleByIntegerLiteral
extension Vector: ExpressibleByIntegerLiteral {
  init(integerLiteral value: Int) {
    x = value
    y = value
  }
}

// 實作Numeric
extension Vector: Numeric {
  var magnitude: Int {
    return Int(sqrt(Double(x * x + y * y)))
  }  

  init?<T>(exactly value: T) {
    x = value as! Int
    y = value as! Int
  }
  
  static func +(lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x + rhs.x, lhs.y + rhs.y)
  }
  
  static func +=(lhs: inout Vector, rhs: Vector) {
    lhs = lhs + rhs
  }
  
  static func -(lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x - rhs.x, lhs.y - rhs.y)
  }
  
  static func -=(lhs: inout Vector, rhs: Vector) {
    lhs = lhs - rhs
  }
  // 必須強制要處理乘法
  static func *(lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x * rhs.y, lhs.y * rhs.x)
  }
  // 必須強制要處理除法
  static func *=(lhs: inout Vector, rhs: Vector) {
    lhs = lhs * rhs
  }
}

// 在Swift5.0新增一個`AdditiveArithmetic`Protocol來專門處理向量的加減法
extension Vector: CustomStringConvertible {
  var description: String {
    return "(\(x) \(y))"
  }
}

extension Vector: AdditiveArithmetic {
  static var zero: Vector {
    return Vector(0, 0)
  }
  
  static func +(lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x + rhs.x, lhs.y + rhs.y)
  }
  
  static func +=(lhs: inout Vector, rhs: Vector) {
    lhs = lhs + rhs
  }
  
  static func -(lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x - rhs.x, lhs.y - rhs.y)
  }
  
  static func -=(lhs: inout Vector, rhs: Vector) {
    lhs = lhs - rhs
  }
}


```



------



- 參考資料
  - [Swift ABI 稳定对我们到底意味着什么](https://onevcat.com/2019/02/swift-abi/)
  - [What’s New in Swift 5?](https://www.raywenderlich.com/55728-what-s-new-in-swift-5)
  - [Swift 5 终于来了，快来看看有什么更新！！](https://mp.weixin.qq.com/s/-fLVdoTz3lT5Kxnea0-Avg)

