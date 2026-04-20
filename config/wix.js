import wixData from "wix-data";
import wixLocation from "wix-location";
import { session } from "wix-storage";

function safeTrim(v) {
  return v === undefined || v === null ? "" : String(v).trim();
}

function isEmptyValue(v) {
  if (v instanceof Date) return false;
  return v === undefined || v === null || String(v).trim() === "";
}

function showValidation(el) {
  if (typeof el.updateValidityIndication === "function") {
    el.updateValidityIndication();
  }
}

function isValidElement(el) {
  if ("valid" in el) return !!el.valid;
  return !isEmptyValue(el.value);
}

function clearElement(el) {
  if (el.value instanceof Date) {
    el.value = null;
    return;
  }

  el.value = "";

  if (typeof el.resetValidityIndication === "function") {
    el.resetValidityIndication();
  }
}

$w.onReady(() => {
  $w("#successText").hide();
  $w("#errorText").hide();

  const orgName = session.getItem("referralOrgName");
  const orgKey = session.getItem("referralOrgKey") || "";

  if (!orgName) {
    wixLocation.to("/referral-access");
    return;
  }

  $w("#organisationName").value = orgName;
  if (typeof $w("#organisationName").disable === "function") {
    $w("#organisationName").disable();
  }

  $w("#orgText").text = `${orgName}`;

  $w("#bottom").collapse();

  $w("#radioGroup1").onChange(() => {
    if ($w("#radioGroup1").value === "Yes") {
      $w("#bottom").expand();
    } else {
      $w("#bottom").collapse();
    }
  });

  $w("#submitButton").onClick(async () => {
    $w("#successText").hide();
    $w("#errorText").hide();

    const requiredFields = [
      "#referrerFirstName",
      "#referrerLastName",
      "#organisationName",
      "#dateRequested",
      "#referrerEmail",
      "#referrerTelephoneNumber",

      "#customerFirstName",
      "#customerLastName",
      "#customerGender",
      "#customerAge",
      "#customerReference",
      "#customerTelephoneNumber",
      "#customerEmail",

      "#address1",
      "#postcode",

      "#electrical1",
      "#electrical2",

      "#customerBedding",

      "#disability",
      "#language",
      "#ethnicity"
    ];

    if ($w("#radioGroup1").value === "Yes") {
      requiredFields.push(
        "#child1Gender",
        "#child1Age",
        "#child1Bedding"
      );
    }

    if ($w("#disability").value === "Yes") {
      requiredFields.push("#natureOfDisability");
    }

    let allValid = true;
    const invalidFields = [];

    requiredFields.forEach((id) => {
      const el = $w(id);

      showValidation(el);

      if (!isValidElement(el)) {
        allValid = false;
        invalidFields.push({
          id,
          value: el.value
        });
      }
    });

    if (!allValid) {
      $w("#errorText").text = `Missing/invalid: ${invalidFields.map(f => `${f.id} (${f.value})`).join(", ")}`;
      $w("#errorText").show();
      return;
    }

    const referral = {
      referralOrgKey: orgKey,

      RequestedBy_First: safeTrim($w("#referrerFirstName").value),
      RequestedBy_Last: safeTrim($w("#referrerLastName").value),
      OrganisationName: safeTrim($w("#organisationName").value),
      DateRequested: $w("#dateRequested").value,
      Email: safeTrim($w("#referrerEmail").value),
      PhoneNumber: safeTrim($w("#referrerTelephoneNumber").value),
      Extension: safeTrim($w("#telephoneExtension").value),

      CustomerDetails_CustomerName_First: safeTrim($w("#customerFirstName").value),
      CustomerDetails_CustomerName_Last: safeTrim($w("#customerLastName").value),
      CustomerDetails_Gender: safeTrim($w("#customerGender").value),
      CustomerDetails_Age: safeTrim($w("#customerAge").value),
      CustomerDetails_POReferenceNumber: safeTrim($w("#customerReference").value),
      CustomerDetails_CustomerPhoneNumber: safeTrim($w("#customerTelephoneNumber").value),
      CustomerDetails_CustomerEmail: safeTrim($w("#customerEmail").value),

      CustomerDetails_FlatNumber: safeTrim($w("#flatNumber").value),
      CustomerDetails_StreetAddress: safeTrim($w("#address1").value),
      CustomerDetails_AddressLine2: safeTrim($w("#address2").value),
      CustomerDetails_Postcode: safeTrim($w("#postcode").value),
      CustomerDetails_DeliveryAddressIfDifferentFromAbove: safeTrim($w("#deliveryAddress").value),

      CustomerDetails_ElectricalItem1: safeTrim($w("#electrical1").value),
      CustomerDetails_ElectricalItem2: safeTrim($w("#electrical2").value),

      CustomerDetails_SizeOfBedding: safeTrim($w("#customerBedding").value),
      CustomerDetails_AnyOtherCommentsOrRequests: safeTrim($w("#customerComments").value),

      CustomerDetails_PartnerName_First: safeTrim($w("#partnerNameFirst").value),
      CustomerDetails_PartnerName_Last: safeTrim($w("#partnerNameLast").value),
      CustomerDetails_PartnerAge: safeTrim($w("#partnerAge").value),
      CustomerDetails_DoesCustomerHaveChild: safeTrim($w("#doesCustomerHaveChild").value),

      CustomerDetails_Child1: safeTrim($w("#child1Gender").value),
      CustomerDetails_Age2: safeTrim($w("#child1Age").value),
      CustomerDetails_Child1Bedding: safeTrim($w("#child1Bedding").value),

      CustomerDetails_Child2: safeTrim($w("#child2Gender").value),
      CustomerDetails_Age3: safeTrim($w("#child2Age").value),
      CustomerDetails_Child2Bedding: safeTrim($w("#child2Bedding").value),

      CustomerDetails_Child3: safeTrim($w("#child3Gender").value),
      CustomerDetails_Age4: safeTrim($w("#child3Age").value),
      CustomerDetails_Child3Bedding: safeTrim($w("#child3Bedding").value),

      CustomerDetails_Child4: safeTrim($w("#child4Gender").value),
      CustomerDetails_Age5: safeTrim($w("#child4Age").value),
      CustomerDetails_Child4Bedding: safeTrim($w("#child4Bedding").value),

      CustomerDetails_Child5: safeTrim($w("#child5Gender").value),
      CustomerDetails_Age6: safeTrim($w("#child5Age").value),
      CustomerDetails_Child5Bedding: safeTrim($w("#child5Bedding").value),
      CustomerDetails_AnyOtherChildrenPleaseDetailBelow: safeTrim($w("#otherChildrenDetails").value),

      CustomerDetails_IsTheCustomerDisabled: safeTrim($w("#disability").value),
      CustomerDetails_NatureOfDisability: safeTrim($w("#natureOfDisability").value),

      CustomerDetails_MainLanguage: safeTrim($w("#language").value),
      CustomerDetails_Ethnicity: safeTrim($w("#ethnicity").value)
    };

    $w("#submitButton").disable();

    try {
      await wixData.insert("Import1", referral);

      const fieldsToClear = [
        "#referrerFirstName",
        "#referrerLastName",
        "#dateRequested",
        "#referrerEmail",
        "#referrerTelephoneNumber",
        "#telephoneExtension",

        "#customerFirstName",
        "#customerLastName",
        "#customerGender",
        "#customerAge",
        "#customerReference",
        "#customerTelephoneNumber",
        "#customerEmail",

        "#flatNumber",
        "#address1",
        "#address2",
        "#postcode",
        "#deliveryAddress",

        "#electrical1",
        "#electrical2",

        "#customerBedding",
        "#customerComments",

        "#partnerName",
        "#partnerAge",

        "#child1Gender",
        "#child1Age",
        "#child1Bedding",

        "#child2Gender",
        "#child2Age",
        "#child2Bedding",

        "#child3Gender",
        "#child3Age",
        "#child3Bedding",

        "#child4Gender",
        "#child4Age",
        "#child4Bedding",

        "#child5Gender",
        "#child5Age",
        "#child5Bedding",

        "#disability",
        "#natureOfDisability",
        "#language",
        "#ethnicity"
      ];

      fieldsToClear.forEach((id) => clearElement($w(id)));

      $w("#doesCustomerHaveChild").value = "";
      $w("#bottom").collapse();

      $w("#organisationName").value = orgName;
      if (typeof $w("#organisationName").disable === "function") {
        $w("#organisationName").disable();
      }

      $w("#successText").text = "Submitted successfully!";
      $w("#successText").show();
    } catch (err) {
      console.error("Insert failed:", err);

      $w("#errorText").text = `Submission failed: ${err?.message || "Please try again."}`;
      $w("#errorText").show();
    } finally {
      $w("#submitButton").enable();
    }
  });
});