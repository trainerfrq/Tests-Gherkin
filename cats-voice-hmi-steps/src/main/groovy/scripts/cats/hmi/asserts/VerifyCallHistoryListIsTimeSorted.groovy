package scripts.cats.hmi.asserts

import com.frequentis.c4i.test.model.ExecutionDetails
import com.google.common.collect.Ordering
import javafx.scene.Node
import javafx.scene.control.Label
import javafx.scene.control.ListView
import scripts.agent.testfx.automation.FxScriptTemplate


class VerifyCallHistoryListIsTimeSorted extends FxScriptTemplate {


    @Override
    void script() {

        Node callHistoryPopup = robot.lookup("#callHistoryPopup").queryFirst()

        evaluate(ExecutionDetails.create("Call history popup was found")
                .expected("Call history popup is not null")
                .success(callHistoryPopup != null))

        if (callHistoryPopup != null) {
            final ListView callHistoryList = robot.lookup("#callHistoryList").queryFirst()
            int receivedCallHistoryListSize = callHistoryList.getItems().size()

            List<String> dateTimeList = new ArrayList<String>()

            for(int i = 0;i<receivedCallHistoryListSize;i++){
                final Node callHistoryEntry = robot.lookup("#callHistoryList .list-cell").selectAt(i).queryFirst()
                dateTimeList.add((callHistoryEntry).lookup("#timeLabel").toString())
            }
            boolean isSorted = Ordering.natural().reverse().isOrdered(dateTimeList)

            evaluate(ExecutionDetails.create("Call history list is time sorted")
                    .received(dateTimeList.toString())
                    .success(isSorted == true))
        }
    }
}