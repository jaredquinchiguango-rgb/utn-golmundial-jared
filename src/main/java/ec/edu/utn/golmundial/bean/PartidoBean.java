package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.FaseDTO;
import ec.edu.utn.golmundial.dto.estadisticas.PartidoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SedeDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.FaseService;
import ec.edu.utn.golmundial.service.estadisticas.PartidoService;
import ec.edu.utn.golmundial.service.estadisticas.SedeService;
import ec.edu.utn.golmundial.service.estadisticas.SeleccionService;
import jakarta.annotation.PostConstruct;
import jakarta.faces.application.FacesMessage;
import jakarta.faces.context.FacesContext;
import jakarta.faces.view.ViewScoped;
import jakarta.inject.Inject;
import jakarta.inject.Named;
import java.io.Serializable;
import java.util.List;

@Named
@ViewScoped
public class PartidoBean implements Serializable {

    @Inject private PartidoService   partidoService;
    @Inject private SeleccionService seleccionService;
    @Inject private SedeService      sedeService;
    @Inject private FaseService      faseService;

    private List<PartidoDTO>   partidos;
    private List<SeleccionDTO> selecciones;
    private List<SedeDTO>      sedes;
    private List<FaseDTO>      fases;

    private PartidoDTO partidoSeleccionado;
    private Integer    golesLocalForm;
    private Integer    golesVisitanteForm;

    @PostConstruct
    public void init() {
        cargarPartidos();
        selecciones = seleccionService.listarTodas();
        sedes       = sedeService.listarTodas();
        fases       = faseService.listarTodas();
    }

    public void cargarPartidos() {
        partidos = partidoService.listarTodos();
    }

    public String prepararNuevo() {
        partidoSeleccionado = new PartidoDTO();
        return "/partidos/nuevo?faces-redirect=true";
    }

    public String guardarNuevo() {
        boolean exito = partidoService.crear(partidoSeleccionado);
        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO, "Partido creado correctamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo crear el partido. Verifique los datos.");
        return null;
    }

    public String prepararEditar(PartidoDTO partido) {
        partidoSeleccionado = partido;
        return "/partidos/editar?faces-redirect=true";
    }

    public String guardarEdicion() {
        boolean exito = partidoService.actualizar(partidoSeleccionado);
        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO, "Partido actualizado correctamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo actualizar el partido.");
        return null;
    }

    public String prepararResultado(PartidoDTO partido) {
        partidoSeleccionado = partido;
        golesLocalForm = partido.getGolesLocal();
        golesVisitanteForm = partido.getGolesVisitante();
        return "/partidos/resultado?faces-redirect=true";
    }

    public String guardarResultado() {
        boolean exito = partidoService.registrarResultado(
                partidoSeleccionado.getIdPartido(), golesLocalForm, golesVisitanteForm);
        if (exito) {
            cargarPartidos();
            msg(FacesMessage.SEVERITY_INFO,
                "Resultado registrado. Las predicciones se liquidan automaticamente.");
            return "/partidos/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo registrar el resultado.");
        return null;
    }

    public String cancelar() {
        partidoSeleccionado = null;
        return "/partidos/lista?faces-redirect=true";
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public List<PartidoDTO>   getPartidos()             { return partidos; }
    public List<SeleccionDTO> getSelecciones()          { return selecciones; }
    public List<SedeDTO>      getSedes()                { return sedes; }
    public List<FaseDTO>      getFases()                { return fases; }

    public PartidoDTO getPartidoSeleccionado()          { return partidoSeleccionado; }
    public void       setPartidoSeleccionado(PartidoDTO v) { this.partidoSeleccionado = v; }

    public Integer getGolesLocalForm()                  { return golesLocalForm; }
    public void    setGolesLocalForm(Integer v)         { this.golesLocalForm = v; }

    public Integer getGolesVisitanteForm()               { return golesVisitanteForm; }
    public void    setGolesVisitanteForm(Integer v)      { this.golesVisitanteForm = v; }
}
