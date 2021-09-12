# Keycloak Event Provider Example

## Basics

- Create Provider Factory ([UserDetailsEvantListenerProvider](src/main/java/io/ripp/keycloak/userdetails/provider/UserDetailsEventListenerProvider.java))
  - This example combines the factory and provider by implementing both interfaces and returning `this` on create
- Create a link for keycloak to discover our provider in [resources/META-INF.services](src/main/resources/META-INF/services/org.keycloak.events.EventListenerProviderFactory)
- Run `mvn package` to produce the JAR

This JAR can then be dropped in `/opt/jboss/keycloak/standalone/deployments` then enabled via [Realm Admin --> Manage/Events --> Config](http://localhost:9999/auth/admin/master/console/#/realms/master/events-settings) 

For ease of testing, `make keycloak` will:
- `mvn package`
- `chmod +x startup.sh`
  - Make the [startup.sh](startup.sh) executable
- Run [keycloak docker on port 9999](http://localhost:9999)
  - Mount produced JAR to `/opt/jboss/keycloak/standalone/deployments`
  - Mount [startup.sh](startup.sh) to `/opt/jboss/startup-scripts`
  - Create admin user with `admin/admin` credentials

## [startup.sh](startup.sh)

Spins off a script in the background while keycloak is booting that:

- Polls http://localhost:8080/auth until a response is given
- Log in with `admin/admin` credentials
- Enable `user_details_event_listener` event provider
- Create `test` public client with open (`*`) redirects for testing
- Configures `test` client with mapper that maps `user.session.note.ipAddress` to JWT claim `ip`
