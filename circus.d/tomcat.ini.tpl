[env:tomcat]
JAVA_OPTS = {{JAVA_OPTS  | default('-Xms128m -Xmx3072m -XX:MaxPermSize=256m') }}
 
[watcher:tomcat]
#cmd = /opt/tomcat/bin/tomcat_wrapper.sh
cmd = /opt/tomcat/bin/catalina.sh
args = run
uid = tomcat
copy_env = True
use_sockets = False
singleton = True
