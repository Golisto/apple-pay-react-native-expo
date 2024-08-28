# expo-apple-pay

## Installation

```
npx expo install @m1st1ck/expo-apple-pay
```

## Setting up Apple Pay
Before you can start accepting payments in your App, you'll need to setup Apple Pay.
1. Register as an Apple Developer
2. Obtain a merchant ID

Apple has a documentation on how to do this in their _[Configuring your Environment](https://developer.apple.com/library/content/ApplePay_Guide/Configuration.html)_ guide.


## Configuration in app.json / app.config.js
**app.json**
```json
{
  "plugins": [
    [
      "expo-apple-pay",
      {
        "merchantIdentifiers": "merchant.",
      }
    ]
  ]
}
```

or

**app.config.js**
```js
export default {
  ...
  plugins: [
    [
      "expo-apple-pay",
      {
        merchantIdentifiers: "merchant.",
      }
    ]
  ]
};
```

### Plugin Prop
You can pass props to the plugin config object to configure:

| Plugin Prop|||
|---------------------|----------|-----------------------------------------|
| `merchantIdentifiers` | **required** | The merchant identifiers you registered with Apple for use with Apple Pay.
||||

## Usage

```js
import ExpoApplePay, {
  MerchantCapability,
  PaymentNetwork,
  CompleteStatus,
} from "expo-apple-pay";
```


Show Apple pay dialog
```js
ExpoApplePay.show({
    merchantIdentifier: "merchant...",
    countryCode: "US",
    currencyCode: "USD",
    merchantCapabilities: [MerchantCapability["3DS"]],
    supportedNetworks: [PaymentNetwork.masterCard, PaymentNetwork.visa],
    paymentSummaryItems: [
        {
            label: "Ice",
            amount: 0.51,
        },
        {
            label: "Expo",
            amount: 0.51,
        },
    ],
})
.then((paymentData) => {
    // process paymentData on your server
    // then complete the payment process
    ExpoApplePay.complete(
        CompleteStatus.success
    );
    // or
    ExpoApplePay.complete(
        CompleteStatus.failure
    );
     
})
.catch((err) => {

});
```
You can dismiss the dialog
```js
ExpoApplePay.dismiss();
```

## TODO:
- requiredShippingContactFields 
- shippingType 
- shippingMethods
