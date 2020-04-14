CATS_HOME=/opt/cats-case-officer
PROJECT_VERSION=1.1.1-1.2.1
CATS_VERSION=6.3.0
docker cp master:/cats/phone_automation-$PROJECT_VERSION/agents/cats-agent-selenium-$CATS_VERSION.zip $CATS_HOME/agent
unzip $CATS_HOME/agent/cats-agent-selenium*.zip $CATS_HOME/agent/
mkdir $CATS_HOME/agent/cats-agent-selenium/$CATS_VERSION/dsl
docker cp master:/cats/phone_automation-$PROJECT_VERSION/dsl/cats-configurator-steps $CATS_HOME/agent/cats-agent-selenium/$CATS_VERSION/dsl
docker cp master:/cats/phone_automation-$PROJECT_VERSION/resources/browser-support $CATS_HOME/agent/cats-agent-selenium/$CATS_VERSION
chmod +x $CATS_HOME/agent/cats-agent-selenium/$CATS_VERSION/browser-support/geckodriver


