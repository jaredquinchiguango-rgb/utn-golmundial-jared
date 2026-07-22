package ec.edu.utn.golmundial.dto.estadisticas;

import java.time.LocalDateTime;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class AuditoriaDTO {

    private Integer idAuditoria;
    private String  tipoAccion;
    private LocalDateTime fechaHora;
    private String  tablaAfectada;
    private String  descripcion;

    public AuditoriaDTO() {}

    public Integer getIdAuditoria()                { return idAuditoria; }
    public void    setIdAuditoria(Integer v)       { this.idAuditoria = v; }

    public String  getTipoAccion()                 { return tipoAccion; }
    public void    setTipoAccion(String v)         { this.tipoAccion = v; }

    public LocalDateTime getFechaHora()            { return fechaHora; }
    public void    setFechaHora(LocalDateTime v)   { this.fechaHora = v; }

    public String  getTablaAfectada()              { return tablaAfectada; }
    public void    setTablaAfectada(String v)      { this.tablaAfectada = v; }

    public String  getDescripcion()                { return descripcion; }
    public void    setDescripcion(String v)        { this.descripcion = v; }
}
