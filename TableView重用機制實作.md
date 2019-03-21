# TableView重用機制實作

------

- 為何要進行重用
- 重用池的特性
- 如何設計一個重用池

------

*經典面試問題:* 

​	*iOS中Cell的重用機制是如何實作的 ？*

在問如何實作前，會先問為什麼需要重用? 

**<u>重用的目的</u>**

- 減少資源的消耗(不用一直產生新的cell)
- 增加效率(直接拿現成的cell直接使用)

在了解為什麼後，就必須重用機制的核心物件 - 重用池(reusing pool)？iOS利用重用池進行cell重新回收跟利用。

**<u>重用池簡單來說就是一個資料結構，這個資料結構要滿足下列2個特性</u>**

- 紀錄已經產生的cell。
- 從目前沒有再使用的cell中挑選一個cell進行重複利用。

從top到bottom來看整個設計

**<u>top端: 如何使用重用池。</u>**

```swift
// dequeueReusableView(從目前沒有再使用的button中挑選一個button進行重複利用)
var button = reusePool?.dequeueReusableView() as? UIButton
if button == nil {
  button = UIButton.init(frame: CGRect.zero)
  button!.backgroundColor = UIColor.green
  // 紀錄已經產生的button
  reusePool?.addUsingView(button)
  print("創建新button")
 } else {
  print("重用button")
}
```

**<u>bottom端: 如何設計重用池</u>**

- 內部利用兩個NSMutableSet來記錄物件使用狀態。
- 外部開放兩個主要的方法，"取得"跟""新增""。

```swift
class HTReusePool: NSObject {
    // 等待使用的隊列
    var waitUsedQueue: NSMutableSet?
    // 正在使用的隊列
    var usingQueue: NSMutableSet?
    
    override init() {
        super.init()
        
        waitUsedQueue = NSMutableSet()
        usingQueue = NSMutableSet()
    }
    
    // 從pool取得可複用的view
    func dequeueReusableView() -> UIView? {
        let view = waitUsedQueue?.anyObject()
        if view == nil {
            return nil
        } else {
            // 將view從waitUsedQueue放到usingQueue
            waitUsedQueue?.remove(view!)
            usingQueue?.add(view!)
            return view as? UIView
        }
    }
    
    // 加入一個view到pool中
    func addUsingView(_ view: UIView?) {
        if view == nil {
            return
        }
        
        usingQueue?.add(view!)
    }
    
    // 清空pool中所有的view
    func reset() {
        while usingQueue?.anyObject() != nil {
            let view = usingQueue?.anyObject()
            // 將usingQueue中的view全部移到waitUsedQueue中
            usingQueue?.remove(view!)
            waitUsedQueue?.add(view!)
        }
    }
}
```

