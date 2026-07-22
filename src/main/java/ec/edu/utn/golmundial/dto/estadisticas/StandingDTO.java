package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

/** Mapea cada fila de GET /api/grupos/{id}/posiciones (confirmado por Ariel). */
@JsonIgnoreProperties(ignoreUnknown = true)
public class StandingDTO {

    @JsonProperty("idTeam")
    private Integer idSeleccion;

    @JsonProperty("name")
    private String  nombre;

    @JsonProperty("fifaCode")
    private String  codigoFifa;

    @JsonProperty("matchesPlayed")
    private Integer partidosJugados;

    @JsonProperty("points")
    private Integer puntos;

    @JsonProperty("wins")
    private Integer partidosGanados;

    @JsonProperty("draws")
    private Integer partidosEmpatados;

    @JsonProperty("losses")
    private Integer partidosPerdidos;

    @JsonProperty("goalsFor")
    private Integer golesFavor;

    @JsonProperty("goalsAgainst")
    private Integer golesContra;

    @JsonProperty("goalDifference")
    private Integer diferenciaGoles;

    public StandingDTO() {}

    public Integer getIdSeleccion()                 { return idSeleccion; }
    public void    setIdSeleccion(Integer v)        { this.idSeleccion = v; }

    public String  getNombre()                      { return nombre; }
    public void    setNombre(String v)              { this.nombre = v; }

    public String  getCodigoFifa()                  { return codigoFifa; }
    public void    setCodigoFifa(String v)          { this.codigoFifa = v; }

    public Integer getPartidosJugados()             { return partidosJugados; }
    public void    setPartidosJugados(Integer v)    { this.partidosJugados = v; }

    public Integer getPuntos()                       { return puntos; }
    public void    setPuntos(Integer v)              { this.puntos = v; }

    public Integer getPartidosGanados()              { return partidosGanados; }
    public void    setPartidosGanados(Integer v)     { this.partidosGanados = v; }

    public Integer getPartidosEmpatados()            { return partidosEmpatados; }
    public void    setPartidosEmpatados(Integer v)   { this.partidosEmpatados = v; }

    public Integer getPartidosPerdidos()             { return partidosPerdidos; }
    public void    setPartidosPerdidos(Integer v)    { this.partidosPerdidos = v; }

    public Integer getGolesFavor()                   { return golesFavor; }
    public void    setGolesFavor(Integer v)          { this.golesFavor = v; }

    public Integer getGolesContra()                  { return golesContra; }
    public void    setGolesContra(Integer v)         { this.golesContra = v; }

    public Integer getDiferenciaGoles()               { return diferenciaGoles; }
    public void    setDiferenciaGoles(Integer v)      { this.diferenciaGoles = v; }
}
