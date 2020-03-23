package scripts.cats.hmi.actions.PhoneBook

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.css.PseudoClass
import javafx.scene.Node
import javafx.scene.control.TableView
import javafx.scene.control.TextField
import scripts.agent.testfx.automation.FxScriptTemplate

class CallFromPhoneBook extends FxScriptTemplate {

    public static final String IPARAM_FUNCTION_KEY_ID = "function_key_id";
    public static final String IPARAM_SEARCH_BOX_TEXT = "search_box_text"

    @Override
    void script() {

        String functionKeyId = assertInput(IPARAM_FUNCTION_KEY_ID) as String;
        String searchBoxText = assertInput(IPARAM_SEARCH_BOX_TEXT) as String

        Node functionKeyWidget = robot.lookup("#" + functionKeyId).queryFirst();
        // open Phone Book pop-up window
        if (functionKeyId != null) {
            robot.clickOn(robot.point(functionKeyWidget));
        }

        //verify Phone Book pop-up window is visible
        Node phoneBookPopup = robot.lookup("#phonebookPopup").queryFirst()
        evaluate(ExecutionDetails.create("Phonebook popup was found")
                .expected("Phonebook popup is not null")
                .success(phoneBookPopup.isVisible()))

        WaitTimer.pause(150); //this wait is needed to make sure that phone book window is really visible for CATS

        final TextField textField = robot.lookup("#callInputTextField").queryFirst()
        //write the name of the external callee
        if(textField != null){
            robot.clickOn(robot.point(textField))
            robot.write(searchBoxText)
        }
        final TableView phonebookTable = robot.lookup( "#phonebookTable" ).queryFirst()
        phonebookTable.refresh()
        WaitTimer.pause(1000);

        final Node phoneBookEntry = robot.lookup( "#phonebookTable #phonebookEntry_0").queryFirst();
        // select phone book entry
        if(phoneBookEntry != null){
            robot.clickOn(robot.point(phoneBookEntry))
        }
        WaitTimer.pause(150);

        final Node callButton = robot.lookup("#callButton").queryFirst()
        // call from phone book
        if(!callButton.getPseudoClassStates().contains(PseudoClass.getPseudoClass("disabled"))){
            robot.clickOn(robot.point(callButton))
        }

    }
}
