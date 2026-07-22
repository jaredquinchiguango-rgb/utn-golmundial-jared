package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * Mapea GET /api/partidos (confirmado por Ariel).
 *
 * OJO: matchDateTimeUtc viene como epoch millis (numero), igual patron
 * que registeredAt/lastAccess en UsuarioDTO. Se guarda como Long y se
 * expone un getter derivado a LocalDateTime para no tocar
 * partidos/lista.xhtml (que ya usa f:convertDateTime).
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class PartidoDTO {

    @JsonProperty("idMatch")
    private Integer idPartido;

    @JsonProperty("fifaMatchNumber")
    private Integer numeroPartidoFifa;

    @JsonProperty("matchDateTimeUtc")
    private Long fechaHoraUtcEpochMs;

    @JsonProperty("status")
    private String estado;

    @JsonProperty("homeTeam")
    private String nombreSeleccionLocal;

    @JsonProperty("awayTeam")
    private String nombreSeleccionVisitante;

    @JsonProperty("homeGoals")
    private Integer golesLocal;

    @JsonProperty("awayGoals")
    private Integer golesVisitante;

    @JsonProperty("venue")
    private String nombreSede;

    @JsonProperty("group")
    private String nombreGrupo;

    @JsonProperty("phase")
    private String nombreFase;

    public PartidoDTO() {}

    public Integer getIdPartido()                        { return idPartido; }
    public void    setIdPartido(Integer v)               { this.idPartido = v; }

    public Integer getNumeroPartidoFifa()                { return numeroPartidoFifa; }
    public void    setNumeroPartidoFifa(Integer v)       { this.numeroPartidoFifa = v; }

    public Long    getFechaHoraUtcEpochMs()               { return fechaHoraUtcEpochMs; }
    public void    setFechaHoraUtcEpochMs(Long v)         { this.fechaHoraUtcEpochMs = v; }

    /** Derivado del epoch millis, para mostrar/editar como fecha normal. */
    public LocalDateTime getFechaHoraUtc() {
        return fechaHoraUtcEpochMs != null
                ? Instant.ofEpochMilli(fechaHoraUtcEpochMs).atZone(ZoneOffset.UTC).toLocalDateTime()
                : null;
    }

    public String  getEstado()                             { return estado; }
    public void    setEstado(String v)                      { this.estado = v; }

    public String  getNombreSeleccionLocal()               { return nombreSeleccionLocal; }
    public void    setNombreSeleccionLocal(String v)        { this.nombreSeleccionLocal = v; }

    public String  getNombreSeleccionVisitante()           { return nombreSeleccionVisitante; }
    public void    setNombreSeleccionVisitante(String v)    { this.nombreSeleccionVisitante = v; }

    public Integer getGolesLocal()                          { return golesLocal; }
    public void    setGolesLocal(Integer v)                 { this.golesLocal = v; }

    public Integer getGolesVisitante()                      { return golesVisitante; }
    public void    setGolesVisitante(Integer v)             { this.golesVisitante = v; }

    public String  getNombreSede()                          { return nombreSede; }
    public void    setNombreSede(String v)                  { this.nombreSede = v; }

    public String  getNombreGrupo()                         { return nombreGrupo; }
    public void    setNombreGrupo(String v)                 { this.nombreGrupo = v; }

    public String  getNombreFase()                          { return nombreFase; }
    public void    setNombreFase(String v)                  { this.nombreFase = v; }
}
