package ec.edu.utn.golmundial.dto.estadisticas;

import java.time.LocalDateTime;

public class UsuarioDTO {

    private Integer idUsuario;
    private String  nombre;
    private String  email;
    private String  username;
    private Boolean estado;
    private LocalDateTime fechaRegistro;
    private LocalDateTime ultimoAcceso;
    private Integer idRol;
    private String  nombreRol;

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

    public LocalDateTime getFechaRegistro()          { return fechaRegistro; }
    public void    setFechaRegistro(LocalDateTime v) { this.fechaRegistro = v; }

    public LocalDateTime getUltimoAcceso()           { return ultimoAcceso; }
    public void    setUltimoAcceso(LocalDateTime v)  { this.ultimoAcceso = v; }

    public Integer getIdRol()                        { return idRol; }
    public void    setIdRol(Integer v)                { this.idRol = v; }

    public String  getNombreRol()                    { return nombreRol; }
    public void    setNombreRol(String v)             { this.nombreRol = v; }
}
