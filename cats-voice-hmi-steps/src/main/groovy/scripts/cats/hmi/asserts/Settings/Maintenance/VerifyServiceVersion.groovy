package scripts.cats.hmi.asserts.Settings.Maintenance

import com.frequentis.c4i.test.model.ExecutionDetails
import com.frequentis.voice.hmi.component.layout.table.SmartTableView
import com.frequentis.voice.hmi.domain.mission.layout.data.SoftwareVersionElement
import scripts.agent.testfx.automation.FxScriptTemplate

class VerifyServiceVersion extends FxScriptTemplate {

    public static final String IPARAM_SERVICE_NAME = "service_name"
    public static final String IPARAM_SERVICE_VERSION = "service_version"

    @Override
    void script() {
        String serviceName = assertInput(IPARAM_SERVICE_NAME) as String
        String serviceVersion = assertInput(IPARAM_SERVICE_VERSION) as String

        SmartTableView<SoftwareVersionElement> smartTable = robot.lookup( "#softwareVersionTable" ).queryFirst()

        evaluate(ExecutionDetails.create("Searching for Versions table")
                .expected("Versions table found")
                .success(smartTable.isVisible()))

        String receivedServiceName = smartTable.getItems().get(0).getSoftwareComponentName()
        String receivedServiceVersion = smartTable.getItems().get(0).getSoftwareComponentVersion()

        evaluate(ExecutionDetails.create("Verifying service name")
                .expected(serviceName)
                .received(receivedServiceName)
                .success(receivedServiceName.equals(serviceName)))


        evaluate(ExecutionDetails.create("Verifying service version")
                .received(receivedServiceVersion)
                .expected(serviceVersion)
                .success(receivedServiceVersion.equals(serviceVersion)))
    }
}
