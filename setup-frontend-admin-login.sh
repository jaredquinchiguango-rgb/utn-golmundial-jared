#!/usr/bin/env bash
# =============================================================================
# setup-frontend-admin-login.sh
# PASO 2: Login y control de acceso (solo rol administrador)
# UTN GolMundial 2026 - Frontend Administrativo
#
# Requisito: haber ejecutado antes setup-frontend-admin.sh
# Uso: ejecutar desde la raiz del proyecto (donde esta el pom.xml)
#      cd $HOME/ProyectosUTN/frontend-admin
#      bash setup-frontend-admin-login.sh
# =============================================================================

set -e

echo "=== Creando carpeta security ==="
mkdir -p src/main/java/ec/edu/utn/golmundial/security
echo "OK"

# =============================================================================
# UsuarioService.java - se sobrescribe para agregar el metodo login()
# (se mantienen listarTodos() y cambiarEstado() del paso 1)
# =============================================================================
echo "=== Actualizando UsuarioService.java (se agrega login) ==="

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/UsuarioService.java << 'EOF'
package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import ec.edu.utn.golmundial.dto.estadisticas.UsuarioDTO;
import ec.edu.utn.golmundial.util.ApiConfig;
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.ws.rs.client.Client;
import jakarta.ws.rs.client.ClientBuilder;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@ApplicationScoped
public class UsuarioService {

    private static final Logger LOG = Logger.getLogger(UsuarioService.class.getName());

    private Client       client;
    private ObjectMapper mapper;

    @PostConstruct
    public void init() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper().registerModule(new JavaTimeModule());
    }

    @PreDestroy
    public void destroy() {
        if (client != null) client.close();
    }

    // TODO: confirmar path con Ariel (ej: /usuarios)
    public List<UsuarioDTO> listarTodos() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/usuarios")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<UsuarioDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar usuarios", e);
            return new ArrayList<>();
        }
    }

    // Habilitar / deshabilitar una cuenta (RF23)
    public boolean cambiarEstado(Integer idUsuario, boolean nuevoEstado) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("estado", nuevoEstado);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/usuarios/" + idUsuario + "/estado")
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al cambiar estado del usuario id=" + idUsuario, e);
            return false;
        }
    }

    /**
     * Login contra el Servicio de Estadisticas (RF02).
     * Endpoint y estructura CONFIRMADOS por Ariel:
     *   POST {BASE_URL_ESTADISTICAS}/login
     *   body:     {"email": "...", "password": "..."}
     *   response: {"idUser":1,"name":"...","email":"...","username":"...",
     *              "active":true,"role":"ADMINISTRADOR","idRole":1}
     * El mapeo ingles->espanol de la respuesta lo resuelve UsuarioDTO
     * con @JsonProperty, no hace falta tocar nada aqui.
     */
    public UsuarioDTO login(String email, String password) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("email", email);
            body.put("password", password);

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/login")
                .request(MediaType.APPLICATION_JSON)
                .post(Entity.json(mapper.writeValueAsString(body)));

            if (response.getStatus() != 200) {
                return null;
            }

            String json = response.readEntity(String.class);
            return mapper.readValue(json, UsuarioDTO.class);

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al iniciar sesion", e);
            return null;
        }
    }
}
EOF
echo "OK"

# =============================================================================
# LoginBean.java
# =============================================================================
echo "=== Creando LoginBean.java ==="

cat > src/main/java/ec/edu/utn/golmundial/bean/LoginBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.UsuarioDTO;
import ec.edu.utn.golmundial.service.estadisticas.UsuarioService;
import jakarta.enterprise.context.SessionScoped;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;

@Named
@SessionScoped
public class LoginBean implements Serializable {

    @Inject
    private UsuarioService usuarioService;

    private String     correo;
    private String     clave;
    private UsuarioDTO usuarioActual;

    public String ingresar() {
        UsuarioDTO usuario = usuarioService.login(correo, clave);

        if (usuario == null) {
            msg(FacesMessage.SEVERITY_ERROR, "Correo o clave incorrectos.");
            return null;
        }

        // Este panel es exclusivamente para administradores; el publico
        // general entra por el frontend publico, no por aqui (RF25).
        // El backend de Ariel devuelve el rol en mayusculas ("ADMINISTRADOR").
        if (!"ADMINISTRADOR".equals(usuario.getNombreRol())) {
            clave = null;
            msg(FacesMessage.SEVERITY_ERROR,
                "Esta cuenta no tiene permisos de administrador para acceder a este panel.");
            return null;
        }

        usuarioActual = usuario;
        clave = null;
        return "/index?faces-redirect=true";
    }

    public String salir() {
        usuarioActual = null;
        correo = null;
        clave = null;
        return "/login?faces-redirect=true";
    }

    public boolean isAutenticado() {
        return usuarioActual != null;
    }

    /** Inicial del nombre del usuario, para el avatar del rail lateral. */
    public String getInicial() {
        if (usuarioActual == null || usuarioActual.getNombre() == null
                || usuarioActual.getNombre().isBlank()) {
            return "A";
        }
        return usuarioActual.getNombre().substring(0, 1).toUpperCase();
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public String     getCorreo()           { return correo; }
    public void       setCorreo(String v)   { this.correo = v; }

    public String     getClave()            { return clave; }
    public void       setClave(String v)    { this.clave = v; }

    public UsuarioDTO getUsuarioActual()    { return usuarioActual; }
}
EOF
echo "OK"

# =============================================================================
# AccesoPhaseListener.java
# =============================================================================
echo "=== Creando AccesoPhaseListener.java ==="

cat > src/main/java/ec/edu/utn/golmundial/security/AccesoPhaseListener.java << 'EOF'
package ec.edu.utn.golmundial.security;

import ec.edu.utn.golmundial.bean.LoginBean;
import jakarta.faces.application.Application;
import jakarta.faces.context.FacesContext;
import jakarta.faces.event.PhaseEvent;
import jakarta.faces.event.PhaseId;
import jakarta.faces.event.PhaseListener;
import java.io.IOException;

/**
 * Todo este frontend es exclusivo del rol administrador (el publico general
 * entra por el frontend publico de Yurak). Por eso la regla es simple:
 * la unica vista publica es /login.xhtml; todo lo demas exige sesion
 * autenticada de administrador, o redirige a /login.xhtml.
 */
public class AccesoPhaseListener implements PhaseListener {

    @Override
    public PhaseId getPhaseId() {
        return PhaseId.RESTORE_VIEW;
    }

    @Override
    public void beforePhase(PhaseEvent event) {
        // No se necesita logica antes de restaurar la vista
    }

    @Override
    public void afterPhase(PhaseEvent event) {
        FacesContext context = event.getFacesContext();
        if (context.getViewRoot() == null) {
            return;
        }
        String viewId = context.getViewRoot().getViewId();

        boolean esVistaPublica = "/login.xhtml".equals(viewId);
        if (esVistaPublica) {
            return;
        }

        Application app = context.getApplication();
        LoginBean loginBean = app.evaluateExpressionGet(context, "#{loginBean}", LoginBean.class);

        try {
            if (!loginBean.isAutenticado()) {
                redirigir(context, "/login.xhtml");
            }
        } catch (IOException e) {
            // Si la redireccion falla, se deja continuar el ciclo de vida normal
        }
    }

    private void redirigir(FacesContext context, String ruta) throws IOException {
        String contextPath = context.getExternalContext().getRequestContextPath();
        context.getExternalContext().redirect(contextPath + ruta);
        context.responseComplete();
    }
}
EOF
echo "OK"

# =============================================================================
# faces-config.xml - se agrega el <lifecycle> con el phase-listener
# =============================================================================
echo "=== Actualizando faces-config.xml ==="

cat > src/main/webapp/WEB-INF/faces-config.xml << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<faces-config xmlns="https://jakarta.ee/xml/ns/jakartaee"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee
              https://jakarta.ee/xml/ns/jakartaee/web-facesconfig_4_0.xsd"
              version="4.0">

    <lifecycle>
        <phase-listener>ec.edu.utn.golmundial.security.AccesoPhaseListener</phase-listener>
    </lifecycle>

</faces-config>
EOF
echo "OK"

# =============================================================================
# login.xhtml
# =============================================================================
echo "=== Creando login.xhtml ==="

cat > src/main/webapp/login.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Iniciar sesion - Panel Administrativo</ui:define>
    <ui:define name="cabecera">Iniciar sesion</ui:define>

    <ui:define name="contenido">
        <div class="site-title">GolMundial 2026 · Panel Administrativo</div>

        <div class="card" style="max-width:420px;margin:0 auto;">
            <div class="card-header">Acceso exclusivo para administradores</div>
            <div class="card-body">
                <h:form id="formLogin">
                    <div class="form-grid" style="grid-template-columns:1fr;">
                        <div class="form-group">
                            <h:outputLabel for="correo" value="Correo *"/>
                            <h:inputText id="correo"
                                         value="#{loginBean.correo}"
                                         required="true"
                                         requiredMessage="El correo es obligatorio."/>
                            <h:message for="correo" styleClass="msg-error"/>
                        </div>
                        <div class="form-group">
                            <h:outputLabel for="clave" value="Clave *"/>
                            <h:inputSecret id="clave"
                                           value="#{loginBean.clave}"
                                           required="true"
                                           requiredMessage="La clave es obligatoria."
                                           redisplay="true"/>
                            <h:message for="clave" styleClass="msg-error"/>
                        </div>
                    </div>
                    <div class="form-actions" style="justify-content:center;">
                        <h:commandButton value="Ingresar"
                                         styleClass="btn btn-primary"
                                         action="#{loginBean.ingresar()}"/>
                    </div>
                </h:form>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# layout.xhtml - se actualiza: menu solo si autenticado, boton Salir
# =============================================================================
echo "=== Actualizando layout.xhtml ==="

cat > src/main/webapp/WEB-INF/templates/layout.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<h:head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title><ui:insert name="titulo">GolMundial 2026 - Admin</ui:insert></title>
    <h:outputStylesheet library="css" name="estilos.css"/>
</h:head>

<h:body>

    <nav class="navbar">
        <div class="navbar-brand">
            <h:link outcome="/index" styleClass="brand-link">GolMundial 2026 · Panel Admin</h:link>
        </div>
        <ul class="navbar-menu">
            <ui:fragment rendered="#{loginBean.autenticado}">
                <li><h:link outcome="/index"            value="Inicio"      styleClass="nav-link"/></li>
                <li><h:link outcome="/partidos/lista"    value="Partidos"    styleClass="nav-link"/></li>
                <li><h:link outcome="/selecciones/lista" value="Selecciones" styleClass="nav-link"/></li>
                <li><h:link outcome="/usuarios/lista"    value="Usuarios"    styleClass="nav-link"/></li>
                <li><h:link outcome="/reportes/lista"    value="Reportes"    styleClass="nav-link"/></li>
            </ui:fragment>
        </ul>
        <div class="navbar-user">
            <ui:fragment rendered="#{loginBean.autenticado}">
                <span class="user-placeholder">#{loginBean.usuarioActual.nombre}</span>
                <h:form style="display:inline;">
                    <h:commandLink value="Salir" styleClass="nav-link" action="#{loginBean.salir()}"/>
                </h:form>
            </ui:fragment>
        </div>
    </nav>

    <main class="main-content">
        <div class="page-header">
            <h1 class="page-title"><ui:insert name="cabecera">Inicio</ui:insert></h1>
            <div class="page-actions"><ui:insert name="acciones"/></div>
        </div>

        <h:messages globalOnly="true" styleClass="messages" errorClass="msg-error"
                    infoClass="msg-info" warnClass="msg-warn"/>

        <div class="page-body">
            <ui:insert name="contenido"><p>Sin contenido.</p></ui:insert>
        </div>
    </main>

    <footer class="footer">
        <p>UTN GolMundial 2026 - Panel Administrativo</p>
    </footer>

</h:body>
</html>
EOF
echo "OK"

# =============================================================================
# CSS - estilo del titulo de login (site-title), por si no existe aun
# =============================================================================
echo "=== Agregando estilo site-title al CSS (si no existe) ==="

if ! grep -q "site-title" src/main/webapp/resources/css/estilos.css; then
cat >> src/main/webapp/resources/css/estilos.css << 'EOF'

.site-title {
    text-align: center;
    font-size: 1.6rem;
    font-weight: 800;
    color: var(--primary);
    margin-bottom: 1.25rem;
}
EOF
fi
echo "OK"

echo ""
echo "=== Listo. Login y control de acceso agregados. ==="
echo "Compila y despliega de nuevo:"
echo "  mvn clean package"
echo "  cp target/frontend-admin.war \$HOME/programas/wildfly/standalone/deployments/"
