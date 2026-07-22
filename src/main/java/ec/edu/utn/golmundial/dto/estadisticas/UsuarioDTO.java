package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(ignoreUnknown = true)
public class UsuarioDTO {

    @JsonProperty("idUser")
    private Integer idUsuario;

    @JsonProperty("name")
    private String  nombre;

    private String  email;
    private String  username;

    @JsonProperty("active")
    private Boolean estado;

    @JsonProperty("registeredAt")
    private Long fechaRegistro;

    @JsonProperty("lastAccess")
    private Long ultimoAcceso;

    @JsonProperty("idRole")
    private Integer idRol;

    @JsonProperty("role")
    private String  nombreRol; // viene en mayusculas: "ADMINISTRADOR"

    public UsuarioDTO() {}

    public Integer getIdUsuario()                  { return idUsuario; }
    public void    setIdUsuario(Integer v)         { this.idUsuario = v; }

    public String  getNombre()                     { return nombre; }
    public void    setNombre(String v)              { this.nombre = v; }

    public String  getEmail()                       { return email; }
    public void    setEmail(String v)                { this.email = v; }

    public String  getUsername()                    { return username; }
    public void    setUsername(String v)             { this.username = v; }

    public Boolean getEstado()                       { return estado; }
    public void    setEstado(Boolean v)              { this.estado = v; }

    public Long getFechaRegistro()          { return fechaRegistro; }
    public void setFechaRegistro(Long v)    { this.fechaRegistro = v; }

    public Long getUltimoAcceso()           { return ultimoAcceso; }
    public void setUltimoAcceso(Long v)     { this.ultimoAcceso = v; }

    public Integer getIdRol()                        { return idRol; }
    public void    setIdRol(Integer v)                { this.idRol = v; }

    public String  getNombreRol()                    { return nombreRol; }
    public void    setNombreRol(String v)             { this.nombreRol = v; }
}