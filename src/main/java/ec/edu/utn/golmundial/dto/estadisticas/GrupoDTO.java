package ec.edu.utn.golmundial.dto.estadisticas;

public class GrupoDTO {

    private Integer idGrupo;
    private String  codigo;
    private String  nombre;

    public GrupoDTO() {}

    public Integer getIdGrupo()             { return idGrupo; }
    public void    setIdGrupo(Integer v)    { this.idGrupo = v; }

    public String  getCodigo()              { return codigo; }
    public void    setCodigo(String v)      { this.codigo = v; }

    public String  getNombre()              { return nombre; }
    public void    setNombre(String v)      { this.nombre = v; }
}
