package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonProperty;

/**
 * TODO: Ariel confirmo que GET /api/grupos existe, pero NO nos paso un
 * JSON de ejemplo de esa ruta especifica (solo de /posiciones y
 * /partidos). Los nombres de campo aqui son una SUPOSICION basada en
 * el patron que uso para selecciones/partidos (idGroup, code, name).
 * Verificar con un JSON real antes de confiar en esto para produccion.
 */
public class GrupoDTO {

    @JsonProperty("idGroup")
    private Integer idGrupo;

    @JsonProperty("code")
    private String  codigo;

    @JsonProperty("name")
    private String  nombre;

    public GrupoDTO() {}

    public Integer getIdGrupo()             { return idGrupo; }
    public void    setIdGrupo(Integer v)    { this.idGrupo = v; }

    public String  getCodigo()              { return codigo; }
    public void    setCodigo(String v)      { this.codigo = v; }

    public String  getNombre()              { return nombre; }
    public void    setNombre(String v)      { this.nombre = v; }
}
