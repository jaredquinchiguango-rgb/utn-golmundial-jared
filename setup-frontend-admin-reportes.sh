#!/usr/bin/env bash
# =============================================================================
# setup-frontend-admin-reportes.sh
# PASO 4: Reportes (RF27) - total UTNGolCoin en circulacion y
#          partidos con mas predicciones
# UTN GolMundial 2026 - Frontend Administrativo
#
# Requisito: haber ejecutado antes setup-frontend-admin.sh
# Uso: ejecutar desde la raiz del proyecto (donde esta el pom.xml)
#      cd $HOME/ProyectosUTN/frontend-admin
#      bash setup-frontend-admin-reportes.sh
# =============================================================================

set -e

echo "=== Creando carpeta de vistas ==="
mkdir -p src/main/webapp/reportes
echo "OK"

# =============================================================================
# ReportesBean.java - combina datos de los DOS backends
# =============================================================================
echo "=== Creando ReportesBean.java ==="

cat > src/main/java/ec/edu/utn/golmundial/bean/ReportesBean.java << 'EOF'
package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
import ec.edu.utn.golmundial.dto.utncoin.PrediccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.PartidoService;
import ec.edu.utn.golmundial.service.utncoin.BilleteraService;
import ec.edu.utn.golmundial.service.utncoin.PrediccionService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Reportes basicos (RF27): total de UTNGolCoin en circulacion y partidos
 * con mas predicciones. Es el unico bean del proyecto que combina datos
 * de los DOS backends (Estadisticas + UTNGolCoin) en un mismo reporte.
 */
@Named
@ViewScoped
public class ReportesBean implements Serializable {

    @Inject private BilleteraService  billeteraService;
    @Inject private PrediccionService prediccionService;
    @Inject private PartidoService    partidoService;

    private BigDecimal totalCirculante;
    private List<PartidoConteo> topPartidosConMasPredicciones;

    @PostConstruct
    public void init() {
        totalCirculante = billeteraService.calcularTotalCirculante();
        calcularTopPartidos();
    }

    private void calcularTopPartidos() {
        List<PrediccionDTO> predicciones = prediccionService.listarTodas();

        // Contar cuantas predicciones tiene cada partido
        Map<Integer, Long> conteoPorPartido = predicciones.stream()
                .filter(p -> p.getIdPartido() != null)
                .collect(Collectors.groupingBy(PrediccionDTO::getIdPartido, Collectors.counting()));

        // Traer los datos de cada partido (nombres de selecciones) desde Estadisticas
        List<PartidoDTO> partidos = partidoService.listarTodos();
        Map<Integer, PartidoDTO> partidoPorId = partidos.stream()
                .collect(Collectors.toMap(PartidoDTO::getIdPartido, p -> p, (a, b) -> a));

        topPartidosConMasPredicciones = conteoPorPartido.entrySet().stream()
                .map(entry -> {
                    Integer idPartido = entry.getKey();
                    Long cantidad = entry.getValue();
                    PartidoDTO partido = partidoPorId.get(idPartido);
                    String nombre = (partido != null)
                            ? partido.getNombreSeleccionLocal() + " vs " + partido.getNombreSeleccionVisitante()
                            : "Partido #" + idPartido;
                    return new PartidoConteo(idPartido, nombre, cantidad);
                })
                .sorted(Comparator.comparingLong(PartidoConteo::getCantidad).reversed())
                .limit(10)
                .collect(Collectors.toList());
    }

    public void recargar() {
        totalCirculante = billeteraService.calcularTotalCirculante();
        calcularTopPartidos();
    }

    public BigDecimal          getTotalCirculante()               { return totalCirculante; }
    public List<PartidoConteo> getTopPartidosConMasPredicciones()  { return topPartidosConMasPredicciones; }

    /** Clase auxiliar solo para mostrar el ranking en la vista; no viene de ningun DTO del backend. */
    public static class PartidoConteo implements Serializable {
        private final Integer idPartido;
        private final String  nombrePartido;
        private final Long    cantidad;

        public PartidoConteo(Integer idPartido, String nombrePartido, Long cantidad) {
            this.idPartido = idPartido;
            this.nombrePartido = nombrePartido;
            this.cantidad = cantidad;
        }

        public Integer getIdPartido()     { return idPartido; }
        public String  getNombrePartido() { return nombrePartido; }
        public Long    getCantidad()      { return cantidad; }
    }
}
EOF
echo "OK"

# =============================================================================
# XHTML - reportes/lista.xhtml
# =============================================================================
echo "=== Creando reportes/lista.xhtml ==="

cat > src/main/webapp/reportes/lista.xhtml << 'EOF'
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml"
      xmlns:h="jakarta.faces.html"
      xmlns:f="jakarta.faces.core"
      xmlns:ui="jakarta.faces.facelets">

<ui:composition template="/WEB-INF/templates/layout.xhtml">

    <ui:define name="titulo">Reportes</ui:define>
    <ui:define name="cabecera">Reportes b&#225;sicos</ui:define>

    <ui:define name="acciones">
        <h:form>
            <h:commandButton value="Actualizar" styleClass="btn btn-outline"
                             action="#{reportesBean.recargar()}"/>
        </h:form>
    </ui:define>

    <ui:define name="contenido">

        <div class="reportes-grid">
            <div class="card kpi-card">
                <div class="card-body text-center">
                    <div class="kpi-label">Total UTNGolCoin en circulacion</div>
                    <div class="kpi-value">
                        <h:outputText value="#{reportesBean.totalCirculante}">
                            <f:convertNumber type="currency" currencySymbol="&#8383; " maxFractionDigits="2"/>
                        </h:outputText>
                    </div>
                    <div class="text-muted">Suma del saldo de todas las billeteras activas</div>
                </div>
            </div>
        </div>

        <div class="card mt-3">
            <div class="card-header">Top 10 partidos con m&#225;s predicciones</div>
            <div class="card-body">
                <div class="table-container">
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Partido</th>
                                <th>Cantidad de predicciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <ui:repeat value="#{reportesBean.topPartidosConMasPredicciones}"
                                       var="item" varStatus="status">
                                <tr>
                                    <td>#{status.index + 1}</td>
                                    <td>#{item.nombrePartido}</td>
                                    <td>
                                        <span class="badge badge-info">#{item.cantidad}</span>
                                    </td>
                                </tr>
                            </ui:repeat>
                            <ui:fragment rendered="#{empty reportesBean.topPartidosConMasPredicciones}">
                                <tr>
                                    <td colspan="3" class="text-center text-muted">
                                        Aun no hay predicciones registradas.
                                    </td>
                                </tr>
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
# CSS - estilos de las tarjetas KPI (si no existen aun)
# =============================================================================
echo "=== Agregando estilos de reportes al CSS (si no existen) ==="

if ! grep -q "\.kpi-card" src/main/webapp/resources/css/estilos.css; then
cat >> src/main/webapp/resources/css/estilos.css << 'EOF'

.reportes-grid {
    display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
    gap: 1.25rem;
}
.kpi-card .card-body { padding: 2rem 1.5rem; }
.kpi-label { font-size: .85rem; color: var(--text-muted); font-weight: 600; text-transform: uppercase; letter-spacing: .03em; }
.kpi-value { font-size: 2.2rem; font-weight: 800; color: var(--primary); margin: .4rem 0; }
.mt-3 { margin-top: 1.5rem; }
EOF
fi
echo "OK"

echo ""
echo "=== Listo. Pantalla de Reportes agregada. ==="
echo "Compila y despliega de nuevo:"
echo "  mvn clean package"
echo "  cp target/frontend-admin.war \$HOME/programas/wildfly/standalone/deployments/"
