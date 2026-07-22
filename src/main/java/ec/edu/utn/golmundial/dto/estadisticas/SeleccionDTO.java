package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * Mapea GET /api/selecciones (confirmado por Ariel).
 *
 * OJO: el backend devuelve "group" y "confederation" como NOMBRE en texto,
 * no como ID. Para editar (PUT /api/selecciones/{id}, que si exige
 * idGroup e idConfederation) hay que resolver el ID buscando ese nombre
 * en la lista de /api/grupos. Para idConfederation NO hay ningun
 * endpoint que lo entregue todavia - es un TODO pendiente con Ariel.
 */
public class SeleccionDTO {

    @JsonProperty("idTeam")
    private Integer idSeleccion;

    @JsonProperty("name")
    private String  nombre;

    @JsonProperty("fifaCode")
    private String  codigoFifa;

    @JsonProperty("isHost")
    private Boolean esAnfitrion;

    @JsonProperty("qualification")
    private String  clasificacion;

    @JsonProperty("group")
    private String  nombreGrupo;          // viene como texto, no como id

    @JsonProperty("confederation")
    private String  nombreConfederacion;  // viene como texto, no como id

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

    public SeleccionDTO() {}

    public Integer getIdSeleccion()                     { return idSeleccion; }
    public void    setIdSeleccion(Integer v)            { this.idSeleccion = v; }

    public String  getNombre()                          { return nombre; }
    public void    setNombre(String v)                  { this.nombre = v; }

    public String  getCodigoFifa()                       { return codigoFifa; }
    public void    setCodigoFifa(String v)               { this.codigoFifa = v; }

    public Boolean getEsAnfitrion()                       { return esAnfitrion; }
    public void    setEsAnfitrion(Boolean v)              { this.esAnfitrion = v; }

    public String  getClasificacion()                     { return clasificacion; }
    public void    setClasificacion(String v)             { this.clasificacion = v; }

    public String  getNombreGrupo()                       { return nombreGrupo; }
    public void    setNombreGrupo(String v)               { this.nombreGrupo = v; }

    public String  getNombreConfederacion()               { return nombreConfederacion; }
    public void    setNombreConfederacion(String v)       { this.nombreConfederacion = v; }

    public Integer getPartidosJugados()                   { return partidosJugados; }
    public void    setPartidosJugados(Integer v)          { this.partidosJugados = v; }

    public Integer getPuntos()                             { return puntos; }
    public void    setPuntos(Integer v)                     { this.puntos = v; }

    public Integer getPartidosGanados()                    { return partidosGanados; }
    public void    setPartidosGanados(Integer v)           { this.partidosGanados = v; }

    public Integer getPartidosEmpatados()                  { return partidosEmpatados; }
    public void    setPartidosEmpatados(Integer v)         { this.partidosEmpatados = v; }

    public Integer getPartidosPerdidos()                   { return partidosPerdidos; }
    public void    setPartidosPerdidos(Integer v)          { this.partidosPerdidos = v; }

    public Integer getGolesFavor()                         { return golesFavor; }
    public void    setGolesFavor(Integer v)                 { this.golesFavor = v; }

    public Integer getGolesContra()                        { return golesContra; }
    public void    setGolesContra(Integer v)                { this.golesContra = v; }

    public Integer getDiferenciaGoles()                     { return diferenciaGoles; }
    public void    setDiferenciaGoles(Integer v)            { this.diferenciaGoles = v; }
}
