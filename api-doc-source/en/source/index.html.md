---
title: BitroPay API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell: cURL

toc_footers:
  - <a href='https://www.bitro-pay.com'>Sign Up for a API key</a>

includes:
  - errors

search: true
---

# Introduction

Welcome to the BitroPay API! You can use our API to access BitroPay API endpoints.

We have language bindings in Shell and Javascript! You can view code examples in the dark area to the right, and you can switch the programming language of the examples with the tabs in the top right.

# API V1

## Authentication - V1

> To authorize, use this code:

```shell
# With shell, you can just pass the correct header with each request
curl https://www.bitro-pay.com/api/v1 \
  -X GET \
  -H "Authorization: your.api.key"
```

> Make sure to replace `your.api.key` with your API key.

> The above command returns JSON structured like this:

```json
{
  "result": "ok",
  "resultCode": 200
}
```


BitroPay uses API keys to allow access to the API. You can register a new BitroPay API key at our [website](https://www.bitro-pay.com).

BitroPay expects for the API key to be included in all API requests to the server in a header that looks like the following:

`Authorization: your.api.key`

<aside class="notice">
You must replace <code>your.api.key</code> with your personal API key.
</aside>

## Create new invoice - V1
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

> The above command returns JSON structured like this:

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

Create an invoice

### HTTP Request

`POST https://www.bitro-pay.com/api/v1/invoice`

### Parameters

Parameter | Required | Type | Description
--------- | -------- | ---- | -----------
productPrice | Y | Number | Your product price.
productCurrency | Y | String | Price currency (KRW)
redirectURL | Y | String | After user paid redirect to this url.
callbackURL | Y | String | Callback url for notify tx status update.
productId | N | String | Your product id.
productName | N | String | Your product name.
userData | N | Object | User defined data. We will send this data when we request your callbackURL.
email | N | String | Buyer email address.

### Response Parameters

Parameter | Type | Description
--------- | ---- | -----------
result | String | Result message
resultCode | Number | Result code.
data | Object | Result data
data.invoiceId | String | New invoice ID.
data.no | String | New invoice number.
data.gatewayURL | String | Gateway url for payment.
data.productId | String | Your product ID.
data.productName | String | Your product name.
data.productPrice | String | Your product price.
data.productCurrency | String | Price currency.
data.userData | String | User defined data.
data.status | String | Invoice status
data.amount | Number | BTC amount

### Callback Request Parameters
`POST callbackURL`

Parameter | Type | Description
--------- | ---- | -----------
invoiceId | String | Invoice ID
no | String | Invoice number
productPrice | Number | Your product price.
productCurrency | String | Price currency (KRW)
productId | String | Your product id.
productName | String | Your product name.
userData | Object | User defined data.
status | String | Invoice status
amount | Number | Invoice BTC amount

### Invoice Status

Code | Description
---- | -----------
ok | Client paid
timeout | Timeout
wait | Waiting for pay
amountLow | Amount is lower than request amount
amountOver | Amount is higher than request amount
confirmFail | Confirmation is failed.
confirmed | Complete 2 confirmation. You can shipping your product.
confirmedLow | Complete 2 confirmation. But amount is lower than request amount. Run refund process.
confirmedOver | Complete 2 confirmation. But amount is higher than request amount. Run refund process.
refund | 환불이 완료된 경우
