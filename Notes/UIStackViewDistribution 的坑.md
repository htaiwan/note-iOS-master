# UIStackViewDistribution 的坑

------

UIStackView中有個UIStackViewDistribution的屬性，我相信當初apple在設計這個屬性是希望讓我們透過這個屬性來簡化相關layout設定，但是在使用上卻無比的坑啊 ! 

- **UIStackViewDistributionFill**
  - stackView中所有subViews會用盡全力填滿stackView的寬度(或高度,根據要stack的方向)
  - 如果subViews的寬度無法填補stackView的寬度，那就會根據compressionResistance或hugging的大小，來動態調整subViews的寬度。
  - 如果無法從compressionResistance或hugging的大小來決定subView寬度，那就依序由左到右的順序。
- **UIStackViewDistributionFillEqually**
  - 這個還算容易理解，就是subview大家ㄧ樣寬(或高)。但還是會去stackView的寬度(或高度)。
- **UIStackViewDistributionEqualSpacing**
  - 保持subView之間的距離相等。
  - 但如果subView的寬度大於stackView的寬度，此時又要保持距離相等，那該怎麼辦?
    - 那就根據compressionResistance或hugging去優先壓縮某些subView來清出可間隔的距離空間。
- **UIStackViewDistributionEqualCentering**
  - 保持subView中心點之間的距離相等。
- **UIStackViewDistributionFillProportionally**
  - 最雷的就是這個了，因為這個最常用，所以也最容易被坑到。
  - 根據文件上說明，是根據subivew的中intrinsicContentSizes來決定比例的。
  - 讓subView繼承UIView，override intrinsicContentSize，達到我們要比例分配，參考下面的連結作法
    - [UIStackView Tricks: Proportional Custom UIViews with ‘Fill Proportionally’](https://spin.atomicobject.com/2017/02/07/uistackviev-proportional-custom-uiviews/)