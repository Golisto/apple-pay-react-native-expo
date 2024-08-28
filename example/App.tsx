import { StyleSheet, Text, TouchableOpacity, View } from "react-native";

import ApplePay, {
  MerchantCapability,
  PaymentNetwork,
  CompleteStatus,
} from "apple-pay-react-native-expo";

export default function App() {
  return (
    <View style={styles.container}>
      <TouchableOpacity
        onPress={() => {
          ApplePay.show({
            countryCode: "BG",
            currencyCode: "EUR",
            merchantCapabilities: [MerchantCapability["3DS"]],
            supportedNetworks: [PaymentNetwork.masterCard, PaymentNetwork.visa],
            paymentSummaryItems: [
              {
                label: "Ice",
                amount: 0.01,
              },
              {
                label: "Expo",
                amount: 0.01,
              },
            ],
            merchantIdentifier: "merchant.",
          })
            .then((paymentData) => {
              console.log(paymentData);

              setTimeout(() => {
                ApplePay.complete(CompleteStatus.success);
              }, 3000);
            })
            .catch((err) => {
              console.log(err);
              ApplePay.complete(CompleteStatus.failure);
            });
        }}
      >
        <Text> Test</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#fff",
    alignItems: "center",
    justifyContent: "center",
  },
});
