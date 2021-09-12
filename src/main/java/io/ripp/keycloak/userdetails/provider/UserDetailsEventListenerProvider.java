package io.ripp.keycloak.userdetails.provider;

import org.keycloak.Config;
import org.keycloak.events.Event;
import org.keycloak.events.EventListenerProvider;
import org.keycloak.events.EventListenerProviderFactory;
import org.keycloak.events.EventType;
import org.keycloak.events.admin.AdminEvent;
import org.keycloak.models.KeycloakSession;
import org.keycloak.models.KeycloakSessionFactory;
import org.keycloak.models.RealmModel;
import org.keycloak.models.UserSessionModel;

public class UserDetailsEventListenerProvider implements EventListenerProviderFactory, EventListenerProvider {
    private KeycloakSession kSession;

    @Override
    public String getId() {
        return "user_details_event_listener";
    }

    @Override
    public EventListenerProvider create(KeycloakSession kSession) {
        this.kSession = kSession;
        return this;
    }

    @Override
    public void init(Config.Scope scope) {}

    @Override
    public void postInit(KeycloakSessionFactory keycloakSessionFactory) {}

    @Override
    public void close() {}

    @Override
    public void onEvent(Event event) {
        if (event.getType() == EventType.LOGIN || event.getType() == EventType.REFRESH_TOKEN) {
            final RealmModel       realm       = kSession.realms().getRealm(event.getRealmId());
            final UserSessionModel userSession = kSession.sessions().getUserSession(realm, event.getSessionId());
            userSession.setNote("ipAddress", event.getIpAddress());
        }
    }

    @Override
    public void onEvent(AdminEvent adminEvent, boolean b) {
        // Don't care
    }
}
