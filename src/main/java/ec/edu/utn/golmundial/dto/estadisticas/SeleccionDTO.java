package ec.edu.utn.golmundial.dto.estadisticas;

public class SeleccionDTO {

    private Integer idSeleccion;
    private String  nombre;
    private String  codigoFifa;
    private Boolean esAnfitrion;
    private String  clasificacion;
    private Integer partidosJugados;
    private Integer puntos;
    private Integer partidosGanados;
    private Integer partidosEmpatados;
    private Integer partidosPerdidos;
    private Integer golesFavor;
    private Integer golesContra;
    private Integer idGrupo;
    private String  nombreGrupo;

    public SeleccionDTO() {}

    public Integer getIdSeleccion()                 { return idSeleccion; }
    public void    setIdSeleccion(Integer v)        { this.idSeleccion = v; }

    public String  getNombre()                       { return nombre; }
    public void    setNombre(String v)               { this.nombre = v; }

    public String  getCodigoFifa()                   { return codigoFifa; }
    public void    setCodigoFifa(String v)           { this.codigoFifa = v; }

    public Boolean getEsAnfitrion()                  { return esAnfitrion; }
    public void    setEsAnfitrion(Boolean v)         { this.esAnfitrion = v; }

    public String  getClasificacion()                { return clasificacion; }
    public void    setClasificacion(String v)        { this.clasificacion = v; }

    public Integer getPartidosJugados()              { return partidosJugados; }
    public void    setPartidosJugados(Integer v)     { this.partidosJugados = v; }

    public Integer getPuntos()                        { return puntos; }
    public void    setPuntos(Integer v)                { this.puntos = v; }

    public Integer getPartidosGanados()               { return partidosGanados; }
    public void    setPartidosGanados(Integer v)      { this.partidosGanados = v; }

    public Integer getPartidosEmpatados()             { return partidosEmpatados; }
    public void    setPartidosEmpatados(Integer v)    { this.partidosEmpatados = v; }

    public Integer getPartidosPerdidos()              { return partidosPerdidos; }
    public void    setPartidosPerdidos(Integer v)     { this.partidosPerdidos = v; }

    public Integer getGolesFavor()                    { return golesFavor; }
    public void    setGolesFavor(Integer v)            { this.golesFavor = v; }

    public Integer getGolesContra()                   { return golesContra; }
    public void    setGolesContra(Integer v)           { this.golesContra = v; }

    public Integer getIdGrupo()                        { return idGrupo; }
    public void    setIdGrupo(Integer v)               { this.idGrupo = v; }

    public String  getNombreGrupo()                    { return nombreGrupo; }
    public void    setNombreGrupo(String v)            { this.nombreGrupo = v; }
}
