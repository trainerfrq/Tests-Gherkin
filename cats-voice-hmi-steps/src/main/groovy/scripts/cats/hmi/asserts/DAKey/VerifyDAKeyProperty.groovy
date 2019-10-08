package scripts.cats.hmi.asserts.DAKey

import com.frequentis.c4i.test.agent.DSLSupport
import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.c4i.test.util.timer.WaitCondition
import com.frequentis.c4i.test.util.timer.WaitTimer
import javafx.collections.ObservableSet
import javafx.css.PseudoClass
import javafx.scene.Node
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyDAKeyProperty extends FxScriptTemplate {

    public static final String IPARAM_DA_KEY_ID = "da_key_id"
    public static final String IPARAM_DA_KEY_PROPERTY = "da_key_property"
    public static final String IPARAM_PROPERTY_VISIBLE = "property_visible"

    @Override
    void script() {

        String daKeyId = assertInput(IPARAM_DA_KEY_ID) as String
        String daKeyProperty = assertInput(IPARAM_DA_KEY_PROPERTY) as String
        String propertyVisible = assertInput(IPARAM_PROPERTY_VISIBLE) as String

        final PseudoClass pseudoClassState = PseudoClass.getPseudoClass(daKeyProperty)

        Node daWidget = robot.lookup("#" + daKeyId).queryFirst();

        evaluate(ExecutionDetails.create("Verify DA key was found")
                .expected("DA key with id " + daKeyId + " was found")
                .success(daWidget != null));

        switch(propertyVisible){
            case "visible":
                evaluate(ExecutionDetails.create("Verify PseudoClassStates contains: " + daKeyProperty)
                        .success(verifyNodeHasPseudoClass(daWidget, pseudoClassState, 10000)))
                break
            case "not visible":
                evaluate(ExecutionDetails.create("Verify PseudoClassStates contains: " + daKeyProperty)
                        .success(!verifyNodeHasPseudoClass(daWidget, pseudoClassState, 10000)))
                break
        }
    }
    protected static boolean verifyNodeHasPseudoClass(Node node, PseudoClass pseudoClassState, long nWait) {

        WaitCondition condition = new WaitCondition("Wait until node has [" + pseudoClassState + "] class") {
            @Override
            boolean test() {
                ObservableSet<PseudoClass> pseudoClass = node.pseudoClassStates
                DSLSupport.evaluate(ExecutionDetails.create("Verifying has class")
                        .expected("Expected class: " + pseudoClassState)
                        .received("Found classes: " + pseudoClass)
                        .success())
                return pseudoClass.contains(pseudoClassState)
            }
        }
        return WaitTimer.pause(condition, nWait, 400)
    }
}