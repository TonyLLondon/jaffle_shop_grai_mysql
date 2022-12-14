import os
from grai_source_dbt.base import update_server as update_server_from_dbt
from grai_source_mysql.base import update_server as update_server_from_mysql
from grai_client.endpoints.v1.client import ClientV1

client = ClientV1("localhost","8000")
client.set_authentication_headers("null@grai.io","super_secret")
manifest_file = os.path.join(os.path.dirname(__file__),"target", "manifest.json")

update_server_from_dbt(client, manifest_file)
update_server_from_mysql(client, dbname='db', user='docker', password='docker', namespace='jaffle_shop', host='localhost', port='3306')