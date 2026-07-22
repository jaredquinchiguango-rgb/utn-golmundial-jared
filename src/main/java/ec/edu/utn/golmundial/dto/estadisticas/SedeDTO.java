package ec.edu.utn.golmundial.dto.estadisticas;

import com.fasterxml.jackson.annotation.JsonProperty;

/** Mapea GET /api/sedes (confirmado por Ariel). */
public class SedeDTO {

    @JsonProperty("idVenue")
    private Integer idSede;

    @JsonProperty("stadium")
    private String  estadio;

    @JsonProperty("capacity")
    private Integer capacidad;

    @JsonProperty("city")
    private String  nombreCiudad;

    @JsonProperty("country")
    private String  pais;

    public SedeDTO() {}

    public Integer getIdSede()               { return idSede; }
    public void    setIdSede(Integer v)      { this.idSede = v; }

    public String  getEstadio()              { return estadio; }
    public void    setEstadio(String v)      { this.estadio = v; }

    public Integer getCapacidad()            { return capacidad; }
    public void    setCapacidad(Integer v)   { this.capacidad = v; }

    public String  getNombreCiudad()         { return nombreCiudad; }
    public void    setNombreCiudad(String v) { this.nombreCiudad = v; }

    public String  getPais()                 { return pais; }
    public void    setPais(String v)         { this.pais = v; }
}
