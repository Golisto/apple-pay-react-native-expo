import { JSONObject } from "@expo/json-file";
import { ConfigPlugin, withEntitlementsPlist } from "expo/config-plugins";

function setApplePayEntitlement(
  merchantIdentifiers: string | string[],
  entitlements: JSONObject
) {
  const key = "com.apple.developer.in-app-payments";

  const merchants = (entitlements[key] ?? []) as string[];

  if (!Array.isArray(merchantIdentifiers)) {
    merchantIdentifiers = [merchantIdentifiers];
  }

  for (const id of merchantIdentifiers) {
    if (id && !merchants.includes(id)) {
      merchants.push(id);
    }
  }

  if (merchants.length) {
    entitlements[key] = merchants;
  }
  return entitlements;
}

const withExpoApplePay: ConfigPlugin<{
  merchantIdentifiers: string | string[];
}> = (config, { merchantIdentifiers }) => {
  return withEntitlementsPlist(config, (mod) => {
    mod.modResults = setApplePayEntitlement(
      merchantIdentifiers,
      mod.modResults
    );
    return mod;
  });
};

export default withExpoApplePay;
