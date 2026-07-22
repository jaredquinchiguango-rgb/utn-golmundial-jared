package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class RolDTO {

    private Integer idRol;
    private String  nombre;
    private String  descripcion;

    public RolDTO() {}

    public Integer getIdRol()               { return idRol; }
    public void    setIdRol(Integer v)      { this.idRol = v; }

    public String  getNombre()              { return nombre; }
    public void    setNombre(String v)      { this.nombre = v; }

    public String  getDescripcion()         { return descripcion; }
    public void    setDescripcion(String v) { this.descripcion = v; }
}
