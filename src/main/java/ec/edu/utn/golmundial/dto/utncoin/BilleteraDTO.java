package ec.edu.utn.golmundial.dto.utncoin;

import java.math.BigDecimal;

public class BilleteraDTO {

    private Integer    idBilletera;
    private Integer    idUsuario;
    private BigDecimal saldo;
    private Boolean    estado;

    public BilleteraDTO() {}

    public Integer    getIdBilletera()             { return idBilletera; }
    public void       setIdBilletera(Integer v)    { this.idBilletera = v; }

    public Integer    getIdUsuario()               { return idUsuario; }
    public void       setIdUsuario(Integer v)      { this.idUsuario = v; }

    public BigDecimal getSaldo()                   { return saldo; }
    public void       setSaldo(BigDecimal v)       { this.saldo = v; }

    public Boolean    getEstado()                  { return estado; }
    public void       setEstado(Boolean v)         { this.estado = v; }
}
