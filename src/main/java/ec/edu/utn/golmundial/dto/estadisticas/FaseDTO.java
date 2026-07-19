package ec.edu.utn.golmundial.dto.estadisticas;

import java.time.LocalDate;

public class FaseDTO {

    private Integer  idFase;
    private String   nombre;
    private String   codigo;
    private LocalDate fechaInicio;
    private LocalDate fechaFin;

    public FaseDTO() {}

    public Integer   getIdFase()                 { return idFase; }
    public void      setIdFase(Integer v)        { this.idFase = v; }

    public String    getNombre()                 { return nombre; }
    public void      setNombre(String v)         { this.nombre = v; }

    public String    getCodigo()                 { return codigo; }
    public void      setCodigo(String v)         { this.codigo = v; }

    public LocalDate getFechaInicio()            { return fechaInicio; }
    public void      setFechaInicio(LocalDate v) { this.fechaInicio = v; }

    public LocalDate getFechaFin()               { return fechaFin; }
    public void      setFechaFin(LocalDate v)    { this.fechaFin = v; }
}
