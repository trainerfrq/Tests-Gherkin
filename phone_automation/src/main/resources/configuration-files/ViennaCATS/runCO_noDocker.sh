CATS_HOME=/opt/cats-case-officer
DISPLAY=$(w|grep -v grep| grep bash|awk '{print $3}') cats-case-officer -h $CATS_HOME
