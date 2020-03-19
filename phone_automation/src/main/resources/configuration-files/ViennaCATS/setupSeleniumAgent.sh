CATS_HOME=/opt/cats-case-officer
PROJECT_VERSION=1.1.1-1.1.0-SNAPSHOT
CATS_VERSION=6.1.0
docker cp master:/cats/phone_automation-$PROJECT_VERSION/agents/cats-agent-selenium-$CATS_VERSION.zip $CATS_HOME/agent
unzip $CATS_HOME/agent/cats-agent-selenium*.zip $CATS_HOME/agent/
docker cp master:/cats/phone_automation-$PROJECT_VERSION/dsl $CATS_HOME/agent/cats-agent-selenium/$CATS_VERSION
docker cp master:/cats/phone_automation-$PROJECT_VERSION/resources/browser-support $CATS_HOME/agent/cats-agent-selenium/$CATS_VERSION


