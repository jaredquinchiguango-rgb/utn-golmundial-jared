package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
import ec.edu.utn.golmundial.dto.utncoin.ReportePrediccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.PartidoService;
import ec.edu.utn.golmundial.service.utncoin.BilleteraService;
import ec.edu.utn.golmundial.service.utncoin.PrediccionService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Reportes basicos (RF27). El backend de Puma ya entrega el total
 * circulante y el ranking de predicciones calculados/ordenados - aqui
 * solo se cruza el nombre del partido usando idPartido, que segun
 * confirmo el equipo, es CONSISTENTE entre las dos bases de datos
 * (UTNGolCoin guarda el mismo id que genera Estadisticas, no uno propio).
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
        recargar();
    }

    public void recargar() {
        totalCirculante = billeteraService.obtenerTotalCirculante();

        List<ReportePrediccionDTO> reporte = prediccionService.obtenerReporteMasPredichos();
        List<PartidoDTO> partidos = partidoService.listarTodos();
        Map<Integer, PartidoDTO> partidoPorId = partidos.stream()
                .collect(Collectors.toMap(PartidoDTO::getIdPartido, p -> p, (a, b) -> a));

        topPartidosConMasPredicciones = reporte.stream()
                .limit(10)
                .map(r -> {
                    PartidoDTO partido = partidoPorId.get(r.getIdPartido());
                    String nombre = (partido != null)
                            ? partido.getNombreSeleccionLocal() + " vs " + partido.getNombreSeleccionVisitante()
                            : "Partido #" + r.getIdPartido();
                    return new PartidoConteo(r.getIdPartido(), nombre,
                            r.getTotalPredicciones().longValue(), r.getMontoTotal());
                })
                .collect(Collectors.toList());
    }

    public BigDecimal          getTotalCirculante()               { return totalCirculante; }
    public List<PartidoConteo> getTopPartidosConMasPredicciones()  { return topPartidosConMasPredicciones; }

    public static class PartidoConteo implements Serializable {
        private final Integer    idPartido;
        private final String     nombrePartido;
        private final Long       cantidad;
        private final BigDecimal montoTotal;

        public PartidoConteo(Integer idPartido, String nombrePartido, Long cantidad, BigDecimal montoTotal) {
            this.idPartido = idPartido;
            this.nombrePartido = nombrePartido;
            this.cantidad = cantidad;
            this.montoTotal = montoTotal;
        }

        public Integer    getIdPartido()     { return idPartido; }
        public String     getNombrePartido() { return nombrePartido; }
        public Long        getCantidad()      { return cantidad; }
        public BigDecimal getMontoTotal()    { return montoTotal; }
    }
}
