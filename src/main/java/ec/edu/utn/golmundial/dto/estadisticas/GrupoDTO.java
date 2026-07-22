package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import java.util.List;

/**
 * Mapea GET /api/grupos (sin standings) y GET /api/grupos/{id}/posiciones
 * (con standings poblado, ya ordenado por el backend: puntos, diferencia
 * de goles, goles a favor).
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class GrupoDTO {

    @JsonProperty("idGroup")
    private Integer idGrupo;

    @JsonProperty("code")
    private String  codigo;

    @JsonProperty("name")
    private String  nombre;

    @JsonProperty("standings")
    private List<StandingDTO> posiciones;

    public GrupoDTO() {}

    public Integer getIdGrupo()             { return idGrupo; }
    public void    setIdGrupo(Integer v)    { this.idGrupo = v; }

    public String  getCodigo()              { return codigo; }
    public void    setCodigo(String v)      { this.codigo = v; }

    public String  getNombre()              { return nombre; }
    public void    setNombre(String v)      { this.nombre = v; }

    public List<StandingDTO> getPosiciones()             { return posiciones; }
    public void               setPosiciones(List<StandingDTO> v) { this.posiciones = v; }
}
