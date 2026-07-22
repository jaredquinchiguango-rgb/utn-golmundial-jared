package ec.edu.utn.golmundial.dto.utncoin;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Mapea GET /api/Predictions/report/most-predicted (confirmado por Puma).
 * El backend ya lo devuelve ordenado de mayor a menor por cantidad.
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class ReportePrediccionDTO {

    @JsonProperty("matchId")
    private Integer idPartido;

    @JsonProperty("totalPredictions")
    private Integer totalPredicciones;

    @JsonProperty("totalAmount")
    private BigDecimal montoTotal;

    public ReportePrediccionDTO() {}

    public Integer    getIdPartido()                    { return idPartido; }
    public void       setIdPartido(Integer v)           { this.idPartido = v; }

    public Integer    getTotalPredicciones()            { return totalPredicciones; }
    public void       setTotalPredicciones(Integer v)   { this.totalPredicciones = v; }

    public BigDecimal getMontoTotal()                   { return montoTotal; }
    public void       setMontoTotal(BigDecimal v)       { this.montoTotal = v; }
}
