package ec.edu.utn.golmundial.dto.estadisticas;

public class SedeDTO {

    private Integer idSede;
    private String  estadio;
    private Integer capacidad;
    private String  nombreCiudad;

    public SedeDTO() {}

    public Integer getIdSede()               { return idSede; }
    public void    setIdSede(Integer v)      { this.idSede = v; }

    public String  getEstadio()              { return estadio; }
    public void    setEstadio(String v)      { this.estadio = v; }

    public Integer getCapacidad()            { return capacidad; }
    public void    setCapacidad(Integer v)   { this.capacidad = v; }

    public String  getNombreCiudad()         { return nombreCiudad; }
    public void    setNombreCiudad(String v) { this.nombreCiudad = v; }
}
