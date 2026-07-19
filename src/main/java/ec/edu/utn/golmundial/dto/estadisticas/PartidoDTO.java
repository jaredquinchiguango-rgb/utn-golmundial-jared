package ec.edu.utn.golmundial.dto.estadisticas;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PartidoDTO {

    private Integer idPartido;
    private Integer numeroPartidoFifa;
    private LocalDateTime fechaHoraUtc;
    private String  estado;               // programado, en_juego, finalizado
    private Integer golesLocal;
    private Integer golesVisitante;
    private BigDecimal cuotaLocal;
    private BigDecimal cuotaEmpate;
    private BigDecimal cuotaVisitante;
    private LocalDateTime fechaResultadoRegistrado;

    // Relaciones aplanadas (igual que nombreCategoria en ProductoDTO)
    private Integer idSeleccionLocal;
    private String  nombreSeleccionLocal;
    private Integer idSeleccionVisitante;
    private String  nombreSeleccionVisitante;
    private Integer idSede;
    private String  nombreSede;
    private Integer idFase;
    private String  nombreFase;
    private Integer idGrupo;
    private String  nombreGrupo;

    public PartidoDTO() {}

    public Integer getIdPartido()                        { return idPartido; }
    public void    setIdPartido(Integer v)               { this.idPartido = v; }

    public Integer getNumeroPartidoFifa()                { return numeroPartidoFifa; }
    public void    setNumeroPartidoFifa(Integer v)       { this.numeroPartidoFifa = v; }

    public LocalDateTime getFechaHoraUtc()                { return fechaHoraUtc; }
    public void    setFechaHoraUtc(LocalDateTime v)       { this.fechaHoraUtc = v; }

    public String  getEstado()                            { return estado; }
    public void    setEstado(String v)                    { this.estado = v; }

    public Integer getGolesLocal()                        { return golesLocal; }
    public void    setGolesLocal(Integer v)               { this.golesLocal = v; }

    public Integer getGolesVisitante()                    { return golesVisitante; }
    public void    setGolesVisitante(Integer v)           { this.golesVisitante = v; }

    public BigDecimal getCuotaLocal()                     { return cuotaLocal; }
    public void    setCuotaLocal(BigDecimal v)            { this.cuotaLocal = v; }

    public BigDecimal getCuotaEmpate()                    { return cuotaEmpate; }
    public void    setCuotaEmpate(BigDecimal v)           { this.cuotaEmpate = v; }

    public BigDecimal getCuotaVisitante()                 { return cuotaVisitante; }
    public void    setCuotaVisitante(BigDecimal v)        { this.cuotaVisitante = v; }

    public LocalDateTime getFechaResultadoRegistrado()     { return fechaResultadoRegistrado; }
    public void    setFechaResultadoRegistrado(LocalDateTime v) { this.fechaResultadoRegistrado = v; }

    public Integer getIdSeleccionLocal()                  { return idSeleccionLocal; }
    public void    setIdSeleccionLocal(Integer v)         { this.idSeleccionLocal = v; }

    public String  getNombreSeleccionLocal()              { return nombreSeleccionLocal; }
    public void    setNombreSeleccionLocal(String v)      { this.nombreSeleccionLocal = v; }

    public Integer getIdSeleccionVisitante()              { return idSeleccionVisitante; }
    public void    setIdSeleccionVisitante(Integer v)     { this.idSeleccionVisitante = v; }

    public String  getNombreSeleccionVisitante()          { return nombreSeleccionVisitante; }
    public void    setNombreSeleccionVisitante(String v)  { this.nombreSeleccionVisitante = v; }

    public Integer getIdSede()                             { return idSede; }
    public void    setIdSede(Integer v)                    { this.idSede = v; }

    public String  getNombreSede()                         { return nombreSede; }
    public void    setNombreSede(String v)                 { this.nombreSede = v; }

    public Integer getIdFase()                             { return idFase; }
    public void    setIdFase(Integer v)                    { this.idFase = v; }

    public String  getNombreFase()                         { return nombreFase; }
    public void    setNombreFase(String v)                 { this.nombreFase = v; }

    public Integer getIdGrupo()                             { return idGrupo; }
    public void    setIdGrupo(Integer v)                    { this.idGrupo = v; }

    public String  getNombreGrupo()                         { return nombreGrupo; }
    public void    setNombreGrupo(String v)                 { this.nombreGrupo = v; }
}
