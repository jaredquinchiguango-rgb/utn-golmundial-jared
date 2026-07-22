package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;

/** Mapea GET /api/fases (confirmado por Ariel). */
public class FaseDTO {

    @JsonProperty("idPhase")
    private Integer idFase;

    @JsonProperty("code")
    private String  codigo;

    @JsonProperty("name")
    private String  nombre;

    @JsonProperty("startDate")
    private Long fechaInicioEpochMs;

    @JsonProperty("endDate")
    private Long fechaFinEpochMs;

    public FaseDTO() {}

    public Integer getIdFase()             { return idFase; }
    public void    setIdFase(Integer v)    { this.idFase = v; }

    public String  getCodigo()             { return codigo; }
    public void    setCodigo(String v)     { this.codigo = v; }

    public String  getNombre()             { return nombre; }
    public void    setNombre(String v)     { this.nombre = v; }

    public Long    getFechaInicioEpochMs()          { return fechaInicioEpochMs; }
    public void    setFechaInicioEpochMs(Long v)    { this.fechaInicioEpochMs = v; }

    public Long    getFechaFinEpochMs()             { return fechaFinEpochMs; }
    public void    setFechaFinEpochMs(Long v)       { this.fechaFinEpochMs = v; }

    /** Derivado del epoch millis, para mostrar en la tabla. */
    public LocalDate getFechaInicio() {
        return fechaInicioEpochMs != null
                ? Instant.ofEpochMilli(fechaInicioEpochMs).atZone(ZoneOffset.UTC).toLocalDate()
                : null;
    }

    /** Derivado del epoch millis, para mostrar en la tabla. */
    public LocalDate getFechaFin() {
        return fechaFinEpochMs != null
                ? Instant.ofEpochMilli(fechaFinEpochMs).atZone(ZoneOffset.UTC).toLocalDate()
                : null;
    }
}
