package ec.edu.utn.golmundial.bean;

import ec.edu.utn.golmundial.dto.estadisticas.GrupoDTO;
import ec.edu.utn.golmundial.dto.estadisticas.SeleccionDTO;
import ec.edu.utn.golmundial.service.estadisticas.GrupoService;
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
public class SeleccionBean implements Serializable {

    @Inject private SeleccionService seleccionService;
    @Inject private GrupoService     grupoService;

    private List<SeleccionDTO> selecciones;
    private List<GrupoDTO>     grupos;
    private SeleccionDTO       seleccionSeleccionada;

    @PostConstruct
    public void init() {
        cargarSelecciones();
        grupos = grupoService.listarTodos();
    }

    public void cargarSelecciones() {
        selecciones = seleccionService.listarTodas();
    }

    public String prepararEditar(SeleccionDTO seleccion) {
        seleccionSeleccionada = seleccion;
        return "/selecciones/editar?faces-redirect=true";
    }

    public String guardarEdicion() {
        boolean exito = seleccionService.actualizar(seleccionSeleccionada);
        if (exito) {
            cargarSelecciones();
            msg(FacesMessage.SEVERITY_INFO, "Seleccion actualizada correctamente.");
            return "/selecciones/lista?faces-redirect=true";
        }
        msg(FacesMessage.SEVERITY_ERROR, "No se pudo actualizar la seleccion.");
        return null;
    }

    public String cancelar() {
        seleccionSeleccionada = null;
        return "/selecciones/lista?faces-redirect=true";
    }

    private void msg(FacesMessage.Severity nivel, String texto) {
        FacesContext.getCurrentInstance().addMessage(null, new FacesMessage(nivel, texto, null));
    }

    public List<SeleccionDTO> getSelecciones()                  { return selecciones; }
    public List<GrupoDTO>     getGrupos()                        { return grupos; }

    public SeleccionDTO getSeleccionSeleccionada()               { return seleccionSeleccionada; }
    public void         setSeleccionSeleccionada(SeleccionDTO v) { this.seleccionSeleccionada = v; }
}
