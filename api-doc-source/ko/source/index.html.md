---
title: BitroPay API 문서

language_tabs: # must be one of https://git.io/vQNgJ
  - shell: cURL

toc_footers:
  - <a href='https://www.bitro-pay.com'>API 키 발금받으러 가기</a>

includes:
  - errors

search: true
---

# Introduction

BitroPay API 페이지에 방문하신걸 환영합니다. API 를 이용하여 비트코인 결제 시스템을 홈페이지에 연동하실 수 있습니다. 

우측에 있는 영역에서 예제 코드를 보실 수 있습니다. 탭을 선택하여 언어를 변경하실 수 있습니다.

# API V1

## 인증방법 - V1

> 아래코드를 이용하여 API 키가 정상작동하는지 간단하게 확인 할 수 있습니다.

```shell
# 쉘을열고 아래코드를 붙여넣으세요.
curl https://www.bitro-pay.com/api/v1 \
  -X GET \
  -H "Authorization: your.api.key"
```

> `your.api.key` 부분을 회원님의 API 키로 변경해주세요.

> 위 코드를 입력하면 다음과 같은 응답을 확인하실 수 있습니다.

```json
{
  "result": "ok",
  "resultCode": 200
}
```

BitroPay API 를 이용하기 위해서는 API 키가 필요합니다.
API 키는 [website](https://www.bitro-pay.com/merchant/setting) 에서 확인하실 수 있습니다.
API 키는 모든 API 요청 해더에 공통으로 사용 됩니다. 반드시 해더정보에 아래와 같이 추가해주세요.

`Authorization: your.api.key`

<aside class="notice">
<code>your.api.key</code> 부분을 회원님의 API 키로 변경해주세요.
</aside>

## 새로운 송장 생성 - V1
```shell
curl "https://www.bitro-pay.com/api/v1/invoice" \
  -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: your.api.key" \
  --data '{ \
    "productId": "your product id", \ 
    "productName": "your product name", \ 
    "productPrice": 10000, \
    "productCurrency": "KRW", \
    "redirectURL": "your shop url", \
    "callbackURL": "call back url", \
    "userData": {} \
  }'
```

> 위 코드를 입력하면 다음과 같은 응답을 확인하실 수 있습니다.

```json
{
  "result": "ok",
  "resultCode": 200,
  "data": {
    "invoiceId": "ZiFztkEo6FHswocXw",
    "no": "1520998774032",
    "gatewayURL": "https://www.bitro-pay.com/gateway/invoice/ZiFztkEo6FHswocXw",
    "productId": "your product id",
    "productName": "your product name",
    "productPrice": 10000,
    "productCurrency": "KRW",
    "userData": {},
    "status": "wait",
    "amount": 0.01
  }
}
```

> gatewayURL 로 페이지를 이동시켜 주세요.

> 결제 상태가 변경될때마다 callbackURL 로 아래 형식과 같은 요청을 Bitro-Pay로 부터 받으실 수 있습니다.

> Callback JSON Request Data - POST callbackURL

```json
{
  "invoiceId": "ZiFztkEo6FHswocXw",
  "no": "1520998774032",
  "productId": "your product id",
  "productName": "your product name",
  "productPrice": 10000,
  "productCurrency": "KRW",
  "userData": {},
  "status": "ok",
  "amount": 0.01
}
```

인보이스 생성

### HTTP Request

`POST https://www.bitro-pay.com/api/v1/invoice`

### Parameters

Parameter | Required | Type | Description
--------- | -------- | ---- | -----------
productPrice | Y | Number | 제품가격
productCurrency | Y | String | 기준통화 (KRW) - 현재는 KRW 만 지원합니다.
redirectURL | Y | String | 결제완료 후 이 주소로 페이지를 전환합니다.
callbackURL | Y | String | 결제 상태가 변경될때 이 주소로 변경 상태를 보내드립니다.
productId | N | String | 제품 아이디
productName | N | String | 제품명
userData | N | Object | 회원님이 정의한 데이터 입니다. callbackURL로 데이터 전송시 동일한 데이터를 보내드립니다.
email | N | String | 구매자 이메일 주소. 추가시 결제창에서 이메일을 다시 입력하지 않아도 됨.

### Response Parameters

Parameter | Type | Description
--------- | ---- | -----------
result | String | 결과 메시지
resultCode | Number | 결과 코드
data | Object | 결과 데이터
data.invoiceId | String | 송장아이디
data.no | String | 송장번호
data.gatewayURL | String | 결제창 주소 - 송장별 고유 주소가 부여됩니다.
data.productId | String | 제품 아이디
data.productName | String | 제품명
data.productPrice | String | 제품가격
data.productCurrency | String | 기준통화
data.userData | String | 결제 생성 요청시 정의한 데이터
data.status | String | 결제 상태
data.amount | Number | 결제 BTC 수량

### Callback Request Parameters
`POST callbackURL`

Parameter | Type | Description
--------- | ---- | -----------
invoiceId | String | 송장 아이디
no | String | 송장 번호
productPrice | Number | 제품금액
productCurrency | String | 기준통화
productId | String | 제품 아이디
productName | String | 제품명
userData | Object | 회원님이 정의한 데이터
status | String | 결제 상태
amount | Number | 결제 BTC 수량

### Invoice Status

Code | Description
---- | -----------
ok | 사용자 지불 완료
timeout | 시간초과
wait | 사용자 지불 대기
amountLow | 입금 금액이 결제해야할 금액보다 작은 경우
amountOver | 입금 금액이 결제해야할 금액보다 큰 경우
confirmFail | 지불 검증 실패
confirmed | 검증이 2회 이상 완료된 경우. 이 상태일때 제품을 배송하시면 됩니다.
confirmedLow | 검증이 2회 이상 완료된 되었으나 금액이 부족한 경우. 환불 프로세스 진행
confirmedOver | 검증이 2회 이상 완료된 되었으나 금액이 초과된 경우. 환불 프로세스 진행
refund | 환불이 완료된 경우
