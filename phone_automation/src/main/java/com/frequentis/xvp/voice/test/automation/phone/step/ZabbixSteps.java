/************************************************************************
 ** PROJECT:   XVP
 ** LANGUAGE:  Java, J2SE JDK 1.8
 **
 ** COPYRIGHT: FREQUENTIS AG
 **            Innovationsstrasse 1
 **            A-1100 VIENNA
 **            AUSTRIA
 **            tel +43 1 811 50-0
 **
 ** The copyright to the computer program(s) herein
 ** is the property of Frequentis AG, Austria.
 ** The program(s) shall not be used and/or copied without
 ** the written permission of Frequentis AG.
 **
 ************************************************************************/
package com.frequentis.xvp.voice.test.automation.phone.step;

import com.frequentis.c4i.test.bdd.api.ResolvedExpression;
import com.frequentis.c4i.test.bdd.fluent.step.AutomationSteps;
import com.frequentis.c4i.test.model.ExecutionDetails;
import com.frequentis.cats.zabbix.tecpac.item.ItemGetResponse;
import org.jbehave.core.annotations.Alias;
import org.jbehave.core.annotations.Then;

import java.util.List;
import java.util.Optional;

import static com.google.common.base.Preconditions.checkNotNull;

public class ZabbixSteps extends AutomationSteps {
    @Then("host $hostItems contains $itemName with value: $value")
    public void checkZabbixHostContainsItemWithValue(List<ItemGetResponse.Result> itemsList, String searchedItemName, String value) {

        final ItemGetResponse.Result item = getZabbixItemByName(itemsList, searchedItemName);

        evaluate(localStep("Check Zabbix's item value")
                .details(ExecutionDetails.create("Check item \"" + searchedItemName + "\" contains value: " + value)
                        .received(item.getLastvalue())
                        .expected(value)
                        .success(item.getLastvalue().equals(value))));
    }

    @Then("verify $itemName value from $hostItems is incremented by $value towards $oldItemValue")
    public void checkZabbixItemValueWasIncremented(String searchedItemName, List<ItemGetResponse.Result> itemsList, Integer incrementValue, Integer oldValue) {

        int actualValue = Integer.parseInt(getValueOfZabbixItem(searchedItemName, itemsList));

        evaluate(localStep("Verifying value was incremented")
                .details(ExecutionDetails.create("Compare Current and Previous values")
                        .received("Current value: " + actualValue + "\nPrevious value: " + oldValue)
                        .expected("Current value is greater than Previous value with " + incrementValue)
                        .success((oldValue + incrementValue) == actualValue)));
    }

    @Then("verify $itemName value from $hostItems is the same with $oldItemValue")
    public void checkZabbixItemValueIsTheSameAsPreviousValue(String searchedItemName, List<ItemGetResponse.Result> itemsList, Integer oldValue) {

        int actualValue = Integer.parseInt(getValueOfZabbixItem(searchedItemName, itemsList));

        evaluate(localStep("Verifying values are the same")
                .details(ExecutionDetails.create("Current and Previous values are the same")
                        .received("Current value: " + actualValue + "\nPrevious value: " + oldValue)
                        .expected("Values are the same")
                        .success(oldValue == actualValue)));
    }

    @Then("get items of active instance amongst $hostItems1 and $hostItems2")
    public List<ItemGetResponse.Result> getZabbixItemsOfActiveInstance(List<ItemGetResponse.Result> itemsList1, List<ItemGetResponse.Result> itemsList2) {

        verifyInstancesAreMonitored(itemsList1, itemsList2);

        return getItemsListOfActiveInstance(itemsList1, itemsList2);
    }


    @Then("get $itemName value from $hostItems")
    public String getValueOfZabbixItem(String searchedItemName, List<ItemGetResponse.Result> itemsList) {

        final ItemGetResponse.Result item = getZabbixItemByName(itemsList, searchedItemName);

        evaluate(localStep("Check value not null")
                .details(ExecutionDetails.create("Check item \"" + searchedItemName + "\" value")
                        .expected("Value is not null")
                        .received(item.getLastvalue())
                        .success(item.getLastvalue() != null)));

        return item.getLastvalue();
    }

    @Then("verify that $itemValue has the expected value $expectedValue")
    public void checkItemHasExpectedValue(ResolvedExpression itemValue, ResolvedExpression expectedValue) {
        boolean equal = isEqual(itemValue, expectedValue);
        evaluate(localStep("Check Zabbix Item value")
                .details(ExecutionDetails.create("Verify that Zabbix Item has expected value")
                        .received("Item value: " + itemValue.resultAs(String.class))
                        .expected("Expected value " + expectedValue.resultAs(String.class))
                        .success(equal)));
    }

    @Then("verify that $firstItemValue is $comparison than $secondItemValue")
    @Alias("verify that $firstItemValue is $comparison to $secondItemValue")
    public void compareTwoZabbixItemsValue(ResolvedExpression firstItemValue, String comparisonSign, ResolvedExpression secondItemValue) {
        boolean comparisonIsTrue = compare(firstItemValue, secondItemValue, comparisonSign);
        evaluate(localStep("Compare Zabbix Items values")
                .details(ExecutionDetails.create("Compare " + firstItemValue.resultAs(String.class) + " and " + secondItemValue.resultAs(String.class))
                        .expected(firstItemValue.resultAs(String.class) + " " +comparisonSign + " " + secondItemValue.resultAs(String.class))
                        .success(comparisonIsTrue)));
    }

    public void verifyInstancesAreMonitored(List<ItemGetResponse.Result> itemsList1, List<ItemGetResponse.Result> itemsList2) {
        boolean isInstance1Monitored = Integer.parseInt(getValueOfZabbixItem("Monitoring Status", itemsList1)) == 0;
        boolean isInstance2Monitored = Integer.parseInt(getValueOfZabbixItem("Monitoring Status", itemsList2)) == 0;

        evaluate(localStep("Check if service is currently monitored")
                .details(ExecutionDetails.create("Verifying Monitoring status of each instance")
                        .received("Instance 1 is monitored: " + isInstance1Monitored + "\nInstance 2 is monitored: " + isInstance2Monitored)
                        .expected("The instances are monitored")
                        .success(isInstance1Monitored && isInstance2Monitored)));
    }

    public List<ItemGetResponse.Result> getItemsListOfActiveInstance(List<ItemGetResponse.Result> itemsList1, List<ItemGetResponse.Result> itemsList2) {
        int statusInstance1 = Integer.parseInt(getValueOfZabbixItem("Lifecycle status", itemsList1));
        int statusInstance2 = Integer.parseInt(getValueOfZabbixItem("Lifecycle status", itemsList2));

        evaluate(localStep("Check if there is an active instance")
                .details(ExecutionDetails.create("Verifying status of each instance")
                        .received("Instance 1 status: " + statusInstance1 + "\nInstance 2 status: " + statusInstance2)
                        .expected("One instance is active having status 1")
                        .success(((statusInstance1 == 1) || (statusInstance2 == 1)))));

        if (statusInstance1 == 1) {
            return itemsList1;
        }

        return itemsList2;
    }

    public ItemGetResponse.Result getZabbixItemByName(List<ItemGetResponse.Result> itemsList, String itemName) {

        Optional<ItemGetResponse.Result> searchedItem = itemsList.stream()
                .filter(x -> itemName.equals(x.getName()))
                .findFirst();

        evaluate(localStep("Check " + itemName + " Zabbix's item exists")
                .details(ExecutionDetails.create("Verify if \"" + itemName + "\" was found")
                        .usedData("It searched for: ", itemName)
                        .success(searchedItem.isPresent())));

        return searchedItem.get();
    }

    public void validateParameters(final ResolvedExpression leftOperand, final ResolvedExpression rightOperand) {
        checkNotNull(leftOperand, "Value to be compared (leftOperand) must not be null");
        checkNotNull(rightOperand, "Value to be compared (rightOperand) must not be null");
    }

    public boolean isEqual(final ResolvedExpression leftOperand, final ResolvedExpression rightOperand) {
        validateParameters(leftOperand, rightOperand);
        boolean equal;
        if (leftOperand.getResult() != null) {
            equal = leftOperand.getResult().equals(rightOperand.getResult())
                    || leftOperand.getResult().toString().equals(rightOperand.getResult() != null ? rightOperand.getResult().toString() : null);
        } else {
            equal = rightOperand.getResult() == null;
        }

        return equal;
    }

    public boolean compare(final ResolvedExpression leftOperand, final ResolvedExpression rightOperand, String comparisonSign) {
        validateParameters(leftOperand, rightOperand);
        boolean expressionIsTrue = false;
        switch (comparisonSign) {
            case "equal":{
                expressionIsTrue = Integer.parseInt((String)leftOperand.getResult()) == Integer.parseInt((String)rightOperand.getResult());
                break;
            }
            case "greater": {
                expressionIsTrue = Integer.parseInt((String)leftOperand.getResult()) > Integer.parseInt((String)rightOperand.getResult());
                break;
            }
            case "smaller": {
                expressionIsTrue = Integer.parseInt((String)leftOperand.getResult()) < Integer.parseInt((String)rightOperand.getResult());
                break;
            }
            case "greater or equal": {
                expressionIsTrue =Integer.parseInt((String)leftOperand.getResult()) >= Integer.parseInt((String)rightOperand.getResult());
                break;
            }
            case "smaller or equal": {
                expressionIsTrue = Integer.parseInt((String)leftOperand.getResult()) <= Integer.parseInt((String)rightOperand.getResult());
                break;
            }
        }
        return expressionIsTrue;
    }
}



