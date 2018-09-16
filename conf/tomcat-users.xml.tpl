<tomcat-users>
  <role rolename="manager"/>
  <user name="{{MANAGER_USER| default('admin')}}" password="{{MANAGER_PASSWORD| default ('admin')}}" roles="manager"/>
</tomcat-users>
