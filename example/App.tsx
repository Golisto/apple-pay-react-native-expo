import { StyleSheet, Text, TouchableOpacity, View } from "react-native";

import ExpoApplePay, {
  MerchantCapability,
  PaymentNetwork,
  CompleteStatus,
} from "expo-apple-pay";

export default function App() {
  return (
    <View style={styles.container}>
      <TouchableOpacity
        onPress={() => {
          ExpoApplePay.show({
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
                ExpoApplePay.complete(CompleteStatus.success);
              }, 3000);
            })
            .catch((err) => {
              console.log(err);
              ExpoApplePay.complete(CompleteStatus.failure);
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
