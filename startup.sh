#!/bin/bash

export PATH=$PATH:$JBOSS_HOME/bin

until $(curl --output /dev/null --silent --head --fail http://localhost:8080/auth); do sleep 1; done && \
kcadm.sh config credentials --server http://localhost:8080/auth --realm master --user admin --password admin && \
kcadm.sh update events/config -r master -s 'eventsListeners=["jboss-logging","user_details_event_listener"]' && \
kcadm.sh create clients -r master -s clientId=test -s publicClient=true -s redirectUris='["*"]' -s enabled=true && \
export CLIENT_ID=$(kcadm.sh get clients -r master -q clientId=test -F id --format csv --noquotes) && \
kcadm.sh create clients/$CLIENT_ID/protocol-mappers/models -r master \
	-s name="IP Address" -s protocol=openid-connect \
	-s protocolMapper=oidc-usersessionmodel-note-mapper -s consentRequired=false \
	-s 'config."access.tokenResponse.claim"=false' -s 'config."id.token.claim"=false' \
	-s 'config."access.token.claim"=true' -s 'config."jsonType.label"=String' \
	-s 'config."user.session.note"=ipAddress' -s 'config."claim.name"=ip' && \
echo "Setup Complete" & disown
