keycloak:
	@mvn package
	@chmod +x startup.sh
	@docker run --rm --name keycloak-userdetails-testing -p 9999:8080 \
	-e KEYCLOAK_USER=admin -e KEYCLOAK_PASSWORD=admin \
	-v $$PWD/target/user-details-event-listener.jar:/opt/jboss/keycloak/standalone/deployments/user-details-event-listener.jar \
	-v $$PWD/startup.sh:/opt/jboss/startup-scripts/startup.sh \
	quay.io/keycloak/keycloak:15.0.2
