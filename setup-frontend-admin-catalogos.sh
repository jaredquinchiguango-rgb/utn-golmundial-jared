#!/usr/bin/env bash
# =============================================================================
# setup-frontend-admin-catalogos.sh
# PASO 3: Selecciones (editable), Grupos, Sedes y Fases (consulta)
# UTN GolMundial 2026 - Frontend Administrativo
#
# Requisito: haber ejecutado antes setup-frontend-admin.sh y
#            setup-frontend-admin-login.sh
# Uso: ejecutar desde la raiz del proyecto (donde esta el pom.xml)
#      cd $HOME/ProyectosUTN/frontend-admin
#      bash setup-frontend-admin-catalogos.sh
# =============================================================================

set -e

echo "=== Creando carpetas de vistas ==="
mkdir -p src/main/webapp/{grupos,sedes,fases}
echo "OK"

# =============================================================================
# SeleccionService.java - se agrega actualizar()
# (listarTodas() se mantiene igual que en el paso 1)
# =============================================================================
echo "=== Actualizando SeleccionService.java (se agrega actualizar) ==="

cat > src/main/java/ec/edu/utn/golmundial/service/estadisticas/SeleccionService.java << 'EOF'
package ec.edu.utn.golmundial.service.estadisticas;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
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
public class SeleccionService {

    private static final Logger LOG = Logger.getLogger(SeleccionService.class.getName());

    private Client       client;
    private ObjectMapper mapper;

    @PostConstruct
    public void init() {
        client = ClientBuilder.newClient();
        mapper = new ObjectMapper();
    }

    @PreDestroy
    public void destroy() {
        if (client != null) client.close();
    }

    // TODO: confirmar path real con Ariel (ej: /selecciones)
    public List<SeleccionDTO> listarTodas() {
        try {
            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/selecciones")
                .request(MediaType.APPLICATION_JSON)
                .get();

            String json = response.readEntity(String.class);
            return mapper.readValue(json, new TypeReference<List<SeleccionDTO>>() {});

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al listar selecciones", e);
            return new ArrayList<>();
        }
    }

    /**
     * Actualiza los datos editables de una seleccion (RF10). Los campos
     * estadisticos (partidosJugados, puntos, golesFavor, etc.) NO se
     * envian: esos los calcula y actualiza el propio backend cuando se
     * registra un resultado (RF06), no se editan manualmente aqui.
     *
     * TODO: confirmar path con Ariel (ej: PUT /selecciones/{id})
     */
    public boolean actualizar(SeleccionDTO dto) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("nombre", dto.getNombre());
            body.put("codigoFifa", dto.getCodigoFifa());
            body.put("esAnfitrion", dto.getEsAnfitrion());
            body.put("idGrupo", dto.getIdGrupo());

            Response response = client
                .target(ApiConfig.BASE_URL_ESTADISTICAS + "/selecciones/" + dto.getIdSeleccion())
                .request(MediaType.APPLICATION_JSON)
                .put(Entity.json(mapper.writeValueAsString(body)));

            return response.getStatus() == 200;

        } catch (Exception e) {
            LOG.log(Level.SEVERE, "Error al actualizar seleccion id=" + dto.getIdSeleccion(), e);
            return false;
        }
    }
}
EOF
echo "OK"

# =============================================================================
# Beans
# =============================================================================
echo "=== Creando SeleccionBean.java ==="

cat > src/main/java/ec/edu/utn/golmundial/bean/SeleccionBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.GrupoService;
import ec.edu.utn.golmundial.service.estadisticas.SeleccionService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class SeleccionBean implements Serializable {

    @Inject private SeleccionService seleccionService;
    @Inject private GrupoService     grupoService;

    private List<SeleccionDTO> selecciones;
    private List<GrupoDTO>     grupos;
    private SeleccionDTO       seleccionSeleccionada;

    @PostConstruct
    public void init() {
        cargarSelecciones();
        grupos = grupoService.listarTodos();
    }

    public void cargarSelecciones() {
        selecciones = seleccionService.listarTodas();
    }

    public String prepararEditar(SeleccionDTO seleccion) {
        seleccionSeleccionada = seleccion;
        return "/selecciones/editar?faces-redirect=true";
    }

    public String guardarEdicion() {
        boolean exito = seleccionService.actualizar(seleccionSeleccionada);
        if (exito) {
            cargarSelecciones();
            msg(FacesMessage.SEVERITY_INFO, "Seleccion actualizada correctamente.");
            return "/selecciones/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo actualizar la seleccion.");
        return null;
    }

    public String cancelar() {
        seleccionSeleccionada = null;
        return "/selecciones/lista?faces-redirect=true";
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public List<SeleccionDTO> getSelecciones()                  { return selecciones; }
    public List<GrupoDTO>     getGrupos()                        { return grupos; }

    public SeleccionDTO getSeleccionSeleccionada()               { return seleccionSeleccionada; }
    public void         setSeleccionSeleccionada(SeleccionDTO v) { this.seleccionSeleccionada = v; }
}
EOF

echo "=== Creando GrupoBean.java ==="

cat > src/main/java/ec/edu/utn/golmundial/bean/GrupoBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.service.estadisticas.GrupoService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class GrupoBean implements Serializable {

    @Inject private GrupoService grupoService;

    private List<GrupoDTO> grupos;

    @PostConstruct
    public void init() {
        grupos = grupoService.listarTodos();
    }

    public List<GrupoDTO> getGrupos() { return grupos; }
}
EOF

echo "=== Creando SedeBean.java ==="

cat > src/main/java/ec/edu/utn/golmundial/bean/SedeBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.SedeDTO;
import ec.edu.utn.golmundial.service.estadisticas.SedeService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class SedeBean implements Serializable {

    @Inject private SedeService sedeService;

    private List<SedeDTO> sedes;

    @PostConstruct
    public void init() {
        sedes = sedeService.listarTodas();
    }

    public List<SedeDTO> getSedes() { return sedes; }
}
EOF

echo "=== Creando FaseBean.java ==="

cat > src/main/java/ec/edu/utn/golmundial/bean/FaseBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.FaseDTO;
import ec.edu.utn.golmundial.service.estadisticas.FaseService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class FaseBean implements Serializable {

    @Inject private FaseService faseService;

    private List<FaseDTO> fases;

    @PostConstruct
    public void init() {
        fases = faseService.listarTodas();
    }

    public List<FaseDTO> getFases() { return fases; }
}
EOF
echo "OK"

# =============================================================================
# XHTML - selecciones/lista.xhtml (con pestañas de acceso rapido al resto
# del catalogo: Grupos, Sedes, Fases, para no llenar el navbar principal)
# =============================================================================
echo "=== Creando vistas de Selecciones ==="

cat > src/main/webapp/selecciones/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Selecciones</ui:define>
    <ui:define name="cabecera">Cat&#225;logo del torneo</ui:define>

    <ui:define name="contenido">
        <div class="subtabs">
            <h:link outcome="/selecciones/lista" styleClass="subtab subtab-active" value="Selecciones"/>
            <h:link outcome="/grupos/lista"       styleClass="subtab" value="Grupos"/>
            <h:link outcome="/sedes/lista"        styleClass="subtab" value="Sedes"/>
            <h:link outcome="/fases/lista"        styleClass="subtab" value="Fases"/>
        </div>

        <div class="card">
            <div class="card-header">Las 48 selecciones participantes</div>
            <div class="card-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>Nombre</th>
                                <th>Codigo FIFA</th>
                                <th>Grupo</th>
                                <th>Anfitrion</th>
                                <th>PJ</th>
                                <th>Pts</th>
                                <th>G</th>
                                <th>E</th>
                                <th>P</th>
                                <th>GF</th>
                                <th>GC</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <ui:repeat value="#{seleccionBean.selecciones}" var="s">
                                <tr>
                                    <td>#{s.nombre}</td>
                                    <td>#{s.codigoFifa}</td>
                                    <td>#{s.nombreGrupo}</td>
                                    <td>
                                        <h:panelGroup rendered="#{s.esAnfitrion}">
                                            <span class="badge badge-info">Si</span>
                                        </h:panelGroup>
                                    </td>
                                    <td>#{s.partidosJugados}</td>
                                    <td>#{s.puntos}</td>
                                    <td>#{s.partidosGanados}</td>
                                    <td>#{s.partidosEmpatados}</td>
                                    <td>#{s.partidosPerdidos}</td>
                                    <td>#{s.golesFavor}</td>
                                    <td>#{s.golesContra}</td>
                                    <td>
                                        <h:form style="display:inline">
                                            <h:commandButton value="Editar"
                                                             styleClass="btn btn-warning btn-sm"
                                                             action="#{seleccionBean.prepararEditar(s)}"/>
                                        </h:form>
                                    </td>
                                </tr>
                            </ui:repeat>
                            <ui:fragment rendered="#{empty seleccionBean.selecciones}">
                                <tr>
                                    <td colspan="12" class="text-center text-muted">
                                        No hay selecciones registradas.
                                    </td>
                                </tr>
                            </ui:fragment>
                        </tbody>
                    </table>
                </div>
                <p class="text-muted mt-2">
                    PJ: partidos jugados · Pts: puntos · G/E/P: ganados/empatados/perdidos ·
                    GF/GC: goles a favor/en contra. Estas columnas las actualiza el sistema
                    automaticamente al registrar resultados (RF06), no se editan a mano.
                </p>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF

cat > src/main/webapp/selecciones/editar.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Editar seleccion</ui:define>
    <ui:define name="cabecera">Editar seleccion</ui:define>

    <ui:define name="contenido">
        <div class="card" style="max-width:520px;margin:0 auto;">
            <div class="card-header">#{seleccionBean.seleccionSeleccionada.nombre}</div>
            <div class="card-body">
                <h:form id="formSeleccion">
                    <div class="form-grid">
                        <div class="form-group full-width">
                            <h:outputLabel for="nombre" value="Nombre *"/>
                            <h:inputText id="nombre"
                                         value="#{seleccionBean.seleccionSeleccionada.nombre}"
                                         required="true"
                                         requiredMessage="El nombre es obligatorio."/>
                            <h:message for="nombre" styleClass="msg-error"/>
                        </div>
                        <div class="form-group">
                            <h:outputLabel for="codigoFifa" value="Codigo FIFA *"/>
                            <h:inputText id="codigoFifa"
                                         value="#{seleccionBean.seleccionSeleccionada.codigoFifa}"
                                         required="true"
                                         requiredMessage="El codigo FIFA es obligatorio."/>
                            <h:message for="codigoFifa" styleClass="msg-error"/>
                        </div>
                        <div class="form-group">
                            <h:outputLabel for="grupo" value="Grupo"/>
                            <h:selectOneMenu id="grupo"
                                             value="#{seleccionBean.seleccionSeleccionada.idGrupo}">
                                <f:selectItem itemLabel="-- Seleccione --" itemValue="#{null}"/>
                                <f:selectItems value="#{seleccionBean.grupos}"
                                               var="g"
                                               itemValue="#{g.idGrupo}"
                                               itemLabel="#{g.nombre}"/>
                            </h:selectOneMenu>
                        </div>
                        <div class="form-group">
                            <h:outputLabel for="anfitrion" value="Es sede anfitriona"/>
                            <h:selectBooleanCheckbox id="anfitrion"
                                value="#{seleccionBean.seleccionSeleccionada.esAnfitrion}"/>
                        </div>
                    </div>
                    <div class="form-actions">
                        <h:commandButton value="Cancelar"
                                         styleClass="btn btn-outline"
                                         action="#{seleccionBean.cancelar()}"
                                         immediate="true"/>
                        <h:commandButton value="Guardar cambios"
                                         styleClass="btn btn-primary"
                                         action="#{seleccionBean.guardarEdicion()}"/>
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
# XHTML - grupos/lista.xhtml
# =============================================================================
echo "=== Creando vista de Grupos ==="

cat > src/main/webapp/grupos/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Grupos</ui:define>
    <ui:define name="cabecera">Cat&#225;logo del torneo</ui:define>

    <ui:define name="contenido">
        <div class="subtabs">
            <h:link outcome="/selecciones/lista" styleClass="subtab" value="Selecciones"/>
            <h:link outcome="/grupos/lista"       styleClass="subtab subtab-active" value="Grupos"/>
            <h:link outcome="/sedes/lista"        styleClass="subtab" value="Sedes"/>
            <h:link outcome="/fases/lista"        styleClass="subtab" value="Fases"/>
        </div>

        <div class="card">
            <div class="card-header">Los 12 grupos del torneo</div>
            <div class="card-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr><th>Codigo</th><th>Nombre</th></tr>
                        </thead>
                        <tbody>
                            <ui:repeat value="#{grupoBean.grupos}" var="g">
                                <tr>
                                    <td>#{g.codigo}</td>
                                    <td>#{g.nombre}</td>
                                </tr>
                            </ui:repeat>
                            <ui:fragment rendered="#{empty grupoBean.grupos}">
                                <tr><td colspan="2" class="text-center text-muted">No hay grupos registrados.</td></tr>
                            </ui:fragment>
                        </tbody>
                    </table>
                </div>
                <p class="text-muted mt-2">
                    Los grupos se cargan desde el seed inicial del torneo (RF28); esta vista es
                    solo de consulta.
                </p>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# XHTML - sedes/lista.xhtml
# =============================================================================
echo "=== Creando vista de Sedes ==="

cat > src/main/webapp/sedes/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Sedes</ui:define>
    <ui:define name="cabecera">Cat&#225;logo del torneo</ui:define>

    <ui:define name="contenido">
        <div class="subtabs">
            <h:link outcome="/selecciones/lista" styleClass="subtab" value="Selecciones"/>
            <h:link outcome="/grupos/lista"       styleClass="subtab" value="Grupos"/>
            <h:link outcome="/sedes/lista"        styleClass="subtab subtab-active" value="Sedes"/>
            <h:link outcome="/fases/lista"        styleClass="subtab" value="Fases"/>
        </div>

        <div class="card">
            <div class="card-header">Estadios de Estados Unidos, Mexico y Canada</div>
            <div class="card-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr><th>Estadio</th><th>Ciudad</th><th>Capacidad</th></tr>
                        </thead>
                        <tbody>
                            <ui:repeat value="#{sedeBean.sedes}" var="s">
                                <tr>
                                    <td>#{s.estadio}</td>
                                    <td>#{s.nombreCiudad}</td>
                                    <td>#{s.capacidad}</td>
                                </tr>
                            </ui:repeat>
                            <ui:fragment rendered="#{empty sedeBean.sedes}">
                                <tr><td colspan="3" class="text-center text-muted">No hay sedes registradas.</td></tr>
                            </ui:fragment>
                        </tbody>
                    </table>
                </div>
                <p class="text-muted mt-2">
                    Las sedes se cargan desde el seed inicial del torneo (RF28); esta vista es
                    solo de consulta.
                </p>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# XHTML - fases/lista.xhtml
# =============================================================================
echo "=== Creando vista de Fases ==="

cat > src/main/webapp/fases/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Fases</ui:define>
    <ui:define name="cabecera">Cat&#225;logo del torneo</ui:define>

    <ui:define name="contenido">
        <div class="subtabs">
            <h:link outcome="/selecciones/lista" styleClass="subtab" value="Selecciones"/>
            <h:link outcome="/grupos/lista"       styleClass="subtab" value="Grupos"/>
            <h:link outcome="/sedes/lista"        styleClass="subtab" value="Sedes"/>
            <h:link outcome="/fases/lista"        styleClass="subtab subtab-active" value="Fases"/>
        </div>

        <div class="card">
            <div class="card-header">Fases del torneo (RF09)</div>
            <div class="card-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr><th>Codigo</th><th>Nombre</th><th>Inicio</th><th>Fin</th></tr>
                        </thead>
                        <tbody>
                            <ui:repeat value="#{faseBean.fases}" var="f">
                                <tr>
                                    <td>#{f.codigo}</td>
                                    <td>#{f.nombre}</td>
                                    <td>
                                        <h:outputText value="#{f.fechaInicio}">
                                            <f:convertDateTime pattern="dd/MM/yyyy" type="localDate"/>
                                        </h:outputText>
                                    </td>
                                    <td>
                                        <h:outputText value="#{f.fechaFin}">
                                            <f:convertDateTime pattern="dd/MM/yyyy" type="localDate"/>
                                        </h:outputText>
                                    </td>
                                </tr>
                            </ui:repeat>
                            <ui:fragment rendered="#{empty faseBean.fases}">
                                <tr><td colspan="4" class="text-center text-muted">No hay fases registradas.</td></tr>
                            </ui:fragment>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </ui:define>

</ui:composition>
</html>
EOF
echo "OK"

# =============================================================================
# CSS - estilo de las subtabs del catalogo (si no existe aun)
# =============================================================================
echo "=== Agregando estilo subtabs al CSS (si no existe) ==="

if ! grep -q "\.subtabs" src/main/webapp/resources/css/estilos.css; then
cat >> src/main/webapp/resources/css/estilos.css << 'EOF'

.subtabs {
    display: flex; gap: .5rem; margin-bottom: 1rem;
    border-bottom: 1px solid var(--border-light); padding-bottom: 0;
}
.subtab {
    padding: .55rem 1rem; border-radius: var(--radius) var(--radius) 0 0;
    color: var(--text-muted) !important; font-weight: 600; font-size: .85rem;
    text-decoration: none !important; border-bottom: 2px solid transparent;
}
.subtab:hover { color: var(--primary) !important; background: var(--bg); }
.subtab-active {
    color: var(--accent) !important; border-bottom: 2px solid var(--accent);
    background: var(--bg-card);
}
EOF
fi
echo "OK"

echo ""
echo "=== Listo. Selecciones, Grupos, Sedes y Fases agregados. ==="
echo "Compila y despliega de nuevo:"
echo "  mvn clean package"
echo "  cp target/frontend-admin.war \$HOME/programas/wildfly/standalone/deployments/"
