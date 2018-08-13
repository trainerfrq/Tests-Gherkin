package scripts.automation

import com.frequentis.c4i.test.model.parameter.CatsCustomParameter
import com.frequentis.c4i.test.model.parameter.CatsCustomParameterBase

class ConfiguratorConfig extends CatsCustomParameterBase implements Serializable {

    @CatsCustomParameter(parameterName = "user")
    private String user
    @CatsCustomParameter(parameterName = "password")
    private String password

    @CatsCustomParameter(parameterName = "configuration")
    private String configuration

    String getUser() {
        return user
    }

    void setUser(String user) {
        this.user = user
    }

    String getPassword() {
        return password
    }

    void setPassword(String password) {
        this.password = password
    }

    String getConfiguration() {
        return configuration
    }

    void setConfiguration(String Configuration) {
        this.configuration = configuration
    }

    @Override
    String toString() {
        return "{user=\"${user}\", password=\"${password}\", configuration =\"${configuration}\""
    }
}
