package ec.edu.utn.golmundial.dto.utncoin;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class PrediccionDTO {

    private Integer       idPrediccion;
    private Integer       idPartido;
    private String        resultadoPredicho; // L, E, V
    private BigDecimal    monto;
    private BigDecimal    cuotaAplicada;
    private BigDecimal    premio;
    private String        estado; // pendiente, ganada, perdida
    private LocalDateTime fechaCreacion;

    public PrediccionDTO() {}

    public Integer       getIdPrediccion()                { return idPrediccion; }
    public void          setIdPrediccion(Integer v)       { this.idPrediccion = v; }

    public Integer       getIdPartido()                   { return idPartido; }
    public void          setIdPartido(Integer v)          { this.idPartido = v; }

    public String         getResultadoPredicho()          { return resultadoPredicho; }
    public void          setResultadoPredicho(String v)   { this.resultadoPredicho = v; }

    public BigDecimal     getMonto()                      { return monto; }
    public void          setMonto(BigDecimal v)            { this.monto = v; }

    public BigDecimal     getCuotaAplicada()               { return cuotaAplicada; }
    public void          setCuotaAplicada(BigDecimal v)    { this.cuotaAplicada = v; }

    public BigDecimal     getPremio()                      { return premio; }
    public void          setPremio(BigDecimal v)            { this.premio = v; }

    public String         getEstado()                      { return estado; }
    public void          setEstado(String v)               { this.estado = v; }

    public LocalDateTime  getFechaCreacion()                { return fechaCreacion; }
    public void          setFechaCreacion(LocalDateTime v)  { this.fechaCreacion = v; }
}
