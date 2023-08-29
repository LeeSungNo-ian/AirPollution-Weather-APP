# 뿌앵이

<br>

<img width="30%" src="https://user-images.githubusercontent.com/78950704/200374064-b4c08392-12ef-4163-a7db-395efab1f239.jpg">

> `v1.0.0` 2022.10.10 - 2022.10.11

> QR 코드로 앱 다운받기!

<br>

## 👀 프로젝트 소개

- `UIBlurEffect`를 통한 흐림효과로 미세먼지 지수를 확인할 수 있는 앱 입니다.

  + `날씨추가` 기능을 위해 개선중에 있으며, 앱 성능 개선을 위해 리팩토링을 하고 있습니다.

<br>

## ✨ 프로젝트 주요 기능

<img width="100%" src="https://user-images.githubusercontent.com/78950704/197410110-480961c7-2719-4fba-9a07-4063c36b1961.png"/>  | <img width="100%" src="https://user-images.githubusercontent.com/78950704/197410112-5a9d31f1-0813-4051-b4d0-eda1ac529d56.png"/>  | <img width="100%" src="https://user-images.githubusercontent.com/78950704/197410113-02bc3160-3f72-417f-9948-8d28668d3ef1.png"/>
:------------: | :-----------: | :-----------: 
**미세먼지 수치가 낮을 때** | **미세먼지 수치가 높을 때**  | **미세먼지 수치에 따른 UI 변경** 


- 현 지역의 위치를 `CoreLocation`을 통해 받아옵니다.
- 현 지역의 미세먼지 수치를 `API`로 받아옵니다.
- 미세먼지 수치에 따라 이미지, `UIBlurEffect`를 다르게 적용하여 화면의 뿌애짐 효과를 조절했습니다.

---

<img width="20%" src="https://user-images.githubusercontent.com/78950704/197410119-8bf62bc2-2ea5-42fe-bfac-9eb71267ea73.png"/> 


- `CustomBottomSheet`를 만들어 UI를 개선했습니다.
- `WKWebView`를 사용해 주변의 미세먼지 지수를 지도로 보여줍니다.

<br>

## 💡 앱 소개

1. 뿌앵이의 표정과 흐림 상태로 알아 볼 수 있는 미세먼지 측정 앱!

2. 우리는 서서히 마스크를 벗고 다니고 있어요. 마스크를 벗더라고 우리는 여전히 미세먼지를 신경 쓸 수 밖에 없어요.

3. 우리의 건강은 소중해요! `뿌앵이`의 표정과, 화면의 흐림 효과로 현 지역의 미세먼지를 한 눈에 알 수 있어요!

4. `뿌앵이`를 통해 우리의 건강을 지켜봐요.
