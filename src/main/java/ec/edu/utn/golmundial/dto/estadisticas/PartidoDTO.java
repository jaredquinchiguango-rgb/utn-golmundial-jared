package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.time.LocalDateTime;

/**
 * Mapea GET /api/partidos (confirmado por Ariel).
 *
 * OJO: sede/fase/grupo/equipos vienen como NOMBRE en texto plano, no
 * como ID (a diferencia de lo que asumimos al inicio). Los IDs solo se
 * usan al lado del CLIENTE para el body de creacion/edicion
 * (MatchInputDTO), nunca vienen en la respuesta de lectura.
 */
public class PartidoDTO {

    @JsonProperty("idMatch")
    private Integer idPartido;

    @JsonProperty("fifaMatchNumber")
    private Integer numeroPartidoFifa;

    @JsonProperty("matchDateTimeUtc")
    private LocalDateTime fechaHoraUtc;

    @JsonProperty("status")
    private String estado; // ej: "PROGRAMADO" (mayusculas) - confirmar el resto de valores con Ariel

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

    public Integer        getIdPartido()                          { return idPartido; }
    public void           setIdPartido(Integer v)                 { this.idPartido = v; }

    public Integer        getNumeroPartidoFifa()                  { return numeroPartidoFifa; }
    public void           setNumeroPartidoFifa(Integer v)         { this.numeroPartidoFifa = v; }

    public LocalDateTime  getFechaHoraUtc()                        { return fechaHoraUtc; }
    public void           setFechaHoraUtc(LocalDateTime v)         { this.fechaHoraUtc = v; }

    public String          getEstado()                             { return estado; }
    public void           setEstado(String v)                      { this.estado = v; }

    public String          getNombreSeleccionLocal()               { return nombreSeleccionLocal; }
    public void           setNombreSeleccionLocal(String v)        { this.nombreSeleccionLocal = v; }

    public String          getNombreSeleccionVisitante()           { return nombreSeleccionVisitante; }
    public void           setNombreSeleccionVisitante(String v)    { this.nombreSeleccionVisitante = v; }

    public Integer        getGolesLocal()                           { return golesLocal; }
    public void           setGolesLocal(Integer v)                  { this.golesLocal = v; }

    public Integer        getGolesVisitante()                       { return golesVisitante; }
    public void           setGolesVisitante(Integer v)              { this.golesVisitante = v; }

    public String          getNombreSede()                          { return nombreSede; }
    public void           setNombreSede(String v)                   { this.nombreSede = v; }

    public String          getNombreGrupo()                        { return nombreGrupo; }
    public void           setNombreGrupo(String v)                 { this.nombreGrupo = v; }

    public String          getNombreFase()                         { return nombreFase; }
    public void           setNombreFase(String v)                  { this.nombreFase = v; }
}
