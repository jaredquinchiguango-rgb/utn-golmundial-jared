package ec.edu.utn.golmundial.dto.utncoin;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class TransaccionDTO {

    private Integer       idTransaccion;
    private String        tipo;
    private BigDecimal    monto;
    private BigDecimal    saldoResultante;
    private LocalDateTime fecha;
    private String        descripcion;

    public TransaccionDTO() {}

    public Integer       getIdTransaccion()                 { return idTransaccion; }
    public void          setIdTransaccion(Integer v)        { this.idTransaccion = v; }

    public String         getTipo()                         { return tipo; }
    public void          setTipo(String v)                  { this.tipo = v; }

    public BigDecimal     getMonto()                        { return monto; }
    public void          setMonto(BigDecimal v)              { this.monto = v; }

    public BigDecimal     getSaldoResultante()               { return saldoResultante; }
    public void          setSaldoResultante(BigDecimal v)    { this.saldoResultante = v; }

    public LocalDateTime  getFecha()                         { return fecha; }
    public void          setFecha(LocalDateTime v)           { this.fecha = v; }

    public String         getDescripcion()                   { return descripcion; }
    public void          setDescripcion(String v)            { this.descripcion = v; }
}
