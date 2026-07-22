package ec.edu.utn.golmundial.dto.utncoin;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;

/** Mapea GET /api/Wallets/total-circulation (confirmado por Puma). */
public class TotalCirculacionDTO {

    @JsonProperty("totalCirculation")
    private BigDecimal totalCirculante;

    public TotalCirculacionDTO() {}

    public BigDecimal getTotalCirculante()             { return totalCirculante; }
    public void        setTotalCirculante(BigDecimal v) { this.totalCirculante = v; }
}
