##### tags: `README`, `OpenMarket`

[![Swift 5.7](https://img.shields.io/badge/swift-5.7-ED523F.svg?style=flat&color=orange)]()
[![Xcode 14.3](https://img.shields.io/badge/Xcode-14.3-ED523F.svg?style=flat&color=blue)]()
[![iOS 16+](https://img.shields.io/badge/iOS%20-16+-orange)](https://developer.apple.com/ios/) </br>
[![Alamofire (5.6.4)](https://img.shields.io/badge/Alamofire-5.6.4-lightgray)]()
[![lottie-ios (4.3.4)](https://img.shields.io/badge/Lottie-4.3.4-lightgray)]()
[![RxCocoa (6.5.0)](https://img.shields.io/badge/RxCocoa-6.5.0-lightgray)]()
[![RxRelay (6.5.0)](https://img.shields.io/badge/RxRelay-6.5.0-lightgray)]()
[![RxSwift (6.5.0)](https://img.shields.io/badge/RxSwift-6.5.0-lightgray)]()
[![SnapKit (5.6.0)](https://img.shields.io/badge/SnapKit-5.6.0-lightgray)]()
[![Then (3.0.0)](https://img.shields.io/badge/Then-3.0.0-lightgray)]()

# 🥕 오픈 마켓

> 서버와 REST API를 통한 통신이 가능한 오픈마켓 앱 프로젝트 입니다.
> `당근마켓`을 참고하여 UI와 기능을 구현하였습니다.

</br>

# 📚 목차

1. [✨ 키워드](#-키워드)
2. [🛠️ 구조](#-구조)
3. [📱 실행화면](#-실행화면)
4. [🤔 기술적 도전 & 고민했던 부분](#-기술적-도전--고민했던-부분)
5. [🚀 트러블 슈팅](#-트러블-슈팅)
6. [추가적으로 구현하고 싶은 부분](#)

</br>

# ✨ 키워드

- UIKit
- 반응형 프로그래밍
- RxSwift를 활용한 MVVM + Input Output 구조
- SnapKit을 활용한 UI 코드 구현
- Swift Councurrency(async, await)
- TableView Pagination
- Factory Pattern

</br>

# 🛠️ 구조

## ✏️ MVVM + Input Output

<img src = "https://github.com/zhilly11/ios-open-market-refactor/blob/main/Images/MVVM_Input_Output.png" width = 400> </br>

- MVVM 구조를 구현할 때에는 표준이나 정해진 약속이 없어 개발자에 따라 다양한 방식으로 구현하게 됩니다.
- `ViewModel`의 규칙을 정해 보다 규칙적인 코드를 작성하기 위해 `input-output` 패턴을 활용하여 MVVM 구조로 구현하였습니다.
- `View`는 화면을 그리는 역할에만 충실하게 되고 서로의 `input`, `output`을 확실하게 정의 할 수 있었습니다.
- 포스팅 : [zhilly - RxSwift와 Input Ouput을 활용한 MVVM 구현](https://zhilly11.tistory.com/entry/RxSwift와-Input-Output을-활용한-MVVM-구현)
  </br>

## 네트워크 레이어

### Alamofire의 `URLRequestConvertible` 활용

```swift
enum APIRouter: URLRequestConvertible {

    // API method 정의
    case healthChecker
    case inquiryProduct(id: Int)
    ...

    private var method: HTTPMethod {
        // get, post, patch, delete 설정
    }

    private var path: String {
        // url path 설정
    }

    private var query: [String: String] {
        // url 쿼리 설정
    }

    private var parameters: Parameters? {
        // parmeter 설정
    }

    func asURLRequest() throws -> URLRequest {
        // url 조합
    }
}
```

- `URLRequestConvertible`를 활용하여 API Endpoint를 정의하였습니다.
- 확장성과 유지보수성을 높이고 URL 관련하여 한 곳에서 관리할 수 있도록 구현하였습니다.
- Alamofire의 method를 호출할때 간편하게 활용할 수 있습니다.

###

# 📱 실행화면

## 메인 화면

|                             테이블뷰 페이징                             |                                  리프레쉬                                   |                                  검색기능                                  |
| :---------------------------------------------------------------------: | :-------------------------------------------------------------------------: | :------------------------------------------------------------------------: |
| ![](https://github.com/zhilly11/OpenMarket/blob/main/Images/Paging.gif) | ![](https://github.com/zhilly11/OpenMarket/blob/main/Images/Refreshing.gif) | ![](https://github.com/zhilly11/OpenMarket/blob/main/Images/Searching.gif) |

|                                 등록기능                                  |                              API 응답 로딩                               |                               이미지 스크롤뷰                                |
| :-----------------------------------------------------------------------: | :----------------------------------------------------------------------: | :--------------------------------------------------------------------------: |
| ![](https://github.com/zhilly11/OpenMarket/blob/main/Images/Register.gif) | ![](https://github.com/zhilly11/OpenMarket/blob/main/Images/Loading.gif) | ![](https://github.com/zhilly11/OpenMarket/blob/main/Images/ImageScroll.gif) |

</br>

# 🤔 기술적 도전 & 고민했던 부분

</br>

## 현업에서 많이 사용되는 라이브러리 적용

- 많이 사용되는 사이브러리를 직접 학습하고 실제 코드에 구현해보고자 프로젝트를 시작했습니다.
- 라이브러리 사용없이 구현했을 때와 어떠한 장단점이 있는지 직접 느껴보고 싶었습니다.
  </br>

## 코드의 가독성

### 컴플리션 핸들러 지양

#### Swift Cuncurrency(async, await) 적극 활용

- 비동기 메서드에서 Completion Handler를 사용할때 클로저가 중첩 사용되어 코드의 가독성이 떨어집니다.
- 이를 해결하고 코드의 가독성을 높이기 위해 async, await를 적극 사용하여 가독성을 높였습니다.

#### `withCheckedContinuation()`를 활용해 컴플리션 핸들러 -> async 변환

- Alamofire의 Completion Handler로 작성되어있는 네트워크 메서드를 사용하였습니다.
- Completion Handler를 async로 변환하여 코드의 가독성을 높일 수 있었습니다.
- Error를 핸들링하는 과정에서 throw보단 명확하게 Error타입을 전달할 수 있는 Result 타입을 적극 활용하였습니다.
- 포스팅: [zhilly - 컴플리션 핸들러를 async로 감싸기](https://zhilly11.tistory.com/entry/Swift-컴플리션-핸들러를-async로-감싸기)

### 코드의 응집도

- `Then`, `SnapKit` 라이브러리를 활용하여 인스턴스의 응집도를 높일 수 있었습니다.
- 클로저 안에서
  </br>

## 코드의 재사용성

### Base 추상화 객체 활용

- ViewController나 View 코드를 작성할 때 뷰를 설정하는 메서드나 레이아웃을 잡는 메서드 등을 매번 중복하여 작성하는 경우가 많습니다.
- 또한 배경의 색이나 RxSwift의 DisposeBag등 중복되는 코드를 상위 객체에서 설정할 수 있도록 설계하였습니다.
- `BaseViewController` 타입을 정의해서 코드의 통일성과 가독성, 유지보수성을 높일 수 있었습니다.

### 디자인패턴 활용

- ViewController나 Alert등 코드상에서 반복해서 생성을 해야하는 경우가 있습니다.
- 이를 해결하기 위해 `Factory Pattern`을 활용하여 반복적으로 생성되는 객체를 Factory 객체를 통해 생성하고 주입받습니다.
- 이런 과정을 통해 코드의 의존성을 최소화하고 유지보수성과 확장성을 향상시키는 코드를 작성하였습니다.

### Constant 한 곳에서 관리

- 앱 내에서 사용하는 Constant들을 사이드 이펙트를 발생시키고 유지보수가 어렵습니다.
- 이를 해결하기 위해서 파일 하나에서 모든 Constant들을 관리해 유지보수성과 재사용성을 높였습니다.
  </br>

## 순환 참조 방지

- RxSwift와 RxCocoa의 메서드를 사용할 때 필수적으로 클로저를 사용해야합니다.
- 예를들어 제일 많이 사용하는 `subscribe`메서드를 사용할 때 ViewController -> disposeBag -> Subscription(bind) -> self(ViewController) 형태의 순환참조가 발생하게 됩니다.
- 따라서 순환 참조 방지를 위해 `subscribe(with:, onNext:...)`를 사용하여 메모리 누수를 방지할 수 있었습니다.
- 실제로 Instruments - Leaks를 사용해 Memory Leak을 테스트 해봤을때 직접 작성한 코드에서는 메모리 누수가 발생하지 않았습니다.
- 학습한 내용 포스팅 : [zhilly - weak self 톺아보기](https://zhilly11.tistory.com/entry/weak-self-톺아보기)
  </br>

## Dark Mode

- 사용자에게 편의성을 제공하기 위에 다크모드를 적용했습니다.
- Dynamic System Color와 Custom Color를 활용하여 색상을 적용하였습니다.
  </br>

## TableView PageNation

- 네트워킹과 앱의 효율성을 위해 TableView에 Pagenation 기능을 구현하였습니다.
- RxCocoa에 있는 `tableView.rx.prefetchRows`를 활용해 `IndexPath`를 계산에서 뷰모델에게 데이터를 요청하는 방식으로 구현하였습니다.

</br>

# 🚀 트러블 슈팅

</br>

## UIImage 메모리 이슈

### 메모리 이슈 해결 및 결론

- 시뮬레이터에서 많은 이미지를 로드할 수록 메모리 사용량이 앱의 기능의 비해 많이 차지하는 문제가 발생했습니다.
- NSCache 사용만으로 해결되지 않아 `UIImage의 다운샘플링` + `NSCache` 를 활용해 해결하였습니다.

![](https://github.com/zhilly11/OpenMarket/blob/main/Images/TroubleShooting/Result.png)

|                                           | 다운 샘플링 전 | 다운 샘플링 후 |
| ----------------------------------------- | -------------- | -------------- |
| 총 메모리캐시 사용량 (이미지 1339장)      | 약 2.4G        | 약 86MB        |
| 이미지 한 장당 평균 메모리 사용량         | 약 1.8MB       | 약 0.06MB      |
| 100MB의 메모리 캐시에 넣을 수 있는 이미지 | 약 55.5장      | 약 1666장      |
| 다운샘플링 전후 개선율                    |                | 96.42%         |

> 개선율(%) = (이전 상태의 메모리 사용량 − 개선된 상태의 메모리 사용량) / 이전 상태의 메모리 사용량 \* 100

### 이슈 해결 과정

<details>
<summary>자세히 보기</summary>
<div markdown="1">

#### 1. 문제 발생

- 메모리 누수를 확인하기 위해 테스트 중, 스크롤을 통해 많은 상품을 로드했을때 앱이 많은 메모리를 할당하고 있는 것을 확인했습니다.
- 제가 사용하고 있는 아이폰 12의 경우 4GB 램을 탑재하고 있기 때문에 하나의 앱에서 2.4GB의 램을 사용하는 것은 문제가 된다고 생각하였습니다.

#### 2. 해결방안 모색

- 먼저 NSCache를 통해 이미지를 메모리 캐싱햇습니다.
- 유의미한 성능 개선 효과를 확인할 수 없었습니다.
- 따라서 이미지를 다운샘플링 하는 방법을 선택하였습니다.

#### 3. 해결 과정

- 관련 [WWDC - iOS Memory Deep Dive](https://developer.apple.com/videos/play/wwdc2018/416/) 영상을 참고하여 해경 방법을 찾을 수 있었습니다.
- 애플에서는 Image 관련 메모리 문제 해결을 위해 2가지 방법을 제공합니다.
- `UIGraphicsImageRenderer`: 이미지 데이터를 설정한 크기로 줄이고 디코딩후에 렌더링 할 수있게 도와준다.
- `Downsampling`: GPU에서 이미지 데이터를 읽는 Decoding과정에서 메모리가 많이 사용되기 때문에 필요한 크기만큼 데이터를 축소하고, 썸네일로 캡처해 불필요한 Data Buffer를 제거한 채로 디코딩후에 작업을 한다.
- 두 가지 방법 중 `Downsampling`의 방법이 많은 데이터들을 처리하기에 효율적인 방법이라고 생각해서 선택하였습니다.

- `Data` 타입을 다운 샘플링 하는 메서드를 만들어 다운 샘플링 된 `UIImage`를 캐싱하는 방법으로 구현하였습니다. [코드 자세히보기](https://github.com/zhilly11/OpenMarket/blob/main/OpenMarket/OpenMarket/Source/Utils/Extensions/UI/UIImageView%2B.swift)

```swift
    func downsample(imageData: Data, width: CGFloat, height: CGFloat, scale: CGFloat = 1) -> UIImage {
        let imageSourceOptions: CFDictionary = [kCGImageSourceShouldCache: false] as CFDictionary
        let imageSource: CGImageSource = CGImageSourceCreateWithData(imageData as CFData, imageSourceOptions)!
        let maxDimensionInPixels: CGFloat = max(width, height) * scale
        let downsampleOptions: CFDictionary = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as [CFString : Any] as CFDictionary

        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return Constant.Image.loadingFail
        }
        return UIImage(cgImage: downsampledImage)
    }
```

</div>
</details>

## DarkMode에서의 CGColor

- UI 컴포넌트의 색상 설정을 하던 중 Layer의 border color를 CGColor로 설정했을 때 적용이 되지 않는 문제가 발생했습니다.
- 찾아보니 CGColor 및 CALayer 같은 Lower-level class들은 Dynamic System을 이해하지 못한다고 합니다.
- 이와 관련해서 [WWDC 세션](https://developer.apple.com/videos/play/wwdc2019/214/)에서 `traitCollection`를 통한 해결방법을 찾아 프로젝트에 적용하였습니다.
  </br>

## API의 TLS관련 문제

- 정상적으로 동작하던 API가 갑자기 통신이 실패하는 경우가 있었습니다.
  - "unable to determine interface type without an established connection"
  - "unable to determine fallback status without a connection"
- 코드상의 문제가 아니라 HTTPS를 사용해 통신하는데 서버의 TLS 관련 문제가 있다는 것을 알게 되었습니다.
- `info.plist` 파일에서 `App Transport Security Settings` 옵션을 통해 해결할 수 있었습니다.
  </br>

## Then 라이브러리 오류

- `Then`라이브러리를 사용하여 코드를 작성할때 컴파일러에게 타입 추론을 시켜 작성할 때 .을 통한 프로퍼티나 메서드에 접근 자동완성 기능이 수행되지 않았습니다.
- 반면에 타입 명시를 해주었을때에는 컴파일러가 해당 타입을 알고 자동완성 기능이 가능했습니다.
- 타입 추론을 하면 코드가 조금 더 간결해지지만, 컴파일러가 정확한 타입을 알기 어려운 경우가 발생할 수 있다는 점을 알게 되었습니다.

```swift
    // 타입 추론
    let nameLabel = UILabel().then { label in
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
    }

    // 타입 명시
    let nameLabel: UILabel = .init().then { label in
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
    }
```

</br>
