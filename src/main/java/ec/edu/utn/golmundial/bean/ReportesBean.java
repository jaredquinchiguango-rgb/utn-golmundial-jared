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
